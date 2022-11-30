Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF6D26FA1
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:25:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51BD4C433C1;
	Wed, 30 Nov 2022 18:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669832745;
	bh=wMoAmFrAKqCRnCDoXLuanE2Lmzf9mTTi195NSVnTMOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JSjHmGuFaze28PVe5VRxtD8TI0x29HmTeStfSvqwmeULPhqQC5dYa0njiskiddkH2
	 YYvD39tSJD28we5CYicklgro8obh2b/ZOJXOurxbdt7cPL1wmPbJxn/P/DpxSYR1jr
	 g6f5Vsb3gJnT+D5fndXAR+OsKRnkwBrWlV8XVt9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Gilbert <dgilbert@interlog.com>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 026/162] scsi: scsi_debug: Make the READ CAPACITY response compliant with ZBC
Date: Wed, 30 Nov 2022 19:21:47 +0100
Message-Id: <20221130180529.214763570@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit ecb8c2580d37dbb641451049376d80c8afaa387f ]

>From ZBC-1:

 - RC BASIS = 0: The RETURNED LOGICAL BLOCK ADDRESS field indicates the
   highest LBA of a contiguous range of zones that are not sequential write
   required zones starting with the first zone.

 - RC BASIS = 1: The RETURNED LOGICAL BLOCK ADDRESS field indicates the LBA
   of the last logical block on the logical unit.

The current scsi_debug READ CAPACITY response does not comply with the
above if there are one or more sequential write required zones. SCSI
initiators need a way to retrieve the largest valid LBA from SCSI
devices. Reporting the largest valid LBA if there are one or more
sequential zones requires to set the RC BASIS field in the READ CAPACITY
response to one. Hence this patch.

Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Suggested-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20221102193248.3177608-1-bvanassche@acm.org
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 261b915835b4..cc20621bb49d 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1878,6 +1878,13 @@ static int resp_readcap16(struct scsi_cmnd *scp,
 			arr[14] |= 0x40;
 	}
 
+	/*
+	 * Since the scsi_debug READ CAPACITY implementation always reports the
+	 * total disk capacity, set RC BASIS = 1 for host-managed ZBC devices.
+	 */
+	if (devip->zmodel == BLK_ZONED_HM)
+		arr[12] |= 1 << 4;
+
 	arr[15] = sdebug_lowest_aligned & 0xff;
 
 	if (have_dif_prot) {
-- 
2.35.1



