Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A20501DED79;
	Tue,  8 Oct 2024 12:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390125; cv=none; b=YOplqqAmXjWQ42xyu7gVrndYBEW9UZkqxHsG6TBRORqG5O4nF1HejoctkWbb2Gt15rUFMJrBBse4vASLgFA2XYXJTRRqhEUg3ANmVYpBSS0GWLhe1TyIVTaSRZif4P1pU5b2N2VYYEsAlNPkf08j6Z+VGUCi71ILFkFTkybCl2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390125; c=relaxed/simple;
	bh=F9W+ew9OilhKTjt5s11a8pwOIdBDuv2pYWAvzk95WFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dSefrZC7gSGjt+b2oVQjX9DCDs8Yz++YT0ShEj8G2qniV5FVHQRnwHjBKMMjLdGSw0WYGYKTT6pdtT+p52hwJld8zVh8juaSMOwd1Yf5NY7RXmQqBrXCjVlg9YxZGCHqA5B+tY4s9XoR5kRQTCSvWni1W94RlsJEiPtb5DIUnjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iGfNtcnb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iGfNtcnb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E3AC4CEC7;
	Tue,  8 Oct 2024 12:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390125;
	bh=F9W+ew9OilhKTjt5s11a8pwOIdBDuv2pYWAvzk95WFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iGfNtcnbJgBLMEeXtOjDjZgmfH5+ATRvsgTuhKXmfJT+AEAIWuvFzzoVWav20O6OT
	 IjAx1LBQefVDIuxPqfbha+D4ZWEvAhpc6IEryhhcwGd7Owd2ask10LTdoJ31tI1U7q
	 wvzmgYb+5YwVbnkFHEOEMstA5SVctMFE1Jkz1srQ=
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
Subject: [PATCH 6.10 199/482] scsi: smartpqi: correct stream detection
Date: Tue,  8 Oct 2024 14:04:22 +0200
Message-ID: <20241008115656.140215791@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 02d16fddd3123..a4719af88718e 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -5917,7 +5917,7 @@ static bool pqi_is_parity_write_stream(struct pqi_ctrl_info *ctrl_info,
 	int rc;
 	struct pqi_scsi_dev *device;
 	struct pqi_stream_data *pqi_stream_data;
-	struct pqi_scsi_dev_raid_map_data rmd;
+	struct pqi_scsi_dev_raid_map_data rmd = { 0 };
 
 	if (!ctrl_info->enable_stream_detection)
 		return false;
-- 
2.43.0



