Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E13A93C;
	Tue, 13 Feb 2024 17:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845856; cv=none; b=N0hUPuC+isFFOlBVf3gmU+kJKpgkqzRxbfjyzyyEBf2mzSoKj05459RCEkWkCpMGUR2MKc7MqbmwMxI4J01e3Dd+c1grf3evrRIv7hg7zy8OY6XrmIQgpTzmAs/zceASyGijPIN5EIByn5h6v8PShnNVrWHP338uprK9VnBWPUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845856; c=relaxed/simple;
	bh=Vmik+8OSdWZidL1Bzm90Ta3FzUda74iueP+hMOdLQc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XNCOTfpzeOObEiMVoPX6pbMLr1eRda230eL8DkFOcjO91Rrr313sV0x6o3qHLK9mkf00vn3D5AgcL0mM9YqcUmRuvlfCkujIsRhu/D7VaQohG616ZJw80F3ZH+eXms5YYf5NV5JMrQxQ9v0fjPNmJu6UyWzgkDTmmL7CW9ASc5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WDvc9UBI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WDvc9UBI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7363BC433C7;
	Tue, 13 Feb 2024 17:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845855;
	bh=Vmik+8OSdWZidL1Bzm90Ta3FzUda74iueP+hMOdLQc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WDvc9UBIYpvlYgL/6cqjiGFtophN1yGCUgbeu9BQLQvR1QcABoPheJsvXxEpIM9uN
	 118bAU4zrr/RzZ65Fc1kEPpLJcnOzkyjfNxE/UT0yB3Ea3ZIw4Ll4b1fS8Foziiz1f
	 lgnxs8PKKjEickbgRc0ZIflRJ+cZLzBKKECRCjto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 076/124] riscv: Fix hugetlb_mask_last_page() when NAPOT is enabled
Date: Tue, 13 Feb 2024 18:21:38 +0100
Message-ID: <20240213171855.956840388@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

From: Alexandre Ghiti <alexghiti@rivosinc.com>

[ Upstream commit a179a4bfb694f80f2709a1d0398469e787acb974 ]

When NAPOT is enabled, a new hugepage size is available and then we need
to make hugetlb_mask_last_page() aware of that.

Fixes: 82a1a1f3bfb6 ("riscv: mm: support Svnapot in hugetlb page")
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20240117195741.1926459-3-alexghiti@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/mm/hugetlbpage.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/riscv/mm/hugetlbpage.c b/arch/riscv/mm/hugetlbpage.c
index 24c0179565d8..87af75ee7186 100644
--- a/arch/riscv/mm/hugetlbpage.c
+++ b/arch/riscv/mm/hugetlbpage.c
@@ -125,6 +125,26 @@ pte_t *huge_pte_offset(struct mm_struct *mm,
 	return pte;
 }
 
+unsigned long hugetlb_mask_last_page(struct hstate *h)
+{
+	unsigned long hp_size = huge_page_size(h);
+
+	switch (hp_size) {
+#ifndef __PAGETABLE_PMD_FOLDED
+	case PUD_SIZE:
+		return P4D_SIZE - PUD_SIZE;
+#endif
+	case PMD_SIZE:
+		return PUD_SIZE - PMD_SIZE;
+	case napot_cont_size(NAPOT_CONT64KB_ORDER):
+		return PMD_SIZE - napot_cont_size(NAPOT_CONT64KB_ORDER);
+	default:
+		break;
+	}
+
+	return 0UL;
+}
+
 static pte_t get_clear_contig(struct mm_struct *mm,
 			      unsigned long addr,
 			      pte_t *ptep,
-- 
2.43.0



