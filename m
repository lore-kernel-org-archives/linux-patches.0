Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8847630F921;
	Mon, 13 Oct 2025 15:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368890; cv=none; b=WvFlq0h1/jVWu3A9Krwkr7rDGihGeXvSp/t/RTeJtbgtJbHPwRc4pDgUyDDUUB2wilrZo+AYUf4b245inxXJMKtIjLHNps3g/dtr1X6YK0RFEjm6xnrWuTG1CLP51TVAdO0NbXuHWOFGce9MRQmdaqfyCnAT829UB6KdtIQNC5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368890; c=relaxed/simple;
	bh=QgFrONEjRhm/SgOcVFKtrgKKfTozxx3a2dVDxaIsfnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U067XJz5BZ1GtB32y81PdmY+rv4lbRery09eF2O5Ki7BnlVuREDCXJt/dzUV8Z9fB/Hqy9N9+rOxpq5PpwG5u/58b10rdQ95XtxxK7N/AFGyor5kWx+xVeITstAqzmNFKpoAbrrVusGyZ8ZlWMDsIQOzdjbQFC/z97IJM1xlcFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xd6yvREB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xd6yvREB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09EE8C4CEE7;
	Mon, 13 Oct 2025 15:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368890;
	bh=QgFrONEjRhm/SgOcVFKtrgKKfTozxx3a2dVDxaIsfnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xd6yvREBNGnDNn5IpRksMvMP7/gi9+b9zWh7aPvyj1KHNkW/Ii0KtkwosWFNOqr6U
	 c/6LCEMqhXeVZz7myqPCViLoVNWLVDAzfh2H9zoJwAK9MPR/DeZJUgoKE/aFsllp8y
	 7m9dJNhZy2K/2g2ZMb/BfnYqtHn3orp9v/tENXOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 021/563] powerpc/603: Really copy kernel PGD entries into all PGDIRs
Date: Mon, 13 Oct 2025 16:38:02 +0200
Message-ID: <20251013144412.057833252@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit f2863371f017eb03c230addc253783fa4c7e90f5 ]

Commit 82ef440f9a38 ("powerpc/603: Copy kernel PGD entries into all
PGDIRs and preallocate execmem page tables") was supposed to extend
to powerpc 603 the copy of kernel PGD entries into all PGDIRs
implemented in a previous patch on the 8xx. But 603 is book3s/32 and
uses a duplicate of pgd_alloc() defined in another header.

So really do the copy at the correct place for the 603.

Fixes: 82ef440f9a38 ("powerpc/603: Copy kernel PGD entries into all PGDIRs and preallocate execmem page tables")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/752ab7514cae089a2dd7cc0f3d5e35849f76adb9.1755757797.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/book3s/32/pgalloc.h | 10 ++++++++--
 arch/powerpc/include/asm/nohash/pgalloc.h    |  2 +-
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/32/pgalloc.h b/arch/powerpc/include/asm/book3s/32/pgalloc.h
index dd4eb30631758..f4390704d5ba2 100644
--- a/arch/powerpc/include/asm/book3s/32/pgalloc.h
+++ b/arch/powerpc/include/asm/book3s/32/pgalloc.h
@@ -7,8 +7,14 @@
 
 static inline pgd_t *pgd_alloc(struct mm_struct *mm)
 {
-	return kmem_cache_alloc(PGT_CACHE(PGD_INDEX_SIZE),
-			pgtable_gfp_flags(mm, GFP_KERNEL));
+	pgd_t *pgd = kmem_cache_alloc(PGT_CACHE(PGD_INDEX_SIZE),
+				      pgtable_gfp_flags(mm, GFP_KERNEL));
+
+#ifdef CONFIG_PPC_BOOK3S_603
+	memcpy(pgd + USER_PTRS_PER_PGD, swapper_pg_dir + USER_PTRS_PER_PGD,
+	       (MAX_PTRS_PER_PGD - USER_PTRS_PER_PGD) * sizeof(pgd_t));
+#endif
+	return pgd;
 }
 
 static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
diff --git a/arch/powerpc/include/asm/nohash/pgalloc.h b/arch/powerpc/include/asm/nohash/pgalloc.h
index bb5f3e8ea912d..4ef780b291bc3 100644
--- a/arch/powerpc/include/asm/nohash/pgalloc.h
+++ b/arch/powerpc/include/asm/nohash/pgalloc.h
@@ -22,7 +22,7 @@ static inline pgd_t *pgd_alloc(struct mm_struct *mm)
 	pgd_t *pgd = kmem_cache_alloc(PGT_CACHE(PGD_INDEX_SIZE),
 			pgtable_gfp_flags(mm, GFP_KERNEL));
 
-#if defined(CONFIG_PPC_8xx) || defined(CONFIG_PPC_BOOK3S_603)
+#ifdef CONFIG_PPC_8xx
 	memcpy(pgd + USER_PTRS_PER_PGD, swapper_pg_dir + USER_PTRS_PER_PGD,
 	       (MAX_PTRS_PER_PGD - USER_PTRS_PER_PGD) * sizeof(pgd_t));
 #endif
-- 
2.51.0



