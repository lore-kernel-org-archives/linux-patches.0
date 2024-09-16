Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7175D154C14;
	Mon, 16 Sep 2024 12:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488102; cv=none; b=X3VvkLi33K/YX0eJZzM4nxxPuosZ/PwCl0fSyXthpozaTsJpMnWNxBfVpaaPyay0vYW1JOdN9MhZQ+mLyCLSafkuVSEiGFEvq3AAsjKgNkaKiAEFGkrq5bK3UrzQveXmC+4vdoWZQbwIrX+plbFf7lffFZIAtnjfm6cYJx4f0w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488102; c=relaxed/simple;
	bh=Wy754d6yp5lILM8yJr+nowjHXhr9PM1vZyx1xdTQkAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aGgoOQSRYwJmNk32NUqELLEnqM0nrq9jtVyQUsCk1KrMm94fkDHGuiUZyjRdAZEUVU1zipY26QS/wSwMTpaY6gRbFzAHfUDAUhIqWMZ+s6Zu3kquOlKJ0rhTuDicJpxJ7KEfBIPvTZdRBfkotbpHK1k0NhmlGNcdU/g5OkNjRhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rv80Pgp8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rv80Pgp8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEE4DC4CEC4;
	Mon, 16 Sep 2024 12:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488102;
	bh=Wy754d6yp5lILM8yJr+nowjHXhr9PM1vZyx1xdTQkAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rv80Pgp8Y9UOfDnmMNqmdzzKgn9aldStHcvbXsOJ3w76xFU8KFvLTZHDPkgxTawhy
	 NRXHrYfaN1ATQPKKsk4lRv9DjpwjLRfPfZmtK3UYsNBh2aV9qizN1YKn/gCjwDZpsL
	 Nc93huH7dNUdIdUTZD+deq1H/+GbZBtJbpwDRCWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 59/63] spi: geni-qcom: Undo runtime PM changes at driver exit time
Date: Mon, 16 Sep 2024 13:44:38 +0200
Message-ID: <20240916114223.127278027@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114221.021192667@linuxfoundation.org>
References: <20240916114221.021192667@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ac5a581d1e5e..6d8eb7c26076 100644
--- a/drivers/spi/spi-geni-qcom.c
+++ b/drivers/spi/spi-geni-qcom.c
@@ -954,22 +954,24 @@ static int spi_geni_probe(struct platform_device *pdev)
 	spin_lock_init(&mas->lock);
 	pm_runtime_use_autosuspend(&pdev->dev);
 	pm_runtime_set_autosuspend_delay(&pdev->dev, 250);
-	pm_runtime_enable(dev);
+	ret = devm_pm_runtime_enable(dev);
+	if (ret)
+		return ret;
 
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
@@ -998,8 +1000,6 @@ static int spi_geni_probe(struct platform_device *pdev)
 	free_irq(mas->irq, spi);
 spi_geni_release_dma:
 	spi_geni_release_dma_chan(mas);
-spi_geni_probe_runtime_disable:
-	pm_runtime_disable(dev);
 	return ret;
 }
 
@@ -1014,7 +1014,6 @@ static void spi_geni_remove(struct platform_device *pdev)
 	spi_geni_release_dma_chan(mas);
 
 	free_irq(mas->irq, spi);
-	pm_runtime_disable(&pdev->dev);
 }
 
 static int __maybe_unused spi_geni_runtime_suspend(struct device *dev)
-- 
2.43.0



