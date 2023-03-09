Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25CE9944D
	for <patches@lists.linux.dev>; Thu,  9 Mar 2023 11:13:16 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0AD7A2003A;
	Thu,  9 Mar 2023 11:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1678360392; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ra+ZGGzJYIV0TLCmIAChn/kbsadv6V77veypyDRFCLA=;
	b=sfxic2yrLYOvf66YwRLo8vqMxBrnEtpeVOKZnduvnOFxfSBSWr+Ytm/xNhb5n20j255PvX
	t+du4oTVsh6QvJqua4oHxcROcbIiXrFamN2P9bqn5mT8G9WLrOHw+25Q7mZK++ja0cL8sB
	vwqwHI03IUf7LPghvULpND5TXoXN2lk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1678360392;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ra+ZGGzJYIV0TLCmIAChn/kbsadv6V77veypyDRFCLA=;
	b=ZVdLPchMQVSGJL1pIvlz6mWv9fXxKyxo2lYK74riQvY8KZIR2pdZpE3B6EqnBXl13tI9YV
	HySToS2GsUT+/YBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DD1311391B;
	Thu,  9 Mar 2023 11:13:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id iGVVNUe/CWRiRwAAMHmgww
	(envelope-from <vbabka@suse.cz>); Thu, 09 Mar 2023 11:13:11 +0000
From: Vlastimil Babka <vbabka@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Matthew Wilcox <willy@infradead.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	maple-tree@lists.infradead.org,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 08/10] mm/mmap/vma_merge: convert mergeability checks to return bool
Date: Thu,  9 Mar 2023 12:12:56 +0100
Message-Id: <20230309111258.24079-9-vbabka@suse.cz>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230309111258.24079-1-vbabka@suse.cz>
References: <20230309111258.24079-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The comments already mention returning 'true' so make the code match
them.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/mmap.c | 53 +++++++++++++++++++++++++----------------------------
 1 file changed, 25 insertions(+), 28 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index c51d69592e4e..d20bbe9ec613 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -744,10 +744,10 @@ int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
  * If the vma has a ->close operation then the driver probably needs to release
  * per-vma resources, so we don't attempt to merge those.
  */
-static inline int is_mergeable_vma(struct vm_area_struct *vma,
-				   struct file *file, unsigned long vm_flags,
-				   struct vm_userfaultfd_ctx vm_userfaultfd_ctx,
-				   struct anon_vma_name *anon_name)
+static inline bool is_mergeable_vma(struct vm_area_struct *vma,
+		struct file *file, unsigned long vm_flags,
+		struct vm_userfaultfd_ctx vm_userfaultfd_ctx,
+		struct anon_vma_name *anon_name)
 {
 	/*
 	 * VM_SOFTDIRTY should not prevent from VMA merging, if we
@@ -758,21 +758,20 @@ static inline int is_mergeable_vma(struct vm_area_struct *vma,
 	 * extended instead.
 	 */
 	if ((vma->vm_flags ^ vm_flags) & ~VM_SOFTDIRTY)
-		return 0;
+		return false;
 	if (vma->vm_file != file)
-		return 0;
+		return false;
 	if (vma->vm_ops && vma->vm_ops->close)
-		return 0;
+		return false;
 	if (!is_mergeable_vm_userfaultfd_ctx(vma, vm_userfaultfd_ctx))
-		return 0;
+		return false;
 	if (!anon_vma_name_eq(anon_vma_name(vma), anon_name))
-		return 0;
-	return 1;
+		return false;
+	return true;
 }
 
-static inline int is_mergeable_anon_vma(struct anon_vma *anon_vma1,
-					struct anon_vma *anon_vma2,
-					struct vm_area_struct *vma)
+static inline bool is_mergeable_anon_vma(struct anon_vma *anon_vma1,
+		 struct anon_vma *anon_vma2, struct vm_area_struct *vma)
 {
 	/*
 	 * The list_is_singular() test is to avoid merging VMA cloned from
@@ -780,7 +779,7 @@ static inline int is_mergeable_anon_vma(struct anon_vma *anon_vma1,
 	 */
 	if ((!anon_vma1 || !anon_vma2) && (!vma ||
 		list_is_singular(&vma->anon_vma_chain)))
-		return 1;
+		return true;
 	return anon_vma1 == anon_vma2;
 }
 
@@ -795,19 +794,18 @@ static inline int is_mergeable_anon_vma(struct anon_vma *anon_vma1,
  * indices (16TB on ia32) because do_mmap() does not permit mmap's which
  * wrap, nor mmaps which cover the final page at index -1UL.
  */
-static int
+static bool
 can_vma_merge_before(struct vm_area_struct *vma, unsigned long vm_flags,
-		     struct anon_vma *anon_vma, struct file *file,
-		     pgoff_t vm_pgoff,
-		     struct vm_userfaultfd_ctx vm_userfaultfd_ctx,
-		     struct anon_vma_name *anon_name)
+		struct anon_vma *anon_vma, struct file *file,
+		pgoff_t vm_pgoff, struct vm_userfaultfd_ctx vm_userfaultfd_ctx,
+		struct anon_vma_name *anon_name)
 {
 	if (is_mergeable_vma(vma, file, vm_flags, vm_userfaultfd_ctx, anon_name) &&
 	    is_mergeable_anon_vma(anon_vma, vma->anon_vma, vma)) {
 		if (vma->vm_pgoff == vm_pgoff)
-			return 1;
+			return true;
 	}
-	return 0;
+	return false;
 }
 
 /*
@@ -817,21 +815,20 @@ can_vma_merge_before(struct vm_area_struct *vma, unsigned long vm_flags,
  * We cannot merge two vmas if they have differently assigned (non-NULL)
  * anon_vmas, nor if same anon_vma is assigned but offsets incompatible.
  */
-static int
+static bool
 can_vma_merge_after(struct vm_area_struct *vma, unsigned long vm_flags,
-		    struct anon_vma *anon_vma, struct file *file,
-		    pgoff_t vm_pgoff,
-		    struct vm_userfaultfd_ctx vm_userfaultfd_ctx,
-		    struct anon_vma_name *anon_name)
+		struct anon_vma *anon_vma, struct file *file,
+		pgoff_t vm_pgoff, struct vm_userfaultfd_ctx vm_userfaultfd_ctx,
+		struct anon_vma_name *anon_name)
 {
 	if (is_mergeable_vma(vma, file, vm_flags, vm_userfaultfd_ctx, anon_name) &&
 	    is_mergeable_anon_vma(anon_vma, vma->anon_vma, vma)) {
 		pgoff_t vm_pglen;
 		vm_pglen = vma_pages(vma);
 		if (vma->vm_pgoff + vm_pglen == vm_pgoff)
-			return 1;
+			return true;
 	}
-	return 0;
+	return false;
 }
 
 /*
-- 
2.39.2

