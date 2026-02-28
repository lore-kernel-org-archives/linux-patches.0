Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B0B37524F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302608; cv=none; b=P+uJpiWBMo/8J80YR+2KqWG+VkdN3RVQ6A4DUShusrqmbojwnU+T+XoCMtlg4ZIxZ97W6eh4MhMEYtBYpFpWHG2z+7/CJCV2bEQFM3w/LNxdbkom98/INE3eEo3y//YtpogKHaDG0B9719QSEhQtFu2tZLrV2EG6ePfAdyYva8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302608; c=relaxed/simple;
	bh=HfhvTey7/FHVnlRB6PHItdu1Cg7z3ANDEMy3QucTxFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cnORgyu1pZmE3Xsfh28TsJrVbe6xL2yd6P75tl5GcWHg5G4lopDLBCk44oehFwHVjyelENkjdczY+ZadE0nccm4DZj8hsZCUJrMrDU4LJfJcTgbeEpjHyjv4HaeoxQp1ZRjxAAppqPA0osae3o9A09FQxkIRoVkMKrWCwjlQuW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RuMWe6Ur; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RuMWe6Ur"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BB84C116D0;
	Sat, 28 Feb 2026 18:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302608;
	bh=HfhvTey7/FHVnlRB6PHItdu1Cg7z3ANDEMy3QucTxFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RuMWe6UrQT8pZ+3140Z974beuj4Ax3bupvNnwuu1UW7t125DoPzmKGaBI6qJJcfSY
	 ieq8xFAxuK6qakLHEgmsYtlzGTj+GjwmEyrsa9saHlvuGcD2nnq7uQ7swScdTUc8hG
	 iNafHmmYGFEqJuvE1iHKtJ2+WEHeBkT6DkWkxU3pQFy+lQlY0DjyIXkXhu/d2DMZbb
	 htAtTTozBiUciuZ5AldZZXZAKCSxI+xKIVMHhm2GTichQL7jBM1wWBn8/3g09kTlMV
	 v9uVy+coTzWBtQRf2YXtwX6fSx2jQOOribtobkeGREa/jZvduvW6NNOqxpZtgg74c0
	 DX+Ed36rg1ubw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Colin Ian King <colin.i.king@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 123/164] scsi: csiostor: Fix dereference of null pointer rn
Date: Sat, 28 Feb 2026 13:14:22 -0500
Message-ID: <20260228181505.1600663-123-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index 3b2eb6ce1fcff..59d7dadfbfb71 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -2070,7 +2070,7 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 	struct csio_scsi_level_data sld;
 
 	if (!rn)
-		goto fail;
+		goto fail_ret;
 
 	csio_dbg(hw, "Request to reset LUN:%llu (ssni:0x%x tgtid:%d)\n",
 		      cmnd->device->lun, rn->flowid, rn->scsi_id);
@@ -2215,6 +2215,7 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 	csio_put_scsi_ioreq_lock(hw, scsim, ioreq);
 fail:
 	CSIO_INC_STATS(rn, n_lun_rst_fail);
+fail_ret:
 	return FAILED;
 }
 
-- 
2.51.0

