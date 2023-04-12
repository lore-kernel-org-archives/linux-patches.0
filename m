Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEBC82F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:43:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49073C4339B;
	Wed, 12 Apr 2023 08:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289021;
	bh=AZNT+Cl+hXJedy9fRIdLCIO8HMocsopZS18/9NMKlp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HrXt9HtUumP+gjxxm9zM0nIe5II83ix+b+QrYLp4p+4jxYCwDUUQxCpnvPvq6qxNL
	 bA/10VyS7bpqUZSsuJaZsR4FcYxlcTjBly2s57NdWX35V6RlN4J5iIN0/b474VOGO0
	 DuvehT5XJbhM/8+0OmoPXMv+Z0JYAqLWiAXpAJsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurence Oberman <loberman@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Niklas Cassel <niklas.cassel@wdc.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 106/164] nvme: fix discard support without oncs
Date: Wed, 12 Apr 2023 10:33:48 +0200
Message-Id: <20230412082841.122616210@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit d3205ab75e99a47539ec91ef85ba488f4ddfeaa9 ]

The device can report discard support without setting the ONCS DSM bit.
When not set, the driver clears max_discard_size expecting it to be set
later. We don't know the size until we have the namespace format,
though, so setting it is deferred until configuring one, but the driver
was abandoning the discard settings due to that initial clearing.

Move the max_discard_size calculation above the check for a '0' discard
size.

Fixes: 1a86924e4f46475 ("nvme: fix interpretation of DMRSL")
Reported-by: Laurence Oberman <loberman@redhat.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Tested-by: Laurence Oberman <loberman@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index a95e48b51da66..cb71ce3413c2d 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1711,6 +1711,9 @@ static void nvme_config_discard(struct gendisk *disk, struct nvme_ns *ns)
 	struct request_queue *queue = disk->queue;
 	u32 size = queue_logical_block_size(queue);
 
+	if (ctrl->dmrsl && ctrl->dmrsl <= nvme_sect_to_lba(ns, UINT_MAX))
+		ctrl->max_discard_sectors = nvme_lba_to_sect(ns, ctrl->dmrsl);
+
 	if (ctrl->max_discard_sectors == 0) {
 		blk_queue_max_discard_sectors(queue, 0);
 		return;
@@ -1725,9 +1728,6 @@ static void nvme_config_discard(struct gendisk *disk, struct nvme_ns *ns)
 	if (queue->limits.max_discard_sectors)
 		return;
 
-	if (ctrl->dmrsl && ctrl->dmrsl <= nvme_sect_to_lba(ns, UINT_MAX))
-		ctrl->max_discard_sectors = nvme_lba_to_sect(ns, ctrl->dmrsl);
-
 	blk_queue_max_discard_sectors(queue, ctrl->max_discard_sectors);
 	blk_queue_max_discard_segments(queue, ctrl->max_discard_segments);
 
-- 
2.39.2



