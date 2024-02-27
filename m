Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 753C613B797;
	Tue, 27 Feb 2024 13:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041325; cv=none; b=s814mVYkSC+Lv1bKLAsU2sBcRKULb28aXfCm5TE117Pm9SN7/A6rvi1oP1p7G6EJ1l40o2v/vNeclmYyjFPzt+KeJNNdWHbnZYLkv48u0C3jiuanIDx7KiYBlaqSmrWCvgDncxkb+hr7HLjYhaVmGKXzX/xcqdfIWesWIi/9kpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041325; c=relaxed/simple;
	bh=tbW4gMmzZN8JfzeLuJJHNhxv/k2UWX6DM6QLe5n3V5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BrBhHDhLWWC4w980VfaXfhdh5nEp2ToO5BTmK4jD0bmqE/JVsQHv3fbjgub39wkG6qt6M7QU+KZj604WTnUgBa6N97BSzEpac27oVnDWJJlefFmQ7XROwc1vmXUa9G8WD8i9LFxytQoorqid36LrRjjc9P4KKQmNw89qPBNvQug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VS5Mb+PS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VS5Mb+PS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 008DCC433C7;
	Tue, 27 Feb 2024 13:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041325;
	bh=tbW4gMmzZN8JfzeLuJJHNhxv/k2UWX6DM6QLe5n3V5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VS5Mb+PSnlPDko7bEucRVW1hgWhIPofBa7i99QO+HqoQot03SYdlEbjJiMuWShjtY
	 0RJGsQOmahBAHjaPJy7v8RKT7sMKOYSBtYyaUMTZ0dMrAchvc0clhUCZ6IQQ/Q29k3
	 hE4ky/1PIntGTxXCBN/QPaANhYXaOWo3hh9RnAn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 299/334] s390: use the correct count for __iowrite64_copy()
Date: Tue, 27 Feb 2024 14:22:37 +0100
Message-ID: <20240227131640.689639906@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 676ac74026a82..52a44e353796c 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -252,7 +252,7 @@ resource_size_t pcibios_align_resource(void *data, const struct resource *res,
 /* combine single writes by using store-block insn */
 void __iowrite64_copy(void __iomem *to, const void *from, size_t count)
 {
-       zpci_memcpy_toio(to, from, count);
+	zpci_memcpy_toio(to, from, count * 8);
 }
 
 void __iomem *ioremap_prot(phys_addr_t phys_addr, size_t size,
-- 
2.43.0



