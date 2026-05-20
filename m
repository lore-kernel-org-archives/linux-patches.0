Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 139C43DA7C6;
	Wed, 20 May 2026 17:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297971; cv=none; b=tllj0avYPIbNlNzLDuJ6XKkGxX6TEXMp+Pm3SIuyDhuRcCBIhMZ3XsbBql4kD/E5m5gGx+TxPMyTxFxaIDMbKnG8/Nk6tk+c4nrMBa6BTJHJgYL9go0/rjkVZxSo3pyU6qC34dsb5mowkTbSpkQOGnlWdlkksS6ikEmpEPdZqK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297971; c=relaxed/simple;
	bh=JTBCx2ncvTabH1fAAMUTjyGG+Iu37dchteCSX9/M43s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q5AjneYlMbaq4KEuZQ2yTW/5nwb9dp//PXQMll3eC89/9OkPMU1MaXpFEmTSkTcXQyh5gRtHgpLQMEoQHKxj0aWt1k25+aIViqCx6GUH1IVRUD1hVFPicqfciJOlxTD0kWZVyVitQE7jVxw4vBgPn23QS+o9YTwV8PSuO4Nl0JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=exeNZAyW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="exeNZAyW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 780AC1F000E9;
	Wed, 20 May 2026 17:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297970;
	bh=iY6TAiYwCxAcy11BiCZ+7LdPmtWEf1mK0BbMTTCLDx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=exeNZAyWPY4m7PAP1BeuTeve/ujm1UziDpOq7DLz4skvzVkmWh91fQhFJC4eMLwPV
	 JOMzu7Pt1ckd9JOrYlndqVc8sBDwy2tjGpJYCddzBeyO05YIXMRp5+QZb6qce/q/ZL
	 fasUx0G1xzBs9thVNrvzjVtAYbqrGFWkHW7GzJUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 234/957] PCI: dwc: rcar-gen4: Change EPC BAR alignment to 4K as per the documentation
Date: Wed, 20 May 2026 18:11:57 +0200
Message-ID: <20260520162139.614548795@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Koichiro Den <den@valinux.co.jp>

[ Upstream commit 13f55a7ca773c731a1e645934c1ae48577f48785 ]

R-Car S4 Series (R8A779F[4-7]*) EP controller uses a 4K minimum iATU region
size (CX_ATU_MIN_REGION_SIZE = 4K) as per R19UH0161EJ0130 Rev.1.30. Also,
the controller itself can only be configured in the range 4 KB to 64 KB, so
the current 1 MB alignment requirement is incorrect.

Hence, change the alignment to the min size 4K as per the documentation.

This also fixes needless unusability of BAR4 on this platform when the
target address is fixed, such as for doorbell targets.

Fixes: e311b3834dfa ("PCI: rcar-gen4: Add endpoint mode support")
Signed-off-by: Koichiro Den <den@valinux.co.jp>
[mani: commit log]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Link: https://patch.msgid.link/20260305151050.1834007-1-den@valinux.co.jp
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-rcar-gen4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pcie-rcar-gen4.c b/drivers/pci/controller/dwc/pcie-rcar-gen4.c
index 80778917d2ddd..7e171526b1ded 100644
--- a/drivers/pci/controller/dwc/pcie-rcar-gen4.c
+++ b/drivers/pci/controller/dwc/pcie-rcar-gen4.c
@@ -425,7 +425,7 @@ static const struct pci_epc_features rcar_gen4_pcie_epc_features = {
 	.bar[BAR_3] = { .type = BAR_RESERVED, },
 	.bar[BAR_4] = { .type = BAR_FIXED, .fixed_size = 256 },
 	.bar[BAR_5] = { .type = BAR_RESERVED, },
-	.align = SZ_1M,
+	.align = SZ_4K,
 };
 
 static const struct pci_epc_features*
-- 
2.53.0



