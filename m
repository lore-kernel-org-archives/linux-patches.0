Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F6F1A76A1;
	Tue, 30 Jul 2024 17:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360343; cv=none; b=l/Z9vlhDBJbj5TkfVrw1GA3P+Gf1CpR5dHAihO2N+nKx+EzSfXe/So9oYT9tbBGXKSgUnvcnKCu1MY6C1tDfvgaguOruZU9TaZAFSQ0cMTjS+gobOHXMKZGOp+hkjVf+yiT8mgvydkRljGFQVZXo1WMBYiJxhkU7dgQfLJAGrrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360343; c=relaxed/simple;
	bh=S6Xd9PJN/wisVJGt5+HiQFcu7IGJ/9a+z4gYCBYZqK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DAjTQ0jmHJeOp29+LzQq7U+tsv0M+81F04um+36JTEKzx6Wg7T/+5/uCRx5a4raoMmpyVKJ2dgkbcZ1gb/X2d0qJDBAX7Thy5Ouwj+iVqtL65aqsWI+ZJwYrsEGHZ8ZdjF5ujQXlRX8BnIh4xwqq8iqAwLfrMxxTldov3qrOqdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0lGGeiIu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0lGGeiIu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D1FBC32782;
	Tue, 30 Jul 2024 17:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360342;
	bh=S6Xd9PJN/wisVJGt5+HiQFcu7IGJ/9a+z4gYCBYZqK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0lGGeiIuBxpuukbJ4UAuIhC0ReoOoxWRnkDfFuuqE8oWwJfrFt+PxvlMlQVWpbygX
	 XHSi3pK7lruYQjPbB22jsSINlxbtXSIWIr7qFTaGg1VVBXSU7sVVk9kDiusW0qCbQQ
	 8JSjZzHpWpWVf5UmcACbW7IjBUNGTGVou+4/7euQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Asahi Lina <lina@asahilina.net>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.10 670/809] arm64: mm: Fix lockless walks with static and dynamic page-table folding
Date: Tue, 30 Jul 2024 17:49:06 +0200
Message-ID: <20240730151751.366292960@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will@kernel.org>

commit 36639013b3462c06ff8e3400a427f775b4fc97f5 upstream.

Lina reports random oopsen originating from the fast GUP code when
16K pages are used with 4-level page-tables, the fourth level being
folded at runtime due to lack of LPA2.

In this configuration, the generic implementation of
p4d_offset_lockless() will return a 'p4d_t *' corresponding to the
'pgd_t' allocated on the stack of the caller, gup_fast_pgd_range().
This is normally fine, but when the fourth level of page-table is folded
at runtime, pud_offset_lockless() will offset from the address of the
'p4d_t' to calculate the address of the PUD in the same page-table page.
This results in a stray stack read when the 'p4d_t' has been allocated
on the stack and can send the walker into the weeds.

Fix the problem by providing our own definition of p4d_offset_lockless()
when CONFIG_PGTABLE_LEVELS <= 4 which returns the real page-table
pointer rather than the address of the local stack variable.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/50360968-13fb-4e6f-8f52-1725b3177215@asahilina.net
Fixes: 0dd4f60a2c76 ("arm64: mm: Add support for folding PUDs at runtime")
Reported-by: Asahi Lina <lina@asahilina.net>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/20240725090345.28461-1-will@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/pgtable.h |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1065,6 +1065,28 @@ static inline bool pgtable_l5_enabled(vo
 
 #define p4d_offset_kimg(dir,addr)	((p4d_t *)dir)
 
+static inline
+p4d_t *p4d_offset_lockless_folded(pgd_t *pgdp, pgd_t pgd, unsigned long addr)
+{
+	/*
+	 * With runtime folding of the pud, pud_offset_lockless() passes
+	 * the 'pgd_t *' we return here to p4d_to_folded_pud(), which
+	 * will offset the pointer assuming that it points into
+	 * a page-table page. However, the fast GUP path passes us a
+	 * pgd_t allocated on the stack and so we must use the original
+	 * pointer in 'pgdp' to construct the p4d pointer instead of
+	 * using the generic p4d_offset_lockless() implementation.
+	 *
+	 * Note: reusing the original pointer means that we may
+	 * dereference the same (live) page-table entry multiple times.
+	 * This is safe because it is still only loaded once in the
+	 * context of each level and the CPU guarantees same-address
+	 * read-after-read ordering.
+	 */
+	return p4d_offset(pgdp, addr);
+}
+#define p4d_offset_lockless p4d_offset_lockless_folded
+
 #endif  /* CONFIG_PGTABLE_LEVELS > 4 */
 
 #define pgd_ERROR(e)	\


