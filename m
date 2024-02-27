Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2DC816423;
	Tue, 27 Feb 2024 14:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042624; cv=none; b=fINlpJCCB9u/N1m3YMG35Yo8UYucYdRkrtgWoq7FM4GesHPcBdNIpdeoP7JbNez941d6yD1cdo6yqDTV2BGW2doovvFXvM4BXxTwWGLWCdff9aWf6PsnEu1m5/fyf3hdRIp0a5r5UzxpY9eUL9qFLsM1CR3O52JFIRTiFJwbylI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042624; c=relaxed/simple;
	bh=KZcRIUDjU/TgopgkQXVywBYvHkMgtI/ksEjjbRvd30g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mEIoYCyzULS9izyqktCWjoclIgNKP8DCaQd4gUqu3Q4Hv3htXH5wvCimJlYT6Uj1O5emX7kN2jU3ZnuaP+wc4f4wqQlwh9Zgm7f0nUXXZJWwBZ9LONoDyThf0wl5NYMdY+Oz2EduB0EPE04jqmF1PHClqdrK/RgViE78fK3xPHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BZtgv9Jj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BZtgv9Jj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33488C433F1;
	Tue, 27 Feb 2024 14:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042624;
	bh=KZcRIUDjU/TgopgkQXVywBYvHkMgtI/ksEjjbRvd30g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BZtgv9Jj1mE8DzRDsM97DWpKf0pyFsdr3gi9xRo2l95GBa31GdRyy9ceLxnGKhA0m
	 aZZTeakVBHgSS0aKoacHQTERWEqGmbUwrZzzZpI6xD6vT6Ku8W2fRzw+JNG3D+nn3f
	 idHJrltRs2mqsmrKVsj0tfiYKXcEdNT0mYj1UoHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 033/245] dmaengine: ti: edma: Add some null pointer checks to the edma_probe
Date: Tue, 27 Feb 2024 14:23:41 +0100
Message-ID: <20240227131616.194470666@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kunwu Chan <chentao@kylinos.cn>

[ Upstream commit 6e2276203ac9ff10fc76917ec9813c660f627369 ]

devm_kasprintf() returns a pointer to dynamically allocated memory
which can be NULL upon failure. Ensure the allocation was successful
by checking the pointer validity.

Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Link: https://lore.kernel.org/r/20240118031929.192192-1-chentao@kylinos.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ti/edma.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/dma/ti/edma.c b/drivers/dma/ti/edma.c
index a1adc8d91fd8d..69292d4a0c441 100644
--- a/drivers/dma/ti/edma.c
+++ b/drivers/dma/ti/edma.c
@@ -2462,6 +2462,11 @@ static int edma_probe(struct platform_device *pdev)
 	if (irq > 0) {
 		irq_name = devm_kasprintf(dev, GFP_KERNEL, "%s_ccint",
 					  dev_name(dev));
+		if (!irq_name) {
+			ret = -ENOMEM;
+			goto err_disable_pm;
+		}
+
 		ret = devm_request_irq(dev, irq, dma_irq_handler, 0, irq_name,
 				       ecc);
 		if (ret) {
@@ -2478,6 +2483,11 @@ static int edma_probe(struct platform_device *pdev)
 	if (irq > 0) {
 		irq_name = devm_kasprintf(dev, GFP_KERNEL, "%s_ccerrint",
 					  dev_name(dev));
+		if (!irq_name) {
+			ret = -ENOMEM;
+			goto err_disable_pm;
+		}
+
 		ret = devm_request_irq(dev, irq, dma_ccerr_handler, 0, irq_name,
 				       ecc);
 		if (ret) {
-- 
2.43.0



