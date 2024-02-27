Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D70DC13B2B4;
	Tue, 27 Feb 2024 14:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043671; cv=none; b=urdKOKI5a2zDfGBu8lcyAkz09osdK5z3tLUyfjrcGSl3xA8XT5tbVlEg7CqyK2ME767PLcAkAscjLF47w/d5xVY1vhs1qgb4Pvm8tEfAc7WWu3BXC/IhfJPwYzEI7GEEV93u87GB12yyFsVIBcDIXepJdZ02ySJqONvOceVt3zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043671; c=relaxed/simple;
	bh=wZysLImAkurh8lL4d3PC4akT6Am4PQOB55RhogujXuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WpUyoft834UVIwq8a2sZyGoF0f0rVYX9E3ZQpMnztkRlfEzf5Ccs/oNVExWcKnw95tnt667Ut6emm24liLGRzbRKu3pW7chlsifxnlksWijE/eMn4VBLI/fgryh60xy9+OCjgzSLagxjR4Wmmbmnap/pQOQ3tSt1vgRvayEHC8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aAtgt5Ui; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aAtgt5Ui"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 643E8C433F1;
	Tue, 27 Feb 2024 14:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043671;
	bh=wZysLImAkurh8lL4d3PC4akT6Am4PQOB55RhogujXuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aAtgt5UiQuyVa2zZp8LpChJTdcYoBcuUdfdBYjXt9Cnh55WzwFRO3bZaxa3vA4xTQ
	 KD9HSOv1lyP+W+Q1HtbzBfKHN34sqDT9XCwZA5ea+Wj1fhXIG/mBKTIlslkzlDGt+C
	 QYDtDUQfRTfj3NM23fDCyMAwN1cD24pLcrCdxkjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 164/195] s390: use the correct count for __iowrite64_copy()
Date: Tue, 27 Feb 2024 14:27:05 +0100
Message-ID: <20240227131615.826081545@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 723a2cc8d69d4342b47dfddbfe6c19f1b135f09b ]

The signature for __iowrite64_copy() requires the number of 64 bit
quantities, not bytes. Multiple by 8 to get to a byte length before
invoking zpci_memcpy_toio()

Fixes: 87bc359b9822 ("s390/pci: speed up __iowrite64_copy by using pci store block insn")
Acked-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/0-v1-9223d11a7662+1d7785-s390_iowrite64_jgg@nvidia.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/pci/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index 2c99f9552b2f5..394c69fda399e 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -241,7 +241,7 @@ resource_size_t pcibios_align_resource(void *data, const struct resource *res,
 /* combine single writes by using store-block insn */
 void __iowrite64_copy(void __iomem *to, const void *from, size_t count)
 {
-       zpci_memcpy_toio(to, from, count);
+	zpci_memcpy_toio(to, from, count * 8);
 }
 
 static void __iomem *__ioremap(phys_addr_t addr, size_t size, pgprot_t prot)
-- 
2.43.0



