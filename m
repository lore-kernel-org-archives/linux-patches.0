Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214961;
	b=pDk0v3J6TTOQ1Di168KAjlSPYPUGoRdOHvx4C1W1GOuAy+t76p/OZNOtzwb/0eJwq7bZ
	 UHYvtSxAFSjxBkyMmVU99mgS5m/FNBTaFZ1MtToPDmSAyYLyiv1nSU0rp8h3OPD15pXS9
	 jkaO7X1TTlGibHKaKzgF8h3rSwwLSJIgvF9Dc6IPMxJH3Fc7zUjVgxzHs/bw0yCtozwn5
	 md9xjkRR6qrnAdPvb7NV40IPFGpI05lNFYF5QyfYUhllmwAy+IhCeWu/kq0ToWQZGZ3F+
	 fYXTI+5tdNOllA07+wqxUQ7ANlc1f9TH38Q/1RLbYWSqrDdXepeDPxx6bT/BNoxGP4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214961;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IXISKfD439BSGe0FsmyGp9szsz2HteRkxEIoAlvCljQ=;
	b=25ImbKotAPO0UlddHyxBJyIJzgIwPgqc+kjp7gEsqKlMq2fMgxqgnj3RDF/59oAuerNt
	 fsy0FvnZA0wfC67+rQ4b1EHK6KHKbeTHEigNfRoCKSATJM62BFrVDqPYZNNMCNR1ul4KY
	 bufDEqK22x1rz04IfWoFXMC/zKZwLHA6S1MnR3kmZzClGRA3LR2D72ugTm2q/31I80JfJ
	 i/suE1LMamct8kJgslhVxzOEdy03SwxacOHMvRoLHGi7U19JXyyCWqxrjHwnbQgkJ+E77
	 chjgATO5DRqfZo58YhJQ4EP/++5H9nDrAm4nEWG64W+l6VLwnr6viQGYK3WR5KqL9Yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yOY6DN9x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE455606A31A;
	Wed, 28 Oct 2026 19:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yOY6DN9x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 107C21F01825;
	Wed, 28 Oct 2026 19:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214960;
	bh=IXISKfD439BSGe0FsmyGp9szsz2HteRkxEIoAlvCljQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yOY6DN9xAvC/2PfovTQgzSkc3QMpDhUYkqoDZb8Xhjkaj7PJg5+7W69wtkA3+VXnc
	 4prp8u4Zk5wCGKN65UUS0KMKR8C/8dbvDj2zPLWh36gvXp9owc1GNXCe6u03eizE2e
	 Mg2SC0qhqgEW9O7aIOX78SdvTPtzV4uI69XMznuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Stabellini <stefano.stabellini@amd.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1000/1887] 9p/xen: protect xen_9pfs_front_free against concurrent calls
Date: Wed, 28 Oct 2026 17:51:36 +0100
Message-ID: <20261028170522.169437552@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefano Stabellini <stefano.stabellini@amd.com>

[ Upstream commit ce8ded2e61f47747e31eeefb44dc24a2160a7e32 ]

The xenwatch thread can race with other back-end change notifications
and call xen_9pfs_front_free() twice, hitting the observed general
protection fault due to a double-free. Guard the teardown path so only
one caller can release the front-end state at a time, preventing the
crash.

This is a fix for the following double-free:

[   27.052347] Oops: general protection fault, probably for non-canonical address 0x6b6b6b6b6b6b6b6b: 0000 [#1] SMP DEBUG_PAGEALLOC NOPTI
[   27.052357] CPU: 0 UID: 0 PID: 32 Comm: xenwatch Not tainted 6.18.0-02087-g51ab33fc0a8b-dirty #60 PREEMPT(none)
[   27.052363] RIP: e030:xen_9pfs_front_free+0x1d/0x150
[   27.052368] Code: 90 90 90 90 90 90 90 90 90 90 90 90 90 41 55 41 54 55 48 89 fd 48 c7 c7 48 d0 92 85 53 e8 cb cb 05 00 48 8b 45 08 48 8b 55 00 <48> 3b 28 0f 85 f9 28 35 fe 48 3b 6a 08 0f 85 ef 28 35 fe 48 89 42
[   27.052377] RSP: e02b:ffffc9004016fdd0 EFLAGS: 00010246
[   27.052381] RAX: 6b6b6b6b6b6b6b6b RBX: ffff88800d66e400 RCX: 0000000000000000
[   27.052385] RDX: 6b6b6b6b6b6b6b6b RSI: 0000000000000000 RDI: 0000000000000000
[   27.052389] RBP: ffff88800a887040 R08: 0000000000000000 R09: 0000000000000000
[   27.052393] R10: 0000000000000000 R11: 0000000000000000 R12: ffff888009e46b68
[   27.052397] R13: 0000000000000200 R14: 0000000000000000 R15: ffff88800a887040
[   27.052404] FS:  0000000000000000(0000) GS:ffff88808ca57000(0000) knlGS:0000000000000000
[   27.052408] CS:  e030 DS: 0000 ES: 0000 CR0: 0000000080050033
[   27.052412] CR2: 00007f9714004360 CR3: 0000000004834000 CR4: 0000000000050660
[   27.052418] Call Trace:
[   27.052420]  <TASK>
[   27.052422]  xen_9pfs_front_changed+0x5d5/0x720
[   27.052426]  ? xenbus_otherend_changed+0x72/0x140
[   27.052430]  ? __pfx_xenwatch_thread+0x10/0x10
[   27.052434]  xenwatch_thread+0x94/0x1c0
[   27.052438]  ? __pfx_autoremove_wake_function+0x10/0x10
[   27.052442]  kthread+0xf8/0x240
[   27.052445]  ? __pfx_kthread+0x10/0x10
[   27.052449]  ? __pfx_kthread+0x10/0x10
[   27.052452]  ret_from_fork+0x16b/0x1a0
[   27.052456]  ? __pfx_kthread+0x10/0x10
[   27.052459]  ret_from_fork_asm+0x1a/0x30
[   27.052463]  </TASK>
[   27.052465] Modules linked in:
[   27.052471] ---[ end trace 0000000000000000 ]---

Signed-off-by: Stefano Stabellini <stefano.stabellini@amd.com>
Message-ID: <20260129230348.2390470-1-stefano.stabellini@amd.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_xen.c | 85 ++++++++++++++++++++++++----------------------
 1 file changed, 44 insertions(+), 41 deletions(-)

diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index 36f432ca4cd54..7b3d18f96dce4 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -273,45 +273,52 @@ static void xen_9pfs_front_free(struct xen_9pfs_front_priv *priv)
 {
 	int i, j;
 
-	write_lock(&xen_9pfs_lock);
-	list_del(&priv->list);
-	write_unlock(&xen_9pfs_lock);
-
-	for (i = 0; i < priv->num_rings; i++) {
-		struct xen_9pfs_dataring *ring = &priv->rings[i];
-
-		cancel_work_sync(&ring->work);
-
-		if (!priv->rings[i].intf)
-			break;
-		if (priv->rings[i].irq > 0)
-			unbind_from_irqhandler(priv->rings[i].irq, ring);
-		if (priv->rings[i].data.in) {
-			for (j = 0;
-			     j < (1 << priv->rings[i].intf->ring_order);
-			     j++) {
-				grant_ref_t ref;
-
-				ref = priv->rings[i].intf->ref[j];
-				gnttab_end_foreign_access(ref, NULL);
-			}
-			free_pages_exact(priv->rings[i].data.in,
+	if (priv->rings) {
+		for (i = 0; i < priv->num_rings; i++) {
+			struct xen_9pfs_dataring *ring = &priv->rings[i];
+
+			cancel_work_sync(&ring->work);
+
+			if (!priv->rings[i].intf)
+				break;
+			if (priv->rings[i].irq > 0)
+				unbind_from_irqhandler(priv->rings[i].irq, ring);
+			if (priv->rings[i].data.in) {
+				for (j = 0;
+				     j < (1 << priv->rings[i].intf->ring_order);
+				     j++) {
+					grant_ref_t ref;
+
+					ref = priv->rings[i].intf->ref[j];
+					gnttab_end_foreign_access(ref, NULL);
+				}
+				free_pages_exact(priv->rings[i].data.in,
 				   1UL << (priv->rings[i].intf->ring_order +
 					   XEN_PAGE_SHIFT));
+			}
+			gnttab_end_foreign_access(priv->rings[i].ref, NULL);
+			free_page((unsigned long)priv->rings[i].intf);
 		}
-		gnttab_end_foreign_access(priv->rings[i].ref, NULL);
-		free_page((unsigned long)priv->rings[i].intf);
+		kfree(priv->rings);
 	}
-	kfree(priv->rings);
 	kfree(priv->tag);
 	kfree(priv);
 }
 
 static void xen_9pfs_front_remove(struct xenbus_device *dev)
 {
-	struct xen_9pfs_front_priv *priv = dev_get_drvdata(&dev->dev);
+	struct xen_9pfs_front_priv *priv;
 
+	write_lock(&xen_9pfs_lock);
+	priv = dev_get_drvdata(&dev->dev);
+	if (priv == NULL) {
+		write_unlock(&xen_9pfs_lock);
+		return;
+	}
 	dev_set_drvdata(&dev->dev, NULL);
+	list_del(&priv->list);
+	write_unlock(&xen_9pfs_lock);
+
 	xen_9pfs_front_free(priv);
 }
 
@@ -378,7 +385,7 @@ static int xen_9pfs_front_init(struct xenbus_device *dev)
 {
 	int ret, i;
 	struct xenbus_transaction xbt;
-	struct xen_9pfs_front_priv *priv = dev_get_drvdata(&dev->dev);
+	struct xen_9pfs_front_priv *priv;
 	char *versions, *v;
 	unsigned int max_rings, max_ring_order, len = 0;
 
@@ -406,6 +413,10 @@ static int xen_9pfs_front_init(struct xenbus_device *dev)
 	if (p9_xen_trans.maxsize > XEN_FLEX_RING_SIZE(max_ring_order))
 		p9_xen_trans.maxsize = XEN_FLEX_RING_SIZE(max_ring_order) / 2;
 
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+	priv->dev = dev;
 	priv->num_rings = XEN_9PFS_NUM_RINGS;
 	priv->rings = kcalloc(priv->num_rings, sizeof(*priv->rings),
 			      GFP_KERNEL);
@@ -464,6 +475,11 @@ static int xen_9pfs_front_init(struct xenbus_device *dev)
 		goto error;
 	}
 
+	write_lock(&xen_9pfs_lock);
+	dev_set_drvdata(&dev->dev, priv);
+	list_add_tail(&priv->list, &xen_9pfs_devs);
+	write_unlock(&xen_9pfs_lock);
+
 	xenbus_switch_state(dev, XenbusStateInitialised);
 	return 0;
 
@@ -478,19 +494,6 @@ static int xen_9pfs_front_init(struct xenbus_device *dev)
 static int xen_9pfs_front_probe(struct xenbus_device *dev,
 				const struct xenbus_device_id *id)
 {
-	struct xen_9pfs_front_priv *priv = NULL;
-
-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
-	if (!priv)
-		return -ENOMEM;
-
-	priv->dev = dev;
-	dev_set_drvdata(&dev->dev, priv);
-
-	write_lock(&xen_9pfs_lock);
-	list_add_tail(&priv->list, &xen_9pfs_devs);
-	write_unlock(&xen_9pfs_lock);
-
 	return 0;
 }
 
-- 
2.53.0



