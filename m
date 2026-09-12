Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82836429802;
	Sat, 12 Sep 2026 10:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208531; cv=none; b=njqbUIweudqXt4JTV7zvlMDe1sNS7ki60M6bxQ63PZ089KH8Qoe+CFXg4zF7gFjC3Z6NvmZZI2/yl8wnuDKCaP9Mc2vC4b8oILc1+ZbAsbVBOrLTpCb9/vgLPepG0MCFxTkMbhc6OP7tKtBYFLm5Id3pqBvceZ3RPWzz9vp4WBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208531; c=relaxed/simple;
	bh=pNHL4E8bnWIOfZDE66l7PHImvw7Z2ezXsTcSUqKo6YY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pQZDs1xyR/mIcIpNx0xrNJ7Dg51e1WpX65AKlJ2wSIm5CnIUZPwSx/514K8HzA4VZkQ/1lf+dj7X+cSyVA6VuvQZsQtKUQUw0JRg/X8gzpVTZxXrFWpJfd4wQe/SccnDV3dnJ48U7VpTzokOxSkyR2lV64yFQ2M9dLF28sDb+4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e99zPFdC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e99zPFdC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6DE71F00899;
	Sat, 12 Sep 2026 10:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208524;
	bh=uVw+zcc+kZdtiyvY3v0cDb9azx3bb175kXot0xgDmwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e99zPFdCpJEpLhobZA/ZutwTm/ZqLjQ2WFFYd3uRgqh3AMdc64a7Hup85gm+tk+FA
	 xcJiuoeXj0WI9KWKoXosU07fOjQW/q5OeyBfDv4I4SfRo9xXHjgwjMqW+txAIsYgHw
	 ulKoFSFOf43PNMe1cBJ6M06hQ2S9dlAqsLLBKsQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Tariq <alitariq45892@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0634/1518] PCI: starfive: Fix Runtime PM handling and teardown ordering
Date: Sat, 12 Sep 2026 08:46:43 +0200
Message-ID: <20260912065637.774293474@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ali Tariq <alitariq45892@gmail.com>

[ Upstream commit fb9f7973473fc30d62e0f5f90d59df8ef5223777 ]

The starfive_pcie_remove() path incorrectly disabled runtime PM
before executing plda_pcie_host_deinit(), which can cause unmanaged
hardware register access in plda_pcie_host_deinit() while power domains or
clocks are disabled.

Fix this by restructuring starfive_pcie_remove() to deinitialize the host
controller first while runtime PM is active, followed by a synchronous
pm_runtime_put_sync() and pm_runtime_disable().

This bug was found in automated AI review by sashiko-bot.

Fixes: 39b91eb40c6a ("PCI: starfive: Add JH7110 PCIe controller")
Closes: https://lore.kernel.org/linux-pci/20260712180440.423421F000E9@smtp.kernel.org/
Signed-off-by: Ali Tariq <alitariq45892@gmail.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260718133825.445041-1-alitariq45892@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/plda/pcie-starfive.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/plda/pcie-starfive.c b/drivers/pci/controller/plda/pcie-starfive.c
index 628f8c8d67471..0ca39f3fa1d4f 100644
--- a/drivers/pci/controller/plda/pcie-starfive.c
+++ b/drivers/pci/controller/plda/pcie-starfive.c
@@ -445,9 +445,9 @@ static void starfive_pcie_remove(struct platform_device *pdev)
 {
 	struct starfive_jh7110_pcie *pcie = platform_get_drvdata(pdev);
 
-	pm_runtime_put(&pdev->dev);
-	pm_runtime_disable(&pdev->dev);
 	plda_pcie_host_deinit(&pcie->plda);
+	pm_runtime_put_sync(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
 	platform_set_drvdata(pdev, NULL);
 }
 
-- 
2.53.0



