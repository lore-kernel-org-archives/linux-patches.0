Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE0A14A088;
	Tue,  3 Dec 2024 16:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241810; cv=none; b=UpV2lfsb1HQBtzRn+KswmNd9O+0GPDTtZB1ZjJ3fKnvWGODsW5I5cNkFrtd0Z2TdBVm2RC9xPNJnHHAXo2Ii5ZTZshetwHHEW/Ka+ndvBs1gD+KVNyurXyvVa758j9zXgNCg1V9FEbwmaPsNeoimHdWp9S9nfqF2RubwCIH5SSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241810; c=relaxed/simple;
	bh=Id9aPw737/wrRWqS39KeRQ6Me5yHvz29Bf+o3RcDgJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=REb6GVM1Ra3yQM45RY+OgzPhe7byv1r+kt9uY4S0fLmCs8dbG8tXS8gTw7OIXz3ZDsneV3j6Hk3eNZbehn9+nXx+AHyUHLqH0PQ25G9vooASF5b/J36gn/6+O4x84sZpN8IzzLZLOfWEk76EEn1Gz71TDJk9EGhEv+jZqccyeRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jJZtaMUp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jJZtaMUp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E04BC4CECF;
	Tue,  3 Dec 2024 16:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241810;
	bh=Id9aPw737/wrRWqS39KeRQ6Me5yHvz29Bf+o3RcDgJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jJZtaMUpsJ3mUmVHbx7ZTcjQ1x1c7XmpqXli0G/1Ta+aDGcga+iq5xbdkQsozqho0
	 9k9ri+TRmAEKugbkEKiLYBYFWXHx+lOLWv9ymxJVP0Cw/ur8cZEmyqU+Y5TUTugL6n
	 Wewj0CvkqLEIbelZdUqAhv6lLV4pW51z4DiGfGDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <quic_zhonhan@quicinc.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 524/826] PCI: endpoint: epf-mhi: Avoid NULL dereference if DT lacks mmio
Date: Tue,  3 Dec 2024 15:44:11 +0100
Message-ID: <20241203144804.199543251@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7d070b1def116..54286a40bdfbf 100644
--- a/drivers/pci/endpoint/functions/pci-epf-mhi.c
+++ b/drivers/pci/endpoint/functions/pci-epf-mhi.c
@@ -867,12 +867,18 @@ static int pci_epf_mhi_bind(struct pci_epf *epf)
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



