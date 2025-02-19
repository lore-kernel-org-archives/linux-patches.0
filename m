Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 936881AF0C0;
	Wed, 19 Feb 2025 09:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955934; cv=none; b=VSjvjQtA0ZjTscOv7qRGGt5Csy+XZ1O2+RDJY08YxZhcmlMGJM+drp4/QtdxnseoD5RX9tjTsvYSMyJ3TsSumFb76renRwUZnynfrXe8qDGLcZgSsABoiHYgoTWAe+m+ZvC7pTKWotoZhxLIRDY7qmdqucWFDrjM8b6ppKqoO2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955934; c=relaxed/simple;
	bh=6ILATVrFTbSRaj2Rf+66RtZ2Rash7pkCFJBo1cF6ozc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jvTRDvegM4mIooXpl9JKA6gfw3viHS2MydhRKWnqKIatia+bJs4fBFuZsEp2wAhzJW2Iz9QW5YJ9CMx/1pzjwpYLkJLFchbJMDkUIBU0Uxk25vbmWBgZIYoO9qGoH/Skgo8yURW5G8QP1DEnMaT2d0OIgSz7BmeCpBnPzSY06So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KipWL/r1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KipWL/r1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B8F7C4CED1;
	Wed, 19 Feb 2025 09:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955934;
	bh=6ILATVrFTbSRaj2Rf+66RtZ2Rash7pkCFJBo1cF6ozc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KipWL/r1l0YZouczGkcXFQ18SUC2qqgI28E8HTdFn3FfRMAWvPEy7nqlvC7RjkFvc
	 qSvf3NwgDdcf0KfnKcwB8Kq1DvuUJMVc1ag8YA1uXpVGg9GPutOMxyJV4bejb7hMdi
	 tEjJ3keFEi6Ufb/M0m1RsmZqKwQq7NRpc+sM2JuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 001/578] powerpc/book3s64/hugetlb: Fix disabling hugetlb when fadump is active
Date: Wed, 19 Feb 2025 09:20:05 +0100
Message-ID: <20250219082652.955915634@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sourabh Jain <sourabhjain@linux.ibm.com>

[ Upstream commit d629d7a8efc33d05d62f4805c0ffb44727e3d99f ]

Commit 8597538712eb ("powerpc/fadump: Do not use hugepages when fadump
is active") disabled hugetlb support when fadump is active by returning
early from hugetlbpage_init():arch/powerpc/mm/hugetlbpage.c and not
populating hpage_shift/HPAGE_SHIFT.

Later, commit 2354ad252b66 ("powerpc/mm: Update default hugetlb size
early") moved the allocation of hpage_shift/HPAGE_SHIFT to early boot,
which inadvertently re-enabled hugetlb support when fadump is active.

Fix this by implementing hugepages_supported() on powerpc. This ensures
that disabling hugetlb for the fadump kernel is independent of
hpage_shift/HPAGE_SHIFT.

Fixes: 2354ad252b66 ("powerpc/mm: Update default hugetlb size early")
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20241217074640.1064510-1-sourabhjain@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/hugetlb.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/powerpc/include/asm/hugetlb.h b/arch/powerpc/include/asm/hugetlb.h
index ea71f7245a63e..8d8f4909ae1a4 100644
--- a/arch/powerpc/include/asm/hugetlb.h
+++ b/arch/powerpc/include/asm/hugetlb.h
@@ -15,6 +15,15 @@
 
 extern bool hugetlb_disabled;
 
+static inline bool hugepages_supported(void)
+{
+	if (hugetlb_disabled)
+		return false;
+
+	return HPAGE_SHIFT != 0;
+}
+#define hugepages_supported hugepages_supported
+
 void __init hugetlbpage_init_defaultsize(void);
 
 int slice_is_hugepage_only_range(struct mm_struct *mm, unsigned long addr,
-- 
2.39.5



