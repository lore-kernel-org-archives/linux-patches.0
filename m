Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44756AD9
	for <patches@lists.linux.dev>; Thu,  9 Mar 2023 11:13:12 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F1EAE20033;
	Thu,  9 Mar 2023 11:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1678360390; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=HLw5okzX2YOIOl54HcyFrCD7eCYDReR9tZ7faP+4gLY=;
	b=xS6SE1c9jvJoN8Sf3sRW3e/qFqrx71W8GR/+fXs+glvxvgiH0rrVIEQIGYRPWa+0r65yQm
	SDNO2BDfHHn+KMJyLN7BS7AnJ7LxnTDkLsIr/jEzDa4F4920wgjCTxmCDmhPqa59fUSxXn
	8env8mBOqO4WGcWosBYiaSBsy46irbg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1678360390;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=HLw5okzX2YOIOl54HcyFrCD7eCYDReR9tZ7faP+4gLY=;
	b=+olrXbacWh0hZWiayS4RqaTtMulahUtv1oRLVy01s0GgkIBkSQ/6Ao4bK4EJjjTFgQnEGw
	g6oWBtJPCIo1yXBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D00C61391B;
	Thu,  9 Mar 2023 11:13:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id BfsRMka/CWRiRwAAMHmgww
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
Subject: [PATCH 00/10] cleanup vma_merge() and improve mergeability tests
Date: Thu,  9 Mar 2023 12:12:48 +0100
Message-Id: <20230309111258.24079-1-vbabka@suse.cz>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Also available in git:
https://git.kernel.org/vbabka/h/vma_merge_cleanup-v1r2

Changes since RFC:
- rebased to 6.3-rc1, dropped first patch (urgent fix) that was merged there
- reindent parameters of mergeability checks (suggested by willy on IRC)

My initial goal here was to try making the check for vm_ops->close in
is_mergeable_vma() only be applied for vma's that would be truly removed
as part of the merge (see Patch 9). This would then allow reverting the
quick fix d014cd7c1c35 ("mm, mremap: fix mremap() expanding for vma's
with vm_ops->close()"). This was successful enough to allow the revert
(Patch 10). Checks using can_vma_merge_before() are still pessimistic
about possible vma removal, and making them precise would probably
complicate the vma_merge() code too much.

Liam's 6.3-rc1 simplification of vma_merge() and removal of
__vma_adjust() was very much helpful in understanding the vma_merge()
implementation and especially when vma removals can happen, which is now
very obvious. While studing the code, I've found ways to make it
hopefully even more easy to follow, so that's the patches 1-8. That made
me also notice a bug that's now already fixed in 6.3-rc1.

Vlastimil Babka (10):
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

 mm/mmap.c   | 142 ++++++++++++++++++++++++++++------------------------
 mm/mremap.c |  20 ++------
 2 files changed, 80 insertions(+), 82 deletions(-)

-- 
2.39.2

