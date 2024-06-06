Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5415C1B29CF;
	Thu,  6 Jun 2024 14:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683411; cv=none; b=l4IvboxqVWJrCxr9ztGnokti3rdf002pEN1gWKeB6lj3plkuhCLYoS1aB8GT9AWzuJKSpcU0QdmfRiZsSC1H414NdUdcenqfkx9ron2lGCIfACuE2wlq70RfDXhGOlLNZRoCepNEgRP+jX/A+bTMwxF4LLuZ2h8qsNve2eRNy8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683411; c=relaxed/simple;
	bh=30zUgdENfmXw7bvscPXFkKFnd/5Yl/nQJGc2UzX91gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mV06YBh9oOO5ezrzACTEwZfD2oeL1/ZVTv0Uf3vQpjC+ZYS3BklJcJIVZYhquv1I7JDGvs2oCIgk8P9P8Pvd4nt5IdWiEzhuo0U6Aiju2ir+Xu2ne5LpPI6XgoHXihXuvPcmid9xBeXbnrdnRyzHNszgjYr54X6SU4PrF4QTDAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tGejTWeS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tGejTWeS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B56FC2BD10;
	Thu,  6 Jun 2024 14:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683411;
	bh=30zUgdENfmXw7bvscPXFkKFnd/5Yl/nQJGc2UzX91gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tGejTWeSpL/CkkjjmhqIqYvOAYu6GHmtTM2PJo594D2xbXYPfdD1rSyMPy1sm3ycs
	 hJijwpq3NyTpdzS14S26gDrFtXM61hg1a/K9jCbOxLmdFHSMMP4zYtw5nyyDQyWGnd
	 BdgPpX+u9njaYsm4Y87S3RJfG9A66WwJjTBYyA8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vidya Sagar <vidyas@nvidia.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Jon Hunter <jonathanh@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 294/473] PCI: tegra194: Fix probe path for Endpoint mode
Date: Thu,  6 Jun 2024 16:03:43 +0200
Message-ID: <20240606131709.598611138@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

From: Vidya Sagar <vidyas@nvidia.com>

[ Upstream commit 19326006a21da26532d982254677c892dae8f29b ]

Tegra194 PCIe probe path is taking failure path in success case for
Endpoint mode. Return success from the switch case instead of going
into the failure path.

Fixes: c57247f940e8 ("PCI: tegra: Add support for PCIe endpoint mode in Tegra194")
Link: https://lore.kernel.org/linux-pci/20240408093053.3948634-1-vidyas@nvidia.com
Signed-off-by: Vidya Sagar <vidyas@nvidia.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-tegra194.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/controller/dwc/pcie-tegra194.c b/drivers/pci/controller/dwc/pcie-tegra194.c
index 5d1ae2706f6ea..0839454fe4994 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -2250,11 +2250,14 @@ static int tegra_pcie_dw_probe(struct platform_device *pdev)
 		ret = tegra_pcie_config_ep(pcie, pdev);
 		if (ret < 0)
 			goto fail;
+		else
+			return 0;
 		break;
 
 	default:
 		dev_err(dev, "Invalid PCIe device type %d\n",
 			pcie->of_data->mode);
+		ret = -EINVAL;
 	}
 
 fail:
-- 
2.43.0



