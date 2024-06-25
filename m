Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90FE71465A8;
	Tue, 25 Jun 2024 09:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308754; cv=none; b=mDDeRE138sSJiIf7WvdkBo7P2a+42CMPaS53OC19edOLsakIIqqjN1bK4Srb3XQmCi1CzkFR/KNYx99QZhu1DCCc+WLN6K9tgrxaU/CGk5xIeuYo/Urz5XCNMRZ+5V48ePM/te6XEmInzkd1AKo47i38T6oUc64KvZ8pmBLFVyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308754; c=relaxed/simple;
	bh=NHc5rXdZdjA5KVThV3FRqnsqNqGpSrufy0WS9EK01/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b6w5Nz4yhTtI+dsFtIDtrSicfsc7rBdrwrqaIHIhii+vwaK0NbpeQmJKQYgmHi2AsEg3raPyhYu8NydnFhYNx7eu0AlZ375NtT5GhdxwVyAbUBqkYmE1EMECsjXNkiBfni38AVoZvRcEbK8X0sK+2ow4KlqT9R0J8TwHw2eIf7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CO9KCQ8N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CO9KCQ8N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5AFFC32781;
	Tue, 25 Jun 2024 09:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308754;
	bh=NHc5rXdZdjA5KVThV3FRqnsqNqGpSrufy0WS9EK01/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CO9KCQ8NpVieVCR/y9U5UcWCQzyUtyWr4LBOhnI0eoQ9V7MqzgZJwKqprHJFAL2Zv
	 HLBx+aSQWeKrUpDaU0JyCM3brX+uypmqfoa3R2KLJrB8+NlnQYg+RAeArVW/u2So+u
	 cjVFLPTyWXuj1bw26D9Y72rvgLNVse/BqBz6Lv64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Xu <peterx@redhat.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.9 227/250] mm/page_table_check: fix crash on ZONE_DEVICE
Date: Tue, 25 Jun 2024 11:33:05 +0200
Message-ID: <20240625085556.764183767@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Xu <peterx@redhat.com>

commit 8bb592c2eca8fd2bc06db7d80b38da18da4a2f43 upstream.

Not all pages may apply to pgtable check.  One example is ZONE_DEVICE
pages: they map PFNs directly, and they don't allocate page_ext at all
even if there's struct page around.  One may reference
devm_memremap_pages().

When both ZONE_DEVICE and page-table-check enabled, then try to map some
dax memories, one can trigger kernel bug constantly now when the kernel
was trying to inject some pfn maps on the dax device:

 kernel BUG at mm/page_table_check.c:55!

While it's pretty legal to use set_pxx_at() for ZONE_DEVICE pages for page
fault resolutions, skip all the checks if page_ext doesn't even exist in
pgtable checker, which applies to ZONE_DEVICE but maybe more.

Link: https://lkml.kernel.org/r/20240605212146.994486-1-peterx@redhat.com
Fixes: df4e817b7108 ("mm: page table check")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_table_check.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/mm/page_table_check.c
+++ b/mm/page_table_check.c
@@ -71,6 +71,9 @@ static void page_table_check_clear(unsig
 	page = pfn_to_page(pfn);
 	page_ext = page_ext_get(page);
 
+	if (!page_ext)
+		return;
+
 	BUG_ON(PageSlab(page));
 	anon = PageAnon(page);
 
@@ -108,6 +111,9 @@ static void page_table_check_set(unsigne
 	page = pfn_to_page(pfn);
 	page_ext = page_ext_get(page);
 
+	if (!page_ext)
+		return;
+
 	BUG_ON(PageSlab(page));
 	anon = PageAnon(page);
 
@@ -138,7 +144,10 @@ void __page_table_check_zero(struct page
 	BUG_ON(PageSlab(page));
 
 	page_ext = page_ext_get(page);
-	BUG_ON(!page_ext);
+
+	if (!page_ext)
+		return;
+
 	for (i = 0; i < (1ul << order); i++) {
 		struct page_table_check *ptc = get_page_table_check(page_ext);
 


