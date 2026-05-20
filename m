Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A25EC3F8704;
	Wed, 20 May 2026 18:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300568; cv=none; b=pHtFIeRJhLy22acQ0sE8JWMtPKw7hUAfd1SrrXwY9SYUK3eBUN7mcwNzcQSlzXVbDk72kTObSvZcwb4Sp1i9HNAlK+CwmsueBMQEz/rsG3KZJlqWVbx5n6w/9uVrfOdRxSmI55hmG32zYLO452huDRSF/rgDpP+Hb1cKa8h58I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300568; c=relaxed/simple;
	bh=h36Vc7M7K2LE1scU816rBUQGKfz488TdZ2R1N55052M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WMRJCHlFhvZ56p756qpisokx3afsD3bPw6WqyrOIZJHcgY/Z8+m7px7TMBClGffi+DwQEjjgwQi7vaWQeuOtMYl0UEGyxu11nd93PJOEeXqFXuT00cHAMo1XFe5ljlQDmZv2FEXf1UeWkMAt4UN8nA3VZUAMb3U5cADUJ/L/I1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oNaiUqmL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oNaiUqmL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F02B1F000E9;
	Wed, 20 May 2026 18:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300567;
	bh=nXc/MD2xuTF8LXQMGXTB47pGSAdMR8cjPHRpf9s45Ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oNaiUqmLr/pgtrkLZpIlhEpkESMu2mCACi6IQRmdWK2T+6hm1g3vgI4XEsSG/fnhS
	 wuFcfQqrcv+U4VcY8UKbaYNKNG4N6o/7x6x8LUsw8nqwLWxX1jbO99HKOUR+lMA+30
	 IKj80wfGbaHF/QE2fU9Sgs0x0KjYNYPwdBcTZWN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 225/666] PCI: mediatek-gen3: Prevent leaking IRQ domains when IRQ not found
Date: Wed, 20 May 2026 18:17:16 +0200
Message-ID: <20260520162116.090598378@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 5573c44cb3fd01a9f62d569ae9ac870ef5f0e0ba ]

In mtk_pcie_setup_irq(), the IRQ domains are allocated before the
controller's IRQ is fetched. If the latter fails, the function
directly returns an error, without cleaning up the allocated domains.

Hence, reverse the order so that the IRQ domains are allocated after the
controller's IRQ is found.

This was flagged by Sashiko during a review of "[PATCH v6 0/7] PCI:
mediatek-gen3: add power control support".

Fixes: 814cceebba9b ("PCI: mediatek-gen3: Add INTx support")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://sashiko.dev/#/patchset/20260324052002.4072430-1-wenst%40chromium.org
Link: https://patch.msgid.link/20260324093542.18523-1-wenst@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-mediatek-gen3.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/controller/pcie-mediatek-gen3.c b/drivers/pci/controller/pcie-mediatek-gen3.c
index 66ce4b5d309bb..b373ece9542c4 100644
--- a/drivers/pci/controller/pcie-mediatek-gen3.c
+++ b/drivers/pci/controller/pcie-mediatek-gen3.c
@@ -794,14 +794,14 @@ static int mtk_pcie_setup_irq(struct mtk_gen3_pcie *pcie)
 	struct platform_device *pdev = to_platform_device(dev);
 	int err;
 
-	err = mtk_pcie_init_irq_domains(pcie);
-	if (err)
-		return err;
-
 	pcie->irq = platform_get_irq(pdev, 0);
 	if (pcie->irq < 0)
 		return pcie->irq;
 
+	err = mtk_pcie_init_irq_domains(pcie);
+	if (err)
+		return err;
+
 	irq_set_chained_handler_and_data(pcie->irq, mtk_pcie_irq_handler, pcie);
 
 	return 0;
-- 
2.53.0



