Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0FE78B61;
	Tue, 27 Feb 2024 14:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043415; cv=none; b=UKKJE2LuKaXNa6PZDWQLJqgWK6UwD4eCnv1VPJmg5EPZ57aNQWqlqQT3eHpILMH2xBbxUKNPud9vqVXdwI9qPNlyqg5x9g/vuifgargJG0FYBSfsaEHvWaPGTy6fCJYoHJSd3sZ2JhNeLGTEjCOCMuTG1wFdDX/NfrhVkLXPaY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043415; c=relaxed/simple;
	bh=DCYi6dCZ/GhyebRxA+omiLr574Ad6okLCwq476HZ+3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BHhsOjs6mJc+cTBzXfyXwKPZzMIQFOTo6nZzFai8Msdb3CxmUD1w/qg4AXeSIfzhmpik0h7fzmOCSCSMfJ56rU+Wvnh1W8VE1coYN6MhSZXpvd2IjXTrWu9dh+sUSCwyNdxZDcjGbP5WKA7y/Kqv93Nyjre+RZJeEPPVcKH+2So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y3qJ2jRK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y3qJ2jRK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6BAAC433C7;
	Tue, 27 Feb 2024 14:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043415;
	bh=DCYi6dCZ/GhyebRxA+omiLr574Ad6okLCwq476HZ+3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y3qJ2jRKUIiI6ZK5Dgye+5vFnboaSRZJf04AuVg/NpEeSmB71xtxmHI+BM3CAHLay
	 FI/KnH90aEreA7mYWdF/FS+lIXA6cFAwf3pWTBff7RZkWrs2YGqx2F5226p3OzdxRx
	 2nJND7Vc4mN3z8lNscyTRCLWbzOHJzekRLavu+bo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Daniel Wagner <dwagner@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 071/195] scsi: lpfc: Use unsigned type for num_sge
Date: Tue, 27 Feb 2024 14:25:32 +0100
Message-ID: <20240227131612.843328702@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit d6c1b19153f92e95e5e1801d540e98771053afae ]

LUNs going into "failed ready running" state observed on >1T and on even
numbers of size (2T, 4T, 6T, 8T and 10T). The issue occurs when DIF is
enabled at the host.

The kernel logs:

  Cannot setup S/G List for HBAIO segs 1/1 SGL 512 SCSI 256: 3 0

The host lpfc driver is failing to setup scatter/gather list (protection
data) for the I/Os.

The return type lpfc_bg_setup_sgl()/lpfc_bg_setup_sgl_prot() causes the
compiler to remove the most significant bit. Use an unsigned type instead.

Signed-off-by: Hannes Reinecke <hare@suse.de>
[dwagner: added commit message]
Signed-off-by: Daniel Wagner <dwagner@suse.de>
Link: https://lore.kernel.org/r/20231220162658.12392-1-dwagner@suse.de
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 7aac9fc719675..0bb7e164b525f 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -1919,7 +1919,7 @@ lpfc_bg_setup_bpl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
  *
  * Returns the number of SGEs added to the SGL.
  **/
-static int
+static uint32_t
 lpfc_bg_setup_sgl(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		struct sli4_sge *sgl, int datasegcnt,
 		struct lpfc_io_buf *lpfc_cmd)
@@ -1927,8 +1927,8 @@ lpfc_bg_setup_sgl(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 	struct scatterlist *sgde = NULL; /* s/g data entry */
 	struct sli4_sge_diseed *diseed = NULL;
 	dma_addr_t physaddr;
-	int i = 0, num_sge = 0, status;
-	uint32_t reftag;
+	int i = 0, status;
+	uint32_t reftag, num_sge = 0;
 	uint8_t txop, rxop;
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	uint32_t rc;
@@ -2100,7 +2100,7 @@ lpfc_bg_setup_sgl(struct lpfc_hba *phba, struct scsi_cmnd *sc,
  *
  * Returns the number of SGEs added to the SGL.
  **/
-static int
+static uint32_t
 lpfc_bg_setup_sgl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		struct sli4_sge *sgl, int datacnt, int protcnt,
 		struct lpfc_io_buf *lpfc_cmd)
@@ -2124,8 +2124,8 @@ lpfc_bg_setup_sgl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 	uint32_t rc;
 #endif
 	uint32_t checking = 1;
-	uint32_t dma_offset = 0;
-	int num_sge = 0, j = 2;
+	uint32_t dma_offset = 0, num_sge = 0;
+	int j = 2;
 	struct sli4_hybrid_sgl *sgl_xtra = NULL;
 
 	sgpe = scsi_prot_sglist(sc);
-- 
2.43.0



