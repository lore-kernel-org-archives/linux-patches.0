Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692FF1E411D;
	Wed, 19 Feb 2025 09:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956135; cv=none; b=d3ghKaT8ylmcUEv/3AARlr3g4ues8ss8QQBCbp6rlEK3T1UGItksiW8eX4ikUAMlv0kZ8eKpqa3Abm33FVIOP+z/dKlPym/DO0/BdEb8UbTuraPL/As4xEtWr1+Rfc5dKmlMOjK7TYlNPezFCaC9ZupyBc3NJxiJJtvy5D+ZDhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956135; c=relaxed/simple;
	bh=+EbXcXmCvYyZxnVWlCaEVvgeTTW+1xiiYcg4vHLqm0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UrKBK3ggLrh2qsCvkaQdxvbcTJWOn0c86Pv6AbnwzVaCaVTLg7mlikCHR8ojrKLc27hUHtZ8K3zC/Ff5xuE1F/EKRxO5FJELkqEfdNhkPc1JnztBHRNVk7mmr8gy9+wJAiRLOuI2PrrkYDLTT3xjY0aau2pJndDV1mD6ML99V9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MAbZAjqa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MAbZAjqa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1077C4AF0F;
	Wed, 19 Feb 2025 09:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956135;
	bh=+EbXcXmCvYyZxnVWlCaEVvgeTTW+1xiiYcg4vHLqm0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MAbZAjqa0GA7COv04eERkkcrpBJZbzrFgH6W38pgB9MjFlJQNCLpC0tjiWIUIV/Xj
	 /mUywGalRVyhD+eYsckD4v6Ebw498zAm4oS1p5b1L9Ji42yz6bxPzpW6ETlw0EYUEM
	 oOFweesACEIXfXQnnZjNIRAXX1mijflqajUW+TIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingwei Zheng <zmw12306@gmail.com>,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 045/578] spi: zynq-qspi: Add check for clk_enable()
Date: Wed, 19 Feb 2025 09:20:49 +0100
Message-ID: <20250219082654.663722456@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Mingwei Zheng <zmw12306@gmail.com>

[ Upstream commit 8332e667099712e05ec87ba2058af394b51ebdc9 ]

Add check for the return value of clk_enable() to catch the potential
error.

Fixes: c618a90dcaf3 ("spi: zynq-qspi: Drop GPIO header")
Signed-off-by: Mingwei Zheng <zmw12306@gmail.com>
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Link: https://patch.msgid.link/20241207015206.3689364-1-zmw12306@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-zynq-qspi.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-zynq-qspi.c b/drivers/spi/spi-zynq-qspi.c
index 78f31b61a2aac..77ea6b5223483 100644
--- a/drivers/spi/spi-zynq-qspi.c
+++ b/drivers/spi/spi-zynq-qspi.c
@@ -379,12 +379,21 @@ static int zynq_qspi_setup_op(struct spi_device *spi)
 {
 	struct spi_controller *ctlr = spi->master;
 	struct zynq_qspi *qspi = spi_controller_get_devdata(ctlr);
+	int ret;
 
 	if (ctlr->busy)
 		return -EBUSY;
 
-	clk_enable(qspi->refclk);
-	clk_enable(qspi->pclk);
+	ret = clk_enable(qspi->refclk);
+	if (ret)
+		return ret;
+
+	ret = clk_enable(qspi->pclk);
+	if (ret) {
+		clk_disable(qspi->refclk);
+		return ret;
+	}
+
 	zynq_qspi_write(qspi, ZYNQ_QSPI_ENABLE_OFFSET,
 			ZYNQ_QSPI_ENABLE_ENABLE_MASK);
 
-- 
2.39.5



