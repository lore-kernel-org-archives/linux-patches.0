Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA6113B2B4;
	Tue, 27 Feb 2024 14:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043937; cv=none; b=gCpBAp1oc8vdfgG8ra1v2Zpa81EDHT3Z6o7p3ijCW5NlXOZFZVL9S6rLsssWgGkZ6RxbyDgTvCqOEqaBuFEcbWNj+Rxi5Q8R2pQYdi4ljV+WfZHRAzYTjztujyF8bCUyHUFcdYEL3N3oEIKGeFh83UC+2Yrc2a/PpQIpRV4Cu7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043937; c=relaxed/simple;
	bh=DRcAUSSA4NX0yzEjMjGbP7b/2CgOVkU5tte/swngIao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V9wnI7wq4eL25MqeGS4sze/5gNlDpHO5Vh+FMZO/r6lQe0kn3QbXBS/2m4qw2A+gjzQkcyYIw+kzWfUoXsdyyX6oouNWZDpDXaRQjKrZW2UlgvTuEw4526OF/6NM/BZqy1y8fRWgh5nMb0QTACH//2GxPuJyW/BtQwrYVV8JH1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rYnbvnmj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rYnbvnmj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DC05C433F1;
	Tue, 27 Feb 2024 14:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043937;
	bh=DRcAUSSA4NX0yzEjMjGbP7b/2CgOVkU5tte/swngIao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rYnbvnmjrjtUcRDHsjBdqZpaLTIiysqM/rMRrKBHuup5KfMosZagseCttZ6X9+lhV
	 KGgRPo3bRxFfCTdLtmxV7szwAS/EbSfKvAkOPOOVeO1oo/Russw8LI9F/55Xe4JW9L
	 3jCx+EdbBd9bclowjXrj9qOJBZ+LEfViTcnW8NJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 76/84] s390: use the correct count for __iowrite64_copy()
Date: Tue, 27 Feb 2024 14:27:43 +0100
Message-ID: <20240227131555.343296328@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131552.864701583@linuxfoundation.org>
References: <20240227131552.864701583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index b8ddacf1efe11..8d241f3c3b78b 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -223,7 +223,7 @@ resource_size_t pcibios_align_resource(void *data, const struct resource *res,
 /* combine single writes by using store-block insn */
 void __iowrite64_copy(void __iomem *to, const void *from, size_t count)
 {
-       zpci_memcpy_toio(to, from, count);
+	zpci_memcpy_toio(to, from, count * 8);
 }
 
 void __iomem *ioremap(unsigned long ioaddr, unsigned long size)
-- 
2.43.0



