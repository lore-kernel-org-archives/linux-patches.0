Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5B61DFE1;
	Thu, 13 Jun 2024 12:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282273; cv=none; b=r1R328gd4zJBSLxsvV4HmZhdLt4XR57R/v3Gc3YWamfTj/p16hyEAtBlDDdHbiVxh/IVRxZDdJAg7QfJVJVLjkWO3QCQLJsHdn5dkMAjQvtBreZYNnpne5QN65vWnVJd5UVSg9Sn7Jp1oj+sLCtzS78LdqcePlU1vSeWFTN2Hwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282273; c=relaxed/simple;
	bh=cp9nyixji9q9qA7Ld9YccHCBQZeb6XI7t01myyGrGBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VxQ+90BdBmRPQtp5TJ1bRPXX3xviXF0XUNGw7A/YwtEr1Xr9kqvLQq2KXO4s0XaND6rDntzM3dfrLYq8V6uHVGyTO5NPgg6ioxj6KiOeieB5d1mw0X96NtCjLuf21K7KkeHcWuZA6sVQj8kw8I6se/Iz1BWbCqDoOOm493Xg8uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sAyzjc/n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sAyzjc/n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E447C2BBFC;
	Thu, 13 Jun 2024 12:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282273;
	bh=cp9nyixji9q9qA7Ld9YccHCBQZeb6XI7t01myyGrGBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sAyzjc/nNpSmNXZoBboaRKsgINg0FLAMt7rXgC28HJ8e+uoW0uA+4Q98QKICOKaSE
	 UspZ8mT2ckmAOyrD4h9QMTEuNA8jaC+CkG73zcYgtcHcMT6/yDxjwu7iS5FGutu7KJ
	 D8KXsju0ELGvCQtH+jMS0qrkWsZh5NNP589T+IgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vidya Sagar <vidyas@nvidia.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Jon Hunter <jonathanh@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 190/402] PCI: tegra194: Fix probe path for Endpoint mode
Date: Thu, 13 Jun 2024 13:32:27 +0200
Message-ID: <20240613113309.556718951@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2f82da76e3711..3703ea0d90c28 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -2142,10 +2142,13 @@ static int tegra_pcie_dw_probe(struct platform_device *pdev)
 		ret = tegra_pcie_config_ep(pcie, pdev);
 		if (ret < 0)
 			goto fail;
+		else
+			return 0;
 		break;
 
 	default:
 		dev_err(dev, "Invalid PCIe device type %d\n", pcie->mode);
+		ret = -EINVAL;
 	}
 
 fail:
-- 
2.43.0



