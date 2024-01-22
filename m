Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2BD56B89;
	Tue, 23 Jan 2024 00:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969820; cv=none; b=Af7zkkfHKn1ksdlcFvDFGfz8F/P4UORU8AFn2KxNY98p0Xwwe+QR5sHjNYykfOrcQYfxm6iVn7aDGN1OzosJ+0NxBeeiHbBUGg264Yp6qSJSyO2dvTYfGm0RAKr6bui5eAFgLqzFYo5+XLVSfwcZ6e7WZjts+tlbbMC/EQvhV98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969820; c=relaxed/simple;
	bh=1SEVr7f/RSdTjRGXfoIbZnxJ5O/cY70vZ1NMe4t/ZFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fKdLtlp4gbWksG4LvKF8dnkRjzMKXcy26zpLv633jXGYSnExZaVsbl4SYvrpwo2DtwGr+EH8B6HD6qT4VctBcEz5sM+EmKdz8oeURwtgnwrOcBLySPTNrzmn+MpPBJuOimVUOXnANMIEtHF9CjhmHVzt1aH3xTufSBHYF1Qc7EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SgeEJzVt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SgeEJzVt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0794AC433C7;
	Tue, 23 Jan 2024 00:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969820;
	bh=1SEVr7f/RSdTjRGXfoIbZnxJ5O/cY70vZ1NMe4t/ZFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SgeEJzVtnUjIlATosc2umUr5JJpQsesnm6J6kqVA3b/4OCo4xWGpU6U3YEv0Vm/tT
	 mbGhfBGgUliJJvWnEg4LsfZXEB7aMpzk3oU+NXiMt05lQaxXWQmzNqEkCt6/PbNDL7
	 L1F26+wdjCsUJEc0COtWm2Zdl0U+tQ+QQM81Gvyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	qizhong cheng <qizhong.cheng@mediatek.com>,
	Jianjun Wang <jianjun.wang@mediatek.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: [PATCH 6.7 469/641] PCI: mediatek: Clear interrupt status before dispatching handler
Date: Mon, 22 Jan 2024 15:56:13 -0800
Message-ID: <20240122235832.716889199@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
 


