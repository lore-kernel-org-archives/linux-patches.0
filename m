Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615F546EC9C;
	Tue, 21 Jul 2026 17:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656575; cv=none; b=Pi48E0V24LgUP/HnKIkI8WvtftQboBPywJDkONzCLsSV0jgCbCT385Y0fl/YYR7CVIom5Nbp8+ac/CGLwA4lzZGy3sPW4qaOB+2+nMJE8WjdMUlLIrLiFTanoPopUoNPfgzKuz5tQPmY2nPbWRPQHjAMtCMXGRmkHuTE9lLyI00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656575; c=relaxed/simple;
	bh=EZbKsIGco2OwRP2ilPjcESreqwfsWHPY80JvvXDZtNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AfD8h0aiS4TSVF+mkQ4YRg6jILi3UD6N1dumZCfQvirnt1ZyU5uT2pxM1Jny1cLjQhNrtppWF/ms5j1D30VS/3Ze+C8mCZoHh9ohRx5wOBHi0uY6zxEqobab7sUO/v4efZwa2VdUkdbiwY/NjpIs1U2rrcCSDMwxqtq38nr0/0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IHTBOuDn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IHTBOuDn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C70731F000E9;
	Tue, 21 Jul 2026 17:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656574;
	bh=SliWCDNfUfEwWRuF7qZLFutrZdjrOhydt0UAysHNhLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IHTBOuDnt+AUXZtR0MxwOpKz+6EAy67TukH249wH38DqJjZAU1rFg3kGw1sLITWxA
	 X6nnC7Og6/KlIUuhVD6Qe9XNh0KLL40l7Ahww2+p3qCCqZOP9QprwA/2mFo7kGw6+H
	 SpJG9xUGFh5M4FDuaL8SG6CzhDw1RB6ioGtSyEjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qing Ming <a0yami@mailbox.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0439/1611] vhost/net: complete zerocopy ubufs only once
Date: Tue, 21 Jul 2026 17:09:15 +0200
Message-ID: <20260721152525.161462481@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qing Ming <a0yami@mailbox.org>

[ Upstream commit 8f6898fe80794f2d7c3d38c1158c806e4074a1c4 ]

vhost-net initializes one ubuf_info per outstanding zerocopy TX
descriptor and hands it to the backend socket.  The networking stack may
then clone a zerocopy skb before all skb references are released.  For
example, batman-adv fragmentation reaches skb_split(), which calls
skb_zerocopy_clone() and increments the same ubuf_info refcount.

vhost_zerocopy_complete() currently treats every ubuf callback as a
completed vhost descriptor.  It dereferences ubuf->ctx, writes the
descriptor completion state, and drops the vhost_net_ubuf_ref even when
the callback only releases a cloned skb reference.  A backend reset can
therefore wait for and free the vhost_net_ubuf_ref while another cloned
skb still carries the same ubuf_info.  A later completion then
dereferences the freed ubufs pointer.

KASAN reports the stale completion as:

  BUG: KASAN: slab-use-after-free in vhost_zerocopy_complete+0x1d7/0x1f0
  BUG: KASAN: slab-use-after-free in vhost_zerocopy_complete+0x101/0x1f0
  vhost_zerocopy_complete
  skb_copy_ubufs
  __dev_forward_skb2
  veth_xmit

The freed object was allocated from vhost_net_ioctl() while setting the
backend and freed through kfree_rcu()/kvfree_rcu_bulk after backend
removal, while delayed skb completion still reached
vhost_zerocopy_complete().

Honor the generic ubuf_info refcount before touching vhost state, and run
the vhost descriptor completion only for the final ubuf reference.  This
matches the msg_zerocopy_complete() ownership rule for cloned zerocopy
skbs.

Fixes: bab632d69ee4 ("vhost: vhost TX zero-copy support")
Signed-off-by: Qing Ming <a0yami@mailbox.org>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260601104300.197210-1-a0yami@mailbox.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/net.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index e11b46a1c9374c..b2b90732b1d595 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -392,13 +392,20 @@ static void vhost_zerocopy_signal_used(struct vhost_net *net,
 static void vhost_zerocopy_complete(struct sk_buff *skb,
 				    struct ubuf_info *ubuf_base, bool success)
 {
-	struct ubuf_info_msgzc *ubuf = uarg_to_msgzc(ubuf_base);
-	struct vhost_net_ubuf_ref *ubufs = ubuf->ctx;
-	struct vhost_virtqueue *vq = ubufs->vq;
+	struct ubuf_info_msgzc *ubuf;
+	struct vhost_net_ubuf_ref *ubufs;
+	struct vhost_virtqueue *vq;
 	int cnt;
 
-	rcu_read_lock_bh();
+	/* Only the final cloned skb reference completes the vhost descriptor. */
+	if (!refcount_dec_and_test(&ubuf_base->refcnt))
+		return;
+
+	ubuf = uarg_to_msgzc(ubuf_base);
+	ubufs = ubuf->ctx;
+	vq = ubufs->vq;
 
+	rcu_read_lock_bh();
 	/* set len to mark this desc buffers done DMA */
 	vq->heads[ubuf->desc].len = success ?
 		VHOST_DMA_DONE_LEN : VHOST_DMA_FAILED_LEN;
-- 
2.53.0



