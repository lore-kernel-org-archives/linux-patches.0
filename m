Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B01113DBA0;
	Mon, 16 Sep 2024 12:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488105; cv=none; b=d/t54tuyKmm2SQmxj8UA+ZydswxCuMkt2xzSyGlKzZO2ZZmNkIcRSf0Gdxtdt8xFmk+UfxEeWbTAckkuJMvfR7Rob0xiFcDro1Ik/Cb+KntsUV4Wg+krmjoLAhRI415cR9e3k1KDnjQTUzM41xWqb7IpyUSUHIQ8s4j7NNZFZg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488105; c=relaxed/simple;
	bh=IGnujiHp596BT+bxVn21ZzMSCzxWUscyipZ1jMmjNl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U1JQsOoz/m5yKLS0QJjLnNn7Z1Uk/ofXKh/6ePKVI0Ma3/rQXUWa8DWblTpmzQH8lHnFUxL7az8s4xceMavA5gyU7UOBG2FCz5R5IpAm96JL0X9aeQcAEgM8xEeeC9K1Xax6iW2uu1LuS6P72VlTvb0VI0ggOdIRx6IVU4iC0HU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oqp026Te; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oqp026Te"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C76FBC4CEC4;
	Mon, 16 Sep 2024 12:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488105;
	bh=IGnujiHp596BT+bxVn21ZzMSCzxWUscyipZ1jMmjNl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oqp026TeB11Bn/6uJIzuF90nMGyX6VLyV8SF/R7uxXwUh7DWTApzelL0aP4WUllc6
	 RIUkJO9RFgh3WULba34E4ZkdEDBwkQO+KrG4K1e/D3X4rnIswY+7uplUWix+y+2j8p
	 OOYo3okn7FYNf5cwJd/R3B7QiVTWo+SEYOoznNCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 60/63] spi: geni-qcom: Fix incorrect free_irq() sequence
Date: Mon, 16 Sep 2024 13:44:39 +0200
Message-ID: <20240916114223.160683201@linuxfoundation.org>
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
index 6d8eb7c26076..17b5299c18c7 100644
--- a/drivers/spi/spi-geni-qcom.c
+++ b/drivers/spi/spi-geni-qcom.c
@@ -1011,9 +1011,9 @@ static void spi_geni_remove(struct platform_device *pdev)
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



