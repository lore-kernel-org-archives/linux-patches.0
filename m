Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F9527FD68;
	Tue, 27 May 2025 17:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366732; cv=none; b=swB94uJ9U0vlQEBPonL2NKcm60N4A3OpUoq/B3KITHTyDm6pE9wk30kZDMKKC+h2eeDhYjQISVUarv61Ha5VAa844jt11vFfDcxardQxrahpR4izLcZhhZ9qrTNBTsV1C6Ohbvb0Q5d/v0KZCfudPfIk+GpXg4IRDolC02S5Vgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366732; c=relaxed/simple;
	bh=M/rsY8BDvn1DJZ0DAJOhSChXltb/tw63yl8I5rjYVXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GHtf+LT57mB5HZj9Zn0yuVKfsajv4IvKsFrGDye3JFVvphau8l9hp6o9yRFdatv+UXFvRItPA3StUAYGjg8G9fXjawVvSXe2l65R3++o1UiNhCurOQSUoau09wPinkVdgxKOpPKyoVv1VT9q7WGuwT4RKt1MA+DTX3IxkjbiDII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vGszR3ku; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vGszR3ku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D8D5C4CEEB;
	Tue, 27 May 2025 17:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366732;
	bh=M/rsY8BDvn1DJZ0DAJOhSChXltb/tw63yl8I5rjYVXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vGszR3ku7gx6+wvRMHpc5Dm+gwO4RHSoHfDdnUOJ3ysAP5IugE7/D1qkySyo1MmsF
	 EMj4TJqRuMUleGSELdeBMUMkkunWzjOljahMmAYjiiUia02YOq7/GqBv5g8ufMWQo6
	 xDics1r628UpOsh2wu/cd180L/JLsvw+H2NxHp/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 164/783] PCI: dwc: Use resource start as ioremap() input in dw_pcie_pme_turn_off()
Date: Tue, 27 May 2025 18:19:21 +0200
Message-ID: <20250527162519.846074088@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit 8f4a489b370e6612700aa16b9e4373b2d85d7503 ]

The msg_res region translates writes into PCIe Message TLPs. Previously we
mapped this region using atu.cpu_addr, the input address programmed into
the ATU.

"cpu_addr" is a misnomer because when a bus fabric translates addresses
between the CPU and the ATU, the ATU input address is different from the
CPU address.  A future patch will rename "cpu_addr" and correct the value
to be the ATU input address instead of the CPU physical address.

Map the msg_res region before writing to it using the msg_res resource
start, a CPU physical address.

Link: https://lore.kernel.org/r/20250315201548.858189-2-helgaas@kernel.org
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware-host.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware-host.c b/drivers/pci/controller/dwc/pcie-designware-host.c
index ffaded8f2df7b..ae3fd2a5dbf85 100644
--- a/drivers/pci/controller/dwc/pcie-designware-host.c
+++ b/drivers/pci/controller/dwc/pcie-designware-host.c
@@ -908,7 +908,7 @@ static int dw_pcie_pme_turn_off(struct dw_pcie *pci)
 	if (ret)
 		return ret;
 
-	mem = ioremap(atu.cpu_addr, pci->region_align);
+	mem = ioremap(pci->pp.msg_res->start, pci->region_align);
 	if (!mem)
 		return -ENOMEM;
 
-- 
2.39.5



