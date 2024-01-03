Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481BE1BDFE;
	Wed,  3 Jan 2024 17:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0foa8ASY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE2AC433C7;
	Wed,  3 Jan 2024 17:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301906;
	bh=cxEiGtM3B0yz7fO+6x7uqB/27fYjPTsHO5xj5vifAAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0foa8ASYhTYpjD4I1z4gShO7xFQTCimVAyI5fVAROSqm8PwNwCRds8zExuDja+Bfh
	 yII7sb7HnPnGpYT1RNsVi9Gi8VaR1IYNKnfzHwRU8qf7PsIqqBzT831mbRRVDfVCYW
	 H31+gjZln6Ouv1h4q1Ptkde4Oixf8MU3wJl35Nh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Benjamin Block <bblock@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 64/75] scsi: core: Make scsi_get_lba() return the LBA
Date: Wed,  3 Jan 2024 17:55:45 +0100
Message-ID: <20240103164852.800275980@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164842.953224409@linuxfoundation.org>
References: <20240103164842.953224409@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin K. Petersen <martin.petersen@oracle.com>

[ Upstream commit d2c945f01d233085fedc9e3cf7ec180eaa2b7a85 ]

scsi_get_lba() confusingly returned the block layer sector number expressed
in units of 512 bytes. Now that we have a more aptly named
scsi_get_sector() function, make scsi_get_lba() return the actual LBA.

Link: https://lore.kernel.org/r/20210609033929.3815-13-martin.petersen@oracle.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Message-Id: <20210609033929.3815-13-martin.petersen@oracle.com>
Stable-dep-of: 066c5b46b6ea ("scsi: core: Always send batch on reset or error handling command")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/scsi/scsi_cmnd.h | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index ddab0c580382b..162a53a39ac0d 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -229,6 +229,13 @@ static inline sector_t scsi_get_sector(struct scsi_cmnd *scmd)
 	return blk_rq_pos(scmd->request);
 }
 
+static inline sector_t scsi_get_lba(struct scsi_cmnd *scmd)
+{
+	unsigned int shift = ilog2(scmd->device->sector_size) - SECTOR_SHIFT;
+
+	return blk_rq_pos(scmd->request) >> shift;
+}
+
 /*
  * The operations below are hints that tell the controller driver how
  * to handle I/Os with DIF or similar types of protection information.
@@ -291,11 +298,6 @@ static inline unsigned char scsi_get_prot_type(struct scsi_cmnd *scmd)
 	return scmd->prot_type;
 }
 
-static inline sector_t scsi_get_lba(struct scsi_cmnd *scmd)
-{
-	return blk_rq_pos(scmd->request);
-}
-
 static inline u32 scsi_prot_ref_tag(struct scsi_cmnd *scmd)
 {
 	struct request *rq = blk_mq_rq_from_pdu(scmd);
-- 
2.43.0



