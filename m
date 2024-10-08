Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9466B183CB8;
	Tue,  8 Oct 2024 12:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391633; cv=none; b=iC9EvOd/5ptGyyXHVTSjg+V6udxIExU991KyOZrNiJ1rGJtMI28LzcRjrPX92IMFoLWqEMTQHGvQpxQADSY2dVPA2Nys2X4+hNaV2fgpLHRcbt+X+FSjth2TR7sNmQA+74OIQKE3c/KipUl4ZhEm0jZhyGPsx5NdCwgmaRaYBxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391633; c=relaxed/simple;
	bh=RLb1QAmJGfr8+zLZXPhPirWBR+IG7TCinhAvRmfUsSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q+VTShvTmTMLbI80dKLJGk8S1Y9Fh2mbvlQJInYkah4eU5C4FAlwY76jjifyru6339f4iZh/xxLUgNdCtHJJpe2GNG2efvKmh0y+b46WxA0kzYhfL9aiAexP5XYkZDifD+XgZYYsxKijwefFYKfUe8ApBCBojgtfKFQ2ghq13uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=STS/b2Vt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="STS/b2Vt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14BBCC4CEC7;
	Tue,  8 Oct 2024 12:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391633;
	bh=RLb1QAmJGfr8+zLZXPhPirWBR+IG7TCinhAvRmfUsSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=STS/b2VtJSpu4sqyPVnvO6Ca11ZNSz2ZtA+7QJaP3uMAvil1UpZCynwHs0Uevs9uo
	 BcHtK2Po7X+ZSGBwUA8+vlyxSFC4poce65cKIfRNqvP9NSeN2aPfu+fWTnEL4qOolf
	 LIf8kIXoe6lV8eEaRE9u+7ZI5oF/Q3QOGjZfza+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Puranjay Mohan <pjy@amazon.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 146/558] nvme: fix metadata handling in nvme-passthrough
Date: Tue,  8 Oct 2024 14:02:56 +0200
Message-ID: <20241008115708.108698204@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Puranjay Mohan <pjy@amazon.com>

[ Upstream commit 7c2fd76048e95dd267055b5f5e0a48e6e7c81fd9 ]

On an NVMe namespace that does not support metadata, it is possible to
send an IO command with metadata through io-passthru. This allows issues
like [1] to trigger in the completion code path.
nvme_map_user_request() doesn't check if the namespace supports metadata
before sending it forward. It also allows admin commands with metadata to
be processed as it ignores metadata when bdev == NULL and may report
success.

Reject an IO command with metadata when the NVMe namespace doesn't
support it and reject an admin command if it has metadata.

[1] https://lore.kernel.org/all/mb61pcylvnym8.fsf@amazon.com/

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Puranjay Mohan <pjy@amazon.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/ioctl.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index f1d58e70933f5..15c93ce07e263 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -4,6 +4,7 @@
  * Copyright (c) 2017-2021 Christoph Hellwig.
  */
 #include <linux/bio-integrity.h>
+#include <linux/blk-integrity.h>
 #include <linux/ptrace.h>	/* for force_successful_syscall_return */
 #include <linux/nvme_ioctl.h>
 #include <linux/io_uring/cmd.h>
@@ -119,9 +120,14 @@ static int nvme_map_user_request(struct request *req, u64 ubuffer,
 	struct request_queue *q = req->q;
 	struct nvme_ns *ns = q->queuedata;
 	struct block_device *bdev = ns ? ns->disk->part0 : NULL;
+	bool supports_metadata = bdev && blk_get_integrity(bdev->bd_disk);
+	bool has_metadata = meta_buffer && meta_len;
 	struct bio *bio = NULL;
 	int ret;
 
+	if (has_metadata && !supports_metadata)
+		return -EINVAL;
+
 	if (ioucmd && (ioucmd->flags & IORING_URING_CMD_FIXED)) {
 		struct iov_iter iter;
 
@@ -143,15 +149,15 @@ static int nvme_map_user_request(struct request *req, u64 ubuffer,
 		goto out;
 
 	bio = req->bio;
-	if (bdev) {
+	if (bdev)
 		bio_set_dev(bio, bdev);
-		if (meta_buffer && meta_len) {
-			ret = bio_integrity_map_user(bio, meta_buffer, meta_len,
-						     meta_seed);
-			if (ret)
-				goto out_unmap;
-			req->cmd_flags |= REQ_INTEGRITY;
-		}
+
+	if (has_metadata) {
+		ret = bio_integrity_map_user(bio, meta_buffer, meta_len,
+					     meta_seed);
+		if (ret)
+			goto out_unmap;
+		req->cmd_flags |= REQ_INTEGRITY;
 	}
 
 	return ret;
-- 
2.43.0



