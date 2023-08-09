Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71FD4847D
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:49:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E89EEC433C7;
	Wed,  9 Aug 2023 10:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578156;
	bh=sHN2l86ZglHUnKY3f0NpZWlkA6GdjbqanbACEb6wWoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Icfz8+EU9Uhzgj8MueKL8wKov1aa16AxAVjCAvOckcs6zGkeAdkgZ5sIBI+VXqCka
	 o8oM4ztxrQRGIeCnXevMmv8ixdT7/VhHF746/b6rO9LDwsT6jjFQIPg/B1qv0VigBM
	 sTb7Ms/vlGW47UP3EtY7iKLzKLHLvMIkyY+wg2pA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mikelley@microsoft.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.4 098/165] scsi: storvsc: Limit max_sectors for virtual Fibre Channel devices
Date: Wed,  9 Aug 2023 12:40:29 +0200
Message-ID: <20230809103645.990905663@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
References: <20230809103642.720851262@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michael Kelley <mikelley@microsoft.com>

commit 010c1e1c5741365dbbf44a5a5bb9f30192875c4c upstream.

The Hyper-V host is queried to get the max transfer size that it supports,
and this value is used to set max_sectors for the synthetic SCSI
controller.  However, this max transfer size may be too large for virtual
Fibre Channel devices, which are limited to 512 Kbytes.  If a larger
transfer size is used with a vFC device, Hyper-V always returns an error,
and storvsc logs a message like this where the SRB status and SCSI status
are both zero:

hv_storvsc <GUID>: tag#197 cmd 0x8a status: scsi 0x0 srb 0x0 hv 0xc0000001

Add logic to limit the max transfer size to 512 Kbytes for vFC devices.

Fixes: 1d3e0980782f ("scsi: storvsc: Correct reporting of Hyper-V I/O size limits")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/1689887102-32806-1-git-send-email-mikelley@microsoft.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/storvsc_drv.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -365,6 +365,7 @@ static void storvsc_on_channel_callback(
 #define STORVSC_FC_MAX_LUNS_PER_TARGET			255
 #define STORVSC_FC_MAX_TARGETS				128
 #define STORVSC_FC_MAX_CHANNELS				8
+#define STORVSC_FC_MAX_XFER_SIZE			((u32)(512 * 1024))
 
 #define STORVSC_IDE_MAX_LUNS_PER_TARGET			64
 #define STORVSC_IDE_MAX_TARGETS				1
@@ -2004,6 +2005,9 @@ static int storvsc_probe(struct hv_devic
 	 * protecting it from any weird value.
 	 */
 	max_xfer_bytes = round_down(stor_device->max_transfer_bytes, HV_HYP_PAGE_SIZE);
+	if (is_fc)
+		max_xfer_bytes = min(max_xfer_bytes, STORVSC_FC_MAX_XFER_SIZE);
+
 	/* max_hw_sectors_kb */
 	host->max_sectors = max_xfer_bytes >> 9;
 	/*


