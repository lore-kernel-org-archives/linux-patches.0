Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054913;
	b=Ybwhu1OxAIH41nDb2ZrfSX2gx5f5brd8sw26r0VKQvBcH4k4uTAwyKxt3Usmp9ZzyjH/
	 GYgh7iCSxUSLHBHSvIa05lOrS1eHznQ5hXZOvL+7B/cIWgIdLRrdc/+WJkB4rpDZv8par
	 0s2JLzeGpmCCD/iillgFPywkBwDOSwmvnkv1Pb8xe3bXb4xSEE7YW70xf1bi/jTdm2udU
	 xhKDBVH9lQ7THEbiChfqmMYZWmHuDEfeoyuL3RLCwr/I/UjAWgbLih2pY7GwdaHf8pKZG
	 XkO5WlND4GjP/ikP6wrxHM4+PGHYixmnEkvwfjlyMFcoKMKmjKFkBGje+A9CdGLE48w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054913;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Jmb+ymaObfvZj3G4yjwZUnLwWI0HO+jn3+3q10oEvBQ=;
	b=VCdpVkMGNsJKJKky3cfKjrgrr9ovXSlyOxcVjivUILWty2ADbbHSkStu2SwXi306p0Nk
	 Ay8XNafmYHE+7APwbLwQwYsnJBCDBlA2m9DKHXNRPN6epZdCl8gbrfTC9UOx4JTQ4VvWt
	 sBSX/0eU2S6OTxI6Jxa2IZdGogo9Wwt6nP6eSkmnrY0PFEPh+yqJC506cdij8NkOuR+7e
	 T3tA/Ngv0J+64+Ax/C+uhhIGnN7o0BYzEdmDRINYYtoIG311LAb24pcNqRWgvTHwYfRu5
	 ggdTyUO9EGrI/alopmKLaPG8R55b5jFI254eNVN/DDRc6e+3nAFsVRED539ubImbtfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YSPEf1zA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C69606A325;
	Thu, 19 Nov 2026 02:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YSPEf1zA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 835A11F000C4;
	Thu, 19 Nov 2026 02:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054913;
	bh=Jmb+ymaObfvZj3G4yjwZUnLwWI0HO+jn3+3q10oEvBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YSPEf1zAaDaGE4f65hCBWXT4twxbn+6tyYlijdS/G9q9ssGNR3PIRZk4dLbM31wvB
	 mhfePG+shM9BT/yKcGPX+s96K3oQpumroz0V2j1CpC5mfPruD9IAiATj00LkALDyuu
	 OJxQ3BaSRw/An6DekF0sedp99k7HbJnOkxP1ALos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1444/2214] PCI: xgene: Use managed clock for PCIe controller
Date: Wed, 18 Nov 2026 15:52:00 +0100
Message-ID: <20261118150108.887367251@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit b9022584ebbae81f7bbe4a61bd1df0d0a95e1a99 ]

xgene_pcie_init_port() obtains and enables the controller clock manually.
When xgene_pcie_setup() or pci_host_probe() fails, probe returns without
disabling, unpreparing, or releasing the clock. A failed enable also leaves
the clk_get() reference unreleased.

Use devm_clk_get_enabled() so the clock is unwound automatically on probe
failure and device removal.

Fixes: 5f6b6ccdbe1c ("PCI: xgene: Add APM X-Gene PCIe driver")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260802221146.573233-1-dbgh9129@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-xgene.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/controller/pci-xgene.c b/drivers/pci/controller/pci-xgene.c
index 4641e57487cfd..426544fd5eb8d 100644
--- a/drivers/pci/controller/pci-xgene.c
+++ b/drivers/pci/controller/pci-xgene.c
@@ -326,18 +326,11 @@ static void xgene_pcie_linkup(struct xgene_pcie_port *port,
 static int xgene_pcie_init_port(struct xgene_pcie_port *port)
 {
 	struct device *dev = port->dev;
-	int rc;
 
-	port->clk = clk_get(dev, NULL);
+	port->clk = devm_clk_get_enabled(dev, NULL);
 	if (IS_ERR(port->clk)) {
 		dev_err(dev, "clock not available\n");
-		return -ENODEV;
-	}
-
-	rc = clk_prepare_enable(port->clk);
-	if (rc) {
-		dev_err(dev, "clock enable failed\n");
-		return rc;
+		return PTR_ERR(port->clk);
 	}
 
 	return 0;
-- 
2.53.0



