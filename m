Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F5613B797;
	Tue, 27 Feb 2024 14:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043829; cv=none; b=BH4spBhrq2xov6Lxeck2yfNep5hFRTJaYt0grbOLOaeYjyWs7HQNRJxuBvL4iB3/JVIgRv80d1gnrNXBKQ9lJ62aQCzZyn7Wmo1ldLX0AeB6nZzngOsrgtTFAOVmMkKR6zlYbP3OKswS9R5CKo9mnB3UPC7UUfoSYATJVMIEIOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043829; c=relaxed/simple;
	bh=VGn0Cmmgi/Of0k9os7/a6mxzeHNe42X0Kjz2lm+JMag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LfNh0UF3ZdOoC+X6BK52bvMbUxUZ2K6wBHVUNIRwW0Jn3cL30fobHGkfWqZrqvOv9wgEaoJKrlvPivBxNzdcbVexU9sggJh9R78AkI6EdnrNit2w0bOPPHEevXkTsWv0S5PvV3R+h2eNwlzL9Xx6/E8Rbo/dKmBSIt8ErOZSTUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gst6eXwg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gst6eXwg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41A15C433F1;
	Tue, 27 Feb 2024 14:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043829;
	bh=VGn0Cmmgi/Of0k9os7/a6mxzeHNe42X0Kjz2lm+JMag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gst6eXwg3ZSK7T9+1YQ0WSNxbYAycHu8zr9eNvPVoLNsxLwfCBPzmYIPcbkDUXe11
	 HQwEpPiNHOs6OwhIdg3EL/zIvk01nlEkuF5dIY35FiH1Gkh3+B6BbLVvyJyJcbE4PL
	 kBvp7DA9WT34h/yB4SaGcAFlpf4bcJ5Jw6gXNC04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
	Vidya Sagar <vidyas@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 52/84] PCI: tegra: Fix OF node reference leak
Date: Tue, 27 Feb 2024 14:27:19 +0100
Message-ID: <20240227131554.565312915@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131552.864701583@linuxfoundation.org>
References: <20240227131552.864701583@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit eff21f5da308265678e7e59821795e606f3e560f ]

Commit 9e38e690ace3 ("PCI: tegra: Fix OF node reference leak") has fixed
some node reference leaks in this function but missed some of them.

In fact, having 'port' referenced in the 'rp' structure is not enough to
prevent the leak, until 'rp' is actually added in the 'pcie->ports' list.

Add the missing 'goto err_node_put' accordingly.

Link: https://lore.kernel.org/r/55b11e9a7fa2987fbc0869d68ae59888954d65e2.1620148539.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Vidya Sagar <vidyas@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-tegra.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/controller/pci-tegra.c b/drivers/pci/controller/pci-tegra.c
index 64921c63874fa..74c0ddd433815 100644
--- a/drivers/pci/controller/pci-tegra.c
+++ b/drivers/pci/controller/pci-tegra.c
@@ -2267,13 +2267,15 @@ static int tegra_pcie_parse_dt(struct tegra_pcie *pcie)
 		rp->np = port;
 
 		rp->base = devm_pci_remap_cfg_resource(dev, &rp->regs);
-		if (IS_ERR(rp->base))
-			return PTR_ERR(rp->base);
+		if (IS_ERR(rp->base)) {
+			err = PTR_ERR(rp->base);
+			goto err_node_put;
+		}
 
 		label = devm_kasprintf(dev, GFP_KERNEL, "pex-reset-%u", index);
 		if (!label) {
-			dev_err(dev, "failed to create reset GPIO label\n");
-			return -ENOMEM;
+			err = -ENOMEM;
+			goto err_node_put;
 		}
 
 		/*
@@ -2291,7 +2293,8 @@ static int tegra_pcie_parse_dt(struct tegra_pcie *pcie)
 			} else {
 				dev_err(dev, "failed to get reset GPIO: %ld\n",
 					PTR_ERR(rp->reset_gpio));
-				return PTR_ERR(rp->reset_gpio);
+				err = PTR_ERR(rp->reset_gpio);
+				goto err_node_put;
 			}
 		}
 
-- 
2.43.0



