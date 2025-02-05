Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE6833993;
	Wed,  5 Feb 2025 14:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767255; cv=none; b=LbmiEIX7GEWgZ/gGZ9htvoXn8iaUL3koPT5r8UaC5ldkBraAhu5iGL9+t2HWqT1G3vwoabzlvoUu4yXe6o09eewvvUGhBULoiBQy2t9rlt56p/rvzUDd7JSkbSPR9371ya7gK7RmNWmZaY4eHQKsJGroCw7hctIk2Ku1Gp+6C3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767255; c=relaxed/simple;
	bh=tp8/uE9aD5ZQkTmDypwnz/TsG+5K4L5SMSH2cThoH2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rfFbZ7FrK/CZ2M5KfRdvkUBA/DIWKMypPJakf52WEbMUoY0t3lrnFwTtn45D7cMW7TeNX0wqyHCncT5czMmEcspomXjfnV3HLJKTKBCm+qu6oX5gvNeOUzFNYDZvkGvSF7Fx2wQBFJRLdWTH2gE2mgmoluTTza+gNZXuw5BE37c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZKI6H4ZB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZKI6H4ZB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6481C4CEDD;
	Wed,  5 Feb 2025 14:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767255;
	bh=tp8/uE9aD5ZQkTmDypwnz/TsG+5K4L5SMSH2cThoH2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZKI6H4ZB3NsYwpZyQ4P2BfnbzMcZMkQ4+Hlc1pf7RlD8WVAPVQDYNYM+CITcqSHyn
	 npyFBqPYSISVhNi1HhNVKy2iZEE89LstlUe82QPAnlW9rowXVUYlxuO+ENy6ZzN6Kw
	 foawsv37cb23DVpgybrboYygq3zMOiUWMW89kC64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Zhu <hongxing.zhu@nxp.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 430/590] PCI: dwc: Always stop link in the dw_pcie_suspend_noirq
Date: Wed,  5 Feb 2025 14:43:05 +0100
Message-ID: <20250205134511.717150674@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Richard Zhu <hongxing.zhu@nxp.com>

[ Upstream commit 86a016e278b78cc2281edd4ffaddbc011c87a593 ]

On the i.MX8QM, PCIe link can't be re-established again in
dw_pcie_resume_noirq(), if the LTSSM_EN bit is not cleared
properly in dw_pcie_suspend_noirq().

So, add dw_pcie_stop_link() to dw_pcie_suspend_noirq() to fix
this issue and to align the suspend/resume functions since there
is dw_pcie_start_link() in dw_pcie_resume_noirq() already.

Fixes: 4774faf854f5 ("PCI: dwc: Implement generic suspend/resume functionality")
Link: https://lore.kernel.org/r/20241210081557.163555-2-hongxing.zhu@nxp.com
Signed-off-by: Richard Zhu <hongxing.zhu@nxp.com>
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware-host.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/controller/dwc/pcie-designware-host.c b/drivers/pci/controller/dwc/pcie-designware-host.c
index 3e41865c72904..120e2aca5164a 100644
--- a/drivers/pci/controller/dwc/pcie-designware-host.c
+++ b/drivers/pci/controller/dwc/pcie-designware-host.c
@@ -946,6 +946,7 @@ int dw_pcie_suspend_noirq(struct dw_pcie *pci)
 		return ret;
 	}
 
+	dw_pcie_stop_link(pci);
 	if (pci->pp.ops->deinit)
 		pci->pp.ops->deinit(&pci->pp);
 
-- 
2.39.5



