Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3264569317;
	Wed, 21 Feb 2024 14:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524935; cv=none; b=e5qvft6aGRVbzMztlpFpkRtbfFjiZp5hDyxPzuizHPGhidIy+w/6vsg73WGFAwFXSROr4VxAvwrjsaVP0+vOrha5wOg0PZYU8fY9Z8Nr/90+a3vZLWJnC2VOX2dAwWy1/JwcrCkpKLJNEGJydm+3DxuePHaECj4IIk3uSJdeHbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524935; c=relaxed/simple;
	bh=cafeoqCBnSBK5g4FUTP4UoWOjtBoGUf89kcnJmc+sRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AjClTXiuZQsCxv2S0+pTpmHMveOocNtJQGIf+DOMg6D2pw5RT+hmGeepTz7Az7yDDZdG1zp9/EefB/c8s4j5LHrjwL0xZYOSXg5fzAmFcJf4DUW/7kxFQDW+OvtQ/4NFth3V8qlViKLB+F7FTsYxhJ79YIrsyFJ8ALHz3+vFw3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=02DnsUmo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="02DnsUmo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9374DC43390;
	Wed, 21 Feb 2024 14:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524935;
	bh=cafeoqCBnSBK5g4FUTP4UoWOjtBoGUf89kcnJmc+sRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=02DnsUmo8o/16AUdrkTwR+XkCdlXNKHdTyvpSl0Sq1KpkiHBwkc9oQeAcoh3ckQvK
	 9gszg/DXTPkcKouzdbozi+nYmOFHnKEGsNZtDonoSL1J7trKuXXUGvzpalTd6hrl5h
	 idHZzDJ3zts28ybOrcr4Ip+KGAg8JVIhKfCKutDU=
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
Subject: [PATCH 5.4 001/267] PCI: mediatek: Clear interrupt status before dispatching handler
Date: Wed, 21 Feb 2024 14:05:42 +0100
Message-ID: <20240221125940.106713023@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 728a59655825..ff22bca818f3 100644
--- a/drivers/pci/controller/pcie-mediatek.c
+++ b/drivers/pci/controller/pcie-mediatek.c
@@ -623,14 +623,20 @@ static void mtk_pcie_intr_handler(struct irq_desc *desc)
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



