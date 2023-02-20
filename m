Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B510363BB
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 14:01:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1273DC4339B;
	Mon, 20 Feb 2023 14:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901668;
	bh=zrGoJVqkNW6P6S0nFa0ohHG8qteJSMg9elOhcc7gsMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wmFAeOVHRtVl4VtPFjEA9oXd5cwhB7xpsqzifUARqtw5DuY78ZfVHiu4kFGV2GHTh
	 U9DTWE/7nbphlzlu2MXsatTW+guVgdnyFz9efrS7WE/GnQCxGxsKbHsKA9y8Ls/mdc
	 Gbv0adVCtxSVbRwXOBX+QwJuYsZ8xyEbcgBXj9Z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Michal Hocko <mhocko@suse.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Duyck <alexander.h.duyck@linux.intel.com>,
	Alexander Potapenko <glider@google.com>,
	Alex Sierra <alex.sierra@amd.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@Oracle.com>,
	Matthew Wilcox <willy@infradead.org>,
	Naoya Horiguchi <naoya.horiguchi@nec.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 106/118] mm: extend max struct page size for kmsan
Date: Mon, 20 Feb 2023 14:37:02 +0100
Message-Id: <20230220133604.638626624@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

commit 3770e52fd4ec40ebee16ba19ad6c09dc0b52739b upstream.

After x86 enabled support for KMSAN, it has become possible to have larger
'struct page' than was expected when commit 5470dea49f53 ("mm: use
mm_zero_struct_page from SPARC on all 64b architectures") was merged:

include/linux/mm.h:156:10: warning: no case matching constant switch condition '96'
        switch (sizeof(struct page)) {

Extend the maximum accordingly.

Link: https://lkml.kernel.org/r/20230130130739.563628-1-arnd@kernel.org
Fixes: 5470dea49f53 ("mm: use mm_zero_struct_page from SPARC on all 64b architectures")
Fixes: 4ca8cc8d1bbe ("x86: kmsan: enable KMSAN builds for x86")
Fixes: f80be4571b19 ("kmsan: add KMSAN runtime core")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Alex Sierra <alex.sierra@amd.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mm.h |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -136,7 +136,7 @@ extern int mmap_rnd_compat_bits __read_m
  * define their own version of this macro in <asm/pgtable.h>
  */
 #if BITS_PER_LONG == 64
-/* This function must be updated when the size of struct page grows above 80
+/* This function must be updated when the size of struct page grows above 96
  * or reduces below 56. The idea that compiler optimizes out switch()
  * statement, and only leaves move/store instructions. Also the compiler can
  * combine write statements if they are both assignments and can be reordered,
@@ -147,12 +147,18 @@ static inline void __mm_zero_struct_page
 {
 	unsigned long *_pp = (void *)page;
 
-	 /* Check that struct page is either 56, 64, 72, or 80 bytes */
+	 /* Check that struct page is either 56, 64, 72, 80, 88 or 96 bytes */
 	BUILD_BUG_ON(sizeof(struct page) & 7);
 	BUILD_BUG_ON(sizeof(struct page) < 56);
-	BUILD_BUG_ON(sizeof(struct page) > 80);
+	BUILD_BUG_ON(sizeof(struct page) > 96);
 
 	switch (sizeof(struct page)) {
+	case 96:
+		_pp[11] = 0;
+		fallthrough;
+	case 88:
+		_pp[10] = 0;
+		fallthrough;
 	case 80:
 		_pp[9] = 0;
 		fallthrough;


