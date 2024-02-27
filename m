Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C105B1468E5;
	Tue, 27 Feb 2024 14:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044233; cv=none; b=asNDs2GYyN0viPoYWVbIhTPJrRJ4YyuKP0jZDjVDxLvJrR2Js5/M1c1nSnCKcY9rHdna4dyZNT4Hawf3LamkNhPFF+ki6cnX224O5jOwCFluG5S7QOg426H4mCEegWAY2Zz5dKG1CdiNsciz21YLCbBirHcfoCrYK9PsLxQdUK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044233; c=relaxed/simple;
	bh=ZT/LgjEwOjPG0bDH3ytMJd6W2wQdDxajwqJOARZ5/Z8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iJVdmR8l3a+hpgycWG2o0XEyEmlbPa6Zuv8dJfQAJ7D3C2oU/dN9pZ+SFBWx9QYY2rLUtd7x4jySpXHFDDuLQ1emMTJDQNs6mtMcMFJrEicF3B2jSSpY9JNV3H2FfPVWJvFleuaSwYsv5byY1PKqntU5pF1P/Aws6Shf8Qu0XT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tj8yprrE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tj8yprrE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50851C433C7;
	Tue, 27 Feb 2024 14:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044233;
	bh=ZT/LgjEwOjPG0bDH3ytMJd6W2wQdDxajwqJOARZ5/Z8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tj8yprrEI2DI/0z/avfs75qkVJ+anGDWZ5V7bHA8YFXvK0h367zOPcDbES3dFTMhe
	 gp0ud0TTrDznEInUdN+B/VXrHody6/kQB+MS2W89xRFjhd4JvI7XJ8ufFpF5OJSiCe
	 gbWBH7Su5Q8zQlVOw18MojUSjz/ZEJ6Xp/WWwoT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 111/122] s390: use the correct count for __iowrite64_copy()
Date: Tue, 27 Feb 2024 14:27:52 +0100
Message-ID: <20240227131602.336458681@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 74799439b2598..beecc36c30276 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -225,7 +225,7 @@ resource_size_t pcibios_align_resource(void *data, const struct resource *res,
 /* combine single writes by using store-block insn */
 void __iowrite64_copy(void __iomem *to, const void *from, size_t count)
 {
-       zpci_memcpy_toio(to, from, count);
+	zpci_memcpy_toio(to, from, count * 8);
 }
 
 static void __iomem *__ioremap(phys_addr_t addr, size_t size, pgprot_t prot)
-- 
2.43.0



