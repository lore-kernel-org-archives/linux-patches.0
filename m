Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D104DF4F
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:51:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA671C433EF;
	Mon, 12 Jun 2023 10:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686567088;
	bh=Vnbick4RJXlfh24XruZNTJh4Ohsn/YfZcReCxvslzyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L1pPbNZ0T+1bY/k4f73GB4n/j9m2ArPPwY6GUdTuSbiZZyVo6ptF2ZtPZGT3DKwXe
	 hKwiFcfzkNTiXqspp5k2tKyG4M3oiRA4kNXj2PSB53lc3fxGxga1vd+9AE7cIx4wSM
	 ss/lGeDOgGxCIlamAfTtQkyH95nhba6cX5jrKTEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+fcf1a817ceb50935ce99@syzkaller.appspotmail.com,
	Ruihan Li <lrh2000@pku.edu.cn>,
	Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: [PATCH 6.3 117/160] mm: page_table_check: Ensure user pages are not slab pages
Date: Mon, 12 Jun 2023 12:27:29 +0200
Message-ID: <20230612101720.413588422@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
References: <20230612101715.129581706@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ruihan Li <lrh2000@pku.edu.cn>

commit 44d0fb387b53e56c8a050bac5c7d460e21eb226f upstream.

The current uses of PageAnon in page table check functions can lead to
type confusion bugs between struct page and slab [1], if slab pages are
accidentally mapped into the user space. This is because slab reuses the
bits in struct page to store its internal states, which renders PageAnon
ineffective on slab pages.

Since slab pages are not expected to be mapped into the user space, this
patch adds BUG_ON(PageSlab(page)) checks to make sure that slab pages
are not inadvertently mapped. Otherwise, there must be some bugs in the
kernel.

Reported-by: syzbot+fcf1a817ceb50935ce99@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/lkml/000000000000258e5e05fae79fc1@google.com/ [1]
Fixes: df4e817b7108 ("mm: page table check")
Cc: <stable@vger.kernel.org> # 5.17
Signed-off-by: Ruihan Li <lrh2000@pku.edu.cn>
Acked-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Link: https://lore.kernel.org/r/20230515130958.32471-5-lrh2000@pku.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/page-flags.h |    6 ++++++
 mm/page_table_check.c      |    6 ++++++
 2 files changed, 12 insertions(+)

--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -630,6 +630,12 @@ PAGEFLAG_FALSE(VmemmapSelfHosted, vmemma
  * Please note that, confusingly, "page_mapping" refers to the inode
  * address_space which maps the page from disk; whereas "page_mapped"
  * refers to user virtual address space into which the page is mapped.
+ *
+ * For slab pages, since slab reuses the bits in struct page to store its
+ * internal states, the page->mapping does not exist as such, nor do these
+ * flags below.  So in order to avoid testing non-existent bits, please
+ * make sure that PageSlab(page) actually evaluates to false before calling
+ * the following functions (e.g., PageAnon).  See mm/slab.h.
  */
 #define PAGE_MAPPING_ANON	0x1
 #define PAGE_MAPPING_MOVABLE	0x2
--- a/mm/page_table_check.c
+++ b/mm/page_table_check.c
@@ -71,6 +71,8 @@ static void page_table_check_clear(struc
 
 	page = pfn_to_page(pfn);
 	page_ext = page_ext_get(page);
+
+	BUG_ON(PageSlab(page));
 	anon = PageAnon(page);
 
 	for (i = 0; i < pgcnt; i++) {
@@ -107,6 +109,8 @@ static void page_table_check_set(struct
 
 	page = pfn_to_page(pfn);
 	page_ext = page_ext_get(page);
+
+	BUG_ON(PageSlab(page));
 	anon = PageAnon(page);
 
 	for (i = 0; i < pgcnt; i++) {
@@ -133,6 +137,8 @@ void __page_table_check_zero(struct page
 	struct page_ext *page_ext;
 	unsigned long i;
 
+	BUG_ON(PageSlab(page));
+
 	page_ext = page_ext_get(page);
 	BUG_ON(!page_ext);
 	for (i = 0; i < (1ul << order); i++) {


