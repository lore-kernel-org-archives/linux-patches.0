Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 756033C5DBA;
	Tue, 17 Mar 2026 16:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765490; cv=none; b=qlOUexjK1+e5cNCTrGoi7gJpVcUTEr+Ktm/yI1HKupvW30+mj9I0Kwt4iFfgQCXDH+CSbru+9cmt9SeJjqkjMVe9a4oc0c+od+tBNB+DHBiqhjhi3zANSg2KsLPpIHkq9NJG9Ckyl9Tf+i1Tz5D0uMrGq7esYm71x7DH9nasgMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765490; c=relaxed/simple;
	bh=HJvoaaE61Ip484V0BHs5o46yPVhEm3LJx0Mnq3DMjgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kYteLQtCVnXna9VdX2JiIbr6yxIP/VfrfnybXqazya2wmXyqyeDztgmLkntM3sB+KqFUBXnnyvPrIk7BFLstv13eNIupsMyn2TGuGeD+W9dQuHonHfwvrUENe+N/PvC5Ri5Z1yBLlsuuVDYDZZkkL5Z0oJNU9sz+qSxbLjarOFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RmnLC4Wb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RmnLC4Wb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BCD8C4CEF7;
	Tue, 17 Mar 2026 16:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765490;
	bh=HJvoaaE61Ip484V0BHs5o46yPVhEm3LJx0Mnq3DMjgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RmnLC4WbHDCqW97bZYlzuy6AYElA7bu7XFe8go5Hf3MpoVmAitzayzLQYXnSb3SfB
	 OAPIfYR0zAT+xk2eWPY7uZaDRLPbhc82h1j4PTJjFB8uxVmoMZLfBVGWARdgjLpXsi
	 36GgsWez6csE1tEiR4juLRpb1s/mI+/0pbWgBvw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangshuaiwei <wangshuaiwei1@xiaomi.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 022/378] scsi: ufs: core: Fix shift out of bounds when MAXQ=32
Date: Tue, 17 Mar 2026 17:29:39 +0100
Message-ID: <20260317163007.791204426@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index d5628ed086381..2048ebc86590e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7106,7 +7106,7 @@ static irqreturn_t ufshcd_handle_mcq_cq_events(struct ufs_hba *hba)
 
 	ret = ufshcd_vops_get_outstanding_cqs(hba, &outstanding_cqs);
 	if (ret)
-		outstanding_cqs = (1U << hba->nr_hw_queues) - 1;
+		outstanding_cqs = (1ULL << hba->nr_hw_queues) - 1;
 
 	/* Exclude the poll queues */
 	nr_queues = hba->nr_hw_queues - hba->nr_queues[HCTX_TYPE_POLL];
-- 
2.51.0



