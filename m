Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B2413B797;
	Tue, 27 Feb 2024 14:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043992; cv=none; b=Rm1WNV1ZZA+Cuj5KZxKiJqT4szV7Qrvyp+1kg0y1UtFdB4wfJXD7xexHO0Q1iHKxHUxbuvJOEQYKNKdFusgwmq9PITa1nxzG5q0ySnAoSNQa+lhtBpzvKgEajIdRmzSpmxYy4BGGjGYT7/aXghgDAVlFDr88JzdZ/i/+YLKqBW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043992; c=relaxed/simple;
	bh=w3rwI4AVhHNjS0vAJVP6diSo4z0g2W2jY+7cvpcy6Ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CTXuKrwT4dIZJd1QxDAGkEWIhilrh7jdNjgiojkN2LiuiDteiW2aeqnNhy+8kYK/YSvgSNFIruMtVc/Dp0N/He1IQC4lhRApdJhoNSKfr3fZy7SXrCDV1059YPAirElA/bEynReKNKH2MYDSxQ2JdGKD3tiMEpnu0phnLIgY68I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jPOri/t+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jPOri/t+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 589B7C433F1;
	Tue, 27 Feb 2024 14:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043992;
	bh=w3rwI4AVhHNjS0vAJVP6diSo4z0g2W2jY+7cvpcy6Ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jPOri/t++n6HV0WuXZ5vAtroKddJwA7JcfkOAPOQwTXW1w/OCsom0gRG5uHo4CRyJ
	 LK3qAB/dEWxYzDflV4JiT06+UhAac6bUTUAiP5B0YbUmkaBfIcbngyTWRlsqI6ue+l
	 ERAW6q98yF1wuJ1u1ML4LcX+No0HwqSO4jj2EP8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 024/122] dmaengine: ti: edma: Add some null pointer checks to the edma_probe
Date: Tue, 27 Feb 2024 14:26:25 +0100
Message-ID: <20240227131559.498339798@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



