Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038990;
	b=LHbsN3mSg226dlRK1bfGk1Z+tI8nCju3OBRdW0JAhFn8hP2mGa+QwwAakL5xtvK2huKc
	 yQkJ0cW/NAHo6dzZP5kYT7nNWX1uxt54O5qeKzH3FzH55fPwqMKNuzmhrhnP/9aUn1zJ4
	 mQGf26umwlwHBTRNWV3QZstn9zYYU7O86Msca8pUQesBPRuyY2v79ygHtTdDscV72+VLN
	 OaWVTMnHuiFrXdi6OXp6fJnyYxSKXzsid0UhwvcADFcVEpBPvAxcVWeBujkCwFiFldqA5
	 MnwkCRvnkRnhjj/OSA6qZrHhpU3Msqz6pObytEVFummuvCKl9vhffj1+YiMHEpCfrIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038990;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ieEhfKZs+slVlqmPrVmpIL2oUq1/f1TSag1YKIpOgvQ=;
	b=nLqHFsCHfvFYeTIS7FqOW2dKHf/yx3nh9O/9qfMyslpnj7XWYZRg1m741s3ou48arvyP
	 vi3IE4vGPWmMxGvg38dI5Xzq81bPqTKGVXco/b846wAQyqZ2+e+rSYHJWYD1PcZe/uNGq
	 1Rpb+TDmwg9TNgrcUn12cGCYjyWk3VcTgX8apuBNa5UsZZApoA+xPfBlotK7YVdVnXl+i
	 nwXoibrUtH+/28Xxwff+Y6gRbCuHCzPp3wj+niMLq3EbGcjBqDmf5jt7zCWPTUzOHPU6z
	 +z7Du5B2EoYKkxoIVwogmdG4nhhSRlZLtanOV9YeWKy7tvXqq1YL8rNLjQnUypifgNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Pq1AUF/A";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA53606A325;
	Wed, 18 Nov 2026 21:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pq1AUF/A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E12C1F000C4;
	Wed, 18 Nov 2026 21:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038990;
	bh=ieEhfKZs+slVlqmPrVmpIL2oUq1/f1TSag1YKIpOgvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pq1AUF/ApNff4Tz7QhOLqF9pv5MCm+pAfVTHURxV3GYaS4tmM+sm3O4Zmex5P7mI4
	 Q393QPLcP5P7GgyhWFfAjdanDhi208UlllpYdZDX9X1pNdsqDlzM+MpNxbkvZRDV/3
	 ZTFLcj6FmJ/bvyWlfYcMF5c6t3Zajmlw0KdpPrKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Christie <michael.christie@oracle.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1940/3318] vhost-scsi: Reduce mem use by moving upages to per queue
Date: Wed, 18 Nov 2026 15:42:42 +0100
Message-ID: <20261118150420.245021405@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 4c1f3a7d74277903b290dd989cbd2ea8627fc925 ]

Each worker thread can process 1 command at a time so there's no need to
allocate a upages array per cmd. This patch moves it to per queue. Even a
small device with 128 cmds and 1 queue this brings mem use for the array
from

2 MB = 8 bytes per page pointer * 2048 pointers * 128 cmds

to

16K = 8 bytes per pointer * 2048 * 1 queue

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Message-Id: <20241203191705.19431-2-michael.christie@oracle.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Stefan Hajnoczi <stefanha@redhat.com>
Stable-dep-of: 01c3a5fa6d64 ("vhost-scsi: zero misaligned I/O bounce pages")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/scsi.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 7603597efe5ef..5fa9aab9279b6 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -83,7 +83,6 @@ struct vhost_scsi_cmd {
 	/* Pointer to the SGL formatted memory from virtio-scsi */
 	struct scatterlist *tvc_sgl;
 	struct scatterlist *tvc_prot_sgl;
-	struct page **tvc_upages;
 	/* Pointer to response header iovec */
 	struct iovec *tvc_resp_iov;
 	/* Pointer to vhost_scsi for our device */
@@ -187,6 +186,7 @@ struct vhost_scsi_virtqueue {
 	struct vhost_scsi_cmd *scsi_cmds;
 	struct sbitmap scsi_tags;
 	int max_cmds;
+	struct page **upages;
 
 	struct vhost_work completion_work;
 	struct llist_head completion_list;
@@ -613,7 +613,6 @@ vhost_scsi_get_cmd(struct vhost_virtqueue *vq, struct vhost_scsi_tpg *tpg,
 	struct vhost_scsi_nexus *tv_nexus;
 	struct scatterlist *sg, *prot_sg;
 	struct iovec *tvc_resp_iov;
-	struct page **pages;
 	int tag;
 
 	tv_nexus = tpg->tpg_nexus;
@@ -631,12 +630,10 @@ vhost_scsi_get_cmd(struct vhost_virtqueue *vq, struct vhost_scsi_tpg *tpg,
 	cmd = &svq->scsi_cmds[tag];
 	sg = cmd->tvc_sgl;
 	prot_sg = cmd->tvc_prot_sgl;
-	pages = cmd->tvc_upages;
 	tvc_resp_iov = cmd->tvc_resp_iov;
 	memset(cmd, 0, sizeof(*cmd));
 	cmd->tvc_sgl = sg;
 	cmd->tvc_prot_sgl = prot_sg;
-	cmd->tvc_upages = pages;
 	cmd->tvc_se_cmd.map_tag = tag;
 	cmd->tvc_tag = scsi_tag;
 	cmd->tvc_lun = lun;
@@ -663,7 +660,9 @@ vhost_scsi_map_to_sgl(struct vhost_scsi_cmd *cmd,
 		      struct scatterlist *sgl,
 		      bool is_prot)
 {
-	struct page **pages = cmd->tvc_upages;
+	struct vhost_scsi_virtqueue *svq = container_of(cmd->tvc_vq,
+					struct vhost_scsi_virtqueue, vq);
+	struct page **pages = svq->upages;
 	struct scatterlist *sg = sgl;
 	ssize_t bytes, mapped_bytes;
 	size_t offset, mapped_offset;
@@ -1596,11 +1595,11 @@ static void vhost_scsi_destroy_vq_cmds(struct vhost_virtqueue *vq)
 
 		kfree(tv_cmd->tvc_sgl);
 		kfree(tv_cmd->tvc_prot_sgl);
-		kfree(tv_cmd->tvc_upages);
 		kfree(tv_cmd->tvc_resp_iov);
 	}
 
 	sbitmap_free(&svq->scsi_tags);
+	kfree(svq->upages);
 	kfree(svq->scsi_cmds);
 	svq->scsi_cmds = NULL;
 }
@@ -1626,6 +1625,11 @@ static int vhost_scsi_setup_vq_cmds(struct vhost_virtqueue *vq, int max_cmds)
 		return -ENOMEM;
 	}
 
+	svq->upages = kcalloc(VHOST_SCSI_PREALLOC_UPAGES, sizeof(struct page *),
+			      GFP_KERNEL);
+	if (!svq->upages)
+		goto out;
+
 	for (i = 0; i < max_cmds; i++) {
 		tv_cmd = &svq->scsi_cmds[i];
 
@@ -1637,14 +1641,6 @@ static int vhost_scsi_setup_vq_cmds(struct vhost_virtqueue *vq, int max_cmds)
 			goto out;
 		}
 
-		tv_cmd->tvc_upages = kcalloc(VHOST_SCSI_PREALLOC_UPAGES,
-					     sizeof(struct page *),
-					     GFP_KERNEL);
-		if (!tv_cmd->tvc_upages) {
-			pr_err("Unable to allocate tv_cmd->tvc_upages\n");
-			goto out;
-		}
-
 		tv_cmd->tvc_resp_iov = kcalloc(UIO_MAXIOV,
 					       sizeof(struct iovec),
 					       GFP_KERNEL);
-- 
2.53.0



