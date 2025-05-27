Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B6427EC73;
	Tue, 27 May 2025 17:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366683; cv=none; b=L4QYIp7f2p49TGka2/MdwoAmZA+6LYLAQYoJR2p9sGXjLTFW1Mia2pSpK9VSLVaiqleniR/d7Y+dS6sn3W/O9K67UPNC3tLke4YmDFhWV5vs+LKIQciHwaK3yHj/OQwfeLYqq8bWft2TKHuoZKzqT26LEmhrA5JreouRgqI91hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366683; c=relaxed/simple;
	bh=GsxsikANRWx795aFiNl1FCnCZYBU4ngwgB8r9j/2/V8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hNr9MBqre6Rh7OjRdn6GNzfULu7J0QyP6v2FRa+Jp7H1VNTT4XlSRySW4YnT54xUX04HdAp2fLTmnnszi7+V6afX6WPysDyW67U0AkwqLkCqtjG/qqSKtkjMtoLaY6EURsvwJDRbCt5zW6jH0G2ILAPbpbAXOHSR6OqXrzoqSo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fJ/bHmGM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fJ/bHmGM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDCB7C4CEE9;
	Tue, 27 May 2025 17:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366683;
	bh=GsxsikANRWx795aFiNl1FCnCZYBU4ngwgB8r9j/2/V8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fJ/bHmGMYMzYMCWMNc0XJ0zJP6GAXhMB+D+GzFWW+thYk20K0js528hgPUU+UQfvx
	 rEhTEbhcSsB0ztgbrUhfKYUYabLV+c++I7urbuGygYGL/GRkZ35m9Db0Cf7R60Ui5s
	 UWsKzaXGxxxX1MOvKJRfvAAz8O9y6tWynaxVFNF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 146/783] s390/tlb: Use mm_has_pgste() instead of mm_alloc_pgste()
Date: Tue, 27 May 2025 18:19:03 +0200
Message-ID: <20250527162519.103099987@linuxfoundation.org>
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

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 9291ea091b29bb3e37c4b3416c7c1e49e472c7d5 ]

An mm has pgstes only after s390_enable_sie() has been called, while
mm_alloc_pgste() may be always true (e.g. via sysctl setting).

Limit the calls to gmap_unlink() in pte_free_tlb() to those cases
where there might be something to unlink.

Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/tlb.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/tlb.h b/arch/s390/include/asm/tlb.h
index 72655fd2d867c..f20601995bb0e 100644
--- a/arch/s390/include/asm/tlb.h
+++ b/arch/s390/include/asm/tlb.h
@@ -84,7 +84,7 @@ static inline void pte_free_tlb(struct mmu_gather *tlb, pgtable_t pte,
 	tlb->mm->context.flush_mm = 1;
 	tlb->freed_tables = 1;
 	tlb->cleared_pmds = 1;
-	if (mm_alloc_pgste(tlb->mm))
+	if (mm_has_pgste(tlb->mm))
 		gmap_unlink(tlb->mm, (unsigned long *)pte, address);
 	tlb_remove_ptdesc(tlb, virt_to_ptdesc(pte));
 }
-- 
2.39.5



