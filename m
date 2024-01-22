Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A36133436;
	Tue, 23 Jan 2024 01:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971863; cv=none; b=Wb+42dyBrlTIZog7KWtET1BTWlDsv4WSsiCKjHU7tXsv9mnCHC0A42VpsknUEuzBYQ044oZq1dmwQ5gZQiueUEcmYlu/O4RV4HkFoVB5BPsaTKIhdy+R5NpiMvIOgKslmWjzMlk3NDSA9Xly4fxS8n6FsF6IopgEcigY6TnRhrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971863; c=relaxed/simple;
	bh=qs1u4sCvdBWlOsdUkribOUGIRJBOn9N3MARPjEx7ArA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JthZs9ihjXK/SIIWgX6U8pbkA3xXP2/4sYNDPYOshKM//nVmxDqWbpii9Kzy51fWUR+6AHUyH6DlT0dwk5pUfVTBoH1L+Jy4w7m/E5R0m4BJy8g09pHStLV/DDCsalaIs7DUszwB72ppvqzrxIC7aUUer0XNfzOsARVf6HczUo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PPwdGPVC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PPwdGPVC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 477C1C433C7;
	Tue, 23 Jan 2024 01:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971863;
	bh=qs1u4sCvdBWlOsdUkribOUGIRJBOn9N3MARPjEx7ArA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PPwdGPVCkLnre5Wmpow9RgK8NEvfDbBAiH1wccjSuhm6YKFoyfEDaHjPkFRsVYy7p
	 4giihaErum7ebG8ChWsnmg/UynRbNnKnwk1oNCXnB/Gh/B9iJKKexYlqL9Zrp7MEnA
	 ADLvPSbYDfuVx00gINMEoB0+Ejzxf8ZdvzctJry4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	qizhong cheng <qizhong.cheng@mediatek.com>,
	Jianjun Wang <jianjun.wang@mediatek.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: [PATCH 6.1 315/417] PCI: mediatek: Clear interrupt status before dispatching handler
Date: Mon, 22 Jan 2024 15:58:03 -0800
Message-ID: <20240122235802.727411608@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: qizhong cheng <qizhong.cheng@mediatek.com>

commit 4e11c29873a8a296a20f99b3e03095e65ebf897d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pcie-mediatek.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/pci/controller/pcie-mediatek.c
+++ b/drivers/pci/controller/pcie-mediatek.c
@@ -617,12 +617,18 @@ static void mtk_pcie_intr_handler(struct
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
 				for_each_set_bit(bit, &imsi_status, MTK_MSI_IRQS_NUM)
 					generic_handle_domain_irq(port->inner_domain, bit);
 			}
-			/* Clear MSI interrupt status */
-			writel(MSI_STATUS, port->base + PCIE_INT_STATUS);
 		}
 	}
 


