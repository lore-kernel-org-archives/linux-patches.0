Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10BD11DDC08;
	Mon,  6 Jan 2025 15:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178280; cv=none; b=tp8ocMY75ngycELx1gN+h0kcigp8kyN2gxweWqM6R3vr1XX0yqbhG7GbGk20LNiCmRfThy+QrWupunH1Eq6rObwaDdYpspByNV7qv5n9LAcklnb2Z7bctebdZWCAX+aG+WeOrjumnLwungMkXodxexjj9uYP+2heylBpMp04fF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178280; c=relaxed/simple;
	bh=wHHt7PeFC6TRrmirSe0KOfH1bLWONDg9BLerTNrhs6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C5XsXF6wYjASsVG0DlK8Fiyn9wlLBdWsoYuvKKR/m8elYs5YO2+aPltnvitqAeAU8prva38yeIkIEZw3cV3pstud9BI6KK+y7MiVIjKDy3eLt/DC4YbUGbdkDrDlyNwB3lZQpnwM+mtAdsZqkLpXWn98ellq2BWJeFwQdmbuFHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qtM6ACqo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qtM6ACqo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A803C4CEDF;
	Mon,  6 Jan 2025 15:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178279;
	bh=wHHt7PeFC6TRrmirSe0KOfH1bLWONDg9BLerTNrhs6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qtM6ACqoSFMMXZpulPt/qNx2mHSF6A7YTmmJR7wWTSmcLcERAvRkrz8eRxLytwi7f
	 hEfBC/P1TzFBb+YUvBKCuaZ6gJqTCvfVcKaF2YWZ90nHlF3W+Vws7xaqmaNSbsiY7d
	 tbDeU9si4KD21QU1Es52Arsji2uncr+1XGOdMPRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mhklinux@outlook.com>,
	Cathy Avery <cavery@redhat.com>,
	"Ewan D. Milne" <emilne@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 066/138] scsi: storvsc: Do not flag MAINTENANCE_IN return of SRB_STATUS_DATA_OVERRUN as an error
Date: Mon,  6 Jan 2025 16:16:30 +0100
Message-ID: <20250106151135.733059211@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cathy Avery <cavery@redhat.com>

[ Upstream commit b1aee7f034615b6824d2c70ddb37ef9fc23493b7 ]

This partially reverts commit 812fe6420a6e ("scsi: storvsc: Handle
additional SRB status values").

HyperV does not support MAINTENANCE_IN resulting in FC passthrough
returning the SRB_STATUS_DATA_OVERRUN value. Now that
SRB_STATUS_DATA_OVERRUN is treated as an error, multipath ALUA paths go
into a faulty state as multipath ALUA submits RTPG commands via
MAINTENANCE_IN.

[    3.215560] hv_storvsc 1d69d403-9692-4460-89f9-a8cbcc0f94f3:
tag#230 cmd 0xa3 status: scsi 0x0 srb 0x12 hv 0xc0000001
[    3.215572] scsi 1:0:0:32: alua: rtpg failed, result 458752

Make MAINTENANCE_IN return success to avoid the error path as is
currently done with INQUIRY and MODE_SENSE.

Suggested-by: Michael Kelley <mhklinux@outlook.com>
Signed-off-by: Cathy Avery <cavery@redhat.com>
Link: https://lore.kernel.org/r/20241127181324.3318443-1-cavery@redhat.com
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/storvsc_drv.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 37ad5f525647..7dc916ce0c3c 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -155,6 +155,8 @@ static int sense_buffer_size = PRE_WIN8_STORVSC_SENSE_BUFFER_SIZE;
 */
 static int vmstor_proto_version;
 
+static bool hv_dev_is_fc(struct hv_device *hv_dev);
+
 #define STORVSC_LOGGING_NONE	0
 #define STORVSC_LOGGING_ERROR	1
 #define STORVSC_LOGGING_WARN	2
@@ -1153,6 +1155,7 @@ static void storvsc_on_io_completion(struct storvsc_device *stor_device,
 	 * not correctly handle:
 	 * INQUIRY command with page code parameter set to 0x80
 	 * MODE_SENSE command with cmd[2] == 0x1c
+	 * MAINTENANCE_IN is not supported by HyperV FC passthrough
 	 *
 	 * Setup srb and scsi status so this won't be fatal.
 	 * We do this so we can distinguish truly fatal failues
@@ -1160,7 +1163,9 @@ static void storvsc_on_io_completion(struct storvsc_device *stor_device,
 	 */
 
 	if ((stor_pkt->vm_srb.cdb[0] == INQUIRY) ||
-	   (stor_pkt->vm_srb.cdb[0] == MODE_SENSE)) {
+	   (stor_pkt->vm_srb.cdb[0] == MODE_SENSE) ||
+	   (stor_pkt->vm_srb.cdb[0] == MAINTENANCE_IN &&
+	   hv_dev_is_fc(device))) {
 		vstor_packet->vm_srb.scsi_status = 0;
 		vstor_packet->vm_srb.srb_status = SRB_STATUS_SUCCESS;
 	}
-- 
2.39.5



