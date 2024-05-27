Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D17C15FA91;
	Mon, 27 May 2024 19:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836756; cv=none; b=e0C89x82mwz5gFr8hyeNWpqEcPS6vHU1jhaNKudA3oBDHGjOmPPfQBSgI2RRDbbmfYXDbsOFboC8X/p7uK0O8M9bJ1fSeIFMYZW3fRG5qxqQy7k4NHmkK4jIfEzilJ8oLg7ITSlywU08GPotaaAROjyh7Nm8sFW8qQniILPvl70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836756; c=relaxed/simple;
	bh=36sxqMtTm3Me/5u4qsl7pVvhT5dS2Fyp62yM6R7PxN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BfbFE5XBLXKmMz3M37oJtCd448qFWUJd+K0MjxJ6Hcn/q/jErGzpBDRTUrjqg5enwefceQ40pcsdj3y3fAOGNlnlBCf0uJnSIOEARpTfEe/dq+uVroOHd1ZlnyIDSx0MpUrPFXtjYb2DOZSl9veXPkWWaTHOynBVlNT4bntye+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MPk5tD3z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MPk5tD3z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57CF4C2BBFC;
	Mon, 27 May 2024 19:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836755;
	bh=36sxqMtTm3Me/5u4qsl7pVvhT5dS2Fyp62yM6R7PxN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MPk5tD3zpjtcxTZ4E3xh/i6O+4GGYMJ5NbzuL7ThZLMIlmpuzc/sMdEp8PH7hhCWS
	 MA2vhKVBrDFJUmQ3RqojBX++aLhQ3TVXgIdBhWcWdNSmKymyKSgB8pGwbiVWeac6A8
	 41ozUK3U45mpGZcIT6ZfFOJRS/LpLUe6VLytlj9k=
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
Subject: [PATCH 6.9 174/427] scsi: ufs: core: mcq: Fix ufshcd_mcq_sqe_search()
Date: Mon, 27 May 2024 20:53:41 +0200
Message-ID: <20240527185618.487397829@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 768bf87cd80d3..005d63ab1f441 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -601,8 +601,7 @@ static bool ufshcd_mcq_sqe_search(struct ufs_hba *hba,
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



