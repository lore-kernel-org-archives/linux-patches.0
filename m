Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D4C34C150;
	Fri, 21 Nov 2025 13:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732069; cv=none; b=gUWMnpToZ06o9rDk3+CEbMlJMdDPVxXJLt0Omrwhn6aq23KJFGeLliONfHt0qi1bH8W7DAiZeWSPbhvVfjF1lWzZUnwZ297MbHL2JrO/fQfDQjjhm8wdX4FpJEycyRZx7EFktXziIr3QARGXuzKNWUr9K8gbOhQtamTxLk8FZKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732069; c=relaxed/simple;
	bh=0TSRZtJ/y/wPaLL5x+N6xsJc5Xi30TOGLKQ0vlNClyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mNCFxRnB0GvA5jIGAiDl4m1S6QCTcbAd7iEL1QW4mrncY1b9Sn31agZnwUAuAR8djnR4/WVzaW7a/c5adO0CBubPX5jd7gXYuoIFiQUJqmOZ4Ue825a02Ycf3u2xPhFJX6cKVgmzfMOnS6EiaZKHnEy5m+IXEnNcJVC/ETBFNXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0bam1Ajt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0bam1Ajt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05D70C116C6;
	Fri, 21 Nov 2025 13:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732068;
	bh=0TSRZtJ/y/wPaLL5x+N6xsJc5Xi30TOGLKQ0vlNClyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0bam1AjtntaWLciRPJFdljVz3gXe3arlONYQH8jArVIn30Ofd9ir1AxxvKgFxMkK5
	 /4mapwJ5COGbBdTT07+tXKoYC0pC7EMFsQDM471eZqcx/B8fMMoeBFeMizhdy26hbg
	 htp1XgkSm8eFlAxeuCUCCQOw+s3CKaTL5g7M6jMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lance Yang <lance.yang@linux.dev>,
	Google Big Sleep <big-sleep-vuln-reports@google.com>,
	David Hildenbrand <david@redhat.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 178/185] mm/secretmem: fix use-after-free race in fault handler
Date: Fri, 21 Nov 2025 14:13:25 +0100
Message-ID: <20251121130150.314228616@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lance Yang <lance.yang@linux.dev>

commit 6f86d0534fddfbd08687fa0f01479d4226bc3c3d upstream.

When a page fault occurs in a secret memory file created with
`memfd_secret(2)`, the kernel will allocate a new folio for it, mark the
underlying page as not-present in the direct map, and add it to the file
mapping.

If two tasks cause a fault in the same page concurrently, both could end
up allocating a folio and removing the page from the direct map, but only
one would succeed in adding the folio to the file mapping.  The task that
failed undoes the effects of its attempt by (a) freeing the folio again
and (b) putting the page back into the direct map.  However, by doing
these two operations in this order, the page becomes available to the
allocator again before it is placed back in the direct mapping.

If another task attempts to allocate the page between (a) and (b), and the
kernel tries to access it via the direct map, it would result in a
supervisor not-present page fault.

Fix the ordering to restore the direct map before the folio is freed.

Link: https://lkml.kernel.org/r/20251031120955.92116-1-lance.yang@linux.dev
Fixes: 1507f51255c9 ("mm: introduce memfd_secret system call to create "secret" memory areas")
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Reported-by: Google Big Sleep <big-sleep-vuln-reports@google.com>
Closes: https://lore.kernel.org/linux-mm/CAEXGt5QeDpiHTu3K9tvjUTPqo+d-=wuCNYPa+6sWKrdQJ-ATdg@mail.gmail.com/
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/secretmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/secretmem.c
+++ b/mm/secretmem.c
@@ -84,13 +84,13 @@ retry:
 		__folio_mark_uptodate(folio);
 		err = filemap_add_folio(mapping, folio, offset, gfp);
 		if (unlikely(err)) {
-			folio_put(folio);
 			/*
 			 * If a split of large page was required, it
 			 * already happened when we marked the page invalid
 			 * which guarantees that this call won't fail
 			 */
 			set_direct_map_default_noflush(page);
+			folio_put(folio);
 			if (err == -EEXIST)
 				goto retry;
 


