Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0160A155336;
	Mon, 16 Sep 2024 12:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488439; cv=none; b=ezmPkufLpoFooiVBJmzRWV0+CAbHGARibEHjRyIg43aQCFhbjmS5z7TcQ1VE00Vsxq1dXtn+UO8epvxRPAG1SASatdICVeQuZDPar52XKaheXuEBsdDfAJ9BZcEzZMGDFlgpXjK7ErB1+s86n4HbgVeYnh2YvzRq25fiJ0E3HvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488439; c=relaxed/simple;
	bh=7dHoZWczIIvnvtm1WAs+ln1058C0P7P65EPvy9kERQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d3WldQPJbZvCkDmlBvdPlA355zEgH6ti0prX4n3qIDwdnEGjeTHRIJ88ILTNU7a64O0ocsptB+4xap4IZSCUCBpjC0ADIKEB0o1S1UVws0+LSgbNhpL+EF8ysa6HmIm7WEZfEUHGjmCjvaYe1YV/5xag/VWHxl9XTw59wIn9+zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=imHIQQwF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="imHIQQwF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46879C4CEC4;
	Mon, 16 Sep 2024 12:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488438;
	bh=7dHoZWczIIvnvtm1WAs+ln1058C0P7P65EPvy9kERQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=imHIQQwFxuaEu4H/PN4uFkehPVa+CuGCOgjIHh9mycH9YS0U6SL/3aPHtg+Hbiw4p
	 MwjNdb+mKizMjMz9B9/DZfxAlwiJzj5ocpCn2BrEqy1WtDszGu9/7wrJyvqimwLfbi
	 BLal8Fps8ZxZZlqiAYYuzgkMUcMcv16xusqjR7WU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 113/121] spi: geni-qcom: Undo runtime PM changes at driver exit time
Date: Mon, 16 Sep 2024 13:44:47 +0200
Message-ID: <20240916114232.838714274@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 89e362c883c65ff94b76b9862285f63545fb5274 ]

It's important to undo pm_runtime_use_autosuspend() with
pm_runtime_dont_use_autosuspend() at driver exit time unless driver
initially enabled pm_runtime with devm_pm_runtime_enable()
(which handles it for you).

Hence, switch to devm_pm_runtime_enable() to fix it, so the
pm_runtime_disable() in probe error path and remove function
can be removed.

Fixes: cfdab2cd85ec ("spi: spi-geni-qcom: Set an autosuspend delay of 250 ms")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Suggested-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://patch.msgid.link/20240909073141.951494-2-ruanjinjie@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-geni-qcom.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/spi/spi-geni-qcom.c b/drivers/spi/spi-geni-qcom.c
index 37ef8c40b276..fef522fece1b 100644
--- a/drivers/spi/spi-geni-qcom.c
+++ b/drivers/spi/spi-geni-qcom.c
@@ -1110,25 +1110,27 @@ static int spi_geni_probe(struct platform_device *pdev)
 	spin_lock_init(&mas->lock);
 	pm_runtime_use_autosuspend(&pdev->dev);
 	pm_runtime_set_autosuspend_delay(&pdev->dev, 250);
-	pm_runtime_enable(dev);
+	ret = devm_pm_runtime_enable(dev);
+	if (ret)
+		return ret;
 
 	if (device_property_read_bool(&pdev->dev, "spi-slave"))
 		spi->target = true;
 
 	ret = geni_icc_get(&mas->se, NULL);
 	if (ret)
-		goto spi_geni_probe_runtime_disable;
+		return ret;
 	/* Set the bus quota to a reasonable value for register access */
 	mas->se.icc_paths[GENI_TO_CORE].avg_bw = Bps_to_icc(CORE_2X_50_MHZ);
 	mas->se.icc_paths[CPU_TO_GENI].avg_bw = GENI_DEFAULT_BW;
 
 	ret = geni_icc_set_bw(&mas->se);
 	if (ret)
-		goto spi_geni_probe_runtime_disable;
+		return ret;
 
 	ret = spi_geni_init(mas);
 	if (ret)
-		goto spi_geni_probe_runtime_disable;
+		return ret;
 
 	/*
 	 * check the mode supported and set_cs for fifo mode only
@@ -1157,8 +1159,6 @@ static int spi_geni_probe(struct platform_device *pdev)
 	free_irq(mas->irq, spi);
 spi_geni_release_dma:
 	spi_geni_release_dma_chan(mas);
-spi_geni_probe_runtime_disable:
-	pm_runtime_disable(dev);
 	return ret;
 }
 
@@ -1173,7 +1173,6 @@ static void spi_geni_remove(struct platform_device *pdev)
 	spi_geni_release_dma_chan(mas);
 
 	free_irq(mas->irq, spi);
-	pm_runtime_disable(&pdev->dev);
 }
 
 static int __maybe_unused spi_geni_runtime_suspend(struct device *dev)
-- 
2.43.0



