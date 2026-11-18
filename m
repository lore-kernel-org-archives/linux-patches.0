Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028713;
	b=vmBXN42lc1mXdu2kvI7keLQ9IGk0pMQuCtDqc0asjB2O5i1WCXthJyuQcKet9NBN5oUg
	 2C/nbEnmqdgO7PEEEJZm/xanKhPK8ofOezxvohzaSr4Ssr+gl+mkPi5tseeGMjmWu+gUI
	 7TLBDM/1ihuWhsDxg0kiGD3VrfYSMowxlbF40Qcc7XqvQPKFw9QAEtrzKJR9JKVoQmEjJ
	 06j9pMqTf24xFZLXeQqodglZbXb5vciWKqUv/rxPyDaXn5wOnGRPVl4U70cJbHQegD1Hf
	 HdcuKR9TAkg2KV8UD9gqPkdSgjmIW1nCRdOGlZpwdmFc2NwXA1dxUfXCNWmBdYYeneQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028713;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hXZONlHlkJm0uvBLx22bjIpDTmJsiHpA/Mmynk4GGhs=;
	b=HxaQYpRIEyet3ZftCpQriXyel3T6l+fkPQ8xbx+OeK57c/Du0ADQDtvmcKOxbL+0Inch
	 6FdPkHntxKOwmt8/HafsM+drPoB8a1odm+1A1eFulT5lcAxb2F6WnuBPEvLyq7kcVI3p+
	 KCinBHnbWdUzbwZ+oX5Sk69EGwmxvIcAlQL+RGjNCRLxIkNou0kcf+NRIQvN31lJCW0C6
	 nvEX62CyYcFJgnkq2dEeTrsRMJZMppMdnMGdBkAGxWptJ/auvfU8snWexoUtUUEshTcl8
	 tliKeIaPoXA0rqKIkfEuMHuVq2OvcIMVD0GCzlDQC8lNmYddptN8xU174DlCoJO9YtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qr3AQ3Fu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C06C606A334;
	Wed, 18 Nov 2026 19:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qr3AQ3Fu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D9B41F000C5;
	Wed, 18 Nov 2026 19:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028713;
	bh=hXZONlHlkJm0uvBLx22bjIpDTmJsiHpA/Mmynk4GGhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qr3AQ3FuxxPSJN08dBzlekIAZkhd9Ni/0iENDBzAA4uZdg8fQPwSLy7yrY51i5jKP
	 IsfDPhI/xoGd/Ltoinix90eFi/U8UPzpEksm2qzYXKPYb73sQmJphfV5TCOgq0dsy5
	 Dd+pJx74jYLKaPtdV328AYthcWrmZJDEUDz9F9WA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Christie <michael.christie@oracle.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0093/1756] vhost-scsi: Reduce mem use by moving upages to per queue
Date: Wed, 18 Nov 2026 15:37:00 +0100
Message-ID: <20261118150011.955201405@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index fa0d407442914..725166d4cc79f 100644
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
@@ -624,7 +624,6 @@ vhost_scsi_get_cmd(struct vhost_virtqueue *vq, struct vhost_scsi_tpg *tpg,
 	struct vhost_scsi_nexus *tv_nexus;
 	struct scatterlist *sg, *prot_sg;
 	struct iovec *tvc_resp_iov;
-	struct page **pages;
 	int tag;
 
 	tv_nexus = tpg->tpg_nexus;
@@ -642,12 +641,10 @@ vhost_scsi_get_cmd(struct vhost_virtqueue *vq, struct vhost_scsi_tpg *tpg,
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
@@ -674,7 +671,9 @@ vhost_scsi_map_to_sgl(struct vhost_scsi_cmd *cmd,
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
@@ -1659,11 +1658,11 @@ static void vhost_scsi_destroy_vq_cmds(struct vhost_virtqueue *vq)
 
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
@@ -1689,6 +1688,11 @@ static int vhost_scsi_setup_vq_cmds(struct vhost_virtqueue *vq, int max_cmds)
 		return -ENOMEM;
 	}
 
+	svq->upages = kcalloc(VHOST_SCSI_PREALLOC_UPAGES, sizeof(struct page *),
+			      GFP_KERNEL);
+	if (!svq->upages)
+		goto out;
+
 	for (i = 0; i < max_cmds; i++) {
 		tv_cmd = &svq->scsi_cmds[i];
 
@@ -1700,14 +1704,6 @@ static int vhost_scsi_setup_vq_cmds(struct vhost_virtqueue *vq, int max_cmds)
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



