Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FD31527AC;
	Fri,  6 Dec 2024 15:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497884; cv=none; b=tQ8Wd6JsWjysUKk18oGFWxQY0KiOwcM35C7vPPWy7kp77rRioqglA6fOJJRhvrLpY1ndY142CBhx9dfX6huIyl+WmcfGKe6QBCqV0fGSIH74M7G0ZObimeI7QKbg4zf8arHED0E+0Bm5l1ZOrz0G2B0xE99lyQxFw5p5pjwoTEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497884; c=relaxed/simple;
	bh=kNLEjfPvQH6A8/s0/SZAHDg5OEpNjq+YMecE9AOQ3FM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IzSFzqdwBOuSmiG1Fr7eY1TQqdig7fX5dD0yde274XoCeuFGaV9OvY7RVwjFBbQ+wZux6MYJYJY6Q1ta4mYmqQ9cEP8tkXQYCaDP7C9mhA7pXDTybEKjp45IGHAXXS4w7+KqR3KV/8UPC1AfjmVKF/nFRUyb/MworeAuq3Yc+3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iCMJg2Mf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iCMJg2Mf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E2C0C4CEDC;
	Fri,  6 Dec 2024 15:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497883;
	bh=kNLEjfPvQH6A8/s0/SZAHDg5OEpNjq+YMecE9AOQ3FM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iCMJg2Mfj6LYymb7GtW852CysxeHmddgBdWpTDkBufvngts6FxgqQKypi5e9YJjtW
	 d4WstCO1+Dlmpl3H91k8H4smdVMVaCTo2GTTyyxy3DYZzKj3DlB25tc9HpUS+2RNiD
	 d9Fvwym5uLn6jtz04QfNPkFGXqKtfOOUvr9mp9As=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <quic_zhonhan@quicinc.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 380/676] PCI: endpoint: epf-mhi: Avoid NULL dereference if DT lacks mmio
Date: Fri,  6 Dec 2024 15:33:19 +0100
Message-ID: <20241206143708.190375200@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhongqiu Han <quic_zhonhan@quicinc.com>

[ Upstream commit 5089b3d874e9933d9842e90410d3af1520494757 ]

If platform_get_resource_byname() fails and returns NULL because DT lacks
an 'mmio' property for the MHI endpoint, dereferencing res->start will
cause a NULL pointer access. Add a check to prevent it.

Fixes: 1bf5f25324f7 ("PCI: endpoint: Add PCI Endpoint function driver for MHI bus")
Link: https://lore.kernel.org/r/20241105120735.1240728-1-quic_zhonhan@quicinc.com
Signed-off-by: Zhongqiu Han <quic_zhonhan@quicinc.com>
[kwilczynski: error message update per the review feedback]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-mhi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/pci/endpoint/functions/pci-epf-mhi.c b/drivers/pci/endpoint/functions/pci-epf-mhi.c
index 34e7191f95086..87154992ea11b 100644
--- a/drivers/pci/endpoint/functions/pci-epf-mhi.c
+++ b/drivers/pci/endpoint/functions/pci-epf-mhi.c
@@ -600,12 +600,18 @@ static int pci_epf_mhi_bind(struct pci_epf *epf)
 {
 	struct pci_epf_mhi *epf_mhi = epf_get_drvdata(epf);
 	struct pci_epc *epc = epf->epc;
+	struct device *dev = &epf->dev;
 	struct platform_device *pdev = to_platform_device(epc->dev.parent);
 	struct resource *res;
 	int ret;
 
 	/* Get MMIO base address from Endpoint controller */
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "mmio");
+	if (!res) {
+		dev_err(dev, "Failed to get \"mmio\" resource\n");
+		return -ENODEV;
+	}
+
 	epf_mhi->mmio_phys = res->start;
 	epf_mhi->mmio_size = resource_size(res);
 
-- 
2.43.0



