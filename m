Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1251974E3;
	Thu,  6 Jun 2024 14:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682905; cv=none; b=qjaT1sbCDWm35BzSyVk7N01FSh+RfvOlV0Ktbz1/rP5XIiQqJjyQfCsLiM+Zecg9nbXmnKjca/Vl8O+7j9iduJA5CL9hjFn38V2WjaihzgXw6pf++b0cfO1ENCVWpdmedQO0ax2oBdmqxLtQManq2POcyLtEnWbpmokzEQcuF30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682905; c=relaxed/simple;
	bh=pcXR9enSend2pAVxxXDWY66kWn8rAXJwyroFn2yP5aI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fpryrzhEr9Vh/Wl4UDPT6A0jZ9lpmy6Ej36y6fTYV+ufwWleJwnevF21+PNEJiVLrv8dq5I/PiytrtF0qHIQHBfr2t3TSkc1ijgX1ZRaAFBrMP1CemAWy6BUEtcksONn1eYvYjCIwQu3wekpKR9D0tAKvtGv7chW9/YQHMQ7GuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RyN2nFVP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RyN2nFVP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3778C2BD10;
	Thu,  6 Jun 2024 14:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682905;
	bh=pcXR9enSend2pAVxxXDWY66kWn8rAXJwyroFn2yP5aI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RyN2nFVP7tQS8FNfGy75/FnsQpxmTbvrNdrjDfeYoxYzQqI2WIam1Kl9P4+TvDsaA
	 zwBepL6agJ0mylUAVdSFgz8WAEmo8/ORRc4Db+lNtQ8XQ3kKmm++2U9Cp/Ohb3o12R
	 32p2ELgMDRytIxVnjLTgmEZ4egPu//Qso1h2qQy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vidya Sagar <vidyas@nvidia.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Jon Hunter <jonathanh@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 029/374] PCI: tegra194: Fix probe path for Endpoint mode
Date: Thu,  6 Jun 2024 16:00:08 +0200
Message-ID: <20240606131652.804888332@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 1f7b662cb8e15..e440c09d1dc11 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -2273,11 +2273,14 @@ static int tegra_pcie_dw_probe(struct platform_device *pdev)
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



