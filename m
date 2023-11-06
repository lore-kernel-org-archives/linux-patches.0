Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B62B20316
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1+DPZ5Ks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB20FC433C7;
	Mon,  6 Nov 2023 13:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276515;
	bh=rGKwbo+5vc1rAat18CCob3XJIeQUYbtxYhsrhxCGDu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1+DPZ5KsPAM8uZe9WbvPdoQ47OHZUePpKUD9W0pEKNAx47dlXBpCJgDkG181QBqbG
	 h6ShyY08YjTJ8pwVedE+npIVXMh4afhpl7Gy+yoIPGKcQ3O/1GL2u+iPWxtmABBoG6
	 mL1BLr4qaQ1NbhW0JeabGpryM/ZW+r4ehh+13qek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lstoakes@gmail.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Jann Horn <jannh@google.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 44/62] mmap: fix error paths with dup_anon_vma()
Date: Mon,  6 Nov 2023 14:03:50 +0100
Message-ID: <20231106130303.379663343@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130301.807965064@linuxfoundation.org>
References: <20231106130301.807965064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liam R. Howlett <Liam.Howlett@oracle.com>

commit 824135c46b00df7fb369ec7f1f8607427bbebeb0 upstream.

When the calling function fails after the dup_anon_vma(), the
duplication of the anon_vma is not being undone.  Add the necessary
unlink_anon_vma() call to the error paths that are missing them.

This issue showed up during inspection of the error path in vma_merge()
for an unrelated vma iterator issue.

Users may experience increased memory usage, which may be problematic as
the failure would likely be caused by a low memory situation.

Link: https://lkml.kernel.org/r/20230929183041.2835469-3-Liam.Howlett@oracle.com
Fixes: d4af56c5c7c6 ("mm: start tracking VMAs with maple tree")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mmap.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -519,6 +519,7 @@ inline int vma_expand(struct ma_state *m
 	struct anon_vma *anon_vma = vma->anon_vma;
 	struct file *file = vma->vm_file;
 	bool remove_next = false;
+	struct vm_area_struct *anon_dup = NULL;
 
 	if (next && (vma != next) && (end == next->vm_end)) {
 		remove_next = true;
@@ -530,6 +531,8 @@ inline int vma_expand(struct ma_state *m
 			error = anon_vma_clone(vma, next);
 			if (error)
 				return error;
+
+			anon_dup = vma;
 		}
 	}
 
@@ -602,6 +605,9 @@ inline int vma_expand(struct ma_state *m
 	return 0;
 
 nomem:
+	if (anon_dup)
+		unlink_anon_vmas(anon_dup);
+
 	return -ENOMEM;
 }
 
@@ -629,6 +635,7 @@ int __vma_adjust(struct vm_area_struct *
 	int remove_next = 0;
 	MA_STATE(mas, &mm->mm_mt, 0, 0);
 	struct vm_area_struct *exporter = NULL, *importer = NULL;
+	struct vm_area_struct *anon_dup = NULL;
 
 	if (next && !insert) {
 		if (end >= next->vm_end) {
@@ -709,11 +716,17 @@ int __vma_adjust(struct vm_area_struct *
 			error = anon_vma_clone(importer, exporter);
 			if (error)
 				return error;
+
+			anon_dup = importer;
 		}
 	}
 
-	if (mas_preallocate(&mas, vma, GFP_KERNEL))
+	if (mas_preallocate(&mas, vma, GFP_KERNEL)) {
+		if (anon_dup)
+			unlink_anon_vmas(anon_dup);
+
 		return -ENOMEM;
+	}
 
 	vma_adjust_trans_huge(orig_vma, start, end, adjust_next);
 	if (file) {


