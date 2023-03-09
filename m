Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6F49443
	for <patches@lists.linux.dev>; Thu,  9 Mar 2023 11:13:16 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 47ACB2003B;
	Thu,  9 Mar 2023 11:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1678360392; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Am3Z7D3PJEF75x3/HiQBrnXvVKIlV3/Qp4c3FogRta0=;
	b=IN9yYJDPpAsUzcK/lBOeD2OcF3abAzwQ1DWsa1jg7+7eKnFdayh/P6CMtsBy7OtrQm00nA
	+0vQ3fFLUakpP8Rn+BjzZ5fmS5nIOFNikGqmEYsrfsawuNGhaI1yOvLmxMGMeyqPH1PF3a
	nm4+jG513He9UWKRAiy73yO6m8P43sc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1678360392;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Am3Z7D3PJEF75x3/HiQBrnXvVKIlV3/Qp4c3FogRta0=;
	b=hsyPFizFKqJYnSdS3E6xpTXq9S6r1rJ5Jji3li+g88rTqmX7AeSbhzGXDyIih4Pl7bflMh
	GAWJAY6loxrLWZCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2AA711391B;
	Thu,  9 Mar 2023 11:13:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id mBDLCUi/CWRiRwAAMHmgww
	(envelope-from <vbabka@suse.cz>); Thu, 09 Mar 2023 11:13:12 +0000
From: Vlastimil Babka <vbabka@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Matthew Wilcox <willy@infradead.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	maple-tree@lists.infradead.org,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 10/10] mm/mremap: simplify vma expansion again
Date: Thu,  9 Mar 2023 12:12:58 +0100
Message-Id: <20230309111258.24079-11-vbabka@suse.cz>
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

This effectively reverts d014cd7c1c35 ("mm, mremap: fix mremap()
expanding for vma's with vm_ops->close()"). After the recent changes,
vma_merge() is able to handle the expansion properly even when the vma
being expanded has a vm_ops->close operation, so we don't need to
special case it anymore.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/mremap.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 411a85682b58..65f5b545601e 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1040,23 +1040,11 @@ SYSCALL_DEFINE5(mremap, unsigned long, addr, unsigned long, old_len,
 			 * vma (expand operation itself) and possibly also with
 			 * the next vma if it becomes adjacent to the expanded
 			 * vma and  otherwise compatible.
-			 *
-			 * However, vma_merge() can currently fail due to
-			 * is_mergeable_vma() check for vm_ops->close (see the
-			 * comment there). Yet this should not prevent vma
-			 * expanding, so perform a simple expand for such vma.
-			 * Ideally the check for close op should be only done
-			 * when a vma would be actually removed due to a merge.
 			 */
-			if (!vma->vm_ops || !vma->vm_ops->close) {
-				vma = vma_merge(&vmi, mm, vma, extension_start,
-					extension_end, vma->vm_flags, vma->anon_vma,
-					vma->vm_file, extension_pgoff, vma_policy(vma),
-					vma->vm_userfaultfd_ctx, anon_vma_name(vma));
-			} else if (vma_expand(&vmi, vma, vma->vm_start,
-					addr + new_len, vma->vm_pgoff, NULL)) {
-				vma = NULL;
-			}
+			vma = vma_merge(&vmi, mm, vma, extension_start,
+				extension_end, vma->vm_flags, vma->anon_vma,
+				vma->vm_file, extension_pgoff, vma_policy(vma),
+				vma->vm_userfaultfd_ctx, anon_vma_name(vma));
 			if (!vma) {
 				vm_unacct_memory(pages);
 				ret = -ENOMEM;
-- 
2.39.2

