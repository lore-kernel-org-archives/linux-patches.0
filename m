Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23EF15FA91;
	Mon, 27 May 2024 19:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838026; cv=none; b=N4TGco1LJ7wkRZT0gpWF6P0DW1M443aXg00hYQ9OCEp5KZXdwvqeA8eFIExa6qiX/kVdsXMUl2nRQsy+kfiwU9u5Pv8yOeKb7y2hqQDKpI/b4jG3rDa32wFhrZTMpPpKnInN4zQ6faG/cpFsts4H+PMt/gyQxchl5O+UalnAOy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838026; c=relaxed/simple;
	bh=JVvUprFIdbVZhlj+MC1ztlU6sFe13pAgmwKr5un6GbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jW7L27vEErwu0oo5LpLidmslCIUSdA7iwuXOcdaSu4rSF7CGTRNlXMxf/6OfgUNlDwbopfsSPPFhpe/cN+D0vJgGmJC6G4HpcSfCXbe9IZB1/ZoTUUPpwTzETfKuNIpQHx6fGsAIVoc+no9bUR+dFjje/ZPKCxV50P/RiZ7yvbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xZQwnBlL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xZQwnBlL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58F68C2BBFC;
	Mon, 27 May 2024 19:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838026;
	bh=JVvUprFIdbVZhlj+MC1ztlU6sFe13pAgmwKr5un6GbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xZQwnBlLhgl1FP+8/82mSGzhQQa2/KEP90LpzxiErkAlIDyKMtB9JjVJu1Z2NT0v7
	 TBt3q6/Z3n3KK2g7sSa0PR9YJ+Nivh7AWiULFFwT9UytZEbVQrFBzjETJdH45+GLxb
	 4D0p1jwugaAHY6R2pss+IZCCRi8diMa/R0MzS2ts=
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
Subject: [PATCH 6.8 238/493] scsi: ufs: core: mcq: Fix ufshcd_mcq_sqe_search()
Date: Mon, 27 May 2024 20:54:00 +0200
Message-ID: <20240527185638.085184893@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



