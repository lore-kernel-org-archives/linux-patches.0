Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CECE512FB2A;
	Tue, 14 May 2024 10:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684227; cv=none; b=LykZN6sZ8/IplFVdTJKXtuEo0Jm/haHxge9WN1BVO5UbdbC8WSanG/UOToXy1kgJsSAY9rfNbQ3/KG2zCzMNwcKPE8iiDK5ekIXVEj0nL1TQmxZfFaB9VP/uo6GQ4Qw/lIOWfskmh9dQ8a7gmsaa2FvtgqYLNq64WHSSet3NmwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684227; c=relaxed/simple;
	bh=IlhrLBfwJFIOQ7HWVtDyWsbodsdte9RBuhysYmfB4m8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ot9PMBnPzYoLhRB+4G2KteG+CNK0dPkuQKTV/27tGRetKOVPIuGGZuDkTWcrF0w1ttLEINRr+e1tOsBSSPJHCThsRpvTgqDscAsARt1imICk2ThHNCZc3DNylluR5mXLW5EeVJshXLVBg+PlyxlsOpbg8yj5LoB/pSp9dgPzJMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nSNwMJaQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nSNwMJaQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C7CC2BD10;
	Tue, 14 May 2024 10:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684227;
	bh=IlhrLBfwJFIOQ7HWVtDyWsbodsdte9RBuhysYmfB4m8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nSNwMJaQq3XA5vjX1YRTmUiQA60NjmFu4Ga86KAfA7pIhAzsESmz3jvTL+BLcFKio
	 av63vPu3ZWxy0x8CXPJsUTiuMeJ7cXzGk115kMouQSjS5jQ+6suumG7FT2lPB/BH3t
	 f+obKAYzX9N0E7oFeslkeF71yYelTdgwYCEthYkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bumyong Lee <bumyong.lee@samsung.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 001/301] dmaengine: pl330: issue_pending waits until WFP state
Date: Tue, 14 May 2024 12:14:32 +0200
Message-ID: <20240514101032.280054211@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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



