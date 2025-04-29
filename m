Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9ED21772B;
	Tue, 29 Apr 2025 16:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945791; cv=none; b=gbE7KPFYtUPzAJYKMsmJJ5ANQuz6stKxQUTWMe5kkZ9WymiJ7ByTXks3/1PtKxLFfcC9upRvfRSzTZWPaRNAWiLzcgjg7bEig3+izfLsNRFaT184Pq8H1w9Bq3gF5ExcG+ton04jJPkegzHUORGabLQ/Oh7Iy6m0f6Pi0sbdgJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945791; c=relaxed/simple;
	bh=Jg+g58Vk4KOLf+fgqd3mCNZEK4wJ+WM3JxtPu4m8nwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P5pslHQiNb0jEANOm7/i5+ByrNEMUwZCkaQc7tBuXPGtpldnsFz48riUuAVPmdojOq7fSaFRSfUYsFDQ2cyCiGKCNer3+zq8NoiMftQz4zkazpKOAS3vmKIw1K/whZ+IJHfZGfZz9Nxm5zf4V+UI65yyEmoA343zUd9B13RXkTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FZ7b93rQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FZ7b93rQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66BB2C4CEE3;
	Tue, 29 Apr 2025 16:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945790;
	bh=Jg+g58Vk4KOLf+fgqd3mCNZEK4wJ+WM3JxtPu4m8nwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FZ7b93rQdD3iqSxMW3bWz4IocC533OMU4g7NeaIEZDZQK0r10fU7zcU8C+Pz7Cm/V
	 j8XhLCRaOuDSlOolsNZo7sh9sEXviK6p0c+oMBrjuZ4bvZhvFPZrGQuhJeNmwQ8DE5
	 Ty0sazGlIcI/S+hSlHdFZs+GLj6AgVZenDin/jQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dongli Zhang <dongli.zhang@oracle.com>,
	Jason Wang <jasowang@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 049/311] vhost-scsi: Fix vhost_scsi_send_status()
Date: Tue, 29 Apr 2025 18:38:06 +0200
Message-ID: <20250429161123.033256292@linuxfoundation.org>
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

From: Dongli Zhang <dongli.zhang@oracle.com>

[ Upstream commit 58465d86071b61415e25fb054201f61e83d21465 ]

Although the support of VIRTIO_F_ANY_LAYOUT + VIRTIO_F_VERSION_1 was
signaled by the commit 664ed90e621c ("vhost/scsi: Set
VIRTIO_F_ANY_LAYOUT + VIRTIO_F_VERSION_1 feature bits"),
vhost_scsi_send_bad_target() still assumes the response in a single
descriptor.

Similar issue in vhost_scsi_send_bad_target() has been fixed in previous
commit. In addition, similar issue for vhost_scsi_complete_cmd_work() has
been fixed by the commit 6dd88fd59da8 ("vhost-scsi: unbreak any layout for
response").

Fixes: 3ca51662f818 ("vhost-scsi: Add better resource allocation failure handling")
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Message-Id: <20250403063028.16045-4-dongli.zhang@oracle.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/scsi.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 7bfe5e5865fe9..35a03306d1345 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -931,18 +931,22 @@ static void vhost_scsi_target_queue_cmd(struct vhost_scsi_cmd *cmd)
 
 static void
 vhost_scsi_send_status(struct vhost_scsi *vs, struct vhost_virtqueue *vq,
-		       int head, unsigned int out, u8 status)
+		       struct vhost_scsi_ctx *vc, u8 status)
 {
-	struct virtio_scsi_cmd_resp __user *resp;
 	struct virtio_scsi_cmd_resp rsp;
+	struct iov_iter iov_iter;
 	int ret;
 
 	memset(&rsp, 0, sizeof(rsp));
 	rsp.status = status;
-	resp = vq->iov[out].iov_base;
-	ret = __copy_to_user(resp, &rsp, sizeof(rsp));
-	if (!ret)
-		vhost_add_used_and_signal(&vs->dev, vq, head, 0);
+
+	iov_iter_init(&iov_iter, ITER_DEST, &vq->iov[vc->out], vc->in,
+		      sizeof(rsp));
+
+	ret = copy_to_iter(&rsp, sizeof(rsp), &iov_iter);
+
+	if (likely(ret == sizeof(rsp)))
+		vhost_add_used_and_signal(&vs->dev, vq, vc->head, 0);
 	else
 		pr_err("Faulted on virtio_scsi_cmd_resp\n");
 }
@@ -1302,7 +1306,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 		else if (ret == -EIO)
 			vhost_scsi_send_bad_target(vs, vq, &vc, TYPE_IO_CMD);
 		else if (ret == -ENOMEM)
-			vhost_scsi_send_status(vs, vq, vc.head, vc.out,
+			vhost_scsi_send_status(vs, vq, &vc,
 					       SAM_STAT_TASK_SET_FULL);
 	} while (likely(!vhost_exceeds_weight(vq, ++c, 0)));
 out:
-- 
2.39.5



