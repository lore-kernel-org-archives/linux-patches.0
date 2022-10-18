Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57404C7C;
	Tue, 18 Oct 2022 15:27:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5B8AC433C1;
	Tue, 18 Oct 2022 15:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1666106852;
	bh=ndYwEDeqYYf4sJcQ9WB423y7Tx/pDZ5xDnUm1T2vjNg=;
	h=From:To:Cc:Subject:Date:From;
	b=CpLiFvwhxFyJUQGrqKFPYaQRniijzGx0jLG31Dy+yGr2tkELrWR415sTtbsx4TTA2
	 URCcynPkdMHjuB0hEgY6DSKXGUVuEpfBvjq7QT39MIuJz23UlelcqoYEacuPYt/6g6
	 If/P3tMGCjPT6/SdnDaZXUFRM8Z+VpchrR+LKbCaihSrF4TVksVMoyAsktduG2klHm
	 gcyUbW1nOQXJH0nBOPoelJrEIR/uZQp2i8fE8ZQtG6LU0b4I6yVxzZRt2o5yqHO4H0
	 zEKczOCamb8aKxGy5Kdmcye/VXvGpY+HF1TM6S7PAXW/ap4x1GsB6PvcnWGe5xtzv6
	 D7LNE+8Cy6OaA==
From: Nathan Chancellor <nathan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <dan.j.williams@intel.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH] mm/memremap: Mark folio_span_valid() as __maybe_unused
Date: Tue, 18 Oct 2022 08:26:46 -0700
Message-Id: <20221018152645.3195108-1-nathan@kernel.org>
X-Mailer: git-send-email 2.38.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When building without CONFIG_DEBUG_VM, clang warns:

  mm/memremap.c:495:13: error: function 'folio_span_valid' is not needed and will not be emitted [-Werror,-Wunneeded-internal-declaration]
  static bool folio_span_valid(struct dev_pagemap *pgmap, struct folio *folio,
              ^
  1 error generated.

folio_span_valid() is only used within a instance of VM_WARN_ON_ONCE(),
which evaluates to BUILD_BUG_ON_INVALID() with CONFIG_DEBUG_VM=n, which
ultimately resolves to sizeof(), which is fully resolved at compile
time. Basically, the warning is flagging that folio_span_valid() is
only used in a compile time context and will not be called at run time.

Since this is expected given the configuration, mark folio_span_valid()
as __maybe_unused so that there is no warning.

Fixes: 07108d5bfeeb ("fsdax: introduce pgmap_request_folios()")
Link: https://github.com/ClangBuiltLinux/linux/issues/1739
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---

I am aware the Fixes SHA is probably not stable but I figured I would
include it anyways.

 mm/memremap.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/memremap.c b/mm/memremap.c
index 53fe30bb79bb..02b796749b72 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -492,8 +492,9 @@ void free_zone_device_page(struct page *page)
 	put_dev_pagemap(page->pgmap);
 }
 
-static bool folio_span_valid(struct dev_pagemap *pgmap, struct folio *folio,
-			     int nr_folios)
+static __maybe_unused bool folio_span_valid(struct dev_pagemap *pgmap,
+					    struct folio *folio,
+					    int nr_folios)
 {
 	unsigned long pfn_start, pfn_end;
 

base-commit: f5938bbbb79d48ca167e305c228dccbecea0309e
-- 
2.38.0

