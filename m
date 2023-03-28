Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28948BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:50:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA45C4339B;
	Tue, 28 Mar 2023 14:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015043;
	bh=4NGiIwqKyua+k+/w8eJSpy8bX3HReGAYKuq4M46ioQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MZT+wNp9WFUf5A+B6eAYVSFRmPfmOoiUaWZhpIEHM0o7sEq2JGepQC0gr5MSWgxkV
	 lf/ivf2h01+3+OdTsL3SOVwfoy0x6eD4+atUs6dsMnuiqylrbLyCw5Fhw8RYbcR0zo
	 /0G4G76TeFgnz7/DJCdbbmKp1+cxR/Dl23LQ62n4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kang Chen <void0red@gmail.com>,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 146/240] scsi: lpfc: Check kzalloc() in lpfc_sli4_cgn_params_read()
Date: Tue, 28 Mar 2023 16:41:49 +0200
Message-Id: <20230328142625.809895676@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit 312320b0e0ec21249a17645683fe5304d796aec1 ]

If kzalloc() fails in lpfc_sli4_cgn_params_read(), then we rely on
lpfc_read_object()'s routine to NULL check pdata.

Currently, an early return error is thrown from lpfc_read_object() to
protect us from NULL ptr dereference, but the errno code is -ENODEV.

Change the errno code to a more appropriate -ENOMEM.

Reported-by: Kang Chen <void0red@gmail.com>
Link: https://lore.kernel.org/all/20230226102338.3362585-1-void0red@gmail.com
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20230228044336.5195-1-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_init.c | 2 ++
 drivers/scsi/lpfc/lpfc_sli.c  | 4 ----
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 3fbd3bec26fc1..eeb73da754d0d 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -7235,6 +7235,8 @@ lpfc_sli4_cgn_params_read(struct lpfc_hba *phba)
 	/* Find out if the FW has a new set of congestion parameters. */
 	len = sizeof(struct lpfc_cgn_param);
 	pdata = kzalloc(len, GFP_KERNEL);
+	if (!pdata)
+		return -ENOMEM;
 	ret = lpfc_read_object(phba, (char *)LPFC_PORT_CFG_NAME,
 			       pdata, len);
 
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 55a0d4013439f..3aa7206537de7 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -22113,10 +22113,6 @@ lpfc_read_object(struct lpfc_hba *phba, char *rdobject, uint32_t *datap,
 	struct lpfc_dmabuf *pcmd;
 	u32 rd_object_name[LPFC_MBX_OBJECT_NAME_LEN_DW] = {0};
 
-	/* sanity check on queue memory */
-	if (!datap)
-		return -ENODEV;
-
 	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (!mbox)
 		return -ENOMEM;
-- 
2.39.2



