Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0128512F588;
	Tue, 14 May 2024 11:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686749; cv=none; b=rFa0KqxbMNnP8WcgPyfsLobUqIvzO8V8fNk/WMgzxnnUC7QQKPqMedDlHvvtDJJT36RmZ7V/4Ys5ptsWaUwBLgC5ogHnMZVVTtfqqr81d6B1AZ36k4a2HvhCnz5gfs4KGkFvnARzLaT+3FUFP5O3fPzBB6fy24d+pimyIRRn4TA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686749; c=relaxed/simple;
	bh=KgELx+xEgpWZJKNuq9bfuvp0EdKfEPzt4F66r4ow/1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sL6wsLubQFavUEzjnUSJeUEHw/Tz+l02hPtHiGG4NB+h9ZuJqWyylcSx4m0Vl80IcNB7XybUFP0EsX+XB/MXkjjbEcYlAXTMNU4/xAjWq0kuRaXbUHcapRIQDexA7+cCFBS9nSso2kYizQae9f3AXlL0iRb9pUsRzX0lB2CjUm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x3hHK2Ug; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x3hHK2Ug"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B5A0C2BD10;
	Tue, 14 May 2024 11:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686748;
	bh=KgELx+xEgpWZJKNuq9bfuvp0EdKfEPzt4F66r4ow/1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x3hHK2Ugf95q6AN3TpzSUJ2rMYbv3d7/gI9SSjv2aTO5haWgq1P8EeosglBK0ylX1
	 LBo8yn/h4YCLb7vaBh0Re+1eqECJHR1fNTnURXK9TgJsVaL/HLeykMUAzBV9AitCG0
	 RMYzgbmhvZ466OPZ+XTUsMSWGCWL3B8sWjh8BQ8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bumyong Lee <bumyong.lee@samsung.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 01/63] dmaengine: pl330: issue_pending waits until WFP state
Date: Tue, 14 May 2024 12:19:22 +0200
Message-ID: <20240514100948.067403036@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100948.010148088@linuxfoundation.org>
References: <20240514100948.010148088@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 1bba1fa3a8096..54bb6e46c1803 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -1045,6 +1045,9 @@ static bool _trigger(struct pl330_thread *thrd)
 
 	thrd->req_running = idx;
 
+	if (desc->rqtype == DMA_MEM_TO_DEV || desc->rqtype == DMA_DEV_TO_MEM)
+		UNTIL(thrd, PL330_STATE_WFP);
+
 	return true;
 }
 
-- 
2.43.0



