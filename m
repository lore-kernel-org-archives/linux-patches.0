Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FB19444
	for <patches@lists.linux.dev>; Thu,  9 Mar 2023 11:13:12 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3DD00219CF;
	Thu,  9 Mar 2023 11:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1678360391; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y+XTfDYhuPvIRFRoJO2lR/Vb/n6vI/gDEgoJ+zMr3So=;
	b=CakbiMz7ESp+PZBarcLSQa0zNpQqPvaGnV/6HiVYEPoMIYL1uJzvY535TNRzkNuNJfHm8G
	baHvFFMgkduFCh/uLKeEcTYTEWWaphwgtng3tkUYz7FxKlXvAyKhCwO7c5U8LHd5QdUk7I
	YULMMvndw22a7fBi1ajnip1FpJXQM3g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1678360391;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y+XTfDYhuPvIRFRoJO2lR/Vb/n6vI/gDEgoJ+zMr3So=;
	b=KdmlvilYt6kG1JZfFees5yu/jB+aJaAamtgpKBaCa/Pg0TK3VAOWwZHYhpcyUwwyYFS03v
	TWMMhE7pACjsZmBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1F0C21391B;
	Thu,  9 Mar 2023 11:13:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id WD7lBke/CWRiRwAAMHmgww
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
Subject: [PATCH 02/10] mm/mmap/vma_merge: use the proper vma pointer in case 3
Date: Thu,  9 Mar 2023 12:12:50 +0100
Message-Id: <20230309111258.24079-3-vbabka@suse.cz>
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

In case 3 we we use 'next' for everything but vma_pgoff. So use 'next'
for that as well, instead of 'mid', for consistency. Then in case 8 we
have to use 'mid' explicitly, which should also make the intent more
obvious.

Adjust the diagram for cases 1-3 in the comment to match the code - we
are using 'next' for case 3 so mark the range with XXXX instead of NNNN.
For case 2 that's a no-op as the code doesn't touch 'next' or 'mid'. For
case 1 it's now wrong but that will be fixed next.

No functional change.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/mmap.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 0a8b052e3022..1af4c9bc2c87 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -857,11 +857,11 @@ can_vma_merge_after(struct vm_area_struct *vma, unsigned long vm_flags,
  *    mmap, brk or    case 4 below       case 5 below
  *    mremap move:
  *                        AAAA               AAAA
- *                    PPPP    NNNN       PPPPNNNNXXXX
+ *                    PPPP    XXXX       PPPPNNNNXXXX
  *                    might become       might become
  *                    PPPPPPPPPPPP 1 or  PPPPPPPPPPPP 6 or
- *                    PPPPPPPPNNNN 2 or  PPPPPPPPXXXX 7 or
- *                    PPPPNNNNNNNN 3     PPPPXXXXXXXX 8
+ *                    PPPPPPPPXXXX 2 or  PPPPPPPPXXXX 7 or
+ *                    PPPPXXXXXXXX 3     PPPPXXXXXXXX 8
  *
  * It is important for case 8 that the vma NNNN overlapping the
  * region AAAA is never going to extended over XXXX. Instead XXXX must
@@ -978,9 +978,10 @@ struct vm_area_struct *vma_merge(struct vma_iterator *vmi, struct mm_struct *mm,
 			vma = next;			/* case 3 */
 			vma_start = addr;
 			vma_end = next->vm_end;
-			vma_pgoff = mid->vm_pgoff;
+			vma_pgoff = next->vm_pgoff;
 			err = 0;
 			if (mid != next) {		/* case 8 */
+				vma_pgoff = mid->vm_pgoff;
 				remove = mid;
 				err = dup_anon_vma(next, mid);
 			}
-- 
2.39.2

