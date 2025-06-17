Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD642E92AD;
	Tue, 17 Jun 2025 16:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177758; cv=none; b=ruK7ez7VGBphPySL5xNDIS5GMLmaygWD3HmXbPOWDNM2xtESxenA0rj2dv+3HEEdrrQdKeDhAgrsjC4M0l1L0f7wB/NKG0Zn1MHfJ5mC/fyzWbGbzxvi1KnSJIfHrcZ6C1P/HSRPJgF4nzpvxh4mFaaoiqXImVhVXMe4+BFdd54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177758; c=relaxed/simple;
	bh=7MlrkWcjD7/Kk0K+u1ONZqWrdkfJe7LxEBrwpjdTJsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pNcR6yMniTsOaZP+hBXDK8KUvoDi0ORFBXgYkbNx3Coymwxlfl+G/lLynQIRyUlffCkRGVVLuaimMJU+6NhOeO6yOCvejxQd7Gzb68/VB8VAC3OLPUZZcFLRHHYGSjm+5GN/sao+4HgWtgFz99CMcz6Xc4Jani3NbzYuR9fE05I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dqcZeuDn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dqcZeuDn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B65EBC4CEE3;
	Tue, 17 Jun 2025 16:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177757;
	bh=7MlrkWcjD7/Kk0K+u1ONZqWrdkfJe7LxEBrwpjdTJsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dqcZeuDnfKWzeynOvqIMlUFx8JRBJKENA7NpfvZej189v8H4ULzmx0+gyJOwjBnVj
	 BDUTyuPH1GgBYEnOH4tjuuqTzg0xhBcO+uHO+JnjGXRGZQAxnAkQpAqeaNAgFoavC/
	 vPbGndB+/yejihLM8Z0II4MBDpV6hVd62ml6tnIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjian Song <jinjian.song@fibocom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 369/512] net: wwan: t7xx: Fix napi rx poll issue
Date: Tue, 17 Jun 2025 17:25:35 +0200
Message-ID: <20250617152434.537772388@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjian Song <jinjian.song@fibocom.com>

[ Upstream commit 905fe0845bb27e4eed2ca27ea06e6c4847f1b2b1 ]

When driver handles the napi rx polling requests, the netdev might
have been released by the dellink logic triggered by the disconnect
operation on user plane. However, in the logic of processing skb in
polling, an invalid netdev is still being used, which causes a panic.

BUG: kernel NULL pointer dereference, address: 00000000000000f1
Oops: 0000 [#1] PREEMPT SMP NOPTI
RIP: 0010:dev_gro_receive+0x3a/0x620
[...]
Call Trace:
 <IRQ>
 ? __die_body+0x68/0xb0
 ? page_fault_oops+0x379/0x3e0
 ? exc_page_fault+0x4f/0xa0
 ? asm_exc_page_fault+0x22/0x30
 ? __pfx_t7xx_ccmni_recv_skb+0x10/0x10 [mtk_t7xx (HASH:1400 7)]
 ? dev_gro_receive+0x3a/0x620
 napi_gro_receive+0xad/0x170
 t7xx_ccmni_recv_skb+0x48/0x70 [mtk_t7xx (HASH:1400 7)]
 t7xx_dpmaif_napi_rx_poll+0x590/0x800 [mtk_t7xx (HASH:1400 7)]
 net_rx_action+0x103/0x470
 irq_exit_rcu+0x13a/0x310
 sysvec_apic_timer_interrupt+0x56/0x90
 </IRQ>

Fixes: 5545b7b9f294 ("net: wwan: t7xx: Add NAPI support")
Signed-off-by: Jinjian Song <jinjian.song@fibocom.com>
Link: https://patch.msgid.link/20250530031648.5592-1-jinjian.song@fibocom.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/t7xx/t7xx_netdev.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wwan/t7xx/t7xx_netdev.c b/drivers/net/wwan/t7xx/t7xx_netdev.c
index 91fa082e9cab8..fc0a7cb181df2 100644
--- a/drivers/net/wwan/t7xx/t7xx_netdev.c
+++ b/drivers/net/wwan/t7xx/t7xx_netdev.c
@@ -302,7 +302,7 @@ static int t7xx_ccmni_wwan_newlink(void *ctxt, struct net_device *dev, u32 if_id
 	ccmni->ctlb = ctlb;
 	ccmni->dev = dev;
 	atomic_set(&ccmni->usage, 0);
-	ctlb->ccmni_inst[if_id] = ccmni;
+	WRITE_ONCE(ctlb->ccmni_inst[if_id], ccmni);
 
 	ret = register_netdevice(dev);
 	if (ret)
@@ -324,6 +324,7 @@ static void t7xx_ccmni_wwan_dellink(void *ctxt, struct net_device *dev, struct l
 	if (WARN_ON(ctlb->ccmni_inst[if_id] != ccmni))
 		return;
 
+	WRITE_ONCE(ctlb->ccmni_inst[if_id], NULL);
 	unregister_netdevice(dev);
 }
 
@@ -419,7 +420,7 @@ static void t7xx_ccmni_recv_skb(struct t7xx_ccmni_ctrl *ccmni_ctlb, struct sk_bu
 
 	skb_cb = T7XX_SKB_CB(skb);
 	netif_id = skb_cb->netif_idx;
-	ccmni = ccmni_ctlb->ccmni_inst[netif_id];
+	ccmni = READ_ONCE(ccmni_ctlb->ccmni_inst[netif_id]);
 	if (!ccmni) {
 		dev_kfree_skb(skb);
 		return;
@@ -441,7 +442,7 @@ static void t7xx_ccmni_recv_skb(struct t7xx_ccmni_ctrl *ccmni_ctlb, struct sk_bu
 
 static void t7xx_ccmni_queue_tx_irq_notify(struct t7xx_ccmni_ctrl *ctlb, int qno)
 {
-	struct t7xx_ccmni *ccmni = ctlb->ccmni_inst[0];
+	struct t7xx_ccmni *ccmni = READ_ONCE(ctlb->ccmni_inst[0]);
 	struct netdev_queue *net_queue;
 
 	if (netif_running(ccmni->dev) && atomic_read(&ccmni->usage) > 0) {
@@ -453,7 +454,7 @@ static void t7xx_ccmni_queue_tx_irq_notify(struct t7xx_ccmni_ctrl *ctlb, int qno
 
 static void t7xx_ccmni_queue_tx_full_notify(struct t7xx_ccmni_ctrl *ctlb, int qno)
 {
-	struct t7xx_ccmni *ccmni = ctlb->ccmni_inst[0];
+	struct t7xx_ccmni *ccmni = READ_ONCE(ctlb->ccmni_inst[0]);
 	struct netdev_queue *net_queue;
 
 	if (atomic_read(&ccmni->usage) > 0) {
@@ -471,7 +472,7 @@ static void t7xx_ccmni_queue_state_notify(struct t7xx_pci_dev *t7xx_dev,
 	if (ctlb->md_sta != MD_STATE_READY)
 		return;
 
-	if (!ctlb->ccmni_inst[0]) {
+	if (!READ_ONCE(ctlb->ccmni_inst[0])) {
 		dev_warn(&t7xx_dev->pdev->dev, "No netdev registered yet\n");
 		return;
 	}
-- 
2.39.5



