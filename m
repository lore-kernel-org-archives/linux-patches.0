Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC2951AB510;
	Thu,  6 Jun 2024 14:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683253; cv=none; b=ir1G6RBLETw0uil6NATOKHckoAb2j6MEJnScMuVcyjumXHUrAgqRV4RXOV7l6xT0Nl1bBc3s/ibMD839MEj0NeV2XNzfad2nUt2pbBEmap4c9hhfJoaMPc7fyRgW54RqaM1wSJBIiouFHxNz+p/rHmUwPmFd595XIDFKYkpjYSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683253; c=relaxed/simple;
	bh=Pk1LLFiXxR30ApH99jW8y3gx2i6VJ8bVAMpXn8aAxCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rw5BXCDp0Kc1MvgeHwGHY8QcH1lDygEF6SjL+SMJTw37JwGdIxPzO+58NMNBkxQuzp4ckEsu50tU+/INwjQw80z8wMkiNyQvb69QeEQiH7rARCb3VSz/c5/SK6T+0ADvXW3BQqFPSM/L3gPHxCdS6xG5dt/aSNTRYR4quxXj5Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B6hpPJk/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B6hpPJk/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C3E2C32781;
	Thu,  6 Jun 2024 14:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683253;
	bh=Pk1LLFiXxR30ApH99jW8y3gx2i6VJ8bVAMpXn8aAxCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B6hpPJk/ULqnln8oAR6rIpJ6sH6/hxPncCvgrOB66dh/1Vn9kaqInWEm4WFnDwAhB
	 RVsbQK8NUkGL5Jcx/LgiVll5dHE7PEZ24/ed5wb7vJ17Ztu5E8izaJN5AONweWZgjP
	 kiyfiktLsK4+B3CoZuT69ldtHQ+mBeulMijS22UI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Stanley Chu <stanley.chu@mediatek.com>,
	Can Guo <quic_cang@quicinc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 197/744] scsi: ufs: core: mcq: Fix ufshcd_mcq_sqe_search()
Date: Thu,  6 Jun 2024 15:57:49 +0200
Message-ID: <20240606131738.749545604@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 3c5d0dce8ce0a2781ac306b9ad1492b005ecbab5 ]

Fix the calculation of the utrd pointer. This patch addresses the following
Coverity complaint:

CID 1538170: (#1 of 1): Extra sizeof expression (SIZEOF_MISMATCH)
suspicious_pointer_arithmetic: Adding sq_head_slot * 32UL /* sizeof (struct
utp_transfer_req_desc) */ to pointer hwq->sqe_base_addr of type struct
utp_transfer_req_desc * is suspicious because adding an integral value to
this pointer automatically scales that value by the size, 32 bytes, of the
pointed-to type, struct utp_transfer_req_desc. Most likely, the
multiplication by sizeof (struct utp_transfer_req_desc) in this expression
is extraneous and should be eliminated.

Cc: Bao D. Nguyen <quic_nguyenb@quicinc.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Can Guo <quic_cang@quicinc.com>
Fixes: 8d7290348992 ("scsi: ufs: mcq: Add supporting functions for MCQ abort")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20240410000751.1047758-1-bvanassche@acm.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufs-mcq.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index c873fd8239427..7ae3096814282 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -597,8 +597,7 @@ static bool ufshcd_mcq_sqe_search(struct ufs_hba *hba,
 	addr = le64_to_cpu(cmd_desc_base_addr) & CQE_UCD_BA;
 
 	while (sq_head_slot != hwq->sq_tail_slot) {
-		utrd = hwq->sqe_base_addr +
-				sq_head_slot * sizeof(struct utp_transfer_req_desc);
+		utrd = hwq->sqe_base_addr + sq_head_slot;
 		match = le64_to_cpu(utrd->command_desc_base_addr) & CQE_UCD_BA;
 		if (addr == match) {
 			ufshcd_mcq_nullify_sqe(utrd);
-- 
2.43.0



