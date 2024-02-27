Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD7213B2B3;
	Tue, 27 Feb 2024 14:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043224; cv=none; b=jVkjOwrKna7vJoyN52taGfNH+M4qNhkHJsSaBuHqMQeqnOTXQnggkkL86fyOTURJp9rYCEORk0ba+IyPTQ4LDuZCRfZmpLLgQkDS2ps0efiEJo8vGyMHqHUDJkjfAyCGqJDPkJUdLb9R2UfOzzWmOd7PN8+WiuOBINRh5+8l05I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043224; c=relaxed/simple;
	bh=6WcJ6hmMvvrY5tFHi6N8ISUhD5ut3vCL4dr0/IZFtzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R7nIhPqLHJvdL/XvyBhW65u2nYjIIyLLQkGiVCaYQwWUdS1GG3Kix9r/tQrcOPvRlAwOUenBXOf4zTOQagrZdGWmouz6BxQlWLCB/EJULERXJA2NNcXIRED8mfTCQgC2Iq6IKyHpiLzljMRfjnfqn7NisjjofQZjz/exNAbUTpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dm75kG3N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dm75kG3N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9876C43390;
	Tue, 27 Feb 2024 14:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043224;
	bh=6WcJ6hmMvvrY5tFHi6N8ISUhD5ut3vCL4dr0/IZFtzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dm75kG3Nfu3oiW4Ab7iLvtx3GXFmVOudEcHw6KePoaS4zYpCPsuCVm4F42MYTdK5d
	 egYDH2E8lHu880wa/2N+e0EAQuJHLgPciEcg517cr1t90o06wqYI9QNrMbW9VZEzan
	 tSLFuNArszL7CDOSvSsROYEZy1si/2DW2J6YpmAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 030/195] dmaengine: ti: edma: Add some null pointer checks to the edma_probe
Date: Tue, 27 Feb 2024 14:24:51 +0100
Message-ID: <20240227131611.388138193@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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
index 7ec6e5d728b03..9212ac9f978f2 100644
--- a/drivers/dma/ti/edma.c
+++ b/drivers/dma/ti/edma.c
@@ -2413,6 +2413,11 @@ static int edma_probe(struct platform_device *pdev)
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
@@ -2429,6 +2434,11 @@ static int edma_probe(struct platform_device *pdev)
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



