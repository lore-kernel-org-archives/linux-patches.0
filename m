Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B1CD2F2351;
	Tue, 17 Jun 2025 16:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177626; cv=none; b=lk2oh7Jt7rwh0QcngChvrfYFXItCKk8sYjKR17Hr5Ksu3VmkLt/InenekLINl772eporBiDQsiRwPHgSLjGMJAz1rWJypxgYQOSseRZBBEGOH5d4pWVIFXFU44tpgwFIrwTW7XF92JbBAKwFoLBW1D/yxoN9jZHliMXKJ/vlA4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177626; c=relaxed/simple;
	bh=aLQ60jhA6KvhnEr7Ai9xtigQnYx/mcs3aqKG1Vsw5+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DB2d0yk8VmD30rb+KlFZq6BQFufySFBDCIaI1fTVfuTcgM5xj59G8yjWML8c8KZ12UAZomT0FmSBXjcV+7+FCSJKQxCul+ggcE4cNJk5n/IpBLLHdaJ7HO62n0g8jSFht36QuqPfdsXl5AzsWwlFPFGcle5bUwCiwHH/xRqQQWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i2tXex49; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i2tXex49"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01695C4CEE3;
	Tue, 17 Jun 2025 16:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177626;
	bh=aLQ60jhA6KvhnEr7Ai9xtigQnYx/mcs3aqKG1Vsw5+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i2tXex49kOgjXEY7vjPwlLYAj3CKAEB0bYL4fgw53WU6h41MpuoYESg8YpTrti0Em
	 ptiMJ/PJzwPJLz58+xt6cYFJsGLYxaQOPuoinget0l6T9lBPlwoO7ap9WsZ14wwJ++
	 e8WLHAMmTdBINv1FGDMzmfVvjcDHgsC/8YGNyIDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaitanya Kulkarni <chaitanyak@nvidia.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 373/512] nvme: fix command limits status code
Date: Tue, 17 Jun 2025 17:25:39 +0200
Message-ID: <20250617152434.713978007@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 98dad1bdff440..eca764fede48f 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -284,7 +284,6 @@ static blk_status_t nvme_error_status(u16 status)
 	case NVME_SC_NS_NOT_READY:
 		return BLK_STS_TARGET;
 	case NVME_SC_BAD_ATTRIBUTES:
-	case NVME_SC_ONCS_NOT_SUPPORTED:
 	case NVME_SC_INVALID_OPCODE:
 	case NVME_SC_INVALID_FIELD:
 	case NVME_SC_INVALID_NS:
diff --git a/drivers/nvme/host/pr.c b/drivers/nvme/host/pr.c
index dc7922f226004..80dd09aa01a3b 100644
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
index ed2424f8a396e..4606c88136669 100644
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
index eaf31c823cbe8..73ecbc13c5b23 100644
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
index 1c101f6fad2f3..84d4f0657b7a8 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -1954,7 +1954,7 @@ enum {
 	NVME_SC_BAD_ATTRIBUTES		= 0x180,
 	NVME_SC_INVALID_PI		= 0x181,
 	NVME_SC_READ_ONLY		= 0x182,
-	NVME_SC_ONCS_NOT_SUPPORTED	= 0x183,
+	NVME_SC_CMD_SIZE_LIM_EXCEEDED	= 0x183,
 
 	/*
 	 * I/O Command Set Specific - Fabrics commands:
-- 
2.39.5



