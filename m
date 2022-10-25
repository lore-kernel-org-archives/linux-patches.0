Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C33748E;
	Tue, 25 Oct 2022 17:34:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A339C433D6;
	Tue, 25 Oct 2022 17:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1666719284;
	bh=LmmlmDI/9NPsq0QGCvtmuqw5lnkthpFZOpXXgGIwnck=;
	h=From:To:Cc:Subject:Date:From;
	b=I3r1NmzfeNK3f9OJUJmeldgLvABnio6QcckHU/bm2RIjlbTKtrObTxxPL4/O7Mp3w
	 ZRuKxjgS3Kuc+MgOhoPNvRh5w3mr67uEiZffVCQV9yS+PcJGZcwNdUaZZ1LqqD5O7V
	 RNEGsknJIdTuq+k8MYu8JhgnPB95gdZHbMlSFIQde9DokxcmVy3Eu2DaSsStb3wCyM
	 0yiAw6ia96ErCi0S277hG50E8lUYTPo8ELvd7JpuCZUVgGRCMpdo8J0gij3vYhEjeB
	 XGDj1UQ6uOLkJNoCTsDoP/Mbv+smHZ3kFUprf+gYSrZyezDP1sOr+E5xETFNS4jIZW
	 HGua5UzcUHOJg==
From: Nathan Chancellor <nathan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gautam Menghani <gautammenghani201@gmail.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH] mm/khugepaged: Initialize index and nr in collapse_file()
Date: Tue, 25 Oct 2022 10:34:07 -0700
Message-Id: <20221025173407.3423241-1-nathan@kernel.org>
X-Mailer: git-send-email 2.38.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Clang warns (trimmed for brevity):

  mm/khugepaged.c:1729:7: warning: variable 'index' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
  mm/khugepaged.c:1716:6: warning: variable 'index' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
  mm/khugepaged.c:1729:7: warning: variable 'nr' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
  mm/khugepaged.c:1716:6: warning: variable 'nr' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]

There are two goto statements that will use index and nr before they
have been properly initialized. Zero initialize them so that they can be
safely used by the tracepoint at the end of the function.

Fixes: eae5270d3322 ("mm/khugepaged: add tracepoint to collapse_file()")
Link: https://github.com/ClangBuiltLinux/linux/issues/1749
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 mm/khugepaged.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 977c0ff82c46..789db2f3fc06 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1702,12 +1702,12 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 {
 	struct address_space *mapping = file->f_mapping;
 	struct page *hpage;
-	pgoff_t index, end = start + HPAGE_PMD_NR;
+	pgoff_t index = 0, end = start + HPAGE_PMD_NR;
 	LIST_HEAD(pagelist);
 	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
 	int nr_none = 0, result = SCAN_SUCCEED;
 	bool is_shmem = shmem_file(file);
-	int nr;
+	int nr = 0;
 
 	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
 	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));

base-commit: ec24a700584c4df869282bcd92b6d88329afe395
-- 
2.38.1

