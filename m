Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3359D3C01;
	Tue, 27 May 2025 17:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367348; cv=none; b=C/Q27A9NHDJGfjoH+jwGGFb0aWe2G3+V7MXBjn2cgw8TYS7NoQnazFKQox+iLrqnYJ02zQNNEWTqqNU4UWWhQKihohp5bT49X+cMOKUfhcbv8srlQoOIaTpmPpMOViMeGIw6GeAUltkjj0yYmtWGEmVb7xckmjW74fzxFlSAZVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367348; c=relaxed/simple;
	bh=1tyf++Hh8wNPSvHzv27hUaB0x+MF976GcVfp/Rc7wV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MtfFSa4ZeqiHqeyisAsX6bETEfZTnq2tGlGybkwsy3b9Xc5mv0gPPbckTpYQo0UnkVUdv732rmu1PohLMpp7kQY8ACFymN+XFt8PAP8sGS5JjXb0he5GfxQ0jbow0I3/7kbqbOUJvNzG1feZCRNvotMPmRRKZsDsFhjAmX085qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TTMUM4UF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TTMUM4UF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F7AC4CEE9;
	Tue, 27 May 2025 17:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367348;
	bh=1tyf++Hh8wNPSvHzv27hUaB0x+MF976GcVfp/Rc7wV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TTMUM4UF+vILYgs6qK1TPXadcGC8mMi6M6wnLJ6LkL1Kj4cCdNnheQWEtF9vwC3wu
	 HzMKa2qhePbT5h2SWg09V+FP4LyU0WvSIHu1cDOazVZJkwtlg4WuwMJzKZrWrVewUR
	 h8agCO+SA3JL13QtU2WGtNg0yt26Uc33pwT/u9eQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Christie <michael.christie@oracle.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 359/783] vhost-scsi: Return queue full for page alloc failures during copy
Date: Tue, 27 May 2025 18:22:36 +0200
Message-ID: <20250527162527.698980224@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 891b99eab0f89dbe08d216f4ab71acbeaf7a3102 ]

This has us return queue full if we can't allocate a page during the
copy operation so the initiator can retry.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Message-Id: <20241203191705.19431-5-michael.christie@oracle.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/scsi.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index ecad2f53b7635..38d243d914d00 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -762,7 +762,7 @@ vhost_scsi_copy_iov_to_sgl(struct vhost_scsi_cmd *cmd, struct iov_iter *iter,
 	size_t len = iov_iter_count(iter);
 	unsigned int nbytes = 0;
 	struct page *page;
-	int i;
+	int i, ret;
 
 	if (cmd->tvc_data_direction == DMA_FROM_DEVICE) {
 		cmd->saved_iter_addr = dup_iter(&cmd->saved_iter, iter,
@@ -775,6 +775,7 @@ vhost_scsi_copy_iov_to_sgl(struct vhost_scsi_cmd *cmd, struct iov_iter *iter,
 		page = alloc_page(GFP_KERNEL);
 		if (!page) {
 			i--;
+			ret = -ENOMEM;
 			goto err;
 		}
 
@@ -782,8 +783,10 @@ vhost_scsi_copy_iov_to_sgl(struct vhost_scsi_cmd *cmd, struct iov_iter *iter,
 		sg_set_page(&sg[i], page, nbytes, 0);
 
 		if (cmd->tvc_data_direction == DMA_TO_DEVICE &&
-		    copy_page_from_iter(page, 0, nbytes, iter) != nbytes)
+		    copy_page_from_iter(page, 0, nbytes, iter) != nbytes) {
+			ret = -EFAULT;
 			goto err;
+		}
 
 		len -= nbytes;
 	}
@@ -798,7 +801,7 @@ vhost_scsi_copy_iov_to_sgl(struct vhost_scsi_cmd *cmd, struct iov_iter *iter,
 	for (; i >= 0; i--)
 		__free_page(sg_page(&sg[i]));
 	kfree(cmd->saved_iter_addr);
-	return -ENOMEM;
+	return ret;
 }
 
 static int
@@ -1282,9 +1285,9 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 			 " %d\n", cmd, exp_data_len, prot_bytes, data_direction);
 
 		if (data_direction != DMA_NONE) {
-			if (unlikely(vhost_scsi_mapal(cmd, prot_bytes,
-						      &prot_iter, exp_data_len,
-						      &data_iter))) {
+			ret = vhost_scsi_mapal(cmd, prot_bytes, &prot_iter,
+					       exp_data_len, &data_iter);
+			if (unlikely(ret)) {
 				vq_err(vq, "Failed to map iov to sgl\n");
 				vhost_scsi_release_cmd_res(&cmd->tvc_se_cmd);
 				goto err;
-- 
2.39.5



