Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91BBF33FE
	for <patches@lists.linux.dev>; Fri, 24 Feb 2023 10:00:43 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BC0165C9DD;
	Fri, 24 Feb 2023 10:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1677232841; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qDnc8EEjpBsvOiKhZLRnNlYD59HvUD8m9uXQyW8ks/U=;
	b=3SY5VXphxPVip2cwgUzC6lOWoIxu1TXkew7APj+jPzBAf+IlC6a+bzrUBpg63peJcBGHgr
	cQFjIVUoPpBegCvEWaQsz64Y+C80k+5H8a8EqUuJnoxNEeuD8LnbyXtsDJb82TeOS1psl/
	rgX7BNLG6B6ql4Gt/2iGE9eMUm/p2mI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1677232841;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qDnc8EEjpBsvOiKhZLRnNlYD59HvUD8m9uXQyW8ks/U=;
	b=/jIAtMOp3EUMEalc7cG90G5k2mOZB7brQnDVETi/NY6CKBucBfOljhQr8Ndj1oWYSVgzl4
	VsE7Pr3tVwvZdyAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6D09F13246;
	Fri, 24 Feb 2023 10:00:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id iAsMGsmK+GPeTgAAMHmgww
	(envelope-from <vbabka@suse.cz>); Fri, 24 Feb 2023 10:00:41 +0000
From: Vlastimil Babka <vbabka@suse.cz>
To: linux-mm@kvack.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	maple-tree@lists.infradead.org,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [RFC 04/11] mm/mmap/vma_merge: use the proper vma pointers in cases 1 and 6
Date: Fri, 24 Feb 2023 11:00:15 +0100
Message-Id: <20230224100022.11268-5-vbabka@suse.cz>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230224100022.11268-1-vbabka@suse.cz>
References: <20230224100022.11268-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Case 1 is now shown in the comment as next vma being merged with prev,
so use 'next' instead of 'mid'. In case 1 they both point to the same
vma.

As a consequence, in case 6, the dup_anon_vma() is now tried first on
'next' and then on 'mid', before it was the opposite order. This is not
a functional change, as those two vma's cannnot have a different
anon_vma, as that would have prevented the merging in the first place.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/mmap.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 1af4c9bc2c87..704afa278a98 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -605,7 +605,7 @@ static inline void vma_complete(struct vma_prepare *vp,
 
 		/*
 		 * In mprotect's case 6 (see comments on vma_merge),
-		 * we must remove the one after next as well.
+		 * we are removing both mid and next vma's
 		 */
 		if (vp->remove2) {
 			vp->remove = vp->remove2;
@@ -948,13 +948,14 @@ struct vm_area_struct *vma_merge(struct vma_iterator *vmi, struct mm_struct *mm,
 	/* Can we merge both the predecessor and the successor? */
 	if (merge_prev && merge_next &&
 	    is_mergeable_anon_vma(prev->anon_vma, next->anon_vma, NULL)) {
-		remove = mid;				/* case 1 */
+		remove = next;				/* case 1 */
 		vma_end = next->vm_end;
-		err = dup_anon_vma(prev, mid);
+		err = dup_anon_vma(prev, next);
 		if (mid != next) {			/* case 6 */
+			remove = mid;
 			remove2 = next;
-			if (!mid->anon_vma)
-				err = dup_anon_vma(prev, next);
+			if (!next->anon_vma)
+				err = dup_anon_vma(prev, mid);
 		}
 	} else if (merge_prev) {
 		err = 0;				/* case 2 */
-- 
2.39.2

