Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B61C2340A79
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301063; cv=none; b=TGC6grjFxjoIzYMKwKQfNJRW22zccFeyjcZzDlmgzy226+M6QbpdYDJsFlGSJI6gpY0X7aWN5/213uwP7fdkVtSRSdHdOWg6mGs8ov9zSDEAb7L6X6JGyC8YCXAJKZsg6qdleh+UiRiDHDejUXsGoTkc6tDC4wL0Xnx0B5Zp6LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301063; c=relaxed/simple;
	bh=9DePG+3ApJLWUkuXD2BkxLNtgVIC0JyRLY+gVS8vJo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jX5F7jxUY5sply05MuGv+CAjW3RCYJY4kZrTeYOTP95re3I27e4FmY+EzZhWv61Scm01A4R/ZEe0bxvOzDRCDWSjol+O+esGc06c4Una7CVxwQ/1ahJSSscitXdsTsKRbp0h37q1twQmU4jyNjRO9865A9RbHErx1y1NH8P+Ndc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fjSjpmSh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fjSjpmSh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10230C116D0;
	Sat, 28 Feb 2026 17:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301063;
	bh=9DePG+3ApJLWUkuXD2BkxLNtgVIC0JyRLY+gVS8vJo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fjSjpmShL/JXNMbxAKklsSUEDDMufncUxcffFlRrP3WGIMN6+bWfxq78PHbYHoUQ0
	 9q95uC7vCvARXUIwuYqsgudF7ek7nyh8jCj+4LqI1aNw5nwOiaeVtTHmNS7pDfa3g/
	 Jy3aLQt+3s9FrfkpbIK7lOfzZWSEHMeTjdAsbe1bUt3rDhnmL2tVkto3NvvG+kAt2N
	 D+phiYoS0H7XeJYFnywPpeSVfdQPzSY8u8hIFB9xzPrD8gsgWV0SF3syoO3JBgV1qh
	 V7+lUdj2VkasgigqxDowEj/YmmffN2dF4JE6k5/cLLsNJHGsY5ABVDS4lSvq/02b8f
	 2+vrLATl+KpZA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Praveen Talari <praveen.talari@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 206/752] spi: geni-qcom: Fix abort sequence execution for serial engine errors
Date: Sat, 28 Feb 2026 12:38:37 -0500
Message-ID: <20260228174750.1542406-206-sashal@kernel.org>
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

From: Praveen Talari <praveen.talari@oss.qualcomm.com>

[ Upstream commit 96e041647bb0f9d92f95df1d69cb7442d7408b79 ]

The driver currently skips the abort sequence for target mode when serial
engine errors occur. This leads to improper error recovery as the serial
engine may remain in an undefined state without proper cleanup, potentially
causing subsequent operations to fail or behave unpredictably.

Fix this by ensuring the abort sequence and DMA reset always execute during
error recovery, as both are required for proper serial engine error
handling.

Co-developed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Praveen Talari <praveen.talari@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260204162854.1206323-3-praveen.talari@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-geni-qcom.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/spi/spi-geni-qcom.c b/drivers/spi/spi-geni-qcom.c
index 5ab20d7955121..acfcf870efd84 100644
--- a/drivers/spi/spi-geni-qcom.c
+++ b/drivers/spi/spi-geni-qcom.c
@@ -160,24 +160,20 @@ static void handle_se_timeout(struct spi_controller *spi,
 	xfer = mas->cur_xfer;
 	mas->cur_xfer = NULL;
 
-	if (spi->target) {
-		/*
-		 * skip CMD Cancel sequnece since spi target
-		 * doesn`t support CMD Cancel sequnece
-		 */
+	/* The controller doesn't support the Cancel commnand in target mode */
+	if (!spi->target) {
+		reinit_completion(&mas->cancel_done);
+		geni_se_cancel_m_cmd(se);
+
 		spin_unlock_irq(&mas->lock);
-		goto reset_if_dma;
-	}
 
-	reinit_completion(&mas->cancel_done);
-	geni_se_cancel_m_cmd(se);
-	spin_unlock_irq(&mas->lock);
+		time_left = wait_for_completion_timeout(&mas->cancel_done, HZ);
+		if (time_left)
+			goto reset_if_dma;
 
-	time_left = wait_for_completion_timeout(&mas->cancel_done, HZ);
-	if (time_left)
-		goto reset_if_dma;
+		spin_lock_irq(&mas->lock);
+	}
 
-	spin_lock_irq(&mas->lock);
 	reinit_completion(&mas->abort_done);
 	geni_se_abort_m_cmd(se);
 	spin_unlock_irq(&mas->lock);
-- 
2.51.0

