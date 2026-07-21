Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202F8411691;
	Tue, 21 Jul 2026 19:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660831; cv=none; b=A1rPDCU5iLF61N3N1ckSVurubcDfcjFcbHkcTWLe+F3X1Pg/4Un/Saw8hIrzIl1Z9NBnMoZO5PoIq0FJ7sGHxLQsaWQjf5j9I0mdsSUfvdpJecrz+tWy28BxOkmqHIWSenSJpLzSjbHLppOAibVX6tHOt2cruDkAduRhOotPrl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660831; c=relaxed/simple;
	bh=TaTTsD2Uuglgu4Rl6AIn5Ovi+2/fUhz0ovLgASQwqlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oHdPac5S9uwZcQmThH5RXfpAbp2b3QpOoUZ4Os96LatunRQWGaWdWYXIVg0iU6uqyoi9rhaef1vCJDG6HEe7Jh+hTwFjY6fvCJidkSed3zxJ7yOSH2gv2ZNMtWujRYIIP3B6hi9wzOtXJDtsrDH0I+oBBdOJcwFjKkXSpV2doDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DkaHBSI3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DkaHBSI3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85BE61F000E9;
	Tue, 21 Jul 2026 19:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660830;
	bh=xvcGdMvDPvAOmkZ+CsSC8UERYpC10q2z5NEjz7X+4Yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DkaHBSI3i0RMKsDliZmCiUHYYbmkXMHB/wUZ8zarbh6ytDZiDxEfOHvZSiapxxBc4
	 exQg/Qqd41Guws6JDuJ7LVQuM5oz8IQ5gmTnVq+VJnuG4I0mMsr91O3mG53xVc+jIe
	 8z3YPyeK8ofyBtep2g3YmVKVe9mMHLXqWuLGqNR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Zahka <daniel.zahka@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1128/2077] eth: fbnic: take netif_addr_lock_bh() around rx mode address programming
Date: Tue, 21 Jul 2026 17:13:21 +0200
Message-ID: <20260721152619.423119262@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Zahka <daniel.zahka@gmail.com>

[ Upstream commit 96e7f9122aae0ed000ee321f324b812a447906d9 ]

When __fbnic_set_rx_mode() is called from contexts other than
.ndo_set_rx_mode_async(), the uc and mc addr lists are accessed
without the addr lock that __hw_addr_sync_dev() and
__hw_addr_unsync_dev() require. Wrap these unprotected accesses with
netif_addr_lock_bh(). fbnic_clear_rx_mode() has similar issues.

Fixes: eb690ef8d1c2 ("eth: fbnic: Add L2 address programming")
Signed-off-by: Daniel Zahka <daniel.zahka@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260617-linux-fbnic-hwaddr-v1-1-3f9f5dee7f99@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic_netdev.c | 7 ++++++-
 drivers/net/ethernet/meta/fbnic/fbnic_pci.c    | 4 ++++
 drivers/net/ethernet/meta/fbnic/fbnic_rpc.c    | 2 ++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c b/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c
index 4dea2bb58d2fca..44c046b253126b 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c
@@ -262,8 +262,11 @@ static int fbnic_set_mac(struct net_device *netdev, void *p)
 
 	eth_hw_addr_set(netdev, addr->sa_data);
 
-	if (netif_running(netdev))
+	if (netif_running(netdev)) {
+		netif_addr_lock_bh(netdev);
 		__fbnic_set_rx_mode(fbn->fbd, &netdev->uc, &netdev->mc);
+		netif_addr_unlock_bh(netdev);
+	}
 
 	return 0;
 }
@@ -308,8 +311,10 @@ void fbnic_clear_rx_mode(struct fbnic_dev *fbd)
 	/* Write updates to hardware */
 	fbnic_write_macda(fbd);
 
+	netif_addr_lock_bh(netdev);
 	__dev_uc_unsync(netdev, NULL);
 	__dev_mc_unsync(netdev, NULL);
+	netif_addr_unlock_bh(netdev);
 }
 
 static int fbnic_hwtstamp_get(struct net_device *netdev,
diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_pci.c b/drivers/net/ethernet/meta/fbnic/fbnic_pci.c
index 7e85b480203c83..8b9bc9e8ea56ca 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_pci.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_pci.c
@@ -135,7 +135,9 @@ void fbnic_up(struct fbnic_net *fbn)
 
 	fbnic_rss_reinit_hw(fbn->fbd, fbn);
 
+	netif_addr_lock_bh(fbn->netdev);
 	__fbnic_set_rx_mode(fbn->fbd, &fbn->netdev->uc, &fbn->netdev->mc);
+	netif_addr_unlock_bh(fbn->netdev);
 
 	/* Enable Tx/Rx processing */
 	fbnic_napi_enable(fbn);
@@ -180,7 +182,9 @@ static int fbnic_fw_config_after_crash(struct fbnic_dev *fbd)
 	}
 
 	fbnic_rpc_reset_valid_entries(fbd);
+	netif_addr_lock_bh(fbd->netdev);
 	__fbnic_set_rx_mode(fbd, &fbd->netdev->uc, &fbd->netdev->mc);
+	netif_addr_unlock_bh(fbd->netdev);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_rpc.c b/drivers/net/ethernet/meta/fbnic/fbnic_rpc.c
index fe95b6f6964632..bc0f38b6a2b2b4 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_rpc.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_rpc.c
@@ -244,7 +244,9 @@ void fbnic_bmc_rpc_check(struct fbnic_dev *fbd)
 
 	if (fbd->fw_cap.need_bmc_tcam_reinit) {
 		fbnic_bmc_rpc_init(fbd);
+		netif_addr_lock_bh(fbd->netdev);
 		__fbnic_set_rx_mode(fbd, &fbd->netdev->uc, &fbd->netdev->mc);
+		netif_addr_unlock_bh(fbd->netdev);
 		fbd->fw_cap.need_bmc_tcam_reinit = false;
 	}
 
-- 
2.53.0



