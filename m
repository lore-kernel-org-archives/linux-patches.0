Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759C74B04B2;
	Wed,  9 Sep 2026 13:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961921; cv=none; b=BbStBtal7DeOIuBTP4APJqMMKcdErffmAh21ai+OBhp5OJbQMXfDCxW4tkLfZUDsaeP0uLBYnbyS/QKH7FwDC9GsbT7xlO9RoKQjdAcB/oOWdLxQIulxAMKeLWq3d5vAyD4QsGt/x66S0QrezH9DRt6Mz1uemh6NXpaQd6Nre1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961921; c=relaxed/simple;
	bh=BpXrCvGh6HuXX8cqcf6THGtDSIlvJyR1UboEN/mzDIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I8bWvfGogbCfXSL1FjcczwdY7psOKvnkdM/KECkwmhL8JvrtRuzNZn7ZmntpEQ/nkKFbvvJcJ7afxVtcvG07qNeCtvOPXVcosIc7CqVTNxx2Sb3hW75osenECIHM65a/3SelzoYUAsheyEWLqoAcQ2VEWxs7dcRE0TKH31xhj6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F1ZXg2yA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F1ZXg2yA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C57A41F00A3A;
	Wed,  9 Sep 2026 13:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961920;
	bh=4e2SKQ9vgBXhhpvX779tpT0wPlBAUUOJh6t8Ys9xU1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F1ZXg2yAkeLZERSz1Fjf0B5p+dSk6KXCoGqLU8qgEYWBo2sG8khJXB5tysG1GpQUr
	 SqMIiTpEZ8iQQ/HChDMCF4vFFtE7XTIm5TZyKHHq78LY6EcKq4HTl1gFkLiQIHtjjr
	 YpCNlmRmvQPgIvPP4TcrIFdd1Lf8GgKH3AkiVxcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Koichiro Den <den@valinux.co.jp>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 7.2 110/556] dmaengine: dw-edma: Fix HDMA channel status register access
Date: Wed,  9 Sep 2026 15:36:30 +0200
Message-ID: <20260909134234.347072476@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koichiro Den <den@valinux.co.jp>

commit ef1b080e03acc83d5bde841da67036985acd50dc upstream.

GET_CH_32() takes the direction before the channel ID, but
dw_hdma_v0_core_ch_status() passed them in the opposite order. This can
make the status callback read another HDMA channel status register.

Use the same argument order as the other HDMA register accesses.

Fixes: e74c39573d35 ("dmaengine: dw-edma: Add support for native HDMA")
Cc: stable@vger.kernel.org
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Link: https://patch.msgid.link/20260717180639.2643243-2-den@valinux.co.jp
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/dw-edma/dw-hdma-v0-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dma/dw-edma/dw-hdma-v0-core.c
+++ b/drivers/dma/dw-edma/dw-hdma-v0-core.c
@@ -79,7 +79,7 @@ static enum dma_status dw_hdma_v0_core_c
 	u32 tmp;
 
 	tmp = FIELD_GET(HDMA_V0_CH_STATUS_MASK,
-			GET_CH_32(dw, chan->id, chan->dir, ch_stat));
+			GET_CH_32(dw, chan->dir, chan->id, ch_stat));
 
 	if (tmp == 1)
 		return DMA_IN_PROGRESS;


