Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0843B0AC6;
	Tue, 21 Jul 2026 20:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666798; cv=none; b=XnyiTHftfFOGiEGkqE2DDddpLUKA+W/rZZ/IRBuYtqIfJuUH0Bw/bLm0D6JpTGLZKx+L4YPMyD6kSvFBIiwe+rkL61d4/j/xEu9Zv8lhvDaSmM1VFZdV8pPuXYoUYWqR7rmq64zJ3ZC4J0u9HukvkoAGeen9HY0AK2T4o3lEQOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666798; c=relaxed/simple;
	bh=D1+vVCGdT8IieduXSoFO5FoX2sk4XwqndBuZN0q0Sjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qWVQ1/b5RGrQtgTavyimQQcrv407BPQu4N1+wg7BE2D2xUely7BENZWqszXgh4N15UjU0YL9Y0E1/eHUBFzP5SPcIyarSBn6UGtTEkOfpCdbldFqRRWd2XzAK6e+Bhtxl18PslZ9+7sKOWhADrHp5HXKP6Ww7S4ttX65FMoaN5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JRLRyDYX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JRLRyDYX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D151F000E9;
	Tue, 21 Jul 2026 20:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666797;
	bh=+p/rJTfWsh2/G3rbfnVw4oPUJNL2tmclxO6+AwaDMI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JRLRyDYXC2DeJVZZ6MQyn95i8BlSC8ijGD3zMJ1PPLLoAlL4wHEA/Hs1Dw8Cj0nLl
	 kSKyInxGPfVaLus85T+9MM4r8BgQmqUmlIdkjhcrYDgdhplxdtCGy4+LkcXCxGz4mc
	 iNXRNLsabp+HPjB990uNJBtv8qQLNSJvw4Av7Zdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingshuang Fu <fuqingshuang@kylinos.cn>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0818/1266] irqchip/ts4800: Fix missing chained handler cleanup on remove
Date: Tue, 21 Jul 2026 17:20:55 +0200
Message-ID: <20260721152500.163900466@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Qingshuang Fu <fuqingshuang@kylinos.cn>

[ Upstream commit 98bf7e54cec07d514b3575c11896a8b12d50ecc4 ]

The driver installs a chained handler for the parent interrupt during probe
using irq_set_chained_handler_and_data(), but the remove function does not
clear this handler. This leaves a dangling handler that may be called when
the parent interrupt fires after the driver has been removed, potentially
accessing freed memory and causing a kernel crash.

Additionally, the parent_irq obtained via irq_of_parse_and_map() is not
stored, making it inaccessible in the remove function. Moreover, interrupt
mappings created during probe are not properly disposed.

Fix this by:

   - Saving parent_irq in probe
   - Clearing the chained handler with NULL in ts4800_ic_remove()
   - Disposing all IRQ mappings before domain removal to prevent resource
     leaks

Fixes: d01f8633d52e ("irqchip/ts4800: Add TS-4800 interrupt controller")
Signed-off-by: Qingshuang Fu <fuqingshuang@kylinos.cn>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260623015211.109382-1-fffsqian@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-ts4800.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/irqchip/irq-ts4800.c b/drivers/irqchip/irq-ts4800.c
index b2d61d4f6fe6f0..c218c588f37a90 100644
--- a/drivers/irqchip/irq-ts4800.c
+++ b/drivers/irqchip/irq-ts4800.c
@@ -28,6 +28,7 @@ struct ts4800_irq_data {
 	void __iomem            *base;
 	struct platform_device	*pdev;
 	struct irq_domain       *domain;
+	unsigned int            parent_irq;
 };
 
 static void ts4800_irq_mask(struct irq_data *d)
@@ -134,6 +135,7 @@ static int ts4800_ic_probe(struct platform_device *pdev)
 	irq_set_chained_handler_and_data(parent_irq,
 					 ts4800_ic_chained_handle_irq, data);
 
+	data->parent_irq = parent_irq;
 	platform_set_drvdata(pdev, data);
 
 	return 0;
@@ -142,6 +144,14 @@ static int ts4800_ic_probe(struct platform_device *pdev)
 static int ts4800_ic_remove(struct platform_device *pdev)
 {
 	struct ts4800_irq_data *data = platform_get_drvdata(pdev);
+	unsigned int hwirq;
+
+	irq_set_chained_handler_and_data(data->parent_irq, NULL, NULL);
+
+	for (hwirq = 0; hwirq < 8; hwirq++)
+		irq_dispose_mapping(irq_find_mapping(data->domain, hwirq));
+
+	irq_dispose_mapping(data->parent_irq);
 
 	irq_domain_remove(data->domain);
 
-- 
2.53.0



