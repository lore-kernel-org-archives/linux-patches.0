Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F851D3653;
	Tue,  8 Oct 2024 13:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393416; cv=none; b=sjQemek5zPmpi7VZI5jcZHmCP+P798fAGJ0m/wCZUwLW+P77DCvsX6Vb18csaP2sAEMsxI3XlFky9s31Y8Xi4d5WfTffJBGhsfVT4j/KYsJbpW3P2eiZgsIQG3cZCMlK3DD3TuIOY1YenAGSbDVcZeHNzMB4pHm9D7wRNc2ZIpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393416; c=relaxed/simple;
	bh=gq1ooTITyYhUImZb+P8Fmb4cxMNEpmhy9wvSFYsePIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kEkC2qCFn3eqinI7MDhm8Ee0NwMkZYWBVjLjM3vzka96b2wQTLEr8hzCVcgwtS0aD4Bh2R0GSmGYpuwjE2zIjUconC1kWSOB1qPGFeYxTRFAN5/WayMPU8ftSfrufFI/T17ot7NG1Wyq7s0BK7an18mAZXavaWelE4CUWk1JAr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wmCxU8/b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wmCxU8/b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE018C4CEC7;
	Tue,  8 Oct 2024 13:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393416;
	bh=gq1ooTITyYhUImZb+P8Fmb4cxMNEpmhy9wvSFYsePIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wmCxU8/bkOQiMMC1x5X2Yg5HXjEhXc+T0K7+e3f5nh3ofalROP+MeRuOe+Fc07s/b
	 bpGYuDakTSR9nSjntH5vtUIjn5TtTJQo24MR6Vs+oxwo1QCppsqjk5RIBCASW2qhpb
	 51x9TQWSHn2xkOXO39nyH3NLfTMT3/0vT3lmZDH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Scott Benesh <scott.benesh@microchip.com>,
	Scott Teel <scott.teel@microchip.com>,
	Mike McGowen <mike.mcgowen@microchip.com>,
	Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>,
	Don Brace <don.brace@microchip.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 145/386] scsi: smartpqi: correct stream detection
Date: Tue,  8 Oct 2024 14:06:30 +0200
Message-ID: <20241008115635.134605845@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

From: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>

[ Upstream commit 4c76114932d1d6fad2e72823e7898a3c960cf2a7 ]

Correct stream detection by initializing the structure
pqi_scsi_dev_raid_map_data to 0s.

When the OS issues SCSI READ commands, the driver erroneously considers
them as SCSI WRITES. If they are identified as sequential IOs, the driver
then submits those requests via the RAID path instead of the AIO path.

The 'is_write' flag might be set for SCSI READ commands also.  The driver
may interpret SCSI READ commands as SCSI WRITE commands, resulting in IOs
being submitted through the RAID path.

Note: This does not cause data corruption.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
Link: https://lore.kernel.org/r/20240827185501.692804-3-don.brace@microchip.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 2ae64cda8bc9e..0af2d366c85f9 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -5918,7 +5918,7 @@ static bool pqi_is_parity_write_stream(struct pqi_ctrl_info *ctrl_info,
 	int rc;
 	struct pqi_scsi_dev *device;
 	struct pqi_stream_data *pqi_stream_data;
-	struct pqi_scsi_dev_raid_map_data rmd;
+	struct pqi_scsi_dev_raid_map_data rmd = { 0 };
 
 	if (!ctrl_info->enable_stream_detection)
 		return false;
-- 
2.43.0



