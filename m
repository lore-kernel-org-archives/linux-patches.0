Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29C02288CB;
	Thu, 12 Dec 2024 16:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021834; cv=none; b=ql9/FknF/C51lIw+1gslkeGfHOy5KmFDH2YByhSl/zJc4EnU/VFa78Qrx64LrcGjwObYs/xoZGzrv5SZgyr7ffhmE+k65ilEpZ4inXyP/OvOGAXM/b5NY+cpNoN56GJBvJbcM81Th7AoNIlA90g4g8ghg/OJQ4fJz6g/6Qemm9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021834; c=relaxed/simple;
	bh=mHYS3rbKZTO1jI3RZSRVLwl5CwCR1ypYPhdeHiT/HTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i/m3EKMA6oaSHrei7J0MHgP6a2ktI0KukLFQm4b2p3FEiYperggAy4rz9QK+opq8dpBHPHEdS2V9iJwmjcVpSbVg/dHzdfRgv6/OEy7z6RFxIf42zPpIzk+V/TZwnj1FKuY9QRs2/gzUBPf0Y2oKoRkz+qLXITY1AxsKR2US17s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QF5BXkgk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QF5BXkgk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26311C4CECE;
	Thu, 12 Dec 2024 16:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021833;
	bh=mHYS3rbKZTO1jI3RZSRVLwl5CwCR1ypYPhdeHiT/HTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QF5BXkgkxDCzc/Ps+eCO476NG6e4hm8B6QuVnmpIXVug0T6e0QY0mL0icms8OQZsy
	 i8LFQ03IC6iOb3yFXcmrbd5FbR4k57p9s9e1DresQN6GD8bjRrIpY8CuUQziSw6+ft
	 gCsAfCgdteWu+2AfDy4gMMrA0kLwarjUOH+grrBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Puranjay Mohan <pjy@amazon.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Keith Busch <kbusch@kernel.org>,
	Hagar Hemdan <hagarhem@amazon.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 075/565] nvme: fix metadata handling in nvme-passthrough
Date: Thu, 12 Dec 2024 15:54:30 +0100
Message-ID: <20241212144314.453055049@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ Move the changes from nvme_map_user_request() to nvme_submit_user_cmd()
  to make it work on 5.15 ]
Signed-off-by: Hagar Hemdan <hagarhem@amazon.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/ioctl.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 7397fad4c96ff..22ff0e617b8f0 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -61,11 +61,16 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 	bool write = nvme_is_write(cmd);
 	struct nvme_ns *ns = q->queuedata;
 	struct block_device *bdev = ns ? ns->disk->part0 : NULL;
+	bool supports_metadata = bdev && blk_get_integrity(bdev->bd_disk);
+	bool has_metadata = meta_buffer && meta_len;
 	struct request *req;
 	struct bio *bio = NULL;
 	void *meta = NULL;
 	int ret;
 
+	if (has_metadata && !supports_metadata)
+			return -EINVAL;
+
 	req = nvme_alloc_request(q, cmd, 0);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
@@ -82,7 +87,7 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 		bio = req->bio;
 		if (bdev)
 			bio_set_dev(bio, bdev);
-		if (bdev && meta_buffer && meta_len) {
+		if (has_metadata) {
 			meta = nvme_add_user_metadata(bio, meta_buffer, meta_len,
 					meta_seed, write);
 			if (IS_ERR(meta)) {
-- 
2.43.0



