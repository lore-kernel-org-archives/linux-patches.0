Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141922FA626;
	Tue, 17 Jun 2025 16:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178949; cv=none; b=EMZRaNNABLvK/1SjZ4wcoLjOKXoakDiMp1nBIbyrmu7sFE58YlUB+I1nekimxiNSU1o1Y6BDx5m4NdHLCPtidi+pLoyN8fFZQNxAEqQcg22lSlz/k7SVI+BvSWsmYfZbWo6jrdVM4+UadytKn7+Eh465E4RS1AP8kierLinmT/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178949; c=relaxed/simple;
	bh=990jIiYfhujheo4V7rl20ReJtJ/sOWv/JfuLdenXB1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oZo81Xft4D3ouYbltRvmo2QXKxCe3KUPP0E9To9M22q2dYq+hmeS+DT6NBAaC8QyXTtxXEFMmFNrpfehM26r3y7LPi255sTRe0VlSsMF/av3frmPB3YcFfBz2qSp234UCxuuHCuV6EmEPgjjL9DsZ0TodHHTQ8IyKxU8R0TZAjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0eKeX93l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0eKeX93l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC72C4CEE3;
	Tue, 17 Jun 2025 16:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178948;
	bh=990jIiYfhujheo4V7rl20ReJtJ/sOWv/JfuLdenXB1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0eKeX93lsTeTkjeCm82M1jAPh+UT+USOT6/37DD+9mpTdq3do7cDPFZx4nMoaqetM
	 FRFCTcDTcSXIIk6VUgQhyvpGT/P0uWl2BWxugI9MasRrb6wDRlnub632zcnG/ymmIN
	 R1U0rKuXQx88wRkzvyGsq1sw9zJJpGxW+5FMGwG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaitanya Kulkarni <chaitanyak@nvidia.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 601/780] nvme: fix command limits status code
Date: Tue, 17 Jun 2025 17:25:09 +0200
Message-ID: <20250617152515.957409524@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 10f4a7cd724e34b7a6ff96e57ac49dc0cadececc ]

The command specific status code, 0x183, was introduced in the NVMe 2.0
specification defined to "Command Size Limits Exceeded" and only ever
applied to DSM and Copy commands.  Fix the name and, remove the
incorrect translation to error codes and special treatment in the
target code for it.

Fixes: 3b7c33b28a44d4 ("nvme.h: add Write Zeroes definitions")
Cc: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/constants.c     | 2 +-
 drivers/nvme/host/core.c          | 1 -
 drivers/nvme/host/pr.c            | 2 --
 drivers/nvme/target/core.c        | 9 +--------
 drivers/nvme/target/io-cmd-bdev.c | 9 +--------
 include/linux/nvme.h              | 2 +-
 6 files changed, 4 insertions(+), 21 deletions(-)

diff --git a/drivers/nvme/host/constants.c b/drivers/nvme/host/constants.c
index 2b9e6cfaf2a80..1a0058be58210 100644
--- a/drivers/nvme/host/constants.c
+++ b/drivers/nvme/host/constants.c
@@ -145,7 +145,7 @@ static const char * const nvme_statuses[] = {
 	[NVME_SC_BAD_ATTRIBUTES] = "Conflicting Attributes",
 	[NVME_SC_INVALID_PI] = "Invalid Protection Information",
 	[NVME_SC_READ_ONLY] = "Attempted Write to Read Only Range",
-	[NVME_SC_ONCS_NOT_SUPPORTED] = "ONCS Not Supported",
+	[NVME_SC_CMD_SIZE_LIM_EXCEEDED	] = "Command Size Limits Exceeded",
 	[NVME_SC_ZONE_BOUNDARY_ERROR] = "Zoned Boundary Error",
 	[NVME_SC_ZONE_FULL] = "Zone Is Full",
 	[NVME_SC_ZONE_READ_ONLY] = "Zone Is Read Only",
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 6b04473c0ab73..93a8119ad5ca6 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -286,7 +286,6 @@ static blk_status_t nvme_error_status(u16 status)
 	case NVME_SC_NS_NOT_READY:
 		return BLK_STS_TARGET;
 	case NVME_SC_BAD_ATTRIBUTES:
-	case NVME_SC_ONCS_NOT_SUPPORTED:
 	case NVME_SC_INVALID_OPCODE:
 	case NVME_SC_INVALID_FIELD:
 	case NVME_SC_INVALID_NS:
diff --git a/drivers/nvme/host/pr.c b/drivers/nvme/host/pr.c
index cf2d2c5039ddb..ca6a74607b139 100644
--- a/drivers/nvme/host/pr.c
+++ b/drivers/nvme/host/pr.c
@@ -82,8 +82,6 @@ static int nvme_status_to_pr_err(int status)
 		return PR_STS_SUCCESS;
 	case NVME_SC_RESERVATION_CONFLICT:
 		return PR_STS_RESERVATION_CONFLICT;
-	case NVME_SC_ONCS_NOT_SUPPORTED:
-		return -EOPNOTSUPP;
 	case NVME_SC_BAD_ATTRIBUTES:
 	case NVME_SC_INVALID_OPCODE:
 	case NVME_SC_INVALID_FIELD:
diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 245475c43127f..69b1ddff6731f 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -62,14 +62,7 @@ inline u16 errno_to_nvme_status(struct nvmet_req *req, int errno)
 		return  NVME_SC_LBA_RANGE | NVME_STATUS_DNR;
 	case -EOPNOTSUPP:
 		req->error_loc = offsetof(struct nvme_common_command, opcode);
-		switch (req->cmd->common.opcode) {
-		case nvme_cmd_dsm:
-		case nvme_cmd_write_zeroes:
-			return NVME_SC_ONCS_NOT_SUPPORTED | NVME_STATUS_DNR;
-		default:
-			return NVME_SC_INVALID_OPCODE | NVME_STATUS_DNR;
-		}
-		break;
+		return NVME_SC_INVALID_OPCODE | NVME_STATUS_DNR;
 	case -ENODATA:
 		req->error_loc = offsetof(struct nvme_rw_command, nsid);
 		return NVME_SC_ACCESS_DENIED;
diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-cmd-bdev.c
index 83be0657e6df4..1cfa13d029bfa 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -145,15 +145,8 @@ u16 blk_to_nvme_status(struct nvmet_req *req, blk_status_t blk_sts)
 		req->error_loc = offsetof(struct nvme_rw_command, slba);
 		break;
 	case BLK_STS_NOTSUPP:
+		status = NVME_SC_INVALID_OPCODE | NVME_STATUS_DNR;
 		req->error_loc = offsetof(struct nvme_common_command, opcode);
-		switch (req->cmd->common.opcode) {
-		case nvme_cmd_dsm:
-		case nvme_cmd_write_zeroes:
-			status = NVME_SC_ONCS_NOT_SUPPORTED | NVME_STATUS_DNR;
-			break;
-		default:
-			status = NVME_SC_INVALID_OPCODE | NVME_STATUS_DNR;
-		}
 		break;
 	case BLK_STS_MEDIUM:
 		status = NVME_SC_ACCESS_DENIED;
diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index 2479ed10f53e3..5d7afb6079f1d 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -2094,7 +2094,7 @@ enum {
 	NVME_SC_BAD_ATTRIBUTES		= 0x180,
 	NVME_SC_INVALID_PI		= 0x181,
 	NVME_SC_READ_ONLY		= 0x182,
-	NVME_SC_ONCS_NOT_SUPPORTED	= 0x183,
+	NVME_SC_CMD_SIZE_LIM_EXCEEDED	= 0x183,
 
 	/*
 	 * I/O Command Set Specific - Fabrics commands:
-- 
2.39.5



