Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B202153DD;
	Thu, 12 Dec 2024 17:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025015; cv=none; b=k6huyyK66MFg2FWPfYK7ZK9DT9A5Mh/gWtBurMXdq3jbBO2xWj9clEb7c/mWPBUSSJ+PdU/+7q2RpsL0De5iGm3UuzecW+hJ3Io9u8pnM8849FjpGOJyG3PE+knonCD2VhiKFPx6ZCG4d7X2nJ4syc6PCgOpQktdE5M+nOg9u68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025015; c=relaxed/simple;
	bh=vFcQScARS2pxCOlDaGuQFKcjEEpjwJ32x1+09ory8IU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XvsE/04LJTeKfPJldYpyXsiKqcIDUBjE2Vjd7ajXRVUDMpBOb0PcHDGBthklqnr7hqXW2SwBybo09FRLy2lOKZuvpOGzZlkokChljT5r3YA64TcXxWAN5zhXA96AoCbjkAYuOETR8ecMQ+ygwP9t9loC7Lw+HyRVw9/5BBHUN/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WF1/8hqC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WF1/8hqC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9308C4CECE;
	Thu, 12 Dec 2024 17:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025015;
	bh=vFcQScARS2pxCOlDaGuQFKcjEEpjwJ32x1+09ory8IU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WF1/8hqCw57ay5cVccnPvJ+5A6Yu+JQl4joSHh1pkor/1fnutjiXze2UIqBGce0W+
	 4VqMdWIwpGISR/JdT+R/hlCviyS2mK5BCwZSt1iZwbgbJ62OR0oyrdi3fJfu/Rw9p5
	 vFuNZnOYerighqJzQR3gRv7ygcSsJ/GoC67r9pNQ=
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
Subject: [PATCH 5.4 027/321] nvme: fix metadata handling in nvme-passthrough
Date: Thu, 12 Dec 2024 15:59:05 +0100
Message-ID: <20241212144231.075907860@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
  to make it work on 5.4 ]
Signed-off-by: Hagar Hemdan <hagarhem@amazon.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 0676637e1eab6..a841fd4929adc 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -921,11 +921,16 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 	bool write = nvme_is_write(cmd);
 	struct nvme_ns *ns = q->queuedata;
 	struct gendisk *disk = ns ? ns->disk : NULL;
+	bool supports_metadata = disk && blk_get_integrity(disk);
+	bool has_metadata = meta_buffer && meta_len;
 	struct request *req;
 	struct bio *bio = NULL;
 	void *meta = NULL;
 	int ret;
 
+	if (has_metadata && !supports_metadata)
+		return -EINVAL;
+
 	req = nvme_alloc_request(q, cmd, 0, NVME_QID_ANY);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
@@ -940,7 +945,7 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 			goto out;
 		bio = req->bio;
 		bio->bi_disk = disk;
-		if (disk && meta_buffer && meta_len) {
+		if (has_metadata) {
 			meta = nvme_add_user_metadata(bio, meta_buffer, meta_len,
 					meta_seed, write);
 			if (IS_ERR(meta)) {
-- 
2.43.0



