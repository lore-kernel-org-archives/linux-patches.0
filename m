Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046885;
	b=oAz9pwUuV8wdlCjw+bfNcWxkvPWGI1x3+yHzG/pxHy1Hgo55N7LIwx9U7+Eqzh8oU2Vv
	 tAUzZTvZshkU+lqprLrCrDYz8gaBJ7ljaUYbQ/CmsfFOOwMMEr2JfODwCbvnAb4piS1Q1
	 fp3EScOYrdDGlajp6HgInXRcR2QDoS5C5znYGFU5qrEnlPXKyEAplFW+hGSMs+rz5V73n
	 NGc5AWkF2fFZxFd6yqWjz2RoJ3q/vQKPNtGuUEE0e2hDUVJrwHgXiSKTY9DmABwVe77oB
	 V9kOpDNKz161sYy8YYA+ovfkC4tc3OMWTpFuDtYGCHtBJp15jZnnOda71NnpM6UTQqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046885;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wDAMp0ckLQ9Nc4pyUoKkzV2DMKJDOpGBc4fJWU8nkfI=;
	b=G3YLFsBrmht0vqecm9yoYylX2DF9jgeJjdzRmYMv97TgOqlbwKqksywBffkBYOZI2gte
	 5FSB2zQ0uG333bF29w1yUaaW6KBDqU2+2FngiLflmW2VD4pMflitzkIFRxrHHIGa0ApSD
	 VcZlvM2keng492BE/vK7HE6fomP2+3ITDHVhq0GkplqAsSZF0pW5bcYIcZTUTNc4VTi+a
	 xAcOaVUcSuja/Uax90frb7giFy0az0TaQiybmDJ1IFumZ/zPPhBO2oyxLuqTEJoJ0KapX
	 onbNqxE6In9nv6/jS2dLTE8jmyTRM703hEoiylEVv226xEK5DwV1hpB1fTwu38uB3dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CEvALF4W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D9F606A325;
	Thu, 19 Nov 2026 00:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CEvALF4W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC791F000C5;
	Thu, 19 Nov 2026 00:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046885;
	bh=wDAMp0ckLQ9Nc4pyUoKkzV2DMKJDOpGBc4fJWU8nkfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CEvALF4WwjqGyFbZ62Sp/OXldsoX+LVeD79xK+hylUiOMwIkVh+bzY5ZJ7IKHeW7d
	 KXNKgglZk9rd19HTwHVXhZkQvynp9qmVGx/92vIPNiNsGJg23v6Y6F1pxAYJoJUavq
	 MI9HRGkChC5BknBGYJAZ8PF1c4Phlr3ufKaN3XnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jann Horn <jannh@google.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1441/2857] mm/madvise: use folio_trylock() in the cold/pageout PMD split
Date: Wed, 18 Nov 2026 15:41:15 +0100
Message-ID: <20261118150253.197635166@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gregory Price <gourry@gourry.net>

[ Upstream commit 5a6c9cf117fca3c38a98fb2a2d5549795c8b0b73 ]

MADV_COLD or MADV_PAGEOUT over part of a PMD splits the THP in
madvise_cold_or_pageout_pte_range().  Two threads doing that to the same
THP create spurious failures.

  CPU0                          CPU1
  ----                          ----
  folio_get()
  spin_unlock(ptl)
  folio_lock()
                                folio_get()
                                spin_unlock(ptl)
                                folio_lock()  <- blocks, keeps its ref
  split_folio()
    folio_expected_ref_count(folio) != folio_ref_count(folio) - 1
    -EAGAIN

CPU1 cannot drop its reference until it gets the lock CPU0 holds, so
CPU0's split always fails.  folio_trylock() makes CPU1 leave without ever
taking a reference.  The PTE branch of this same function already does
this, as do madvise_free_pte_range() and madvise_free_huge_pmd().

Reproducer: 400 rounds of eight threads calling MADV_COLD on half of each
of eight THPs, re-formed with MADV_COLLAPSE between rounds.  From
/proc/vmstat:

                     thp_split_page   thp_split_page_failed
    before                     3186                     860
    after                      3200                       0

The short before count is rounds where every thread failed and the advice
was dropped for that THP entirely.

On failure the walker returns 0 and nothing retries.  The PMD path becomes
best effort when the folio lock is held elsewhere - same as the PTE path.

Link: https://lore.kernel.org/20260912110540.3203010-1-gourry@gourry.net
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260817220810.1175596-1-gourry%40gourry.net
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Assisted-by: LLM
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
[ sashal: Replaced folio_trylock(folio) with trylock_page(page) to match the existing struct page code. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/madvise.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 40e23e42d62b5..2532aee74ae72 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -367,9 +367,10 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 		if (next - addr != HPAGE_PMD_SIZE) {
 			int err;
 
+			if (!trylock_page(page))
+				goto huge_unlock;
 			get_page(page);
 			spin_unlock(ptl);
-			lock_page(page);
 			err = split_huge_page(page);
 			unlock_page(page);
 			put_page(page);
-- 
2.53.0



