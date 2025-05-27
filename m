Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AE4F27BF79;
	Tue, 27 May 2025 17:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367371; cv=none; b=UutGLty75squUqvvqwdI80gD0vncgNZbUHATYW99kb6LfismSDM6r6sQLLO0bLW+c6IIwwN1WPU7FKEvxQjN5U/XG5xwdOVG2krJ5zXTJcXNvLMGpZvsOSx6nkIC6F/rm85qxE05YmOEN1UkZuMDTLGLHrEbeiVT+GMQpmIn0Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367371; c=relaxed/simple;
	bh=y5/RMR+/2VVN7JZNlGHku/7IZctFwofY04lXx2OIawU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bMfiNJC8VIBVS5h/PZXlX5gvF2ujl1KOz40CNL1KMzavgd/arajFXaUqgZdGYcewX0KWSY7LZRSzC3I3z+4SlO8f8yHpGWJZJoa+3VFMGSFLKd0wOOficOO0FLSuAKDv5ySru7LIw9QzmgHPfT6DXw5HaQE6iS0PvHnYYa0JjtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jq1yRL4a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jq1yRL4a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B8B7C4CEE9;
	Tue, 27 May 2025 17:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367370;
	bh=y5/RMR+/2VVN7JZNlGHku/7IZctFwofY04lXx2OIawU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jq1yRL4aVaRIabnSe9EshsenNLsk8Gp7hFiyouinn3B4YRuFfmB24MUKf/mvAeImC
	 Kt8hL4R4yO6MbOQo0XbmdTIPK02ZSaAfgS5wqOqN0Kdln4Oj5lRW4pKHLpYGTbCPOQ
	 K6CMAv0+MvEDM/t+gsC5xmcVE+nkVB2eeU+SppSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 365/783] scsi: mpi3mr: Update timestamp only for supervisor IOCs
Date: Tue, 27 May 2025 18:22:42 +0200
Message-ID: <20250527162527.945516505@linuxfoundation.org>
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

From: Ranjan Kumar <ranjan.kumar@broadcom.com>

[ Upstream commit 83a9d30d29f275571f6e8f879f04b2379be7eb6c ]

The driver issues the time stamp update command periodically. Even if the
command fails with supervisor only IOC Status.

Instead check the Non-Supervisor capability bit reported by IOC as part of
IOC Facts.

Co-developed-by: Sumit Saxena <sumit.saxena@broadcom.com>
Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Link: https://lore.kernel.org/r/20250220142528.20837-3-ranjan.kumar@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index f6d3db3fd0d8e..604f37e5c0c35 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -2747,7 +2747,10 @@ static void mpi3mr_watchdog_work(struct work_struct *work)
 		return;
 	}
 
-	if (mrioc->ts_update_counter++ >= mrioc->ts_update_interval) {
+	if (!(mrioc->facts.ioc_capabilities &
+		MPI3_IOCFACTS_CAPABILITY_NON_SUPERVISOR_IOC) &&
+		(mrioc->ts_update_counter++ >= mrioc->ts_update_interval)) {
+
 		mrioc->ts_update_counter = 0;
 		mpi3mr_sync_timestamp(mrioc);
 	}
-- 
2.39.5



