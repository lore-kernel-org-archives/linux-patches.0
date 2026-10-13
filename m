Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49FE3128B8;
	Tue, 13 Oct 2026 12:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893978; cv=none; b=QMCVUytANdm2PvIu+T4VGc/VPJ9s79XWwAjobKJcW+fRgIR+Nx4gW5G0FczkJEis3UwJqwBk8ZcuMoktd2MW7/rwV9ShN68NE0V+EdXyUsO31mymmXSGDvfpNRE3aazOJ5dFxD/KDXp77BbUThiMBccRn53wULJhpLJcmrKrowU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893978; c=relaxed/simple;
	bh=AA0y/TUPbUE6iaJhv+CmdPf+AyFK1CH2xjc0Kw5Wetk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qVuDc9r7ju+Hbc3nwCt95cHgnmbAZTraHkEIkgGFq2orTIc95heeVlw+k6D5/zSgWncFWtGI0fS0NH7pIWA5EWp59FwkPJexFBow10ToGF+TIs5oA3qU1/BtYcifIcytL0sKfuc1oGYS/fGY/G32Lv0UrH3rdooL3RJwUfREmyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FWIGMWRL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FWIGMWRL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B3B1F000FF;
	Tue, 13 Oct 2026 12:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893977;
	bh=qNF56PWK2Ht7HyMlulZDlzzpiD6CtBKQcOXvE/4/Ojg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FWIGMWRLvx707nkf+qqitUgUlGznFAxpEMPrApo1VDjjRu/3cSLO5tI8PQvRn1W79
	 s4JvcbmmpnmStvKwWmHgzavP/R8w0L1eoD7HpxFSB1Iu+q3EI/vCX+w0eF3xrTonyk
	 zcrT9v6KwrcrBeURi7kfLtXexM9bsCBFMIsBytRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Protopopov <a.s.protopopov@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 407/621] virtio_net: Fix resize of the RX ring
Date: Tue, 13 Oct 2026 13:36:42 +0200
Message-ID: <20261013112930.498386081@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Anton Protopopov <a.s.protopopov@gmail.com>

[ Upstream commit d09c98a6da215bce2173a292e4b95c8de6ea5d51 ]

When a AF_XDP socket is attached, the virtnet_rx_resize
should resize the rq->xsk_buffs XSK buffer array. Otherwise,
when the size grows, the virtnet_rx_resume() causes a write
past the end of the array. This is easily reproducable with

    ethtool -G ens3 rx 32
    ./xdpsock -i eth0 -q 0 -r -z &
    ethtool -G eth0 rx 256

Fixes: e9f3962441c0 ("virtio_net: xsk: rx: support fill with xsk buffer")
Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
Link: https://patch.msgid.link/20260810120728.47445-1-a.s.protopopov@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index f337fed30c6f7..b7ab57f4e277a 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3525,17 +3525,31 @@ static void virtnet_rx_resume(struct virtnet_info *vi, struct receive_queue *rq)
 static int virtnet_rx_resize(struct virtnet_info *vi,
 			     struct receive_queue *rq, u32 ring_num)
 {
+	unsigned int old_ring_num = virtqueue_get_vring_size(rq->vq);
+	struct xdp_buff **tmp_xsk_buffs = NULL;
 	int err, qindex;
 
 	qindex = rq - vi->rq;
 
+	if (rq->xsk_pool && ring_num > old_ring_num) {
+		tmp_xsk_buffs = kvzalloc_objs(*tmp_xsk_buffs, ring_num);
+		if (!tmp_xsk_buffs)
+			return -ENOMEM;
+	}
+
 	virtnet_rx_pause(vi, rq);
 
 	err = virtqueue_resize(rq->vq, ring_num, virtnet_rq_unmap_free_buf, NULL);
+
+	/* virtqueue_resize may have changed the size even if err != 0 */
+	if (tmp_xsk_buffs && virtqueue_get_vring_size(rq->vq) > old_ring_num)
+		swap(rq->xsk_buffs, tmp_xsk_buffs);
+
 	if (err)
 		netdev_err(vi->dev, "resize rx fail: rx queue index: %d err: %d\n", qindex, err);
 
 	virtnet_rx_resume(vi, rq);
+	kvfree(tmp_xsk_buffs);
 	return err;
 }
 
-- 
2.53.0



