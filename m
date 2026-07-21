Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5AA646AA70;
	Tue, 21 Jul 2026 15:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648135; cv=none; b=EbI+yH1jJB0BC1BPqeEB7v52DfdO4VbJo0URuBE1WWTm4xAE+gZes5e7516+UjqKNiXOqXbQuLUjgWf35qG5wdEymYbx6XhyQr8YHy5ongZ7ankx674qReN6zUi2in8eVhEXQRJQr2RXuc7sLM/EInNXS3WGWznAMVMHIstCPYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648135; c=relaxed/simple;
	bh=1xA4KWYF58XEe/H8gbQ3y0tw0YRrzslyOV2RZwu9eYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nKgLoXdNiSp7AukPfceMPpn8yg+JZMnW5WcHozX5jBvcH3BO7Z4niEgb5jQKkMcn5RMGHQ83G65HbN5VMQ1LOag6TXYo20tit8YH30u5CYKxZvD3q7QFPShXtAWyh03qjbVfBFCzXk3x3S5WCLaTsVCbwcOaGQW6KlfxGWJAbV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xehf+6dr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xehf+6dr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3864B1F000E9;
	Tue, 21 Jul 2026 15:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648134;
	bh=3o9E4iw8Okkno6fe71+MZaLM2OHy8cal9AoBO/MQK14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xehf+6drrGwA34vFHpbB9LvOJ2/Ep5M1icU5fXMhK63EepoLQVqj8Vin0UO4Asqg6
	 KF7XAwATTwaIyQj1a96zNjZRNEX8EgZBaDnCc1Fr6HS/zYL03phDBwGdFPtpu5mmGt
	 nilxDyiUu+uqOb+7opfdej1GT3Npc6pKXzj+VuQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0041/2077] soc: fsl: qe_ports_ic: Add missing cleanup on device removal
Date: Tue, 21 Jul 2026 16:55:14 +0200
Message-ID: <20260721152553.658004667@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 7dad18a179741dbad9f40799e549fa9111987c0c ]

Add a devm action handler to properly clean up the irq_domain and
chained handler when the device is removed.

Fixes: f0bcd784e1b7 ("soc: fsl: qe: Add an interrupt controller for QUICC Engine Ports")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Link: https://lore.kernel.org/r/20260310-qe_ports_ic-v1-1-608293026561@gmail.com
Signed-off-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/fsl/qe/qe_ports_ic.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/soc/fsl/qe/qe_ports_ic.c b/drivers/soc/fsl/qe/qe_ports_ic.c
index 8e2107e2cde5b2..5e3fae19f31417 100644
--- a/drivers/soc/fsl/qe/qe_ports_ic.c
+++ b/drivers/soc/fsl/qe/qe_ports_ic.c
@@ -17,6 +17,7 @@
 struct qepic_data {
 	void __iomem *reg;
 	struct irq_domain *host;
+	int irq;
 };
 
 static void qepic_mask(struct irq_data *d)
@@ -92,11 +93,18 @@ static const struct irq_domain_ops qepic_host_ops = {
 	.map = qepic_host_map,
 };
 
+static void qepic_remove(void *res)
+{
+	struct qepic_data *data = res;
+
+	irq_set_chained_handler_and_data(data->irq, NULL, NULL);
+	irq_domain_remove(data->host);
+}
+
 static int qepic_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct qepic_data *data;
-	int irq;
 
 	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
 	if (!data)
@@ -106,17 +114,18 @@ static int qepic_probe(struct platform_device *pdev)
 	if (IS_ERR(data->reg))
 		return PTR_ERR(data->reg);
 
-	irq = platform_get_irq(pdev, 0);
-	if (irq < 0)
-		return irq;
+	data->irq = platform_get_irq(pdev, 0);
+	if (data->irq < 0)
+		return data->irq;
 
 	data->host = irq_domain_add_linear(dev->of_node, 32, &qepic_host_ops, data);
 	if (!data->host)
 		return -ENODEV;
 
-	irq_set_chained_handler_and_data(irq, qepic_cascade, data);
+	irq_set_chained_handler_and_data(data->irq, qepic_cascade, data);
+
+	return devm_add_action_or_reset(dev, qepic_remove, data);
 
-	return 0;
 }
 
 static const struct of_device_id qepic_match[] = {
-- 
2.53.0



