Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D0C2512DD;
	Tue, 29 Apr 2025 16:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945818; cv=none; b=bLhhvQ1ktIoE+Msxvs6+DIE3iQo1o6+5shRx3aZGrVIrqG/APMAPJx4sTYmEJG5hU4gakKnW2jObcdnzzFh5AVCOXSXdcjPK1Wj3eFapJme00unPQiDdjh/LHvOX0ew9Q6Yzs2CK2XetxhBzl9So6o9P9yW6vzh9pgwsh6zhE/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945818; c=relaxed/simple;
	bh=sYwxwbbPZjhuDACzYS/eU3RF+peeIZguBGgxeziJfcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xfei775UTwiS8VJIkBXxLh21MNGrLWzZtpl/BsWiT3LFCegByvfiO27EwDA6MHmQwe2+6PHdPsDeN3jacSREfY75kIqyRB6AOLHiuID39H92yzj8dGVvkHO10iNlXOUVD8K2t3CEXnb8wpyN42jM0bbpMV8IpSGaP2Y5Lv60uY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LlotAkEu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LlotAkEu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26F6FC4CEE3;
	Tue, 29 Apr 2025 16:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945817;
	bh=sYwxwbbPZjhuDACzYS/eU3RF+peeIZguBGgxeziJfcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LlotAkEufglZgZB8CVz83WdXeBC02FjBBh3SOA77MKybWlbCHOz2kUWNdpJXbYPgp
	 EsvlEH/lGHZoKQyZGpaABOopnnF+UZ8sazJUIp3J7J3rPHZVPhoyyNaO+1+SoUTGGp
	 zoXvnC0C0tq+b7A6dKIxN43/QzePXkQR7FeL1FSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 060/311] net: phylink: fix suspend/resume with WoL enabled and link down
Date: Tue, 29 Apr 2025 18:38:17 +0200
Message-ID: <20250429161123.500440047@linuxfoundation.org>
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

[ Upstream commit 4c8925cb9db158c812e1e11f3e74b945df7c9801 ]

When WoL is enabled, we update the software state in phylink to
indicate that the link is down, and disable the resolver from
bringing the link back up.

On resume, we attempt to bring the overall state into consistency
by calling the .mac_link_down() method, but this is wrong if the
link was already down, as phylink strictly orders the .mac_link_up()
and .mac_link_down() methods - and this would break that ordering.

Fixes: f97493657c63 ("net: phylink: add suspend/resume support")
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Tested-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://patch.msgid.link/E1u55Qf-0016RN-PA@rmk-PC.armlinux.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phylink.c | 38 ++++++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 16 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index b74b1c3365000..306275fbe4c98 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -82,6 +82,7 @@ struct phylink {
 	unsigned int pcs_state;
 
 	bool link_failed;
+	bool suspend_link_up;
 	bool major_config_failed;
 	bool mac_supports_eee_ops;
 	bool mac_supports_eee;
@@ -2645,14 +2646,16 @@ void phylink_suspend(struct phylink *pl, bool mac_wol)
 		/* Stop the resolver bringing the link up */
 		__set_bit(PHYLINK_DISABLE_MAC_WOL, &pl->phylink_disable_state);
 
-		/* Disable the carrier, to prevent transmit timeouts,
-		 * but one would hope all packets have been sent. This
-		 * also means phylink_resolve() will do nothing.
-		 */
-		if (pl->netdev)
-			netif_carrier_off(pl->netdev);
-		else
+		pl->suspend_link_up = phylink_link_is_up(pl);
+		if (pl->suspend_link_up) {
+			/* Disable the carrier, to prevent transmit timeouts,
+			 * but one would hope all packets have been sent. This
+			 * also means phylink_resolve() will do nothing.
+			 */
+			if (pl->netdev)
+				netif_carrier_off(pl->netdev);
 			pl->old_link_state = false;
+		}
 
 		/* We do not call mac_link_down() here as we want the
 		 * link to remain up to receive the WoL packets.
@@ -2678,15 +2681,18 @@ void phylink_resume(struct phylink *pl)
 	if (test_bit(PHYLINK_DISABLE_MAC_WOL, &pl->phylink_disable_state)) {
 		/* Wake-on-Lan enabled, MAC handling */
 
-		/* Call mac_link_down() so we keep the overall state balanced.
-		 * Do this under the state_mutex lock for consistency. This
-		 * will cause a "Link Down" message to be printed during
-		 * resume, which is harmless - the true link state will be
-		 * printed when we run a resolve.
-		 */
-		mutex_lock(&pl->state_mutex);
-		phylink_link_down(pl);
-		mutex_unlock(&pl->state_mutex);
+		if (pl->suspend_link_up) {
+			/* Call mac_link_down() so we keep the overall state
+			 * balanced. Do this under the state_mutex lock for
+			 * consistency. This will cause a "Link Down" message
+			 * to be printed during resume, which is harmless -
+			 * the true link state will be printed when we run a
+			 * resolve.
+			 */
+			mutex_lock(&pl->state_mutex);
+			phylink_link_down(pl);
+			mutex_unlock(&pl->state_mutex);
+		}
 
 		/* Re-apply the link parameters so that all the settings get
 		 * restored to the MAC.
-- 
2.39.5



