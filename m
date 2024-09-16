Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B0B155359;
	Mon, 16 Sep 2024 12:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488704; cv=none; b=qXVjgpdgecB1DzbtiHfxL1eEdgm4g0TWCJJ1b4BIJ0p4cEyOIQ6FvJvcuOwdlnMdzjm08DfGGaTfXFyePtIPldaOletl29I9jJ/i/0gKYUN5NL0DnK52scPykpEVWOv8sKsrQBfZi0aN0y7Yi+IptDA0CAP3J+6R6jVZsK+ZPis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488704; c=relaxed/simple;
	bh=qFJnaXZRMIhzOGG1tAGaHUtpBBLqT8yxTrcj2qcUCXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UEH0DzoHp/saa8YC5lOeZlFb0E4FKcgWoRftRkKWibSCNW06aAijSzeKsW4HqACP7gnU4tICd3W5jWBm/NrV5XcjrORNcuxcRPkQFvVwgT9+uPrsAkPCX6UTJaSC88209lIhFygI5tdw7hXGmw98d+BrjkTdaQmw6S3Xhs6WomU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QvzLaVI1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QvzLaVI1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B87CAC4CEC4;
	Mon, 16 Sep 2024 12:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488704;
	bh=qFJnaXZRMIhzOGG1tAGaHUtpBBLqT8yxTrcj2qcUCXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QvzLaVI1eJChmhOyOu0cU4QkBRWbAq6p5wfpojXIhvNTt7U9+088l5UzNbbjl2moD
	 SkiRQd2zTTaCMDzuNfUyPXFmnTVDebi9JebISs3ZnWBjflpHhl4PlKZVO/rdpBAP5X
	 3TFbyaTn3aiEXHuRbMJmkmJ8WnX5jJ0rrsuQkDkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 85/91] spi: geni-qcom: Fix incorrect free_irq() sequence
Date: Mon, 16 Sep 2024 13:45:01 +0200
Message-ID: <20240916114227.248223927@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit b787a33864121a565aeb0e88561bf6062a19f99c ]

In spi_geni_remove(), the free_irq() sequence is different from that
on the probe error path. And the IRQ will still remain and it's interrupt
handler may use the dma channel after release dma channel and before free
irq, which is not secure, fix it.

Fixes: b59c122484ec ("spi: spi-geni-qcom: Add support for GPI dma")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://patch.msgid.link/20240909073141.951494-3-ruanjinjie@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-geni-qcom.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-geni-qcom.c b/drivers/spi/spi-geni-qcom.c
index 983c4896c8cf..7401ed3b9acd 100644
--- a/drivers/spi/spi-geni-qcom.c
+++ b/drivers/spi/spi-geni-qcom.c
@@ -1170,9 +1170,9 @@ static void spi_geni_remove(struct platform_device *pdev)
 	/* Unregister _before_ disabling pm_runtime() so we stop transfers */
 	spi_unregister_master(spi);
 
-	spi_geni_release_dma_chan(mas);
-
 	free_irq(mas->irq, spi);
+
+	spi_geni_release_dma_chan(mas);
 }
 
 static int __maybe_unused spi_geni_runtime_suspend(struct device *dev)
-- 
2.43.0



