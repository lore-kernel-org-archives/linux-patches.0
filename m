Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894A233A03F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301868; cv=none; b=eDfMgp4v5jI2fw94kJIMhjH950p6Y2Ky7c2AZXawP6YQRMqt3HWq64k99jaqsnUw5xHcjIDr/ctgRZFLbtueIh48oGgW2FnYK5w6Rejl4K7vvySS0BSVF6esV/n1GY8U+qWoeUQ3caUPuJmysVhL6skea3flXVUO+x1x9NvEKpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301868; c=relaxed/simple;
	bh=6jI3/IDqgTj43G8DbvzofeRC3G+cUtHSFw3efqkYYMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aibo/3lj65SCQ2UGkCuXcWtpsuEU5eeI0zfadzZDDhOW25JWll347lo1GDTYbeFZSoNLqtQoQEgdqMgupVGAl2mtpNpLVBjg0zBG88PjjRDCWw/u1XFK+ba08Uy8P5wGL9wcQd32Q8xnfQ/fRPFewsRtZaJfq6dnDLvwDk9ppc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lx5NgT98; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lx5NgT98"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC826C19424;
	Sat, 28 Feb 2026 18:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301868;
	bh=6jI3/IDqgTj43G8DbvzofeRC3G+cUtHSFw3efqkYYMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lx5NgT98f8Pr1CJdPo7ZFOyNO+b21O12ifgH/Z5vYSv3LfDjWWGTVgo0+zZuT85Qs
	 12aIu0PgdvXRxm5LBWNm1Y0XGr1dgxa1NNbmHHLNJkv/G1DqspPWviy0p4EPgZ1bJy
	 2YfS2TkenS+IfHY8U2cKFemFoZX7sOEhKlaGGBUqxDBV/u+/67xeTMCMLGEIO0eLzU
	 WUDfFXnQKMd80tETEOmUdFh/tjClRibD2CmQBaKHKsSN3bhYmN1G32b8K2nEESgshC
	 bDOcoOshzwcm2m49ctOWb2RHzT1AWsdKfpuJbZ5AO/vs/s11qKwLyBHTWIv2gvSO69
	 n1JqlkKhYob8A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Colin Ian King <colin.i.king@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 292/385] scsi: csiostor: Fix dereference of null pointer rn
Date: Sat, 28 Feb 2026 12:58:34 -0500
Message-ID: <20260228180011.1568201-292-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit 1982257570b84dc33753d536dd969fd357a014e9 ]

The error exit path when rn is NULL ends up deferencing the null pointer rn
via the use of the macro CSIO_INC_STATS. Fix this by adding a new error
return path label after the use of the macro to avoid the deference.

Fixes: a3667aaed569 ("[SCSI] csiostor: Chelsio FCoE offload driver")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Link: https://patch.msgid.link/20260129155332.196338-1-colin.i.king@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/csiostor/csio_scsi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index 8329f0cab4e7d..b0467251cece0 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -2074,7 +2074,7 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 	struct csio_scsi_level_data sld;
 
 	if (!rn)
-		goto fail;
+		goto fail_ret;
 
 	csio_dbg(hw, "Request to reset LUN:%llu (ssni:0x%x tgtid:%d)\n",
 		      cmnd->device->lun, rn->flowid, rn->scsi_id);
@@ -2220,6 +2220,7 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 	csio_put_scsi_ioreq_lock(hw, scsim, ioreq);
 fail:
 	CSIO_INC_STATS(rn, n_lun_rst_fail);
+fail_ret:
 	return FAILED;
 }
 
-- 
2.51.0

