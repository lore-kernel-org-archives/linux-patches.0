Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A791EF0AE;
	Tue,  3 Dec 2024 15:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239220; cv=none; b=kBtRBimr6MqxzJztbXwXy8T3XAWPFPsaKfBEeRAkAmc/QMRWseY50Igod+0ye5KPQcWZjaMmDofThXfGjfKclPkVdobttZCzQu7RxHGgzFXyFnme/xq4kELxKLQwDOV6PFK+SddGSRXCLUT3WyrvwVJ82wk6ILTprebHSY9cbOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239220; c=relaxed/simple;
	bh=PXOeIDuYYdF9uPU3GkcNesXCS6Hkulemfhwn917n8Xo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OYHHs/XVBkF6l+HzpZkhVHqiMhYrO3LfXK6uY3QaS5tSdE15l60GYq/Qlu4/gt6bVvhUg3zIgzll8GBYUabRdIoAg0pfJ4BGdainIijD+nEZHkjU09QQ1YZO6Q3WR0Bztk0j7T27jQQfCvlTdQEsdEeUda6oUIwhCZejhuK+KZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lh8jBGol; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lh8jBGol"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD1C5C4CECF;
	Tue,  3 Dec 2024 15:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239220;
	bh=PXOeIDuYYdF9uPU3GkcNesXCS6Hkulemfhwn917n8Xo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lh8jBGolwfTJPM/+471pgW/Tdz7fNBZga3/ap3BO/Cv7XCBsG15TKftESF/MCxy4j
	 KBeSxYS8Likp2DUSWB8j6KLCPz8HQQPpBwXbP6jcvONmVhPno23F+X1pnVVeOy0xSu
	 CgovoujSjJjii5mhs0Eg4RhQTPSCyBPAq/gJrb24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <quic_zhonhan@quicinc.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 539/817] PCI: endpoint: epf-mhi: Avoid NULL dereference if DT lacks mmio
Date: Tue,  3 Dec 2024 15:41:51 +0100
Message-ID: <20241203144016.944104735@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



