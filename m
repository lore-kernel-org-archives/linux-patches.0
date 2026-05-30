Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878783016E1;
	Sat, 30 May 2026 17:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161252; cv=none; b=qGKn/s9bcD1IJGdhpwOvLKeOOAko3+74lhiuddZqVFjHbmHG3aRKdzUP672tVYKvGBYle7L8AmoU8KaPor7DCsIS+ebmzrVY0eofze2jZJTRJv036BO9CC4+DF5AJ1P14OpVdAK51R48N60V0caUd19QWn0/m/3SNy5AN7RETQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161252; c=relaxed/simple;
	bh=ZWJ3yFWbgKCj/fexS6yonrc5yWQRU0Hma8FlxvwOmQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CaERam8HEKhnntXGVI6DkAcZz/Ip+flLjhlVpVVCgc2l3AIMHNCP8/S7ATPzgB5091J2pVXbMXCg3RKJbhHCh9FvQUBy0sNZQqpYFoQks6D+lzWBtVWO1yppyUvAeSy0ySMcxPvcHRcdpkEq7OGIpLLfEBvo1Ef9DMDCNfwOlgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u8u1Tdn6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u8u1Tdn6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFAF11F00893;
	Sat, 30 May 2026 17:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161251;
	bh=93xGpV2frRoBL2W5W+Zc4hAGatRRJcN87tc+kaHZGEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u8u1Tdn6+3AcUFXqxM3RIucs0SHrJgdto3kXxr8pO9h7kAJuIuDP1Bk0W2TG6YQhp
	 WqdmssHgvg3o3gPFjrRXIdS1MNtszrLR02NJdTRUW6aWQU26fxJT7j9ICJ+CL+VcDd
	 v2qWpiVarIMd3fIoWbn/lxS1Y0O4Eknp2NVsKrXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 539/969] PCI: mediatek-gen3: Prevent leaking IRQ domains when IRQ not found
Date: Sat, 30 May 2026 18:01:03 +0200
Message-ID: <20260530160315.254786551@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 40c38ca5a42e2..b7d87827b5f23 100644
--- a/drivers/pci/controller/pcie-mediatek-gen3.c
+++ b/drivers/pci/controller/pcie-mediatek-gen3.c
@@ -760,14 +760,14 @@ static int mtk_pcie_setup_irq(struct mtk_gen3_pcie *pcie)
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



