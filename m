Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8045A1E7640;
	Tue, 15 Oct 2024 12:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993695; cv=none; b=h7D8vbmFI6LC3gQA2t8OjXWWW1rsgnH9cnO8lRi5U5W0lmlBTHFKrW0K0UXfdG9LH4g5KILqDN6ytKX2aWFPWsn7tmYdEsNsNZKIo5T+AjhQQ8egW+wj6XqwILCC/AoNRTjeAuvABnF4rMkuLgY9G1GjA+tV3Wft8cG0yua+WxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993695; c=relaxed/simple;
	bh=ESehw1ewlO7caZP/frlp8LZgC0XNuaXQaaqvBzgimBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vf5niNUW2N+ScGLEMYIaAAUrjqZRjwUHyTc172InElWFIkCLjfs+yEx7TgqRfNQNYRRy/ZQOAKTGs92Qj4PwMXg9DrsNLosMACCZtOlRyg+KTr1iStJnRVLYIoGST7rQP2MfzOdWAPiIlv9/Yh8OcbJFsR9Xi55eqN5CCXFnRYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=duO4egUI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="duO4egUI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8D54C4CEC6;
	Tue, 15 Oct 2024 12:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993695;
	bh=ESehw1ewlO7caZP/frlp8LZgC0XNuaXQaaqvBzgimBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=duO4egUIBd6mW5cjn/5iNIOutJJCWTXb23fJf4KZI60UWkPCYHM1X7IXWQrPz/u8n
	 kfswSFeakGnXjIZPRWSOZ7kToScuDkl1qQRcQSoeqDlLaCbdQOCEs4IqbMC8Dr7OuH
	 mDnK8xUaRg1upWTzhMJNBbfQf69n4cVPv+dcJtPw=
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
Subject: [PATCH 5.15 456/691] scsi: smartpqi: correct stream detection
Date: Tue, 15 Oct 2024 13:26:44 +0200
Message-ID: <20241015112458.447313435@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e3d8de1159b51..dc6b003cd87fb 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -5646,7 +5646,7 @@ static bool pqi_is_parity_write_stream(struct pqi_ctrl_info *ctrl_info,
 	int rc;
 	struct pqi_scsi_dev *device;
 	struct pqi_stream_data *pqi_stream_data;
-	struct pqi_scsi_dev_raid_map_data rmd;
+	struct pqi_scsi_dev_raid_map_data rmd = { 0 };
 
 	if (!ctrl_info->enable_stream_detection)
 		return false;
-- 
2.43.0



