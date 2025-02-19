Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E081DE4CC;
	Wed, 19 Feb 2025 09:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956686; cv=none; b=HLfDx94alpbF/3iQbdRM4FpmpN7si9NHVaN3FY7n5h8IgLEqqQYguhDWdExDhlMnWOQ4O7ApSkiw3jASy3dri3JDeDOAu+7t61BWw9nTBcKw3oVVONdmF9W+7ldMIfSspN7TL2F9qIu9VAsmyJP+AnfducgVO/AeVTHO8JGeJJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956686; c=relaxed/simple;
	bh=VISn+zkwH46DKaHTRbB1ChacsT5Xzufc5UXudgcS9Qc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mnfSJC5OZOfSDPuNcQmGeHP3zWs91PziyEDH3ZBXsdjoRsujlzFA4IVIVf86mgapw+diKVmvUDc1tvQMnE/YQTK6JpYi7X/2O17mcBd3kt/dvoA0ara2Qe3fs0hj/rxcejnKmJbTBTHqXVESpkS6XiaaGdpmHqS9kQxzbP3j4+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2rPiVCkF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2rPiVCkF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BA97C4CEE8;
	Wed, 19 Feb 2025 09:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956685;
	bh=VISn+zkwH46DKaHTRbB1ChacsT5Xzufc5UXudgcS9Qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2rPiVCkFjG+xl+D4gKV0irg8866J1eDEFIR/ItOYRMRf/BqL8s766XJOABR97yfqm
	 GWG5Y2fO1U2larGIOiuMjxkIXchSb39qFtFIeuieQHCICQHV4ctLfSa2DWfeqiWOGx
	 haFWKNOIzYtcB82JjyPe+lEdHxDh9VQN8CvnSUsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Puranjay Mohan <pjy@amazon.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Keith Busch <kbusch@kernel.org>,
	Hagar Hemdan <hagarhem@amazon.com>
Subject: [PATCH 6.1 247/578] nvme: fix metadata handling in nvme-passthrough
Date: Wed, 19 Feb 2025 09:24:11 +0100
Message-ID: <20250219082702.748812057@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Puranjay Mohan <pjy@amazon.com>

commit 7c2fd76048e95dd267055b5f5e0a48e6e7c81fd9 upstream.

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
[ Minor changes to make it work on 6.1 ]
Signed-off-by: Puranjay Mohan <pjy@amazon.com>
Signed-off-by: Hagar Hemdan <hagarhem@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/ioctl.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2011-2014, Intel Corporation.
  * Copyright (c) 2017-2021 Christoph Hellwig.
  */
+#include <linux/blk-integrity.h>
 #include <linux/ptrace.h>	/* for force_successful_syscall_return */
 #include <linux/nvme_ioctl.h>
 #include <linux/io_uring.h>
@@ -95,10 +96,15 @@ static int nvme_map_user_request(struct
 	struct request_queue *q = req->q;
 	struct nvme_ns *ns = q->queuedata;
 	struct block_device *bdev = ns ? ns->disk->part0 : NULL;
+	bool supports_metadata = bdev && blk_get_integrity(bdev->bd_disk);
+	bool has_metadata = meta_buffer && meta_len;
 	struct bio *bio = NULL;
 	void *meta = NULL;
 	int ret;
 
+	if (has_metadata && !supports_metadata)
+		return -EINVAL;
+
 	if (ioucmd && (ioucmd->flags & IORING_URING_CMD_FIXED)) {
 		struct iov_iter iter;
 
@@ -122,7 +128,7 @@ static int nvme_map_user_request(struct
 	if (bdev)
 		bio_set_dev(bio, bdev);
 
-	if (bdev && meta_buffer && meta_len) {
+	if (has_metadata) {
 		meta = nvme_add_user_metadata(req, meta_buffer, meta_len,
 				meta_seed);
 		if (IS_ERR(meta)) {


