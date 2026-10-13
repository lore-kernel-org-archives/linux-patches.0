Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84EEA4F93D0;
	Tue, 13 Oct 2026 11:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892655; cv=none; b=NR3khH8/7XW5b4+lP7rBKWr43+b3yUcNCnHKiNXsTu0/6U+l4Ho+NCb3IFgU5eLLZXA4kCCTeDfxkxBZGDHGRUzX2lKuUeSQoAow3spbi2UkUScAeDrKqHepcdkCtR4Y034eiW9xMlOmMZgfXMXdtLE/i2olBq2yCi/t8FfEweY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892655; c=relaxed/simple;
	bh=NslqmJImAM/MU/XeDIO729D74MjeuUi7Y3MJ/E1E98Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FJOv4S5IUWxz6i77p5LfCXdQ8euo56nyj6GrINXvjw3ZgNjSMzG+Yc1n1qDKhdMuVYHTomkpLhmDy5xi4QQCrIPmCT+JfIeXV1qFjSH90S3VCjg4Pkbdh13/SGE7vLPBTR1IWH0dfWRQQ+6AjPyStipvt9NWl8xux6U6iWKLShg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yzxRmsi1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yzxRmsi1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C9B1F000FF;
	Tue, 13 Oct 2026 11:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892654;
	bh=QYIFE7hQ3m8rHQ2VZ/kdLQGFJLyZnRawVXL1z9EMWdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yzxRmsi1a/moGqOo59HLK6U41gyWUn0BwxyEF8z0rRnv7+qyjxdbLmJS1Z97MdFhz
	 ROYmUM6wF2A41x2JMslWvrD1MRLViUnF1DFyo0+wMMf9VtRw87lwWiFCcWSn4aimm/
	 fOsOc4g8uihdML2f9eYuZUhBOyA+pSq5OWKrZzEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Han Gao <gaohan@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 245/281] spi: sg2044-nor: Return transfer errors
Date: Tue, 13 Oct 2026 13:39:21 +0200
Message-ID: <20261013112901.093152454@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

From: Han Gao <gaohan@iscas.ac.cn>

[ Upstream commit e130c54fbb603f9aeacf5029789b4a2c8c48f416 ]

The transfer helpers return errors, but both dispatchers discard them.
Return these errors to the SPI memory layer instead of reporting success.

Fixes: de16c322eefb ("spi: sophgo: add SG2044 SPI NOR controller driver")
Signed-off-by: Han Gao <gaohan@iscas.ac.cn>
Link: https://patch.msgid.link/20261001-fix-sg204xspi-v2-1-014dbaf22b5e@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-sg2044-nor.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/spi/spi-sg2044-nor.c b/drivers/spi/spi-sg2044-nor.c
index f3bcb8a1b92bb..ff026ca0f7663 100644
--- a/drivers/spi/spi-sg2044-nor.c
+++ b/drivers/spi/spi-sg2044-nor.c
@@ -307,15 +307,15 @@ static ssize_t sg2044_spifmc_tran_cmd(struct sg2044_spifmc *spifmc,
 	return 0;
 }
 
-static void sg2044_spifmc_trans(struct sg2044_spifmc *spifmc,
-				const struct spi_mem_op *op)
+static int sg2044_spifmc_trans(struct sg2044_spifmc *spifmc,
+			       const struct spi_mem_op *op)
 {
 	if (op->data.dir == SPI_MEM_DATA_IN)
-		sg2044_spifmc_read(spifmc, op);
+		return sg2044_spifmc_read(spifmc, op);
 	else if (op->data.dir == SPI_MEM_DATA_OUT)
-		sg2044_spifmc_write(spifmc, op);
+		return sg2044_spifmc_write(spifmc, op);
 	else
-		sg2044_spifmc_tran_cmd(spifmc, op);
+		return sg2044_spifmc_tran_cmd(spifmc, op);
 }
 
 static ssize_t sg2044_spifmc_trans_reg(struct sg2044_spifmc *spifmc,
@@ -389,19 +389,20 @@ static int sg2044_spifmc_exec_op(struct spi_mem *mem,
 				 const struct spi_mem_op *op)
 {
 	struct sg2044_spifmc *spifmc;
+	int ret;
 
 	spifmc = spi_controller_get_devdata(mem->spi->controller);
 
 	mutex_lock(&spifmc->lock);
 
 	if (op->addr.nbytes == 0)
-		sg2044_spifmc_trans_reg(spifmc, op);
+		ret = sg2044_spifmc_trans_reg(spifmc, op);
 	else
-		sg2044_spifmc_trans(spifmc, op);
+		ret = sg2044_spifmc_trans(spifmc, op);
 
 	mutex_unlock(&spifmc->lock);
 
-	return 0;
+	return ret;
 }
 
 static const struct spi_controller_mem_ops sg2044_spifmc_mem_ops = {
-- 
2.53.0



