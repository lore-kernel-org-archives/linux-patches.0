Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC890242934;
	Tue, 29 Apr 2025 16:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945788; cv=none; b=q+7orphl/pjPpoPk4eCU3ZvHYdNM1wJswaMWlPoMwNkkL/h4vRp9Wgm8ZerIkwHUV1JYhAoYTO3JIdGtx8U4utWwcTJkV8aLLJ5zUu9i7w7WftmUNfmhQZ+UT7s4BgPf25aItHHK5KFddWiRa8wTpCGfHQhK+J7svp+GExByblM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945788; c=relaxed/simple;
	bh=7kLr7SunNzVfdwnbhRtdHg2YdyCKrro8XqrhKhqxV/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BA6n2hhoRDBdS1mp9o1vfLlchdM043oS1ET23FNprCD4iMI/IFxniaqmuanAAZKOw3MM78F1bduscV58m1l314Y7CQgEEmGW+9TyQAHIoh10P7LRiJ+p5Di5THmmgyH9RxcI/2QWDoAci1gF/TP1OdkOSBr4ZD3sU0O4VUrKitg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BqaWB2Xw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BqaWB2Xw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E4D2C4CEE3;
	Tue, 29 Apr 2025 16:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945787;
	bh=7kLr7SunNzVfdwnbhRtdHg2YdyCKrro8XqrhKhqxV/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BqaWB2XwLuo5BVn6lsYc27rdrLMs0OWnrz9OnhvYq4tMicZt7DoFxx116Q6xE4m1y
	 +sV1Z0Pwtt2czGpl55nWLzJAsSywXpDSamjniCqPAvOemRfcMiiar3FPaBQVpaT80/
	 JyXvVrES6rgJgsaVjGFyM7k02PYy+NudYYojmD1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dongli Zhang <dongli.zhang@oracle.com>,
	Jason Wang <jasowang@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 048/311] vhost-scsi: Fix vhost_scsi_send_bad_target()
Date: Tue, 29 Apr 2025 18:38:05 +0200
Message-ID: <20250429161122.992386841@linuxfoundation.org>
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

[ Upstream commit b182687135474d7ed905a07cc6cb2734b359e13e ]

Although the support of VIRTIO_F_ANY_LAYOUT + VIRTIO_F_VERSION_1 was
signaled by the commit 664ed90e621c ("vhost/scsi: Set
VIRTIO_F_ANY_LAYOUT + VIRTIO_F_VERSION_1 feature bits"),
vhost_scsi_send_bad_target() still assumes the response in a single
descriptor.

In addition, although vhost_scsi_send_bad_target() is used by both I/O
queue and control queue, the response header is always
virtio_scsi_cmd_resp. It is required to use virtio_scsi_ctrl_tmf_resp or
virtio_scsi_ctrl_an_resp for control queue.

Fixes: 664ed90e621c ("vhost/scsi: Set VIRTIO_F_ANY_LAYOUT + VIRTIO_F_VERSION_1 feature bits")
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Message-Id: <20250403063028.16045-3-dongli.zhang@oracle.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/scsi.c | 48 ++++++++++++++++++++++++++++++++++----------
 1 file changed, 37 insertions(+), 11 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index ad7fa5bc0f5fc..7bfe5e5865fe9 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -947,23 +947,46 @@ vhost_scsi_send_status(struct vhost_scsi *vs, struct vhost_virtqueue *vq,
 		pr_err("Faulted on virtio_scsi_cmd_resp\n");
 }
 
+#define TYPE_IO_CMD    0
+#define TYPE_CTRL_TMF  1
+#define TYPE_CTRL_AN   2
+
 static void
 vhost_scsi_send_bad_target(struct vhost_scsi *vs,
 			   struct vhost_virtqueue *vq,
-			   int head, unsigned out)
+			   struct vhost_scsi_ctx *vc, int type)
 {
-	struct virtio_scsi_cmd_resp __user *resp;
-	struct virtio_scsi_cmd_resp rsp;
+	union {
+		struct virtio_scsi_cmd_resp cmd;
+		struct virtio_scsi_ctrl_tmf_resp tmf;
+		struct virtio_scsi_ctrl_an_resp an;
+	} rsp;
+	struct iov_iter iov_iter;
+	size_t rsp_size;
 	int ret;
 
 	memset(&rsp, 0, sizeof(rsp));
-	rsp.response = VIRTIO_SCSI_S_BAD_TARGET;
-	resp = vq->iov[out].iov_base;
-	ret = __copy_to_user(resp, &rsp, sizeof(rsp));
-	if (!ret)
-		vhost_add_used_and_signal(&vs->dev, vq, head, 0);
+
+	if (type == TYPE_IO_CMD) {
+		rsp_size = sizeof(struct virtio_scsi_cmd_resp);
+		rsp.cmd.response = VIRTIO_SCSI_S_BAD_TARGET;
+	} else if (type == TYPE_CTRL_TMF) {
+		rsp_size = sizeof(struct virtio_scsi_ctrl_tmf_resp);
+		rsp.tmf.response = VIRTIO_SCSI_S_BAD_TARGET;
+	} else {
+		rsp_size = sizeof(struct virtio_scsi_ctrl_an_resp);
+		rsp.an.response = VIRTIO_SCSI_S_BAD_TARGET;
+	}
+
+	iov_iter_init(&iov_iter, ITER_DEST, &vq->iov[vc->out], vc->in,
+		      rsp_size);
+
+	ret = copy_to_iter(&rsp, rsp_size, &iov_iter);
+
+	if (likely(ret == rsp_size))
+		vhost_add_used_and_signal(&vs->dev, vq, vc->head, 0);
 	else
-		pr_err("Faulted on virtio_scsi_cmd_resp\n");
+		pr_err("Faulted on virtio scsi type=%d\n", type);
 }
 
 static int
@@ -1277,7 +1300,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 		if (ret == -ENXIO)
 			break;
 		else if (ret == -EIO)
-			vhost_scsi_send_bad_target(vs, vq, vc.head, vc.out);
+			vhost_scsi_send_bad_target(vs, vq, &vc, TYPE_IO_CMD);
 		else if (ret == -ENOMEM)
 			vhost_scsi_send_status(vs, vq, vc.head, vc.out,
 					       SAM_STAT_TASK_SET_FULL);
@@ -1510,7 +1533,10 @@ vhost_scsi_ctl_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 		if (ret == -ENXIO)
 			break;
 		else if (ret == -EIO)
-			vhost_scsi_send_bad_target(vs, vq, vc.head, vc.out);
+			vhost_scsi_send_bad_target(vs, vq, &vc,
+						   v_req.type == VIRTIO_SCSI_T_TMF ?
+						   TYPE_CTRL_TMF :
+						   TYPE_CTRL_AN);
 	} while (likely(!vhost_exceeds_weight(vq, ++c, 0)));
 out:
 	mutex_unlock(&vq->mutex);
-- 
2.39.5



