Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD652765FF;
	Fri, 21 Nov 2025 13:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731353; cv=none; b=QGtFkr/N4uUKTQNPGh6WHdkddcx/m2uTgQ/D6NJ9v1wWSBE+SzhE5AYI4Y5pysafbdJqImuUtLoysjZKV52Tr6yafEdchHpZ24Xzg6KTOl9ywYXAuFKKisaawdSj6sydJY8pGdkDbsMMEhBBlw6H6DPOdq29mZwObKxnqtvyWAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731353; c=relaxed/simple;
	bh=B99N49zoeNIFEzTRspKVhE9TEhYQLMWkIZmEndJundk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=frRk9E1r79sJ3P4tLYDYWyA4ijP6HBB2DibdP2vSIDbVKUNwpgraf5Rn695x3kgXlCBAEpSazZKTWxGbezFHrA+0UgtC8lKwizZ0hL8ELSQrBHrJtjxC3ktUiCVRjly1N66xQKVcMuvWYGedBzIye0IHzE+KWPDoQCQv72BHsjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UEFxHf+U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UEFxHf+U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B14B1C4CEF1;
	Fri, 21 Nov 2025 13:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731353;
	bh=B99N49zoeNIFEzTRspKVhE9TEhYQLMWkIZmEndJundk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UEFxHf+UFRp7IMNG6BwEJpTV1lA81cAkZ0lGUnaUfzoox1KThEspTimTpsy3m8Kmr
	 vwMTrAyREsLpxcnZGUnneduDTNEzDARHa9xoZxNjwDM9pAUU27cgoqN6jmiw7PB3Db
	 boHU518i++I3u40NgMuk3X87qnlMHRNgKTQEB/Fg=
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
Subject: [PATCH 6.17 178/247] mm/secretmem: fix use-after-free race in fault handler
Date: Fri, 21 Nov 2025 14:12:05 +0100
Message-ID: <20251121130201.110991055@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/secretmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/secretmem.c
+++ b/mm/secretmem.c
@@ -82,13 +82,13 @@ retry:
 		__folio_mark_uptodate(folio);
 		err = filemap_add_folio(mapping, folio, offset, gfp);
 		if (unlikely(err)) {
-			folio_put(folio);
 			/*
 			 * If a split of large page was required, it
 			 * already happened when we marked the page invalid
 			 * which guarantees that this call won't fail
 			 */
 			set_direct_map_default_noflush(folio_page(folio, 0));
+			folio_put(folio);
 			if (err == -EEXIST)
 				goto retry;
 


