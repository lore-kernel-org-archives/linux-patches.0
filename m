Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D6115DBA3;
	Wed,  5 Feb 2025 15:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768070; cv=none; b=uH/s+ogxH77adbZYPPiSC6cfzywWRvo809tV3bi0cwwT2iM4UgjsMSc/Ti9Qp6YKRWy/r8/FkrwXx5On5UBQufEv7XBAP4jjwQGPzGfdlN98lrQLMaUdH/EOVpy3eODUPdd224ve7f5cfVRQbx+AXsQ+2sBrTWxiPKjzv22y7Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768070; c=relaxed/simple;
	bh=Cwp5wz4qoNoSDqNdvFFAs8YOKRwnhf8Eg9NDFjfSBZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SbAvuODVkVgg2Lf+MN1kC0XhgCKR6lJVYBqCsLc3iczRwCB2YTF7T9YU+OyViFroNHDyd4hXa/wIGLlXXMUMJKfqtMZTsV03ysVJ60DY6VH6RaYJffiFt8EpvCaeM8/fvPNDdw1V/Xu5JYce+C3B6JnwL2miQHn1JWh0TBDP67U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=US5YJ32m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="US5YJ32m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F50EC4CED1;
	Wed,  5 Feb 2025 15:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768070;
	bh=Cwp5wz4qoNoSDqNdvFFAs8YOKRwnhf8Eg9NDFjfSBZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=US5YJ32mUU7kpZGTcUJwyGeg+ZL5T2bC7QTdxNyfyHY+b6Qj1WnNjXHyERso4yC5h
	 7Q46W/uENML5Yt6ckBEx3Eaysgw+6+Ka/2zUHpbwAEX8DMha0136EkcfMUE+vI6mpM
	 jDtaCAtbp9J6ZY7z9Rfccu5nRozmb1QzMNs2/MDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Zhu <hongxing.zhu@nxp.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 469/623] PCI: dwc: Always stop link in the dw_pcie_suspend_noirq
Date: Wed,  5 Feb 2025 14:43:31 +0100
Message-ID: <20250205134514.161728268@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index d2291c3ceb8be..cf146ff6a3ea8 100644
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



