Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FDA196DA2;
	Thu,  6 Jun 2024 14:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682901; cv=none; b=UMdh5cmQ88OvIpi4TLdRY6gByZWAp6yh/iE8PzmaPb0DTfASII2vxIOWouZm9kjhtHqGMtxHnqoxKXGMAbI7NYkQR6GrxepwohgXr/HQifjhyt3ZXCQObcK9pOeXRkilbEtXqyLzBrajDpfPCnYU2Nc1lnsH7jOa5Zi3fsy4p4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682901; c=relaxed/simple;
	bh=7jv/UwYjef9nB0SGTNaYsU6ZgnlaYjjTBLPnpfIQy+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UdQCwX2PAMNs1jHE2TixOdBMtHaMLiclOt1tOzVOYnbWN6C6BAY6AMZ/QcuD2IOKtfll3o/Cw/SLuonYbqK2F/GV1X3Vth3getZzdNfZpasXccKI+iVQ7C15EZS/X8uWAQqK9mxsaj4rt6ZWIOLzIy9jym92nLrrSripA+1SSgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ctxhJrn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ctxhJrn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13743C32781;
	Thu,  6 Jun 2024 14:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682901;
	bh=7jv/UwYjef9nB0SGTNaYsU6ZgnlaYjjTBLPnpfIQy+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ctxhJrn02FgSreO3VH16QrBv7Z1nRSkYqyrB8JvM3JTz/ExGNTXRoAjY45UJv5Wh
	 ZFdVkA7XYsvnciTcLxCpFjbm9DCOHfkTER6kcsViqT0E6RUV0DNz161pRuo7j0H8jH
	 hXFbtZMd2shu7xxPtgpQwiliO/NZNpnbZZqKd8LY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 021/374] dmaengine: idma64: Add check for dma_set_max_seg_size
Date: Thu,  6 Jun 2024 16:00:00 +0200
Message-ID: <20240606131652.495802477@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit 2b1c1cf08a0addb6df42f16b37133dc7a351de29 ]

As the possible failure of the dma_set_max_seg_size(), it should be
better to check the return value of the dma_set_max_seg_size().

Fixes: e3fdb1894cfa ("dmaengine: idma64: set maximum allowed segment size for DMA")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20240403024932.3342606-1-nichen@iscas.ac.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idma64.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/idma64.c b/drivers/dma/idma64.c
index 1398814d8fbb6..e3505e56784b1 100644
--- a/drivers/dma/idma64.c
+++ b/drivers/dma/idma64.c
@@ -598,7 +598,9 @@ static int idma64_probe(struct idma64_chip *chip)
 
 	idma64->dma.dev = chip->sysdev;
 
-	dma_set_max_seg_size(idma64->dma.dev, IDMA64C_CTLH_BLOCK_TS_MASK);
+	ret = dma_set_max_seg_size(idma64->dma.dev, IDMA64C_CTLH_BLOCK_TS_MASK);
+	if (ret)
+		return ret;
 
 	ret = dma_async_device_register(&idma64->dma);
 	if (ret)
-- 
2.43.0



