Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625297;
	b=gQt3E7qf7T5IF3RsczzxCxZC0CtY5yv5X82zBix3IhvrDvpySQMElXoTuzys3DzE/wZR
	 kutJ1gH4yV/8da8Q5VL8sQaRL3cCQkb0fGQWYjdCOultKQZ+4GOdd7oN8rWMH/az7WAKw
	 dgahEFPMLM0EeGKJ0OxS1WChLtWn4ypZ5WF4WFKB9Z1lPOgLHWDAynrpBwEZwmOYLFNPQ
	 E8orEw/tRC6deYZ4Tv3daSZDvnUddPeNztUas74PVrdC2QjIc+Y5KOIXs42ezP3e5nrN+
	 rc8yiE25VdCDU1Yx7EC0nqCu1DBlZEsq6+LYSJoXnURzOw+/DY5/idFLmmk4I6kjFmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625297;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aKJOAR8q5sGjxD4htZNq02O0AUUgQ5abaKOD1ugJUY0=;
	b=rpLqRnma+Im/4oACdMoIKYQwEClO1SKn2ZUItQxGMvCBDAe2Izf7tN5LM43RB+eos2Gd
	 YCilCexxDisIdxWa0U6PzD/0lLtOn0PYNBAEgAtAOisaAsu8z7I3CepgjsYBBmfQRB0Ml
	 J5y0zJgitgCldy69AlxKpNyXgmZuTPCY+dbsIUPku+sibJzV1bv5PIAToOnrPXO4/g1wf
	 YVLbnMwl2nmEG3s2uf1xGrBUhCy820Lx/v5+W3c/9bQJtXdYRO+mnPcTkDhFYbB+E+/pa
	 UcsNpTuav8ElL9yrNe2dn/iOr7tw26ttHvM43zCKHFSGVMBW/Rvzqmnu7/oG2vuZVkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K1jM7k9V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD4D606A321;
	Wed, 25 Nov 2026 16:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K1jM7k9V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C45E1F000C0;
	Wed, 25 Nov 2026 16:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625296;
	bh=aKJOAR8q5sGjxD4htZNq02O0AUUgQ5abaKOD1ugJUY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K1jM7k9VqNtC+q+5RuLeot1w7XVQqlt7NJY+NV2qa7swvs2Viqlv0sZueRhcRuFpF
	 8Se4xQNfjAc6Bguh3wcfdj0B/WpaTi4waHR+SBKzjngLLJKJQkD0/CUxG5J9rdQAe0
	 PI5iVXyGRi635bAAZ+r3Oylv6MCc5ZPNmuN9Kq4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Lance Yang <lance.yang@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 415/816] mm/gup: honour FOLL_PIN in NOMMU __get_user_pages_locked()
Date: Wed, 25 Nov 2026 15:32:43 +0100
Message-ID: <20261125143858.803315304@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit da01399b90a73cd00b502f7903fa5acbfac4a103 ]

The !CONFIG_MMU implementation of __get_user_pages_locked() takes a bare
get_page() reference for each page regardless of foll_flags:
	if (pages[i])
		get_page(pages[i]);

This is reached from pin_user_pages*() with FOLL_PIN set.
unpin_user_page() is shared between MMU and NOMMU configurations and
unconditionally calls gup_put_folio(..., FOLL_PIN), which subtracts
GUP_PIN_COUNTING_BIAS (1024) from the folio refcount.

This means that pin adds 1, and then unpin will subtract 1024.

If a user maps a page (refcount 1), registers it 1023 times as an
io_uring fixed buffer (1023 pin_user_pages calls -> refcount 1024), then
unregisters: the first unpin_user_page subtracts 1024, refcount hits 0,
the page is freed and returned to the buddy allocator.  The remaining
1022 unpins write into whatever was reallocated, and the user's VMA
still maps the freed page (NOMMU has no MMU to invalidate it).
Reallocating the page for an io_uring pbuf_ring then lets userspace
corrupt the new owner's data through the stale mapping.

Use try_grab_folio() which adds GUP_PIN_COUNTING_BIAS for FOLL_PIN and 1
for FOLL_GET, mirroring the CONFIG_MMU path so pin and unpin are
symmetric. Keep supporting the traditional behavior where users specify
a pages array but don't set FOLL_GET.

While at it, don't return NULL pointers in the page array,
as this is really not expected for GUP users; instead, just fail and return
-EFAULT.

[ david: support traditional behavior with no FOLL_GET, extend
  description ]

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Lance Yang <lance.yang@linux.dev>
Reported-by: Anthropic
Fixes: 3faa52c03f44 ("mm/gup: track FOLL_PIN pages")
Assisted-by: gkh_clanker_t1000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Tested-by: Lance Yang <lance.yang@linux.dev>
Link: https://patch.msgid.link/20260921-nommu_gup_pin-v4-1-c410041cc479@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
[ sashal: Kept unsigned long vm_flags; in the declaration context instead of upstream's vm_flags_t vm_flags;, since this branch never got the typedef conversion, and added the new int ret, err = -EFAULT; below it. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/gup.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index d9107eb461a02..01a6408055102 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2058,6 +2058,7 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
 	struct vm_area_struct *vma;
 	bool must_unlock = false;
 	unsigned long vm_flags;
+	int ret, err = -EFAULT;
 	long i;
 
 	if (!nr_pages)
@@ -2074,6 +2075,10 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
 		*locked = 1;
 	}
 
+	/* See the MMU variant: support the traditional behavior. */
+	if (pages && !(foll_flags & FOLL_PIN))
+		foll_flags |= FOLL_GET;
+
 	/* calculate required read or write permissions.
 	 * If FOLL_FORCE is set, we only require the "MAY" flags.
 	 */
@@ -2094,8 +2099,14 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
 
 		if (pages) {
 			pages[i] = virt_to_page((void *)start);
-			if (pages[i])
-				get_page(pages[i]);
+			if (!pages[i])
+				break;
+			ret = try_grab_folio(page_folio(pages[i]), 1, foll_flags);
+			if (unlikely(ret)) {
+				pages[i] = NULL;
+				err = ret;
+				break;
+			}
 		}
 
 		start = (start + PAGE_SIZE) & PAGE_MASK;
@@ -2106,7 +2117,7 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
 		*locked = 0;
 	}
 
-	return i ? : -EFAULT;
+	return i ? : err;
 }
 #endif /* !CONFIG_MMU */
 
-- 
2.53.0



