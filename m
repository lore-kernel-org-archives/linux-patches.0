Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC713C04
	for <patches@lists.linux.dev>; Fri, 24 Feb 2023 10:00:49 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1AB8E33EE5;
	Fri, 24 Feb 2023 10:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1677232841; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=fYMDHGhxtWDPrzo59tlrqmcRMh/4v4Ahxqb6AiuSjpQ=;
	b=Y/ZrJ6qe1NfuJIJNSTTEanWL95b0DAnESjs38m2DbmrMT10P5glp21o4r+DHI9oiY+TF++
	ig5wRyjJayiJpB00Pf8wdAkK9TZAX8HRIy5j1MqSJUyqWYavtc6eWwiwmNrVSDnbtJW3lk
	+fh68YhzFmhtS/zEaAJkTZ9X1yg51k0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1677232841;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=fYMDHGhxtWDPrzo59tlrqmcRMh/4v4Ahxqb6AiuSjpQ=;
	b=sNGIvmG2ukA90dhMqxG0fenSAvhFuGBs6vhVhuMlYxdxBP0yXBULWgKAIL5TRyAkgv968z
	jlzMXum9M42wIsCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F349813246;
	Fri, 24 Feb 2023 10:00:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id HHSvOsiK+GPeTgAAMHmgww
	(envelope-from <vbabka@suse.cz>); Fri, 24 Feb 2023 10:00:40 +0000
From: Vlastimil Babka <vbabka@suse.cz>
To: linux-mm@kvack.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	maple-tree@lists.infradead.org,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [RFC 00/11] cleanup vma_merge and improve mergeability tests
Date: Fri, 24 Feb 2023 11:00:11 +0100
Message-Id: <20230224100022.11268-1-vbabka@suse.cz>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Also available in git:
https://git.kernel.org/vbabka/h/vma_merge_cleanup-v1r1

My initial goal here was to try making the check for vm_ops->close in
is_mergeable_vma() only be applied for vma's that would be truly removed
as part of the merge (see Patch 10). This would then allow reverting the
quick fix d014cd7c1c35 ("mm, mremap: fix mremap() expanding for vma's
with vm_ops->close()"). This was successful enough to allow the revert.
Checks using can_vma_merge_before() are still pessimistic about possible
vma removal, and making them precise would probably complicate the
vma_merge() code too much.

Liam's recent simplification of vma_merge() and removal of
__vma_adjust() was very much helpful in understanding the vma_merge()
implementation and especially when vma removals can happen, which is now
very obvious. While studing the code, I've found ways to make it
hopefully even more easy to follow, so that's the patches 2-9. That made
me notice a bug fixed in patch 1, which is already in the mm tree and
here just for completeness.

Vlastimil Babka (11):
  mm/mremap: fix dup_anon_vma() in vma_merge() case 4
  mm/mmap/vma_merge: use only primary pointers for preparing merge
  mm/mmap/vma_merge: use the proper vma pointer in case 3
  mm/mmap/vma_merge: use the proper vma pointers in cases 1 and 6
  mm/mmap/vma_merge: use the proper vma pointer in case 4
  mm/mmap/vma_merge: initialize mid and next in natural order
  mm/mmap/vma_merge: set mid to NULL if not applicable
  mm/mmap/vma_merge: rename adj_next to adj_start
  mm/mmap/vma_merge: convert mergeability checks to return bool
  mm/mmap: start distinguishing if vma can be removed in mergeability
    test
  mm/mremap: simplify vma expansion again

 mm/mmap.c   | 130 +++++++++++++++++++++++++++++-----------------------
 mm/mremap.c |  20 ++------
 2 files changed, 76 insertions(+), 74 deletions(-)

-- 
2.39.2

