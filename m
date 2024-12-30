Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B8B15E8B;
	Mon, 30 Dec 2024 15:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573828; cv=none; b=awjKDQy5oJCLHiH6FWjrVUWLkOVMKKlWj9u9WBd7TstxdZG3Gj2ktyRUgVDCZhUGh8kFBOP1qAlwjnAvCjD4BRMTjhssip1deyfSwLT7BfyBHW/ay6883rQH+cYoJK+OuzzTX9IQgWSTaZYmoW7eJJSdxL8TOqSdD4GmV8t182w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573828; c=relaxed/simple;
	bh=mn/1HmaRzpWVk58MMBSqnyTxWwPoT79NwPmkQf72qcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nmP4uETUa9VK4CBcfeb2tkB5rEBaQLopb+/1KZAOqawxDUY1nFI1qmCk4T/jJs52BHgIw6h1LEaca0Oz70b0IItyYQkx6hdyV24UG60eaVEVg2/9Mp8gQ9JAb6bvkY2oksubKX7Ai1HhzNdorY+tkjqUs9itpOH/jGmN/VDcizA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j1balGL4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j1balGL4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D5FC4CED0;
	Mon, 30 Dec 2024 15:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573828;
	bh=mn/1HmaRzpWVk58MMBSqnyTxWwPoT79NwPmkQf72qcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j1balGL4WWyf8AARjLLEOaAcqxjx2XHGbGPnIUBpHBdtHA6EpiWXU+JssClGv/ygo
	 Hxpg9yV4UZRGYu9l4/J3QSCv/ghFsMnVJDrrEijxhwU/AFJgFBro/pTFwCpFu8bK+2
	 XOHWPa29bz5sp3ORyxOW/A/ezSe9R4mta2mzdKHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mhklinux@outlook.com>,
	Cathy Avery <cavery@redhat.com>,
	"Ewan D. Milne" <emilne@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 46/86] scsi: storvsc: Do not flag MAINTENANCE_IN return of SRB_STATUS_DATA_OVERRUN as an error
Date: Mon, 30 Dec 2024 16:42:54 +0100
Message-ID: <20241230154213.462968790@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7ceb982040a5..d0b55c1fa908 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -149,6 +149,8 @@ struct hv_fc_wwn_packet {
 */
 static int vmstor_proto_version;
 
+static bool hv_dev_is_fc(struct hv_device *hv_dev);
+
 #define STORVSC_LOGGING_NONE	0
 #define STORVSC_LOGGING_ERROR	1
 #define STORVSC_LOGGING_WARN	2
@@ -1138,6 +1140,7 @@ static void storvsc_on_io_completion(struct storvsc_device *stor_device,
 	 * not correctly handle:
 	 * INQUIRY command with page code parameter set to 0x80
 	 * MODE_SENSE command with cmd[2] == 0x1c
+	 * MAINTENANCE_IN is not supported by HyperV FC passthrough
 	 *
 	 * Setup srb and scsi status so this won't be fatal.
 	 * We do this so we can distinguish truly fatal failues
@@ -1145,7 +1148,9 @@ static void storvsc_on_io_completion(struct storvsc_device *stor_device,
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



