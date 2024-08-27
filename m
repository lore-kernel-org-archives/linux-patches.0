Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89A21B4C4E;
	Tue, 27 Aug 2024 15:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770998; cv=none; b=aFvN5fdu2+a31uNArQm8AmQVaS5g3S7AO3bcfBVnMEhDizmXZsBX7vOMQFZHav6suSWyFMb241CWvgTX520MWy1fuJG+8Kcj3zbpohb72EAPiQKZy4gZBru2Jnfflasv+S9cuRn/tkV2bdzUSirSgGzaYP7ygAZ4Ac6SLaxX+YQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770998; c=relaxed/simple;
	bh=3cOXsv4A2Tk06gjWNrGRRpdCZSuUTDn5ad7ezTeOHck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JPc2LksgPOqg/oKfe1ncPw43P0Y8gzYZdGEuorH5VKMCZI0IwCy/wGSMKCpgnupiFHCnWIFnwTMKOY+uKWU28FhxZL4FYasabHAx3/AsWrMb+9gYhh9AKsbmjouNaBS0btDkur6YBIZc4W6I9BO6vL3cdNz1wRYJ85wUlFpenoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GZGfYhmu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GZGfYhmu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 005CAC61049;
	Tue, 27 Aug 2024 15:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770998;
	bh=3cOXsv4A2Tk06gjWNrGRRpdCZSuUTDn5ad7ezTeOHck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GZGfYhmu7W7+0MpwK1+haYI/E2vI28rjpjBqFPFJ/LjxlyU7zBFDzyvGGJg0yiWvf
	 BzE+lfGkgOab95N4zVbyDGZIm1fiurNXRiJYS2GuIg4MYtI9MchSvC/Rp3/PUX1FqA
	 7ekPk6I+dXpK0Yz4+wrOQzSRzYm/FfxPkH7qYd0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suren Baghdasaryan <surenb@google.com>,
	David Hildenbrand <david@redhat.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Kees Cook <keescook@chromium.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Sourav Panda <souravpanda@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.10 056/273] alloc_tag: introduce clear_page_tag_ref() helper function
Date: Tue, 27 Aug 2024 16:36:20 +0200
Message-ID: <20240827143835.532796134@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

From: Suren Baghdasaryan <surenb@google.com>

commit a8fc28dad6d574582cdf2f7e78c73c59c623df30 upstream.

In several cases we are freeing pages which were not allocated using
common page allocators.  For such cases, in order to keep allocation
accounting correct, we should clear the page tag to indicate that the page
being freed is expected to not have a valid allocation tag.  Introduce
clear_page_tag_ref() helper function to be used for this.

Link: https://lkml.kernel.org/r/20240813150758.855881-1-surenb@google.com
Fixes: d224eb0287fb ("codetag: debug: mark codetags for reserved pages as empty")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>	[6.10]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/pgalloc_tag.h |   13 +++++++++++++
 mm/mm_init.c                |   10 +---------
 mm/page_alloc.c             |    9 +--------
 3 files changed, 15 insertions(+), 17 deletions(-)

--- a/include/linux/pgalloc_tag.h
+++ b/include/linux/pgalloc_tag.h
@@ -43,6 +43,18 @@ static inline void put_page_tag_ref(unio
 	page_ext_put(page_ext_from_codetag_ref(ref));
 }
 
+static inline void clear_page_tag_ref(struct page *page)
+{
+	if (mem_alloc_profiling_enabled()) {
+		union codetag_ref *ref = get_page_tag_ref(page);
+
+		if (ref) {
+			set_codetag_empty(ref);
+			put_page_tag_ref(ref);
+		}
+	}
+}
+
 static inline void pgalloc_tag_add(struct page *page, struct task_struct *task,
 				   unsigned int nr)
 {
@@ -126,6 +138,7 @@ static inline void pgalloc_tag_sub_pages
 
 static inline union codetag_ref *get_page_tag_ref(struct page *page) { return NULL; }
 static inline void put_page_tag_ref(union codetag_ref *ref) {}
+static inline void clear_page_tag_ref(struct page *page) {}
 static inline void pgalloc_tag_add(struct page *page, struct task_struct *task,
 				   unsigned int nr) {}
 static inline void pgalloc_tag_sub(struct page *page, unsigned int nr) {}
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2507,15 +2507,7 @@ void __init memblock_free_pages(struct p
 	}
 
 	/* pages were reserved and not allocated */
-	if (mem_alloc_profiling_enabled()) {
-		union codetag_ref *ref = get_page_tag_ref(page);
-
-		if (ref) {
-			set_codetag_empty(ref);
-			put_page_tag_ref(ref);
-		}
-	}
-
+	clear_page_tag_ref(page);
 	__free_pages_core(page, order);
 }
 
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5806,14 +5806,7 @@ unsigned long free_reserved_area(void *s
 
 void free_reserved_page(struct page *page)
 {
-	if (mem_alloc_profiling_enabled()) {
-		union codetag_ref *ref = get_page_tag_ref(page);
-
-		if (ref) {
-			set_codetag_empty(ref);
-			put_page_tag_ref(ref);
-		}
-	}
+	clear_page_tag_ref(page);
 	ClearPageReserved(page);
 	init_page_count(page);
 	__free_page(page);


