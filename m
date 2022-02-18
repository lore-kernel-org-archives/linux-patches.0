Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2FF320F
	for <patches@lists.linux.dev>; Fri, 18 Feb 2022 12:21:41 +0000 (UTC)
Received: by mail-ej1-f52.google.com with SMTP id qk11so14672979ejb.2
        for <patches@lists.linux.dev>; Fri, 18 Feb 2022 04:21:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K9wD2Tr0KWFRwLLWFyz8BogF6D34vQqJ2tLSqwNrziY=;
        b=f894Oja0ePJSA3RxY1LN0hdK2YQrjn1gxhMzZU+xzq6qi0xHMLoxnxvT4ddpsm2RJY
         HLIOBTRmGR2mUDCeXMXugR5d4VGHIOlXe7xqB0FiOY6buAJUUw7AK1Tx7CbkIQ4P6TG5
         0MsFuge5LxVPFGg9z5QE6rFGWa152KtVJxJjn6ILg3xeIC/WoPZ2gUnKeHv46AT1lbtv
         MYSFkdPz9/sQxPcCPMXZevKjjg+hl17dURo+b/gGozQ21wgsSc1n23KNT5dmAp8UWXqv
         R+C5f06QDVXDAGf5MEtsYiCLrLyjJOFSO41PSKJ/OxMJeWcmVQJhcs7qkmQBVGl1vIpI
         36rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K9wD2Tr0KWFRwLLWFyz8BogF6D34vQqJ2tLSqwNrziY=;
        b=Pk3Nd8ge7JnKbi6yaH79C3GTinwlURtDChj5NIA2w/myAoAHivZdgGexX4Gj2D+g8n
         55/SWPKYJTUiNnTCu2J5ij8TqbH9TT9qFEv0MFU0eLOAga5teJmqgdWIFWqXh3IklN/w
         LFNop59KsGofTGV8fSz0BwseZs7ve3oVTjMlMDd/HhH32VCCl7UGMasJxHcPXuRyWLwX
         3LtNhZbDHgllWXZ+St8yirMdiFq9hAYSK6R1B56s0YtEZvIDOgp9zRGUQlVte+KkWTXv
         m96aFiKuV0AAx3V9BIcc2HVQoWBiImdQ4qia1y7muzJzOxlzINpTq1w8vjmdj3k9Kwz+
         lMYQ==
X-Gm-Message-State: AOAM5308pCL9HeWr2N2gy14ERbAdns2wHZ2xWZkeeJXVO3ccJVrDlo9P
	u/7pp/35ciOLiRWxEsr2jGE=
X-Google-Smtp-Source: ABdhPJxcgIZ+10B44aMtj9wOPRGY7/4HPeI8NqgjmXec4wFs3wYKpL0ExtoiBsWf7RxBrDdDrvp5Fw==
X-Received: by 2002:a17:906:3708:b0:6cf:bb34:9d2e with SMTP id d8-20020a170906370800b006cfbb349d2emr6083708ejc.665.1645186896545;
        Fri, 18 Feb 2022 04:21:36 -0800 (PST)
Received: from orion.localdomain ([93.99.228.15])
        by smtp.gmail.com with ESMTPSA id e18sm4736506edj.85.2022.02.18.04.21.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 04:21:35 -0800 (PST)
Received: by orion.localdomain (Postfix, from userid 1003)
	id 49536A7FFD; Fri, 18 Feb 2022 13:20:44 +0100 (CET)
From: =?UTF-8?q?Jakub=20Mat=C4=9Bna?= <matenajakub@gmail.com>
To: linux-mm@kvack.org
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	vbabka@suse.cz,
	mhocko@kernel.org,
	mgorman@techsingularity.net,
	willy@infradead.org,
	liam.howlett@oracle.com,
	hughd@google.com,
	kirill@shutemov.name,
	riel@surriel.com,
	rostedt@goodmis.org,
	peterz@infradead.org,
	=?UTF-8?q?Jakub=20Mat=C4=9Bna?= <matenajakub@gmail.com>
Subject: [RFC PATCH 3/4] [PATCH 3/4] mm: enable merging of VMAs with different anon_vmas
Date: Fri, 18 Feb 2022 13:20:18 +0100
Message-Id: <20220218122019.130274-4-matenajakub@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220218122019.130274-1-matenajakub@gmail.com>
References: <20220218122019.130274-1-matenajakub@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Enable merging of a VMA even when it is linked to different
anon_vma than the one it is being merged to, but only if the VMA
in question does not share any page with a parent or child process.
Every anonymous page stores a pointer to its anon_vma in the parameter
mapping, which is now updated as part of the merge process.

Signed-off-by: Jakub Matěna <matenajakub@gmail.com>
---
 include/linux/rmap.h | 17 ++++++++++++++++-
 mm/mmap.c            | 15 ++++++++++++++-
 mm/rmap.c            | 40 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 70 insertions(+), 2 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index e704b1a4c06c..c8508a4ebc46 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -137,10 +137,13 @@ static inline void anon_vma_unlock_read(struct anon_vma *anon_vma)
  */
 void anon_vma_init(void);	/* create anon_vma_cachep */
 int  __anon_vma_prepare(struct vm_area_struct *);
+void reconnect_pages(struct vm_area_struct *vma, struct vm_area_struct *next);
 void unlink_anon_vmas(struct vm_area_struct *);
 int anon_vma_clone(struct vm_area_struct *, struct vm_area_struct *);
 int anon_vma_fork(struct vm_area_struct *, struct vm_area_struct *);
 
+bool rbt_no_children(struct anon_vma *av);
+
 static inline int anon_vma_prepare(struct vm_area_struct *vma)
 {
 	if (likely(vma->anon_vma))
@@ -149,10 +152,22 @@ static inline int anon_vma_prepare(struct vm_area_struct *vma)
 	return __anon_vma_prepare(vma);
 }
 
+/**
+ * anon_vma_merge() - Merge anon_vmas of the given VMAs
+ * @vma: VMA being merged to
+ * @next: VMA being merged
+ */
 static inline void anon_vma_merge(struct vm_area_struct *vma,
 				  struct vm_area_struct *next)
 {
-	VM_BUG_ON_VMA(vma->anon_vma != next->anon_vma, vma);
+	struct anon_vma *anon_vma1 = vma->anon_vma;
+	struct anon_vma *anon_vma2 = next->anon_vma;
+
+	VM_BUG_ON_VMA(anon_vma1 && anon_vma2 && anon_vma1 != anon_vma2 &&
+			((anon_vma2 != anon_vma2->root)
+			|| !rbt_no_children(anon_vma2)), vma);
+
+	reconnect_pages(vma, next);
 	unlink_anon_vmas(next);
 }
 
diff --git a/mm/mmap.c b/mm/mmap.c
index 8d253b46b349..ed91d0cd2111 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1065,7 +1065,20 @@ static inline int is_mergeable_anon_vma(struct anon_vma *anon_vma1,
 	if ((!anon_vma1 || !anon_vma2) && (!vma ||
 		list_is_singular(&vma->anon_vma_chain)))
 		return 1;
-	return anon_vma1 == anon_vma2;
+	if (anon_vma1 == anon_vma2)
+		return 1;
+	/*
+	 * Different anon_vma but not shared by several processes
+	 */
+	else if ((anon_vma1 && anon_vma2) &&
+			(anon_vma1 == anon_vma1->root)
+			&& (rbt_no_children(anon_vma1)))
+		return 1;
+	/*
+	 * Different anon_vma and shared -> unmergeable
+	 */
+	else
+		return 0;
 }
 
 /*
diff --git a/mm/rmap.c b/mm/rmap.c
index 6a1e8c7f6213..1093b518b0be 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -387,6 +387,46 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
 	return -ENOMEM;
 }
 
+/**
+ * reconnect_pages() - Reconnect physical pages from old to vma
+ * @vma: VMA to newly contain all physical pages of old
+ * @old: old VMA being merged to vma
+ */
+void reconnect_pages(struct vm_area_struct *vma, struct vm_area_struct *old)
+{
+	struct anon_vma *anon_vma1 = vma->anon_vma;
+	struct anon_vma *anon_vma2 = old->anon_vma;
+	unsigned long pg_iter;
+	int pg_iters;
+
+	if (anon_vma1 == anon_vma2 || anon_vma1 == NULL || anon_vma2 == NULL)
+		return; /* Nothing to do */
+
+	/* Modify page->mapping for all pages in old */
+	pg_iter = 0;
+	pg_iters = (old->vm_end - old->vm_start) >> PAGE_SHIFT;
+
+	for (; pg_iter < pg_iters; ++pg_iter) {
+		/* Get the physical page */
+		unsigned long shift = pg_iter << PAGE_SHIFT;
+		struct page *phys_page = follow_page(old, old->vm_start + shift, FOLL_GET);
+		struct anon_vma *page_anon_vma;
+
+		/* Do some checks and lock the page */
+		if (phys_page == NULL)
+			continue; /* Virtual memory page is not mapped */
+		lock_page(phys_page);
+		page_anon_vma = page_get_anon_vma(phys_page);
+		if (page_anon_vma != NULL) { /* NULL in case of ZERO_PAGE */
+			VM_BUG_ON_VMA(page_anon_vma != old->anon_vma, old);
+			/* Update physical page's mapping */
+			page_move_anon_rmap(phys_page, vma);
+		}
+		unlock_page(phys_page);
+		put_page(phys_page);
+	}
+}
+
 void unlink_anon_vmas(struct vm_area_struct *vma)
 {
 	struct anon_vma_chain *avc, *next;
-- 
2.34.1

