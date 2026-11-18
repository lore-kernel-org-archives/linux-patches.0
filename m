Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039421;
	b=i19zD7HPIJeE6F2FOgil1GCPrpelqEJjY4VWlQOby/7DDmnyMdI6898norPY7GrgpIQ1
	 Qd3YF0o0QY1tVQ6LiEDqOSzgFyJzaBjviHuX5/Or821159wwndItwImum6XCQLqXbQSI3
	 j4/4OJghPNAyMEqkEM9skLNMe1rHegVjijrpDYbNgeADsEpslVOFYFPA7SwnhIzn0fWk9
	 jaZvW/MgRQHN2N022zC3jzF39nBC5VT8oqKJhtOWnm8FpUW61Zm+CEtPDeZ8FEDQtpZWt
	 GuGwQtIc2AGQu3/NmVZrqeB+wscUP0o3d2urwQUJLbhwJrkduWn7jfLI2/oRH+qiO7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039421;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x+lSpuq9uKxKiA9hXQkWpbS8mfrFhcCjRsGVN4+Co1k=;
	b=NphFHZRp5nY1GBxH8kOBuFL033tEwZnielNHxa0xvnxEuZ800hGjLD/qAjx+UEFqA22Y
	 1ymvLLPmy2YzrNhAHzdEmPcHgNfKm8Y2adFrx+M8KNqKBl1L0L2DpvqO0eMXujb5luZtW
	 L82MACXAV8/HqdCiu8QrRxTjH8bdulCmaN4m7REQZ96KP39CtU00N2BBe4dXRQMLtE4oj
	 AVkuqkVT7Z1Y/+TYZkGvoFn8XB65KmS6jahcirxGJr3ozFW4OAzqqwaloImOk1D1nzX8h
	 G0XEbXCyy6CNqe++p8f4VtodE0mO181FC6lv3ESV0WSZvZN16eEj85cmcB+dO1uKrmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=muN2b6cQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A35606A338;
	Wed, 18 Nov 2026 22:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=muN2b6cQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 923051F000C7;
	Wed, 18 Nov 2026 22:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039421;
	bh=x+lSpuq9uKxKiA9hXQkWpbS8mfrFhcCjRsGVN4+Co1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=muN2b6cQ4U3jfI9KJ2PZ+RhdO0aM+RUo9gytvnMq2nUHHSgl2kTgQ0bwycvt7C2HT
	 8zUyljkEa+qps9FOyoEws7933ithjhiHRDRT9wKaOy6PT9I5CZJJ4UFSv7YqnZcJjK
	 5/EJrF4PlXiObD3i3Z9AUNC4l/YUeF2Plqa/GXWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2092/3318] dmaengine: mediatek: hsdma: fix runtime PM leak on init failure
Date: Wed, 18 Nov 2026 15:45:14 +0100
Message-ID: <20261118150424.857308384@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit f10d96b1c549a2f43506e9bf847196839808b8dc ]

mtk_hsdma_hw_init() enables runtime PM and gets a runtime PM reference
before enabling the HSDMA clock. It currently ignores failures from
pm_runtime_get_sync(); if runtime resume fails, the usage count remains
held. If clk_prepare_enable() then fails, the usage count remains held.

Use devm_pm_runtime_enable() to manage runtime PM enablement, and use
pm_runtime_resume_and_get() so resume failures do not leak the usage count.
If clk_prepare_enable() fails after a successful runtime resume, drop the
runtime PM reference before returning.

The probe path also ignores the return value from mtk_hsdma_hw_init(), so a
failed hardware init can continue as a successful probe. Propagate
mtk_hsdma_hw_init() failures from probe, while keeping a separate unwind
label so mtk_hsdma_hw_deinit() is only called after hardware init succeeds.

Fixes: 548c4597e984 ("dmaengine: mediatek: Add MediaTek High-Speed DMA controller for MT7622 and MT7623 SoC")
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260804153924.49627-1-mhun512@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/mediatek/mtk-hsdma.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/mediatek/mtk-hsdma.c b/drivers/dma/mediatek/mtk-hsdma.c
index 64120767d9838..c18d7cc783380 100644
--- a/drivers/dma/mediatek/mtk-hsdma.c
+++ b/drivers/dma/mediatek/mtk-hsdma.c
@@ -848,17 +848,27 @@ static int mtk_hsdma_hw_init(struct mtk_hsdma_device *hsdma)
 {
 	int err;
 
-	pm_runtime_enable(hsdma2dev(hsdma));
-	pm_runtime_get_sync(hsdma2dev(hsdma));
+	err = devm_pm_runtime_enable(hsdma2dev(hsdma));
+	if (err)
+		return err;
+
+	err = pm_runtime_resume_and_get(hsdma2dev(hsdma));
+	if (err < 0)
+		return err;
 
 	err = clk_prepare_enable(hsdma->clk);
 	if (err)
-		return err;
+		goto err_put_pm;
 
 	mtk_dma_write(hsdma, MTK_HSDMA_INT_ENABLE, 0);
 	mtk_dma_write(hsdma, MTK_HSDMA_GLO, MTK_HSDMA_GLO_DEFAULT);
 
 	return 0;
+
+err_put_pm:
+	pm_runtime_put_sync(hsdma2dev(hsdma));
+
+	return err;
 }
 
 static int mtk_hsdma_hw_deinit(struct mtk_hsdma_device *hsdma)
@@ -868,7 +878,6 @@ static int mtk_hsdma_hw_deinit(struct mtk_hsdma_device *hsdma)
 	clk_disable_unprepare(hsdma->clk);
 
 	pm_runtime_put_sync(hsdma2dev(hsdma));
-	pm_runtime_disable(hsdma2dev(hsdma));
 
 	return 0;
 }
@@ -983,7 +992,9 @@ static int mtk_hsdma_probe(struct platform_device *pdev)
 		goto err_unregister;
 	}
 
-	mtk_hsdma_hw_init(hsdma);
+	err = mtk_hsdma_hw_init(hsdma);
+	if (err)
+		goto err_free;
 
 	err = devm_request_irq(&pdev->dev, hsdma->irq,
 			       mtk_hsdma_irq, 0,
@@ -991,7 +1002,7 @@ static int mtk_hsdma_probe(struct platform_device *pdev)
 	if (err) {
 		dev_err(&pdev->dev,
 			"request_irq failed with err %d\n", err);
-		goto err_free;
+		goto err_deinit;
 	}
 
 	platform_set_drvdata(pdev, hsdma);
@@ -1000,8 +1011,9 @@ static int mtk_hsdma_probe(struct platform_device *pdev)
 
 	return 0;
 
-err_free:
+err_deinit:
 	mtk_hsdma_hw_deinit(hsdma);
+err_free:
 	of_dma_controller_free(pdev->dev.of_node);
 err_unregister:
 	dma_async_device_unregister(dd);
-- 
2.53.0



