Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8696F2FE;
	Thu, 12 Dec 2024 15:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017943; cv=none; b=Wil5HTQpRSdG//X4uTEancbujZReJEIS5PsmWkWdJ7OL9/3psNttvyJXxHlsSzW6KhUA4C8+CQ+ni7m1qwYMJe1pWlnFMZxVO+MOK3M7N6VzA3Mqpm5DuJd9g0kUXxeveSLJzkNL22TP6SEi/S3NGNQd0gKIDZ2zPg4HpYmh7u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017943; c=relaxed/simple;
	bh=VDIVKRPu4nEUvruy7X+lWwItgNP0uHHi1sfSDarG4wg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I1R9fPvY1reuOQK8YSkGnjrC5Xc9ubxUgQWtZppeT+GmXpog2U2biQEihSEc7Rm7WCSpQ8r2WTPHU+5Ls7moZbhPRTPawmOCMeaijZlP+W2weJpNha185w7hu3in2b+Y+OZ7H5AsYKfvcfVLftbWIJd/t7jSHBKvnHGvzLuJDZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ysijjgog; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ysijjgog"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80340C4CECE;
	Thu, 12 Dec 2024 15:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017943;
	bh=VDIVKRPu4nEUvruy7X+lWwItgNP0uHHi1sfSDarG4wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ysijjgogiTGepmiGREfARYfrZ5UOkvTkp4znET/TbVSWUKAPCgC3ov6iwR2xwQdXT
	 Cafw61lEIjkIl9VZCZFPhCdSRhT84RDbt1vNqUReneZoiYFP6DgS8426CCTkrNcGmU
	 r69qtwweeNpKSNELHRsRmJ5CpF7JCThHY5vaIGBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.g.garry@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 127/356] scsi: scsi_debug: Fix hrtimer support for ndelay
Date: Thu, 12 Dec 2024 15:57:26 +0100
Message-ID: <20241212144249.672561722@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Garry <john.g.garry@oracle.com>

[ Upstream commit 6918141d815acef056a0d10e966a027d869a922d ]

Since commit 771f712ba5b0 ("scsi: scsi_debug: Fix cmd duration
calculation"), ns_from_boot value is only evaluated in schedule_resp()
for polled requests.

However, ns_from_boot is also required for hrtimer support for when
ndelay is less than INCLUSIVE_TIMING_MAX_NS, so fix up the logic to
decide when to evaluate ns_from_boot.

Fixes: 771f712ba5b0 ("scsi: scsi_debug: Fix cmd duration calculation")
Signed-off-by: John Garry <john.g.garry@oracle.com>
Link: https://lore.kernel.org/r/20241202130045.2335194-1-john.g.garry@oracle.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 9c0af50501f9a..841f924746781 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5583,7 +5583,7 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 	}
 	sd_dp = &sqcp->sd_dp;
 
-	if (polled)
+	if (polled || (ndelay > 0 && ndelay < INCLUSIVE_TIMING_MAX_NS))
 		ns_from_boot = ktime_get_boottime_ns();
 
 	/* one of the resp_*() response functions is called here */
-- 
2.43.0



