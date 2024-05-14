Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5EB912FB3C;
	Tue, 14 May 2024 11:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686064; cv=none; b=rR+S2v44qCHMFniTZjLmNZwgC+fgaupyoe00qu3kmKuedLfbKkMgsQ8beclzoQ6V7Q4VGvchDzzwYJsXV2nZ+ovIjRFVhEzgLFobcQdeV8XJ6hR3CIHwtiDCoaaSm48iExXRS/vOUXBOqcVPPThULS8D0UQ4AKE25mi6idatyjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686064; c=relaxed/simple;
	bh=hDzIIEEcQZV+SBXGX9G98zDSQep+pegnfohMyvfEK4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cu8PqJCVw1TUcTDfaz1Nt7BH/02z3CCQ0HD7Fi5g54i4zerIMTeluuXXHY2n1a6hW9zOeOkxftQBRDu8oMHoTv88fS9s/dBhnk/ZleZDAv2vvwmCcYuV5eypp46q3ToWN8XWoCAiV0DETJ1gqu8hI6A+QeY8VBUR4i1S3iAly9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C8//Riiv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C8//Riiv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E998C2BD10;
	Tue, 14 May 2024 11:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686064;
	bh=hDzIIEEcQZV+SBXGX9G98zDSQep+pegnfohMyvfEK4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C8//Riiv+kwvvO6pYF7kW81Boy1mdRkle7+/1j5LzkieMlwAxj0UiyuA+mNEOCEJy
	 3nKvBIgdYBWNtkOod9nu8fSf6xCG2q7DHBfpfjZPTU9R5N//mSTkntOaW9TqOIEcYl
	 8BSzXmbjspU8xnwG0ZqBsBdvouft8F4M9bYeylwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bumyong Lee <bumyong.lee@samsung.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 001/236] dmaengine: pl330: issue_pending waits until WFP state
Date: Tue, 14 May 2024 12:16:03 +0200
Message-ID: <20240514101020.381864125@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

From: Bumyong Lee <bumyong.lee@samsung.com>

[ Upstream commit 22a9d9585812440211b0b34a6bc02ade62314be4 ]

According to DMA-330 errata notice[1] 71930, DMAKILL
cannot clear internal signal, named pipeline_req_active.
it makes that pl330 would wait forever in WFP state
although dma already send dma request if pl330 gets
dma request before entering WFP state.

The errata suggests that polling until entering WFP state
as workaround and then peripherals allows to issue dma request.

[1]: https://developer.arm.com/documentation/genc008428/latest

Signed-off-by: Bumyong Lee <bumyong.lee@samsung.com>
Link: https://lore.kernel.org/r/20231219055026.118695-1-bumyong.lee@samsung.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: afc89870ea67 ("dmaengine: Revert "dmaengine: pl330: issue_pending waits until WFP state"")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/pl330.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 3cf0b38387ae5..c29744bfdf2c2 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -1053,6 +1053,9 @@ static bool _trigger(struct pl330_thread *thrd)
 
 	thrd->req_running = idx;
 
+	if (desc->rqtype == DMA_MEM_TO_DEV || desc->rqtype == DMA_DEV_TO_MEM)
+		UNTIL(thrd, PL330_STATE_WFP);
+
 	return true;
 }
 
-- 
2.43.0



