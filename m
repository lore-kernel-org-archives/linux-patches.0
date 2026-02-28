Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4165355049
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300989; cv=none; b=NEdyoBvyjtQvMFoMCWmguhtbYNub0+FgXrpuEACQN+j6Dtd4nDDtGuRRzfoho/UW5hSbv62UxrUklAsN9EwPv9MYjWP1WnezB2DmruYAyJ7VcziAdL0os9AZRER2AhQ9p559i+2ihYLC8PPByGRNDsn7ejQIt9+d5A5tXBbkUps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300989; c=relaxed/simple;
	bh=ioaz2LX6Riu+loomCejEGpzXL8egcwvTRFq/OvGpw7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qHkk1OfLT9VX5AZkCnAN9WGJw2pUzYyyCrkJ/M/8IELVSl/b0AXxYN48CKitXUsQp7LGRuTMu7AZhuhltfMj/2wMd24W5yrc0GWUg94pmy4n8HuTwK1rTl50nto/T4Ic9pQEJsEiVVBVPkIzhqp70FzUGY6h5i5FV2Q4ov2eot0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g2h9YrQA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g2h9YrQA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 417A7C19425;
	Sat, 28 Feb 2026 17:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300989;
	bh=ioaz2LX6Riu+loomCejEGpzXL8egcwvTRFq/OvGpw7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g2h9YrQAqxI56lA+8ksdHKnePlNqm1Mi4GgnhEQIVTBDIZfHSOnx3TJsnvKoqBHSm
	 58LvRbWdjSqWjfmt4FdRDlthmLtKg1P925KWYOPu9YQZTjI28VH+30ZkXBfhTsn0VW
	 PQ/llttEE252Ggoz3JzRK3efQuBEZDTE9G2hywyaihC2vTqafV8zxuG/UUHYQsp/yX
	 QHOTqr2R4i+oixjqTB+YIqMjqo1dtDFU6D1vfmDvb14E3mwRmehDXmqwLa8HCGffZl
	 pOUJbCVSAT7GxaxyUNXdOMNMfI2b2X6PfA67ljjvNK0iCtLiVkykiI4QaLegW/Shce
	 tLBG+XG9sLHBg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jonathan Marek <jonathan@marek.ca>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 120/752] spi-geni-qcom: initialize mode related registers to 0
Date: Sat, 28 Feb 2026 12:37:11 -0500
Message-ID: <20260228174750.1542406-120-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jonathan Marek <jonathan@marek.ca>

[ Upstream commit 739062a9f1e9a77a9687c8fd30f8e5dd12ec70be ]

setup_fifo_params assumes these will be zero, it won't write these
registers if the initial mode is zero.

Signed-off-by: Jonathan Marek <jonathan@marek.ca>
Link: https://patch.msgid.link/20251120211204.24078-4-jonathan@marek.ca
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-geni-qcom.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/spi/spi-geni-qcom.c b/drivers/spi/spi-geni-qcom.c
index a0d8d3425c6c6..9e9953469b3a0 100644
--- a/drivers/spi/spi-geni-qcom.c
+++ b/drivers/spi/spi-geni-qcom.c
@@ -724,6 +724,12 @@ static int spi_geni_init(struct spi_geni_master *mas)
 	case 0:
 		mas->cur_xfer_mode = GENI_SE_FIFO;
 		geni_se_select_mode(se, GENI_SE_FIFO);
+		/* setup_fifo_params assumes that these registers start with a zero value */
+		writel(0, se->base + SE_SPI_LOOPBACK);
+		writel(0, se->base + SE_SPI_DEMUX_SEL);
+		writel(0, se->base + SE_SPI_CPHA);
+		writel(0, se->base + SE_SPI_CPOL);
+		writel(0, se->base + SE_SPI_DEMUX_OUTPUT_INV);
 		ret = 0;
 		break;
 	}
-- 
2.51.0

