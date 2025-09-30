Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2951C2236EB;
	Tue, 30 Sep 2025 15:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244909; cv=none; b=i7DqjGQV84kwavaKfAbZ/M3WEc35HVzBdEFoqIYEPihTisLbdvNVPuVDXbsEaZBKn04bziORzvIh/dsA0/VENc2KRegSiLliw0LRZuAiiURbO9MuiZjJteGDzt/MAmQK4PYETA4rORuyHWiRiFTE9ggAi9+znr6B4bO5th35RbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244909; c=relaxed/simple;
	bh=itPbgRsdqLs+kEAkk19pyrIgKXzyQk2ae7r8yI2XYrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CoBCx0kpcqQ+S20W9YqiTR/X6aMSGZYK19v+AF89wgHi8QBNao/T9S+SkJXt85iKosvtGk0vA/6cRXVp+/lEYEFTlVN1OR7lsZJ/5kHrDGkr44DIXMges0FwRSFoQrxVr5gfEDX0QdGkqpJbLnVk2xEucXCHK2C4CSI8k1yIkeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fNGedoAO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fNGedoAO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B5C4C4CEF0;
	Tue, 30 Sep 2025 15:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244909;
	bh=itPbgRsdqLs+kEAkk19pyrIgKXzyQk2ae7r8yI2XYrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fNGedoAO4qwm9qe3F7EfIPGZo2sZ33FilMhrJCslFRnEV3YNBPGSa+Qt3W9p1FKLq
	 LrUPbCV+KMEUijtaUDXmX5JcI4l6xqVfvlc8pHcdZlQNDUXTErcCiiojGm5NyntUpI
	 1JAxYSz9+ZD6h/kS3WIkFuCipygCLQgHJjOFrwkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 6.16 130/143] riscv: Use an atomic xchg in pudp_huge_get_and_clear()
Date: Tue, 30 Sep 2025 16:47:34 +0200
Message-ID: <20250930143836.411138061@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Ghiti <alexghiti@rivosinc.com>

commit 546e42c8c6d9498d5eac14bf2aca0383a11b145a upstream.

Make sure we return the right pud value and not a value that could
have been overwritten in between by a different core.

Fixes: c3cc2a4a3a23 ("riscv: Add support for PUD THP")
Cc: stable@vger.kernel.org
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20250814-dev-alex-thp_pud_xchg-v1-1-b4704dfae206@rivosinc.com
[pjw@kernel.org: use xchg rather than atomic_long_xchg; avoid atomic op for !CONFIG_SMP like x86]
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/pgtable.h |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -964,6 +964,23 @@ static inline int pudp_test_and_clear_yo
 	return ptep_test_and_clear_young(vma, address, (pte_t *)pudp);
 }
 
+#define __HAVE_ARCH_PUDP_HUGE_GET_AND_CLEAR
+static inline pud_t pudp_huge_get_and_clear(struct mm_struct *mm,
+					    unsigned long address,  pud_t *pudp)
+{
+#ifdef CONFIG_SMP
+	pud_t pud = __pud(xchg(&pudp->pud, 0));
+#else
+	pud_t pud = *pudp;
+
+	pud_clear(pudp);
+#endif
+
+	page_table_check_pud_clear(mm, pud);
+
+	return pud;
+}
+
 static inline int pud_young(pud_t pud)
 {
 	return pte_young(pud_pte(pud));


