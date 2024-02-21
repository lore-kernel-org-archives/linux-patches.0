Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D49E2A1D7;
	Wed, 21 Feb 2024 13:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521048; cv=none; b=FOOiUfh/GiRRcUN3d2JJWFCIg61FKLg80Rv+c/WSUV3UJsxGZSrY4LWVgRTW7sFo2gGDh99Iv7TxYCxDbQMM53ExrXZUgFJZp7hftol0f6sCiWoottwMWEuCE+7ulCp+Rjom4I2oLbGUmWd+6/2ymxNlBYzvcgGDoNCTuNXiYGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521048; c=relaxed/simple;
	bh=ca+KgbvqbiGKCzZ/EHYMN+vJkgjslVsf/7UMipDBxzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AM7k/C/VBN6hBiAfH7+CIbXLirmjvLOI6Yi2dtTnBPQ1HxuVw+oFQAtaB8NqtDNyyAseA/cDqcz4IetQGj6z9XyLUNB9EkzMg6gi8MPLPWbQWWblvS4AaBMm0IHcHSvgTAQR881ccjBGQLKiKc8iQR0JMhZixQkObRn8d6/PuCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bNbNlFRP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bNbNlFRP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5843CC433C7;
	Wed, 21 Feb 2024 13:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521047;
	bh=ca+KgbvqbiGKCzZ/EHYMN+vJkgjslVsf/7UMipDBxzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bNbNlFRP+Ng/O5tTZHEkyT7AvkZutkWYChldA5WAajX+y0QygQBf821sxS2LYbYTx
	 jEMSXtWXZhtbIkL9xe6aWjBlDxigGXTGcrNGx3yTGcXny4Rsme8H8g1AVUZQgSSsMy
	 H4o/nFatxfgFWcWBeP4J2p211uSGtmFko6vCoOvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	qizhong cheng <qizhong.cheng@mediatek.com>,
	Jianjun Wang <jianjun.wang@mediatek.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 001/202] PCI: mediatek: Clear interrupt status before dispatching handler
Date: Wed, 21 Feb 2024 14:05:02 +0100
Message-ID: <20240221125931.790603468@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: qizhong cheng <qizhong.cheng@mediatek.com>

[ Upstream commit 4e11c29873a8a296a20f99b3e03095e65ebf897d ]

We found a failure when using the iperf tool during WiFi performance
testing, where some MSIs were received while clearing the interrupt
status, and these MSIs cannot be serviced.

The interrupt status can be cleared even if the MSI status remains pending.
As such, given the edge-triggered interrupt type, its status should be
cleared before being dispatched to the handler of the underling device.

[kwilczynski: commit log, code comment wording]
Link: https://lore.kernel.org/linux-pci/20231211094923.31967-1-jianjun.wang@mediatek.com
Fixes: 43e6409db64d ("PCI: mediatek: Add MSI support for MT2712 and MT7622")
Signed-off-by: qizhong cheng <qizhong.cheng@mediatek.com>
Signed-off-by: Jianjun Wang <jianjun.wang@mediatek.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
[bhelgaas: rewrap comment]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc:  <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-mediatek.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/pcie-mediatek.c b/drivers/pci/controller/pcie-mediatek.c
index 066e9e00de11..0d5be37660aa 100644
--- a/drivers/pci/controller/pcie-mediatek.c
+++ b/drivers/pci/controller/pcie-mediatek.c
@@ -605,14 +605,20 @@ static void mtk_pcie_intr_handler(struct irq_desc *desc)
 		if (status & MSI_STATUS){
 			unsigned long imsi_status;
 
+			/*
+			 * The interrupt status can be cleared even if the
+			 * MSI status remains pending. As such, given the
+			 * edge-triggered interrupt type, its status should
+			 * be cleared before being dispatched to the
+			 * handler of the underlying device.
+			 */
+			writel(MSI_STATUS, port->base + PCIE_INT_STATUS);
 			while ((imsi_status = readl(port->base + PCIE_IMSI_STATUS))) {
 				for_each_set_bit(bit, &imsi_status, MTK_MSI_IRQS_NUM) {
 					virq = irq_find_mapping(port->inner_domain, bit);
 					generic_handle_irq(virq);
 				}
 			}
-			/* Clear MSI interrupt status */
-			writel(MSI_STATUS, port->base + PCIE_INT_STATUS);
 		}
 	}
 
-- 
2.43.0



