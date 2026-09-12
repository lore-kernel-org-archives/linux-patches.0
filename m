Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6DDC336886;
	Sat, 12 Sep 2026 13:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221295; cv=none; b=rNH2+Y/p+LmV2Qj5QEgHUzGpHYnqTSAWGe/ow9AbQxhPc+gD5TAzoE/027GP5d6qLoR0WszTZHWD82+v9Ib4zpRXq+ZviTKkcPd09BwNPJn3OsP2UGHpRFrVRV1wZum0t8oIuw3pKw/qre9eQFY+ArjlbD/EscxjdPlf6m0vfPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221295; c=relaxed/simple;
	bh=oz+1FHttD7QKANjp4bL5Z2tquiSxLUj5ZzR1C+r9uCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AX+QhiwUVrD+lJj2v5EYTPnnlpQ56oev3qG2H7KrjYNxLC1yx0TOdo1NSeDXihhqe5WL9Vj4DHifijSgmWrgpxyeaJvoG+/yEhQwjiMM0uXOBJlnoCA60tK2+plu0uwb5JTyXeBCKFGYeNqhOoaQhxBin1gqAMsmBU9i07ihiQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aTRRASR2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aTRRASR2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 283F61F00893;
	Sat, 12 Sep 2026 13:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221293;
	bh=0N7oas6VXQGvT/Y7dS6Dt5HwMbADrNJuwPUKjCl/hXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aTRRASR2oIdEdw6hbADFv2wyvwFuwIfgPbRVAzG2OvZOl3FJ24FahALY0T0ynq5zE
	 pUnPYyxr2mZfpPdAqwPUklM9Q15fKUHT+oW0XcRfRAvMtM3knnNctBR7fhm+Yf9Qox
	 avsr0CDzjf4sXfIlhtPuR9PwtRndFD9s2NQyhNgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Koichiro Den <den@valinux.co.jp>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 0354/1424] dmaengine: dw-edma: Fix HDMA channel status register access
Date: Sat, 12 Sep 2026 08:46:26 +0200
Message-ID: <20260912065615.215513500@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


