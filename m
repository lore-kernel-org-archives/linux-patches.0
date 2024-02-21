Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F0A69D38;
	Wed, 21 Feb 2024 14:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524551; cv=none; b=SmoHS0vmHuSP/JLEurM+rNZLWDgzuAhQvAaoSfDH7H/+vF9ITPqEwYhkr8QIH6SUiGRb9jMe8W/S+AhComKNMneMjqvDpEV4DfG58VZqzTiCoGcK/BpBEuNOvB3v+ZqS301cN4DtwSE1UDqWL2QAtcR4/rfZCKp+rm3dz+hWOPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524551; c=relaxed/simple;
	bh=OFFMLXRN92IHraWF2FJmlIEZ2Q04DLrJN8Brnunn3+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DrdEfMTduZrPV0q4y/mrAOBE4BlTKySsS1zmT44Q6p6gHLsIc/IkyDXdKtgOnCn2uh5B2tXkn5qRmHYeVohArEQhwz4sc9pKJk9ny7ss66UggWZVPUP3xJcy+KODAPM59MYTSbGlhmiD0TBN03cUSSV1ljG5GfjmefIu7E8xM3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dMUU04wr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dMUU04wr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08310C433C7;
	Wed, 21 Feb 2024 14:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524551;
	bh=OFFMLXRN92IHraWF2FJmlIEZ2Q04DLrJN8Brnunn3+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dMUU04wreuVJMALqs0XrutCzM3SxCu83XjANrb7KoH87avf4IwfFh/u/kuoHtsr40
	 2YEFTtbNx8EdcQM0U59cnEwHsRf9XeGS37zYgOabrLRCswiY3M3SnppuvJiqJzryku
	 wHDt5UXgj8dztDT8TLVH5WuHAzGCNLqaQjaEkLgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 251/379] dmaengine: fix is_slave_direction() return false when DMA_DEV_TO_DEV
Date: Wed, 21 Feb 2024 14:07:10 +0100
Message-ID: <20240221130002.340313034@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index dd357a747780..4e4cce0ad4d7 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -949,7 +949,8 @@ static inline int dmaengine_slave_config(struct dma_chan *chan,
 
 static inline bool is_slave_direction(enum dma_transfer_direction direction)
 {
-	return (direction == DMA_MEM_TO_DEV) || (direction == DMA_DEV_TO_MEM);
+	return (direction == DMA_MEM_TO_DEV) || (direction == DMA_DEV_TO_MEM) ||
+	       (direction == DMA_DEV_TO_DEV);
 }
 
 static inline struct dma_async_tx_descriptor *dmaengine_prep_slave_single(
-- 
2.43.0



