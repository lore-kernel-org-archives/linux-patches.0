Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7443846A5F6;
	Tue, 21 Jul 2026 15:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649589; cv=none; b=bMn9ObwaZTmMo2DGy5dRF7bvziBDldfbaYjjqxEB2C3JsmJJpxLTp77nhxbAs1v8Xt7I2x0hR3laqdyWQCbKMumfr/p0iuIb/ee3jy9jS/M0m7xTF+QJBxHYmXK7+j/tDbkyE8K3qEYuNNyDDhQSrtZF9HCV11GGhn9YzIX/d48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649589; c=relaxed/simple;
	bh=UoL8B7j99GgF0Nm5g7Nv2bnavC19GYDW+3UMoPV4YpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WVrex0nqmZX4LGlEV0irn+4hM36VTP4miD0p6Q8zw2zhMICnafV2Z5xyj0K+tnqhsuxafCWVE9x6YXZdf1Mc+JRzlBODFai+HeRp4EYi2R+9EG4CwRrr3zgvvWsjZYlKeiWOo9rJV/us1rBeTJfar5IR/zdh0JDB8kg5u/7l/x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=11PuA6cU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="11PuA6cU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7E231F000E9;
	Tue, 21 Jul 2026 15:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649588;
	bh=gXZPDdCB+djGxkWZsSJuF5A2+rbVly1E4pmQxSc7nWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=11PuA6cUHj6sxfBJsZWUpCSTlilj9EawNgmheno+koHPub6ls9pKDFezcXlTl+xV4
	 bP7+6NDLVCb1DGHwINFbXosHaMmvkh5D0Bw6LhMQudLyeb3714otDyJGUFYr4OKp/B
	 Jx5NjoSc8LVruuxGxdtYXeguFYd3qd/2HAB57LlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qing Ming <a0yami@mailbox.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0633/2077] vhost/net: complete zerocopy ubufs only once
Date: Tue, 21 Jul 2026 17:05:06 +0200
Message-ID: <20260721152607.738372079@linuxfoundation.org>
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
index c6536cad9c4f94..b9af63fb630602 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -390,13 +390,20 @@ static void vhost_zerocopy_signal_used(struct vhost_net *net,
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



