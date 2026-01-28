Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4DE2475E3;
	Wed, 28 Jan 2026 15:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614229; cv=none; b=RYEwUhDhuWNP/LvO4v+S1pPQu0WGqiNkycwFintl/39uLdyCYU6ur+FrodIOFYxovN8yjHAT/a1jhh+4/ofG+6F5a573LaYjonRVgl2Oszc/83CqfMm9ddAR/C4tE+Pr9nid7voAbDblD0Owpn/TXD52dOuqJyJXCS/fKj4OpyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614229; c=relaxed/simple;
	bh=8o5JstdUSr6GPZ4prD41RNpe3W9lHuX4O/mGHtypcJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PSlv6yjqQA9QEzJ3OposBXcnPKtOSIGX6a3obYk7FypbVYtMMX4hD/3UR5jNC28WhPZ6QtjRri60sA2A9EtpJ4TADTdpXk83kGxnFa3SIP1aK5IXh4AJwpOEqs3zo9DcDnUbRCA/5c/X9aQb6CBuVNVSo2W3eWlNwt0GeomSEPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YQNE/unI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YQNE/unI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F30BBC4CEF1;
	Wed, 28 Jan 2026 15:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614229;
	bh=8o5JstdUSr6GPZ4prD41RNpe3W9lHuX4O/mGHtypcJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YQNE/unITVOudbvb8ISqQcP81iSETswe0MYuYkug4C5I5a6z0YRFK6Q7gHwmmUfbY
	 XRnLKNXnwxIADvu0p9LylVMLKXBrhu72gJAuIilHhI8dPzzpkkmCv7NHx2pO2s0wJ+
	 XJp333PxZZC3/k/cAgPGmdQ0gJuUWxHk9biGmyPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>,
	Mukesh Kumar Savaliya <mukesh.savaliya@oss.qualcomm.com>
Subject: [PATCH 6.6 042/254] i2c: qcom-geni: make sure I2C hub controllers cant use SE DMA
Date: Wed, 28 Jan 2026 16:20:18 +0100
Message-ID: <20260128145346.215129367@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit c0c50e3743e467ec4752c638e10e97f89c8644e2 ]

The I2C Hub controller is a simpler GENI I2C variant that doesn't
support DMA at all, add a no_dma flag to make sure it nevers selects
the SE DMA mode with mappable 32bytes long transfers.

Fixes: cacd9643eca7 ("i2c: qcom-geni: add support for I2C Master Hub variant")
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Mukesh Kumar Savaliya <mukesh.savaliya@oss.qualcomm.com>>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-qcom-geni.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-qcom-geni.c b/drivers/i2c/busses/i2c-qcom-geni.c
index 350f7827fbaca..f6e46168571f5 100644
--- a/drivers/i2c/busses/i2c-qcom-geni.c
+++ b/drivers/i2c/busses/i2c-qcom-geni.c
@@ -97,6 +97,7 @@ struct geni_i2c_dev {
 	dma_addr_t dma_addr;
 	struct dma_chan *tx_c;
 	struct dma_chan *rx_c;
+	bool no_dma;
 	bool gpi_mode;
 	bool abort_done;
 };
@@ -411,7 +412,7 @@ static int geni_i2c_rx_one_msg(struct geni_i2c_dev *gi2c, struct i2c_msg *msg,
 	size_t len = msg->len;
 	struct i2c_msg *cur;
 
-	dma_buf = i2c_get_dma_safe_msg_buf(msg, 32);
+	dma_buf = gi2c->no_dma ? NULL : i2c_get_dma_safe_msg_buf(msg, 32);
 	if (dma_buf)
 		geni_se_select_mode(se, GENI_SE_DMA);
 	else
@@ -450,7 +451,7 @@ static int geni_i2c_tx_one_msg(struct geni_i2c_dev *gi2c, struct i2c_msg *msg,
 	size_t len = msg->len;
 	struct i2c_msg *cur;
 
-	dma_buf = i2c_get_dma_safe_msg_buf(msg, 32);
+	dma_buf = gi2c->no_dma ? NULL : i2c_get_dma_safe_msg_buf(msg, 32);
 	if (dma_buf)
 		geni_se_select_mode(se, GENI_SE_DMA);
 	else
@@ -866,10 +867,12 @@ static int geni_i2c_probe(struct platform_device *pdev)
 		return -ENXIO;
 	}
 
-	if (desc && desc->no_dma_support)
+	if (desc && desc->no_dma_support) {
 		fifo_disable = false;
-	else
+		gi2c->no_dma = true;
+	} else {
 		fifo_disable = readl_relaxed(gi2c->se.base + GENI_IF_DISABLE_RO) & FIFO_IF_DISABLE;
+	}
 
 	if (fifo_disable) {
 		/* FIFO is disabled, so we can only use GPI DMA */
-- 
2.51.0



