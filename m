Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414A9229B05;
	Tue, 29 Apr 2025 16:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945960; cv=none; b=qBeUFnUdpppndwbPXvsfA9Udwhtvkuwgl36fuAxnhSkfv44lV60HlUzmh5NCsUJ4tMs4XRvatzE2EQmhk6Ua6G21mXlUtJ9TlMviKcCrQqd/fd3wUsrpMVptEBVq3pEzxRbGjxsmgXXObpuw1qo1O5QjdSFK95FWf67KG9Wj8T8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945960; c=relaxed/simple;
	bh=7JZDZMTMsmLGA4rqK+lUhPS7qt9+Gbbos/Ir5hmpCPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PF5wTVvjS4DZqbB6EICxK20iBKctzhfsXI5QlF7zlK4fozT3Iw7vtsi8mFwcgFjQSa8TImOxYiF96yijFj3y3cWhqZcocz7a8+vI4p7CVm21fUNFJDoDgh8Pbv0h+7RqAeZauXVTHXlyLb31R1aVEFPWmPkxLvmHjGoL+QYGLrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RMsqxkv0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RMsqxkv0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7798C4CEE3;
	Tue, 29 Apr 2025 16:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945960;
	bh=7JZDZMTMsmLGA4rqK+lUhPS7qt9+Gbbos/Ir5hmpCPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RMsqxkv0tR67ohoZZIT8YCLtJVRyyS7Di8ZpphDiIe8Rm9rXQOdArof/jLhyHHRVh
	 SivOJNlMe06c/jnYKqAtunkwvznACfeOy5Lxd4klIZ4GeQLJwE5DR0rD0PKC2nG5Oj
	 UIb1C35yF9rsunLZELEfNNxh9t1ZIPxaxv5g6Lq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Jon Hunter <jonathanh@nvidia.com>
Subject: [PATCH 6.14 107/311] net: phylink: add functions to block/unblock rx clock stop
Date: Tue, 29 Apr 2025 18:39:04 +0200
Message-ID: <20250429161125.421143316@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

commit ddf4bd3f738485c84edb98ff96a5759904498e70 upstream.

Some MACs require the PHY receive clock to be running to complete setup
actions. This may fail if the PHY has negotiated EEE, the MAC supports
receive clock stop, and the link has entered LPI state. Provide a pair
of APIs that MAC drivers can use to temporarily block the PHY disabling
the receive clock.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://patch.msgid.link/E1tvO6k-008Vjt-MZ@rmk-PC.armlinux.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Cc: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/phylink.c |   59 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/phylink.h   |    3 ++
 2 files changed, 62 insertions(+)

--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -90,6 +90,7 @@ struct phylink {
 	bool mac_enable_tx_lpi;
 	bool mac_tx_clk_stop;
 	u32 mac_tx_lpi_timer;
+	u8 mac_rx_clk_stop_blocked;
 
 	struct sfp_bus *sfp_bus;
 	bool sfp_may_have_phy;
@@ -2622,6 +2623,64 @@ void phylink_stop(struct phylink *pl)
 EXPORT_SYMBOL_GPL(phylink_stop);
 
 /**
+ * phylink_rx_clk_stop_block() - block PHY ability to stop receive clock in LPI
+ * @pl: a pointer to a &struct phylink returned from phylink_create()
+ *
+ * Disable the PHY's ability to stop the receive clock while the receive path
+ * is in EEE LPI state, until the number of calls to phylink_rx_clk_stop_block()
+ * are balanced by calls to phylink_rx_clk_stop_unblock().
+ */
+void phylink_rx_clk_stop_block(struct phylink *pl)
+{
+	ASSERT_RTNL();
+
+	if (pl->mac_rx_clk_stop_blocked == U8_MAX) {
+		phylink_warn(pl, "%s called too many times - ignoring\n",
+			     __func__);
+		dump_stack();
+		return;
+	}
+
+	/* Disable PHY receive clock stop if this is the first time this
+	 * function has been called and clock-stop was previously enabled.
+	 */
+	if (pl->mac_rx_clk_stop_blocked++ == 0 &&
+	    pl->mac_supports_eee_ops && pl->phydev &&
+	    pl->config->eee_rx_clk_stop_enable)
+		phy_eee_rx_clock_stop(pl->phydev, false);
+}
+EXPORT_SYMBOL_GPL(phylink_rx_clk_stop_block);
+
+/**
+ * phylink_rx_clk_stop_unblock() - unblock PHY ability to stop receive clock
+ * @pl: a pointer to a &struct phylink returned from phylink_create()
+ *
+ * All calls to phylink_rx_clk_stop_block() must be balanced with a
+ * corresponding call to phylink_rx_clk_stop_unblock() to restore the PHYs
+ * ability to stop the receive clock when the receive path is in EEE LPI mode.
+ */
+void phylink_rx_clk_stop_unblock(struct phylink *pl)
+{
+	ASSERT_RTNL();
+
+	if (pl->mac_rx_clk_stop_blocked == 0) {
+		phylink_warn(pl, "%s called too many times - ignoring\n",
+			     __func__);
+		dump_stack();
+		return;
+	}
+
+	/* Re-enable PHY receive clock stop if the number of unblocks matches
+	 * the number of calls to the block function above.
+	 */
+	if (--pl->mac_rx_clk_stop_blocked == 0 &&
+	    pl->mac_supports_eee_ops && pl->phydev &&
+	    pl->config->eee_rx_clk_stop_enable)
+		phy_eee_rx_clock_stop(pl->phydev, true);
+}
+EXPORT_SYMBOL_GPL(phylink_rx_clk_stop_unblock);
+
+/**
  * phylink_suspend() - handle a network device suspend event
  * @pl: a pointer to a &struct phylink returned from phylink_create()
  * @mac_wol: true if the MAC needs to receive packets for Wake-on-Lan
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -678,6 +678,9 @@ int phylink_pcs_pre_init(struct phylink
 void phylink_start(struct phylink *);
 void phylink_stop(struct phylink *);
 
+void phylink_rx_clk_stop_block(struct phylink *);
+void phylink_rx_clk_stop_unblock(struct phylink *);
+
 void phylink_suspend(struct phylink *pl, bool mac_wol);
 void phylink_prepare_resume(struct phylink *pl);
 void phylink_resume(struct phylink *pl);


