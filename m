Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50FC05FF07;
	Tue, 13 Feb 2024 17:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845479; cv=none; b=kwIhKeabiT5CGDkUjBtuupSvg2ze/t40uyIKHi6ZJxAoAZYRoopkhWPPfRPyZxXvG+3lrgBJDf5Tw+LN58pZoJX4reY808DU6OjzXNKzebKi1mv80jG0V4E2K5V9xNvym0nRaGCziktVKMt9ro5WQA1WRb7y1h6vU55LStpOSrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845479; c=relaxed/simple;
	bh=zjWZlE2K13bDSXrJg9x4hKn8iHracqYGELInyaogdPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i2v02aGmiUnqb1ow2u7lRiXhAREZufbW0FvMq4oCTyE6tGAXDUAWRmeuxZLIO9HYmnTsW4xXtkY1Hu6Lc/cpWTJH0pA9HNRaji7/6g/yL64rn/vhF6Wo3sH+7q99cQwIdhFm/z5KUhW/h+GfbsO+JvuMyWhQ8TPLV+qoLZTt/oA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dqLie/cL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dqLie/cL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B74CC43399;
	Tue, 13 Feb 2024 17:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845478;
	bh=zjWZlE2K13bDSXrJg9x4hKn8iHracqYGELInyaogdPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dqLie/cL7Rs146OlqNtne1bf1BF4anbVXXZI+Oobm/XtOSWl9iq0pWUaUHLdZicm3
	 1dcnfWkA5RkDDOFuYGl+mW9klgRPUfW0zPbvYbLt14Nf7YzmWbQuEkQPM+rQWIF2V8
	 3jLA97P0dJK3FCVcIzU0C0cJr59n/mYjS10ue8nU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 091/121] riscv: Fix hugetlb_mask_last_page() when NAPOT is enabled
Date: Tue, 13 Feb 2024 18:21:40 +0100
Message-ID: <20240213171855.650057026@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



