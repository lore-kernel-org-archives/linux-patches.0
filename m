Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A0571A680B;
	Mon, 23 Mar 2026 14:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275316; cv=none; b=tICrjzkaE6zGGYGATr6M+AT5q+HqCj6AHHmFMOG9AazSQwZS1sz3oyRvT/i5NrU4H0EqMlxyTDt3EhLb8LsEE/ODaJOYLNFIsX2CJCJngTEEYuU5GYdiIcuW7sV7k4ztOnwW3XMHV2Y4RamVZwvbDxFfNDGhrJDRtX2Ng7OE3GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275316; c=relaxed/simple;
	bh=C6oqWtEhdP61w1yOPeXYk1htCLE6FHsXrRSsd6C0xSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BlVEMdmvS88Rgkg/5XXCZ5gcTKFg903J3hazJkuKfV35a2F33eFrTFYOmjf//Ny3carWES6qOvK9rhaFj77rDxA3Uas0v1CPqwUMf7MHchHezZhMm1QvoDZbAEfdNPjyk8vBtjDoRBivbPpJiF0PU2wi0IN0MWTJuu23pEIvqgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WP2fzAVL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WP2fzAVL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33554C4CEF7;
	Mon, 23 Mar 2026 14:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275315;
	bh=C6oqWtEhdP61w1yOPeXYk1htCLE6FHsXrRSsd6C0xSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WP2fzAVL5dSfpEvd7g5nJN0FX2eaSfUHv70X+qjTVEeMRnTK3Onpjc2J5J5JK0KoD
	 NhRtm34zzTIEnWw+e1vYMUbkh5cRgTkTw7eGr+urDm/XpaDkYveD9miIUQNJqeiVvR
	 Wyj9dp6ednzaVjU2/IUFD4V1a7ydCET0V5mlUn98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangshuaiwei <wangshuaiwei1@xiaomi.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 012/460] scsi: ufs: core: Fix shift out of bounds when MAXQ=32
Date: Mon, 23 Mar 2026 14:40:08 +0100
Message-ID: <20260323134526.964326676@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: wangshuaiwei <wangshuaiwei1@xiaomi.com>

[ Upstream commit 2f38fd99c0004676d835ae96ac4f3b54edc02c82 ]

According to JESD223F, the maximum number of queues (MAXQ) is 32. When MCQ
is enabled and ESI is disabled, nr_hw_queues=32 causes a shift overflow
problem.

Fix this by using 64-bit intermediate values to handle the nr_hw_queues=32
case safely.

Signed-off-by: wangshuaiwei <wangshuaiwei1@xiaomi.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260224063228.50112-1-wangshuaiwei1@xiaomi.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 726bf4247f1fe..ea6e7c18e35cd 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6974,7 +6974,7 @@ static irqreturn_t ufshcd_handle_mcq_cq_events(struct ufs_hba *hba)
 
 	ret = ufshcd_vops_get_outstanding_cqs(hba, &outstanding_cqs);
 	if (ret)
-		outstanding_cqs = (1U << hba->nr_hw_queues) - 1;
+		outstanding_cqs = (1ULL << hba->nr_hw_queues) - 1;
 
 	/* Exclude the poll queues */
 	nr_queues = hba->nr_hw_queues - hba->nr_queues[HCTX_TYPE_POLL];
-- 
2.51.0



