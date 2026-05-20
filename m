Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71972701C4;
	Wed, 20 May 2026 17:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298039; cv=none; b=g62KM4a95J+54Y0n/No7XxXtPbvbP2mc5AIAjK6lFflLDe5422GB3+dxUArdbaV4yprJr5oamvIRSXlB9UNcru+h76R7UCbH0fKDppn8IkeMXpA2kLqWdd3yndISGIATJJ3XWyz1Y+5wr8IpBAzKkOZRGUNAziYWestxCOVRI9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298039; c=relaxed/simple;
	bh=pxKjBqfBQHP+6hKPGS9KI1uGWY0INTsAyAw85Xm7tsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eH23pGIXU79v5PaEqlwQLzwS5oBJRdIWrrX61VZCAZF+NoJIsq5Ma6HtPIgqKoHCPge95djGf0+QAf+rW3/kk8lWxskiZPGZq+GYXC4nj99CM08w4yrqB+VKi7nL2AzLel1TXvZfmV95NTa8f1VjLpVvfbL6ZxBV6+PktnAVsHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qtY8fqMs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qtY8fqMs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284FB1F00893;
	Wed, 20 May 2026 17:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298038;
	bh=h8qBlfiRJ0vdJQjZBVrk3fJwZInbDoVy8wx+AHdHLJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qtY8fqMsXPHnq391+h9498L9mUIGJPT4qjBGAdAFF0nuMmIzdcVQYH6K2Bb9OIlpu
	 D+3snRS420KDTf16MMxnaE3ad1JZ+JC9lgnK0OKGu/x7BymYcrcl0UEoTcNisLq8B4
	 g2E1XI/c/oyC2AYs5Rr5xw+kJEA/1FT+ZidIy1ZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Tidmore <ethantidmore06@gmail.com>,
	Andrew Jones <andrew.jones@oss.qualcomm.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 257/957] iommu/riscv: Fix signedness bug
Date: Wed, 20 May 2026 18:12:20 +0200
Message-ID: <20260520162140.117718868@linuxfoundation.org>
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

From: Ethan Tidmore <ethantidmore06@gmail.com>

[ Upstream commit 553a127cb66523089bc10eb54640205495f4bb5b ]

The function platform_irq_count() returns negative error codes and
iommu->irqs_count is an unsigned integer, so the check
(iommu->irqs_count <= 0) is always impossible.

Make the return value of platform_irq_count() be assigned to ret, check
for error, and then assign iommu->irqs_count to ret.

Detected by Smatch:
drivers/iommu/riscv/iommu-platform.c:119 riscv_iommu_platform_probe() warn:
'iommu->irqs_count' unsigned <= 0

Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
Fixes: 5c0ebbd3c6c6 ("iommu/riscv: Add RISC-V IOMMU platform device driver")
Reviewed-by: Andrew Jones <andrew.jones@oss.qualcomm.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/riscv/iommu-platform.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/riscv/iommu-platform.c b/drivers/iommu/riscv/iommu-platform.c
index 8f15b06e84997..399ba8fe1b3e5 100644
--- a/drivers/iommu/riscv/iommu-platform.c
+++ b/drivers/iommu/riscv/iommu-platform.c
@@ -115,10 +115,13 @@ static int riscv_iommu_platform_probe(struct platform_device *pdev)
 		fallthrough;
 
 	case RISCV_IOMMU_CAPABILITIES_IGS_WSI:
-		iommu->irqs_count = platform_irq_count(pdev);
-		if (iommu->irqs_count <= 0)
+		ret = platform_irq_count(pdev);
+		if (ret <= 0)
 			return dev_err_probe(dev, -ENODEV,
 					     "no IRQ resources provided\n");
+
+		iommu->irqs_count = ret;
+
 		if (iommu->irqs_count > RISCV_IOMMU_INTR_COUNT)
 			iommu->irqs_count = RISCV_IOMMU_INTR_COUNT;
 
-- 
2.53.0



