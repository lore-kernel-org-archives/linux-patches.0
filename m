Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A402522B3;
	Tue, 29 Apr 2025 16:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945951; cv=none; b=YIednMkP+EkMribyOYAbeSVP/+r9+wlHY5pXj+ZiiRCP7OiVu3b9d9F1a1isQMPX7Ktoh7+1oI0OiT2SNgE1VG6a05izdJ+f02k/zJ60GgvU4Wso2qOJRIs99/fneZENgHtjGwzhSR4fDUIeSydQbw7ixwd+eKmXS1RrR8RQR20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945951; c=relaxed/simple;
	bh=6aLy9D6Z+EdYczfYwCtfZ4ug9Rp9zgQsP1EEtUG4Uac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ksbkrhQbMJwnBTo3A63TMuioYe9Lev6q0lWQkNnapSxirumpIqSS+78Hey79QKxtpBdPUTsQxypMANitDMKtmKxiSs4RvpsDp/wNh6n04P6vP+7QT/OVQkmZtW+rekQFLsuE67giomrQgEj1F7u5Wwmt/uXveNIgpOsaymvmdFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t1rcoc/R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t1rcoc/R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9A22C4CEE9;
	Tue, 29 Apr 2025 16:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945951;
	bh=6aLy9D6Z+EdYczfYwCtfZ4ug9Rp9zgQsP1EEtUG4Uac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t1rcoc/RWFVRXjzKGSFksDaBdw6tZ/vbL8XXaVuMEaN++pzdxoe08FxFg1i8zCpna
	 IYhsf0i/U639ObJ1g/SQKIADPjXB9+Q8K154b7y5BIFy0tA86vSrujeSFgsZ2nZgIE
	 Om5ktOxNHVLB/lXuVKBirihXEoSvycll+KiZn1t0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Jon Hunter <jonathanh@nvidia.com>
Subject: [PATCH 6.14 104/311] net: phylink: add phylink_prepare_resume()
Date: Tue, 29 Apr 2025 18:39:01 +0200
Message-ID: <20250429161125.297088313@linuxfoundation.org>
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

commit 367f1854d442b33c4a0305b068ae40d67ccd7d6a upstream.

When the system is suspended, the PHY may be placed in low-power mode
by setting the BMCR 0.11 Power down bit. IEEE 802.3 states that the
behaviour of the PHY in this state is implementation specific, and
the PHY is not required to meet the RX_CLK and TX_CLK requirements.
Essentially, this means that a PHY may stop the clocks that it is
generating while in power down state.

However, MACs exist which require the clocks from the PHY to be running
in order to properly resume. phylink_prepare_resume() provides them
with a way to clear the Power down bit early.

Note, however, that IEEE 802.3 gives PHYs up to 500ms grace before the
transmit and receive clocks meet the requirements after clearing the
power down bit.

Add a resume preparation function, which will ensure that the receive
clock from the PHY is appropriately configured while resuming.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://patch.msgid.link/E1tvO6V-008Vjb-AP@rmk-PC.armlinux.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Cc: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/phylink.c |   25 +++++++++++++++++++++++++
 include/linux/phylink.h   |    1 +
 2 files changed, 26 insertions(+)

--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -2668,6 +2668,31 @@ void phylink_suspend(struct phylink *pl,
 EXPORT_SYMBOL_GPL(phylink_suspend);
 
 /**
+ * phylink_prepare_resume() - prepare to resume a network device
+ * @pl: a pointer to a &struct phylink returned from phylink_create()
+ *
+ * Optional, but if called must be called prior to phylink_resume().
+ *
+ * Prepare to resume a network device, preparing the PHY as necessary.
+ */
+void phylink_prepare_resume(struct phylink *pl)
+{
+	struct phy_device *phydev = pl->phydev;
+
+	ASSERT_RTNL();
+
+	/* IEEE 802.3 22.2.4.1.5 allows PHYs to stop their receive clock
+	 * when PDOWN is set. However, some MACs require RXC to be running
+	 * in order to resume. If the MAC requires RXC, and we have a PHY,
+	 * then resume the PHY. Note that 802.3 allows PHYs 500ms before
+	 * the clock meets requirements. We do not implement this delay.
+	 */
+	if (pl->config->mac_requires_rxc && phydev && phydev->suspended)
+		phy_resume(phydev);
+}
+EXPORT_SYMBOL_GPL(phylink_prepare_resume);
+
+/**
  * phylink_resume() - handle a network device resume event
  * @pl: a pointer to a &struct phylink returned from phylink_create()
  *
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -679,6 +679,7 @@ void phylink_start(struct phylink *);
 void phylink_stop(struct phylink *);
 
 void phylink_suspend(struct phylink *pl, bool mac_wol);
+void phylink_prepare_resume(struct phylink *pl);
 void phylink_resume(struct phylink *pl);
 
 void phylink_ethtool_get_wol(struct phylink *, struct ethtool_wolinfo *);


