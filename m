Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244CE34252B
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301893; cv=none; b=ZvkzxiZd0vtgnknhytBLFUbhIou59+AfmSbFo7xpxrRZekFkYaMVxw4hp1oRTassQY3A1+zKNCMCh85eL2y7SZmKyJGGq6yQ6rnHK3vEAPvIusAYKRzkBBVmeDmCreXizPvcQjKnILYzhnpupAE9YJz7ShEeBzwt0vziyd8sRIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301893; c=relaxed/simple;
	bh=HXzN/JRO+pBleMuVAsd2xW4kfP7Pc9DcD8DBuEMcewA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nHQ0GcDiU08LtZDCEgOE7CvaP5C4WckeZB5V3zMFQS3JLWlhXqZCehMAzbRYXdTRAYPtSEDP9wPfVtqBzDnULD35FeqB1jwrwtCh9HS/aEhs8rbTJ1dmyAfYwaWcmwq58EMUjvCLRWYXIw1NoR1A9hJelQJqiIxfNnNi2P66SdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KMo2WBQT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KMo2WBQT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6726BC2BCB1;
	Sat, 28 Feb 2026 18:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301893;
	bh=HXzN/JRO+pBleMuVAsd2xW4kfP7Pc9DcD8DBuEMcewA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KMo2WBQTQ9HziMYwTHruFsnh7i35BG9GBWchaTlTDEZn4Ip5IGQUUCn+ENWCx9ZvJ
	 D1Vx1l3pu2HG1dDcvCf3dMusKmNMmsgbgSCUZuhoMjZxsDj5Md7Dtaz5tD1RutKNSi
	 4SvNfvZEdwEesrI4OpS/qh/k/mVw1hfETv4o8vR0sJYLeuymvG1Hv9hJqhTfEWlzIl
	 cjFc76F7BYAO8p7WkU/iZbTGnVBz8AL+J43StqTpP9QnS0swScWQ1f8OkPCRFrCGvM
	 764sJMJ6FfMdTKBqQm4Q4uv6BV2Y5Q2nN95Ro0hUSgWmJLX+1JEK8tb12U8tWwgUhP
	 WLbtZAsZHQu0w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Michael Hennerich <michael.hennerich@analog.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 320/385] dma: dma-axi-dmac: fix HW scatter-gather not looking at the queue
Date: Sat, 28 Feb 2026 12:59:02 -0500
Message-ID: <20260228180011.1568201-320-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Nuno Sá <nuno.sa@analog.com>

[ Upstream commit bbcbafb99df41a1d81403eb4f5bb443b38228b57 ]

For HW scatter gather transfers we still need to look for the queue. The
HW is capable of queueing 3 concurrent transfers and if we try more than
that we'll get the submit queue full and should return. Otherwise, if we
go ahead and program the new transfer, we end up discarding it.

Fixes: e97dc7435972 ("dmaengine: axi-dmac: Add support for scatter-gather transfers")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
base-commit: 398035178503bf662281bbffb4bebce1460a4bc5
change-id: 20251104-axi-dmac-fixes-and-improvs-e3ad512a329c
Acked-by: Michael Hennerich <michael.hennerich@analog.com>
Link: https://patch.msgid.link/20251104-axi-dmac-fixes-and-improvs-v1-2-3e6fd9328f72@analog.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dma-axi-dmac.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/dma-axi-dmac.c b/drivers/dma/dma-axi-dmac.c
index 2aa06f66624ba..47d95d2d743b1 100644
--- a/drivers/dma/dma-axi-dmac.c
+++ b/drivers/dma/dma-axi-dmac.c
@@ -233,11 +233,9 @@ static void axi_dmac_start_transfer(struct axi_dmac_chan *chan)
 	unsigned int flags = 0;
 	unsigned int val;
 
-	if (!chan->hw_sg) {
-		val = axi_dmac_read(dmac, AXI_DMAC_REG_START_TRANSFER);
-		if (val) /* Queue is full, wait for the next SOT IRQ */
-			return;
-	}
+	val = axi_dmac_read(dmac, AXI_DMAC_REG_START_TRANSFER);
+	if (val) /* Queue is full, wait for the next SOT IRQ */
+		return;
 
 	desc = chan->next_desc;
 
-- 
2.51.0

