Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818AB8F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 15:01:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06FD0C433EF;
	Mon, 13 Feb 2023 15:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300513;
	bh=RTlzIJ7ithYxqaG4vqA3vheAE5Id9UhCHac8qKjbXkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hQUhhktdzOaKd+O0D9+LZg2nDzeQL53js7KyTiWgbrwytAGryjliPPzY88Jimll4u
	 T52qzU/0TLvcO9Bz40Blvjp/CInA91B8rZjyy54e+YedjH77ZPQ7t1YK8m77+hzzA5
	 XM8pB9I7Z0AfXf2jxWuhttJ32bA5SMnoirl2/Bs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Martin Wilck <mwilck@suse.com>,
	Hannes Reinecke <hare@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 014/139] scsi: Revert "scsi: core: map PQ=1, PDT=other values to SCSI_SCAN_TARGET_PRESENT"
Date: Mon, 13 Feb 2023 15:49:19 +0100
Message-Id: <20230213144746.421099202@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
References: <20230213144745.696901179@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Martin K. Petersen <martin.petersen@oracle.com>

[ Upstream commit 15600159bcc6abbeae6b33a849bef90dca28b78f ]

This reverts commit 948e922fc44611ee2de0c89583ca958cb5307d36.

Not all targets that return PQ=1 and PDT=0 should be ignored. While
the SCSI spec is vague in this department, there appears to be a
critical mass of devices which rely on devices being accessible with
this combination of reported values.

Fixes: 948e922fc446 ("scsi: core: map PQ=1, PDT=other values to SCSI_SCAN_TARGET_PRESENT")
Link: https://lore.kernel.org/r/yq1lelrleqr.fsf@ca-mkp.ca.oracle.com
Acked-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Martin Wilck <mwilck@suse.com>
Acked-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_scan.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 8e474b145249..6f7c4d41c51d 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1129,8 +1129,7 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 	 * that no LUN is present, so don't add sdev in these cases.
 	 * Two specific examples are:
 	 * 1) NetApp targets: return PQ=1, PDT=0x1f
-	 * 2) IBM/2145 targets: return PQ=1, PDT=0
-	 * 3) USB UFI: returns PDT=0x1f, with the PQ bits being "reserved"
+	 * 2) USB UFI: returns PDT=0x1f, with the PQ bits being "reserved"
 	 *    in the UFI 1.0 spec (we cannot rely on reserved bits).
 	 *
 	 * References:
@@ -1144,8 +1143,8 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 	 * PDT=00h Direct-access device (floppy)
 	 * PDT=1Fh none (no FDD connected to the requested logical unit)
 	 */
-	if (((result[0] >> 5) == 1 ||
-	    (starget->pdt_1f_for_no_lun && (result[0] & 0x1f) == 0x1f)) &&
+	if (((result[0] >> 5) == 1 || starget->pdt_1f_for_no_lun) &&
+	    (result[0] & 0x1f) == 0x1f &&
 	    !scsi_is_wlun(lun)) {
 		SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
 					"scsi scan: peripheral device type"
-- 
2.39.0



