Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49D239C659;
	Wed, 21 Jan 2026 18:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019676; cv=none; b=UTUkte//8RHXcH3g8+C6LfbasOKpoF58H73zXvE7SEhgHkGJgmoVwQchs7ILOgN4LVjoW3axwfywJntNtnlt9sr8OPj+hqOhQrryqy06r1he1qhFPmCa4qS8aJ9PiKxxMzu4tUDoNndzQXI3q1u7uNCE+1TgflvP3QsBSP63XkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019676; c=relaxed/simple;
	bh=3t5XBxUQfE+ZbvvJAWE/P+J0qCX8aJC11SzI2HBbFs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DAEKsGzkCm1z3DVtmvulivr/Dzbzpg1rYCWcOqego3Gvq7BGHL4JpudcisGSSMgzIUGwqbAO/dD5Tds045MWtfSQ1QTMABOR56uHye9ReRZ0ksilT1AW6bcOwZ8ye+cJ2XCcEUHO3SEKe4hH+EKG4JTBDYSHIrmDtEvdu7kaEd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r3lfpNud; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r3lfpNud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E344C16AAE;
	Wed, 21 Jan 2026 18:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019676;
	bh=3t5XBxUQfE+ZbvvJAWE/P+J0qCX8aJC11SzI2HBbFs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r3lfpNudTK1AT69dmM5Oy5F36V7Ep/MRvgmCUCW426OgfW+DaORhaB7fQlNDJ2KuG
	 xt7mafMVgjrgVlerCL6Zx3Z4cJturnpIqRD/GyF5A5qGEN6OEb2Zs2ii31OCiPbKz+
	 BQRbsSse+QH+6ddrwBY4cQtseo73EgZkFE+BNvEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>,
	Mukesh Kumar Savaliya <mukesh.savaliya@oss.qualcomm.com>
Subject: [PATCH 6.12 058/139] i2c: qcom-geni: make sure I2C hub controllers cant use SE DMA
Date: Wed, 21 Jan 2026 19:15:06 +0100
Message-ID: <20260121181413.541232936@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 212336f724a69..96b024dc3f20f 100644
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
@@ -865,10 +866,12 @@ static int geni_i2c_probe(struct platform_device *pdev)
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



