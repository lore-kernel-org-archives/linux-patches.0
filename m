Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84CF5550DC3;
	Wed,  9 Sep 2026 13:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962048; cv=none; b=cBqfeCsOdosQseZpgX1DwFb17DE6oRmqw5bXuuaNRcyYkdvyz1GlXtnw+uhQe3kjI8vcriFSh6SIVNwn8AfT4JQ1Xqt2wM0bQLvxCcJwgMrLMxDqQJ8QtaIe6dyddWzhEKTsnoFp7emjsb3vRiAMAfF5UafffG6g5BJ/WT8a0gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962048; c=relaxed/simple;
	bh=4MhT5uwvuNPYFDVmOm3Szl7BUnVikNLQusLLHYJwhIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q8tl22JiOGZJxGtdcPOzUQyhG+ZYfPvTCo7XVMdY8mEl2Z/WBrYFufcp4uHjZopYPDdjDV6yt1WMoNGtZE3LYsproI9UsktwVtOu4HZi034/3TQ5WCHrNyByKBfI1rflGW44k+I0Bc6X+xHJH92KM94hj4vwhO4iKl5bQnvtO+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pRb6KcsW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pRb6KcsW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D943E1F00A3A;
	Wed,  9 Sep 2026 13:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962047;
	bh=BinUZIXKwTCmry63fi+3256O+FIduDcVeH516ED50BU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pRb6KcsWVQ4N2mEKi8CZAWAKQmcvpE7VMiPUwqZhcc5qcxadiYdqS3f1BB4fImXHU
	 Ur2qqCU+cMhTSOejOiaxDrrCM98hdDa3wMyI65rf6FhZ5hLNKadSA+sC/ffiVK8dTp
	 LA3dYQcbKQv/iL/p0skQAyUQU2blMm9iY2lBBsaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	GuoHan Zhao <zhaoguohan@kylinos.cn>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 7.2 154/556] accel/ethosu: check MMIO mapping errors in probe
Date: Wed,  9 Sep 2026 15:37:14 +0200
Message-ID: <20260909134235.853325167@linuxfoundation.org>
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

From: GuoHan Zhao <zhaoguohan@kylinos.cn>

commit 7ab64476a610fe65858fdc37c7a30caa13e334ac upstream.

devm_platform_ioremap_resource() returns an error pointer when the register
resource cannot be mapped. ethosu_probe() stores it and continues until
initialization dereferences it through MMIO accessors.

Return the mapping error before initializing the device.

Fixes: 5a5e9c0228e6 ("accel: Add Arm Ethos-U NPU driver")
Cc: stable@vger.kernel.org
Signed-off-by: GuoHan Zhao <zhaoguohan@kylinos.cn>
Link: https://patch.msgid.link/20260716065219.931088-1-zhaoguohan@kylinos.cn
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ethosu/ethosu_drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/accel/ethosu/ethosu_drv.c b/drivers/accel/ethosu/ethosu_drv.c
index ed9c748a54ad..b2901eb8a7a0 100644
--- a/drivers/accel/ethosu/ethosu_drv.c
+++ b/drivers/accel/ethosu/ethosu_drv.c
@@ -342,6 +342,8 @@ static int ethosu_probe(struct platform_device *pdev)
 	dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(40));
 
 	ethosudev->regs = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(ethosudev->regs))
+		return PTR_ERR(ethosudev->regs);
 
 	ethosudev->num_clks = devm_clk_bulk_get_all(&pdev->dev, &ethosudev->clks);
 	if (ethosudev->num_clks < 0)
-- 
2.55.0



