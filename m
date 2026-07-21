Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3AAF44CADF;
	Tue, 21 Jul 2026 18:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660281; cv=none; b=YNvcpJluOV5lRjodYMFPwZ9JzucFNujWeNMDCvMAdGd5FvULsPwlrbBx1xmLP8J4KVpUBvRYslFvS+0OBxBj21L0bPYdTOe7Fk8ehC4v67pFdCZdLQ7Olv0O/weWJVrvPXRiDePW0kDvzwIrdTbmYv7HbrmT/JWfbnqnxmo8a2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660281; c=relaxed/simple;
	bh=N7GUzp3a9bQDROoVoHylIMSf3zPuvvQNp6TOukYA2zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cyO2tgiiuZ0u52a4i+IALjyH9dJ9o3QcM7fYkoqAkdjhDmMwDvxmePA5Ar1IH/dxBpc7L5dxq/35f0f8yyB+oecV4svpIhjlPyrHmxWXJDIPW8WNVXsrpysH+IwCvxLG6BkDaYMomsssnqwgZ9pyKP4MKBsYCZiy2KpUipuWoko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nSIbzpXA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nSIbzpXA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 811281F00A3A;
	Tue, 21 Jul 2026 18:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660277;
	bh=hhtFSbmzK8+nual4UbqOiObeLCN8QUG3u4jjGaiZyCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nSIbzpXAAwer55U1B0UN5ttLoqvr8ERN9VCNGA9vIJmSOYLfnlv0hEdtqyEoo8y8X
	 wPZPz/PdxWZPt/iHVaHaQYNQom0EVubDSKNttF3O0gVpFsZDk45qTbrbFVWzsXzNUo
	 O558uFnB8HzWykR/1zHMd2r6c8C5c4psFE9hJ5+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0876/2077] PCI: mediatek-gen3: Do full device power down on removal
Date: Tue, 21 Jul 2026 17:09:09 +0200
Message-ID: <20260721152613.455767486@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit d39d55d7411c18ca6aeb63aafa8035f4ad8b317f ]

When power control for downstream devices was introduced in the
mediatek-gen3 PCIe controller driver, only the power to the downstream
devices was cut when the controller driver is removed. This matched
existing behavior, but in hindsight a proper power down sequence should
have been followed.

Call mtk_pcie_devices_power_down() on driver removal so that in addition
to removing power from the downstream devices, PERST# is asserted.

Fixes: 1a152e21940a ("PCI: mediatek-gen3: Integrate new pwrctrl API")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260505105918.1823170-1-wenst@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-mediatek-gen3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pcie-mediatek-gen3.c b/drivers/pci/controller/pcie-mediatek-gen3.c
index b0accd82858921..e6acca7e79a0ff 100644
--- a/drivers/pci/controller/pcie-mediatek-gen3.c
+++ b/drivers/pci/controller/pcie-mediatek-gen3.c
@@ -1260,7 +1260,7 @@ static void mtk_pcie_remove(struct platform_device *pdev)
 	pci_remove_root_bus(host->bus);
 	pci_unlock_rescan_remove();
 
-	pci_pwrctrl_power_off_devices(pcie->dev);
+	mtk_pcie_devices_power_down(pcie);
 	mtk_pcie_power_down(pcie);
 	pci_pwrctrl_destroy_devices(pcie->dev);
 	mtk_pcie_irq_teardown(pcie);
-- 
2.53.0



