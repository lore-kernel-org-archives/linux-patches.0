Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2BCD272E7C;
	Tue, 21 Oct 2025 19:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076502; cv=none; b=TZpopkA56AEMF0UlGbsjUehiaRx6Ep2niORTMOckzTOFRVl7VheIDj6OCMBDF1O4giWbRCwEKsgrLQg8E9ZK8bc98oshM40qRC2YMHvb+Q09ixzz35rD8zSKw1eCPPCSPvBGpYYK6jlfXGGridg7SapFwmhKz41Wu7LSODco23U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076502; c=relaxed/simple;
	bh=PlPDd15spc5Eq+oQj6tj/qehLHX4bCJ0Wt4WhjBexao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=htkG3SjapDYHavOxZtV7FlczPJhyhUi/ArXPZt1VHwWNNSeHMkaNeNLEwbVPVu/VuojmvDh6sX4lDFun1lG1osfBDXxQgNNG0TcAs4Dc76ceUXJBXTsJtBSw6Yl/LuvnKtCvfjOlpOjm+/MFqosU8ubDFhRLZPcRxR7hxexA5dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g/Ik5y1C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g/Ik5y1C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FBD7C4CEF7;
	Tue, 21 Oct 2025 19:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076502;
	bh=PlPDd15spc5Eq+oQj6tj/qehLHX4bCJ0Wt4WhjBexao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g/Ik5y1CDtYZE31Ns1eHqLt47rDJSih3nFaUCyouIIRsmoojw94/57SMtuXHD7B1p
	 eYW7WGKnsiLFc+lLuDMxAFlmYoN48Y/Tz6Wu76UwVSJjxZltGJISJa2iHsuqiff+vX
	 /ra1r95P1I6X7ELwIejgvAO/QyHXE72uVIubDwNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Chaudhary <achaudhary@purestorage.com>,
	Randy Jennings <randyj@purestorage.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 052/105] nvme-multipath: Skip nr_active increments in RETRY disposition
Date: Tue, 21 Oct 2025 21:51:01 +0200
Message-ID: <20251021195022.917124814@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
References: <20251021195021.492915002@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Chaudhary <achaudhary@purestorage.com>

[ Upstream commit bb642e2d300ee27dcede65cda7ffc47a7047bd69 ]

For queue-depth I/O policy, this patch fixes unbalanced I/Os across
nvme multipaths.

Issue Description:

The RETRY disposition incorrectly increments ns->ctrl->nr_active
counter and reinitializes iostat start-time. In such cases nr_active
counter never goes back to zero until that path disconnects and
reconnects.

Such a path is not chosen for new I/Os if multiple RETRY cases on a given
a path cause its queue-depth counter to be artificially higher compared
to other paths. This leads to unbalanced I/Os across paths.

The patch skips incrementing nr_active if NVME_MPATH_CNT_ACTIVE is already
set. And it skips restarting io stats if NVME_MPATH_IO_STATS is already set.

base-commit: e989a3da2d371a4b6597ee8dee5c72e407b4db7a
Fixes: d4d957b53d91eeb ("nvme-multipath: support io stats on the mpath device")
Signed-off-by: Amit Chaudhary <achaudhary@purestorage.com>
Reviewed-by: Randy Jennings <randyj@purestorage.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/multipath.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 119afdfe4b91e..57416bbf9344f 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -131,12 +131,14 @@ void nvme_mpath_start_request(struct request *rq)
 	struct nvme_ns *ns = rq->q->queuedata;
 	struct gendisk *disk = ns->head->disk;
 
-	if (READ_ONCE(ns->head->subsys->iopolicy) == NVME_IOPOLICY_QD) {
+	if ((READ_ONCE(ns->head->subsys->iopolicy) == NVME_IOPOLICY_QD) &&
+	    !(nvme_req(rq)->flags & NVME_MPATH_CNT_ACTIVE)) {
 		atomic_inc(&ns->ctrl->nr_active);
 		nvme_req(rq)->flags |= NVME_MPATH_CNT_ACTIVE;
 	}
 
-	if (!blk_queue_io_stat(disk->queue) || blk_rq_is_passthrough(rq))
+	if (!blk_queue_io_stat(disk->queue) || blk_rq_is_passthrough(rq) ||
+	    (nvme_req(rq)->flags & NVME_MPATH_IO_STATS))
 		return;
 
 	nvme_req(rq)->flags |= NVME_MPATH_IO_STATS;
-- 
2.51.0



