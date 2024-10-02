Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740FD1D358C;
	Wed,  2 Oct 2024 14:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879506; cv=none; b=WDLo2Tg9Qu3oL8J5GXbnW55upUhkHNIu6eWckMY5iN2uF03E3+K7RHwm37Vi+lbxCx+CFwG/JMo6IeM0wSjt+Iv3IncDjWh/iRiPIPAcMm9CdYgJVtmuv5Nx2nabxvwexNKRtzIRfwI/gg5r9msilq8n0ZxBgVzQ9IlY8YUBFc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879506; c=relaxed/simple;
	bh=VmID93sDalZuN0Fj8fA6yZkNqlGGYxVNNxasvkxvb8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fS1hOFVIvsiR0W/Ha/5HjE2Nd08drE0oCHi0/2cdyCLE9apS20W3txFJ/VuF7YID5JZ1xuUKIQc8sOcMyhI/crn9qqmuZXbYLNlWH2xShiOwU715UvQ7CUiRpy1SO6UHU3NYveJ7XrRL16H3K8pofHT4b8otLwEV5B1PAlaoLNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xFV8mtNZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xFV8mtNZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F13F9C4CEC2;
	Wed,  2 Oct 2024 14:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879506;
	bh=VmID93sDalZuN0Fj8fA6yZkNqlGGYxVNNxasvkxvb8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xFV8mtNZL30IyapXVkVz7t6ueFWrAkCX1o/WXA8c1fI8WsyqO2L5yOxjTWwqD8QET
	 pZInAEEORkhVT9EHewGI24M7OzVbpsgMNfKKtgYTUwRM3G6QZw7tD1i3xyimZSHwwM
	 RAzKY/azd1pI3t8mvaG1M6qNxcfMEcr/TqffixUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Scott Benesh <scott.benesh@microchip.com>,
	Scott Teel <scott.teel@microchip.com>,
	Mike McGowen <mike.mcgowen@microchip.com>,
	Gilbert Wu <Gilbert.Wu@microchip.com>,
	Don Brace <don.brace@microchip.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 143/538] scsi: smartpqi: revert propagate-the-multipath-failure-to-SML-quickly
Date: Wed,  2 Oct 2024 14:56:22 +0200
Message-ID: <20241002125757.886140538@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Gilbert Wu <Gilbert.Wu@microchip.com>

[ Upstream commit f1393d52e6cda9c20f12643cbecf1e1dc357e0e2 ]

Correct a rare multipath failure issue by reverting commit 94a68c814328
("scsi: smartpqi: Quickly propagate path failures to SCSI midlayer") [1].

Reason for revert: The patch propagated the path failure to SML quickly
when one of the path fails during IO and AIO path gets disabled for a
multipath device.

But it created a new issue: when creating a volume on an encryption-enabled
controller, the firmware reports the AIO path is disabled, which cause the
driver to report a path failure to SML for a multipath device.

There will be a new fix to handle "Illegal request" and "Invalid field in
parameter list" on RAID path when the AIO path is disabled on a multipath
device.

[1] https://lore.kernel.org/all/164375209313.440833.9992416628621839233.stgit@brunhilda.pdev.net/

Fixes: 94a68c814328 ("scsi: smartpqi: Quickly propagate path failures to SCSI midlayer")
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: Gilbert Wu <Gilbert.Wu@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
Link: https://lore.kernel.org/r/20240711194704.982400-4-don.brace@microchip.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 20 ++------------------
 1 file changed, 2 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 868453b18c9ae..2ae64cda8bc9e 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -2355,14 +2355,6 @@ static inline void pqi_mask_device(u8 *scsi3addr)
 	scsi3addr[3] |= 0xc0;
 }
 
-static inline bool pqi_is_multipath_device(struct pqi_scsi_dev *device)
-{
-	if (pqi_is_logical_device(device))
-		return false;
-
-	return (device->path_map & (device->path_map - 1)) != 0;
-}
-
 static inline bool pqi_expose_device(struct pqi_scsi_dev *device)
 {
 	return !device->is_physical_device || !pqi_skip_device(device->scsi3addr);
@@ -3259,14 +3251,12 @@ static void pqi_process_aio_io_error(struct pqi_io_request *io_request)
 	int residual_count;
 	int xfer_count;
 	bool device_offline;
-	struct pqi_scsi_dev *device;
 
 	scmd = io_request->scmd;
 	error_info = io_request->error_info;
 	host_byte = DID_OK;
 	sense_data_length = 0;
 	device_offline = false;
-	device = scmd->device->hostdata;
 
 	switch (error_info->service_response) {
 	case PQI_AIO_SERV_RESPONSE_COMPLETE:
@@ -3291,14 +3281,8 @@ static void pqi_process_aio_io_error(struct pqi_io_request *io_request)
 			break;
 		case PQI_AIO_STATUS_AIO_PATH_DISABLED:
 			pqi_aio_path_disabled(io_request);
-			if (pqi_is_multipath_device(device)) {
-				pqi_device_remove_start(device);
-				host_byte = DID_NO_CONNECT;
-				scsi_status = SAM_STAT_CHECK_CONDITION;
-			} else {
-				scsi_status = SAM_STAT_GOOD;
-				io_request->status = -EAGAIN;
-			}
+			scsi_status = SAM_STAT_GOOD;
+			io_request->status = -EAGAIN;
 			break;
 		case PQI_AIO_STATUS_NO_PATH_TO_DEVICE:
 		case PQI_AIO_STATUS_INVALID_DEVICE:
-- 
2.43.0



