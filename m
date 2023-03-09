Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC379443
	for <patches@lists.linux.dev>; Thu,  9 Mar 2023 11:13:12 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1E47C20036;
	Thu,  9 Mar 2023 11:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1678360391; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q9S49Vc4wP4VJtPP7U3rbG14z7j2ldE6Nx08zIq8xuM=;
	b=Mlm8A4HoqAH0hJcmIH7nkeq7Ena0KY5bDzJYjrppMfaDBbBA3WohkCm9JIIgswP2JrYIvo
	zNTW4ebhcCAJOcnFqxgBVFKAYXWUz3I4R0UU5OTZYPI1D/0Rllmax+6SsLOiWp4rvMpYLW
	wBWINPA6bXrywVw+WjfS23ZYMKflGJ0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1678360391;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q9S49Vc4wP4VJtPP7U3rbG14z7j2ldE6Nx08zIq8xuM=;
	b=KJEXsfOBSotb9dP5aHuNoEqWsFqw2hDjbbgnBUqsAQxTVJXXmvPoLo19GujxjABiZmRJoR
	Jf7IWKTG6XnAJ8AQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F1C0A13A73;
	Thu,  9 Mar 2023 11:13:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id MPmCOka/CWRiRwAAMHmgww
	(envelope-from <vbabka@suse.cz>); Thu, 09 Mar 2023 11:13:10 +0000
From: Vlastimil Babka <vbabka@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Matthew Wilcox <willy@infradead.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	maple-tree@lists.infradead.org,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 01/10] mm/mmap/vma_merge: use only primary pointers for preparing merge
Date: Thu,  9 Mar 2023 12:12:49 +0100
Message-Id: <20230309111258.24079-2-vbabka@suse.cz>
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

In the merging preparation part of vma_merge(), some vma pointer
variables are assigned for later execution of the merge, but also read
from in the block itself. The code is easier follow and check against
the cases diagram in the comment if the code reads only from the
"primary" vma variables prev, mid, next instead. No functional change.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/mmap.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 740b54be3ed4..0a8b052e3022 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -950,16 +950,16 @@ struct vm_area_struct *vma_merge(struct vma_iterator *vmi, struct mm_struct *mm,
 	    is_mergeable_anon_vma(prev->anon_vma, next->anon_vma, NULL)) {
 		remove = mid;				/* case 1 */
 		vma_end = next->vm_end;
-		err = dup_anon_vma(res, remove);
+		err = dup_anon_vma(prev, mid);
 		if (mid != next) {			/* case 6 */
 			remove2 = next;
-			if (!remove->anon_vma)
-				err = dup_anon_vma(res, remove2);
+			if (!mid->anon_vma)
+				err = dup_anon_vma(prev, next);
 		}
 	} else if (merge_prev) {
 		err = 0;				/* case 2 */
 		if (mid && end > mid->vm_start) {
-			err = dup_anon_vma(res, mid);
+			err = dup_anon_vma(prev, mid);
 			if (end == mid->vm_end) {	/* case 7 */
 				remove = mid;
 			} else {			/* case 5 */
@@ -972,8 +972,8 @@ struct vm_area_struct *vma_merge(struct vma_iterator *vmi, struct mm_struct *mm,
 		if (prev && addr < prev->vm_end) {	/* case 4 */
 			vma_end = addr;
 			adjust = mid;
-			adj_next = -(vma->vm_end - addr);
-			err = dup_anon_vma(adjust, prev);
+			adj_next = -(prev->vm_end - addr);
+			err = dup_anon_vma(mid, prev);
 		} else {
 			vma = next;			/* case 3 */
 			vma_start = addr;
@@ -982,7 +982,7 @@ struct vm_area_struct *vma_merge(struct vma_iterator *vmi, struct mm_struct *mm,
 			err = 0;
 			if (mid != next) {		/* case 8 */
 				remove = mid;
-				err = dup_anon_vma(res, remove);
+				err = dup_anon_vma(next, mid);
 			}
 		}
 	}
-- 
2.39.2

