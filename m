Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4113A1C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:14:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B637CC433D2;
	Mon, 20 Mar 2023 15:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679325287;
	bh=YTwt102BhJc/wmok+1eqBlZgfszbAecEam3vPLOa1oQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wZi4RzNGITkKr+3VN65ZSg3DOQ5UMv+hPBDX1F+iQr37ymUtsQkAgRx9nBFGghZBF
	 9rgRxci4ZiLPtf28PDJlTePU7XSY5xMce/Xp36K6K8L9o915KlO8wBgR1Utyyg7QD3
	 /sa4QDBvgEpMr9tmRNjmrTa6GiHph7MD0RCa4bTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <ming.lei@redhat.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 064/198] nvme: fix handling single range discard request
Date: Mon, 20 Mar 2023 15:53:22 +0100
Message-Id: <20230320145510.230823799@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 37f0dc2ec78af0c3f35dd05578763de059f6fe77 ]

When investigating one customer report on warning in nvme_setup_discard,
we observed the controller(nvme/tcp) actually exposes
queue_max_discard_segments(req->q) == 1.

Obviously the current code can't handle this situation, since contiguity
merge like normal RW request is taken.

Fix the issue by building range from request sector/nr_sectors directly.

Fixes: b35ba01ea697 ("nvme: support ranged discard requests")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 2031fd960549c..a95e48b51da66 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -779,16 +779,26 @@ static blk_status_t nvme_setup_discard(struct nvme_ns *ns, struct request *req,
 		range = page_address(ns->ctrl->discard_page);
 	}
 
-	__rq_for_each_bio(bio, req) {
-		u64 slba = nvme_sect_to_lba(ns, bio->bi_iter.bi_sector);
-		u32 nlb = bio->bi_iter.bi_size >> ns->lba_shift;
-
-		if (n < segments) {
-			range[n].cattr = cpu_to_le32(0);
-			range[n].nlb = cpu_to_le32(nlb);
-			range[n].slba = cpu_to_le64(slba);
+	if (queue_max_discard_segments(req->q) == 1) {
+		u64 slba = nvme_sect_to_lba(ns, blk_rq_pos(req));
+		u32 nlb = blk_rq_sectors(req) >> (ns->lba_shift - 9);
+
+		range[0].cattr = cpu_to_le32(0);
+		range[0].nlb = cpu_to_le32(nlb);
+		range[0].slba = cpu_to_le64(slba);
+		n = 1;
+	} else {
+		__rq_for_each_bio(bio, req) {
+			u64 slba = nvme_sect_to_lba(ns, bio->bi_iter.bi_sector);
+			u32 nlb = bio->bi_iter.bi_size >> ns->lba_shift;
+
+			if (n < segments) {
+				range[n].cattr = cpu_to_le32(0);
+				range[n].nlb = cpu_to_le32(nlb);
+				range[n].slba = cpu_to_le64(slba);
+			}
+			n++;
 		}
-		n++;
 	}
 
 	if (WARN_ON_ONCE(n != segments)) {
-- 
2.39.2



