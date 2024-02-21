Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB6E53816;
	Wed, 21 Feb 2024 13:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521666; cv=none; b=fTffMUp+TcBtoqrpgdHYUO7nJsaK7MUGSeetqp/PChC1UCV09fXGRgivtSP8WgmHj3HoqBHxVZ3Ynox7q4sF1unLT0sMnT4p3OPLhQqFeMw0O9GdAOgrUax3fAtBjsdELKCpT0v82shlqjYeGpfB7ceTHiXx6GT45XYGxm5sHzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521666; c=relaxed/simple;
	bh=D9lpnnXmYJOGgKFhJL2wKhCd90/x4P9fYTg2u+AJpmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iMJsMCdA0FHPqzmlACJT0v6jYoVc0w5l022JE/TuUhe8ERCHJTHTtuMqBKaB+/KhNrjM+C0q8l5rFnqc0YBQU8QqTm0dfkHMmFn4T+u1I9MvMfeNVV8cJ4eOdR25rYmAp+V6Tb2Xxv06u3wjtQyogw7XomBQOz0ux+eKvdKaTMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a5EVPRuz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a5EVPRuz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBEE6C433C7;
	Wed, 21 Feb 2024 13:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521666;
	bh=D9lpnnXmYJOGgKFhJL2wKhCd90/x4P9fYTg2u+AJpmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a5EVPRuzxQEj7D9bL7pQpv/fKXqM32ZYFyIiI8QIvgHCh0NyeGgP3c0y3kJOhN3mE
	 EbAWGyFwuqiK2lJJUI4GxalZic4cLYaDzDgOnTj7vB6IK731ARw17R/aR863I8ubPW
	 xomLuOtLe3iDjaDF8rgt2+ZzClOHS436TaE+b7gY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 146/202] dmaengine: fix is_slave_direction() return false when DMA_DEV_TO_DEV
Date: Wed, 21 Feb 2024 14:07:27 +0100
Message-ID: <20240221125936.424108251@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit a22fe1d6dec7e98535b97249fdc95c2be79120bb ]

is_slave_direction() should return true when direction is DMA_DEV_TO_DEV.

Fixes: 49920bc66984 ("dmaengine: add new enum dma_transfer_direction")
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20240123172842.3764529-1-Frank.Li@nxp.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/dmaengine.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 50128c36f0b4..6e869419ab17 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -827,7 +827,8 @@ static inline int dmaengine_slave_config(struct dma_chan *chan,
 
 static inline bool is_slave_direction(enum dma_transfer_direction direction)
 {
-	return (direction == DMA_MEM_TO_DEV) || (direction == DMA_DEV_TO_MEM);
+	return (direction == DMA_MEM_TO_DEV) || (direction == DMA_DEV_TO_MEM) ||
+	       (direction == DMA_DEV_TO_DEV);
 }
 
 static inline struct dma_async_tx_descriptor *dmaengine_prep_slave_single(
-- 
2.43.0



