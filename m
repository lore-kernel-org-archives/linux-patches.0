Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059531;
	b=LzrmgH5GXAB83jTKvnL7lr9yhmKJjtRZl3OBUixBaw4QOYzQCOxCDDVB9X6R44tzaEV8
	 /0Q7EHfCfbNQMZQ4jaoLjhswL+BHxbIxIpJ6oSMg/nHeV3JPHhQLYEAtcjz5dWSWYTDkC
	 t3OIxpTI1H+8QGflyoD5BzkJS++8KNPJXumGZepDP53GGoCMjTHRMf29MU774miU2e+ll
	 2B1DulSoKSmDv1DP8ex7kTRVfFO5gSSFNw4A+4RgCNZY+BrapKsq6NkS5bsQDMGXynGyC
	 E5P4muMy4k8xqjAaj8YuJ21MfvgzyGUbCLKI9JfZBWMX1Sru5zEw0vGFvA2HGfrIDvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059531;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TRoBVmWn9HLqbhf0F1Cd2uf93b3eLGpOMTBORqhngfk=;
	b=0c+WJ3N2lIUOEFLPMoRda8W0XuxYKk1e/nucAy/UR0BpR/MG6wgRghUxUa3BWNEhBB5l
	 0JMfWuk1BfQGYZfxH4GhP73K8v+5xSxqxJ902vGfD7f/CXJ0NZavR2r+V3wbHv35Y6RDw
	 p+G5xnxhCHZRuTGJ/AkP8MOXgZJLZHh2YOZ2hlY+1zxJ0p6MijQlEbx+UORPtrP0lX7QL
	 yppiw1+DWAx476XSpWvpDwzlWzaAoGF3azHs9f+HtDTCd2CqtcyG5tRgWOv4Q1h7yyc8z
	 OxR3AMlQHokm8wTXt+MUbobVGBsmmghtQhsBGmqN5yFeV9DNVw+S0zLPXVXZNGZy4Sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uRh8It4X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C17606A325;
	Thu, 19 Nov 2026 03:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uRh8It4X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D2BC1F000C4;
	Thu, 19 Nov 2026 03:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059531;
	bh=TRoBVmWn9HLqbhf0F1Cd2uf93b3eLGpOMTBORqhngfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uRh8It4XOwM1RsP5B/gyrTrmztAtH/N2aY59sPgeTSW9q+OP02IkdjxMpwZ6m7MNI
	 P4niiWH5KVtC09HpctZLW5dZ9raowqG4iVedBWgC2TkQ1BOLypRsS/wGGuKC5VTU4x
	 xuc9IopjPgGPVfYkDUd1mgqNMZ098MyEGlx70cKk=
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
Subject: [PATCH 5.10 0874/1848] mm/madvise: use folio_trylock() in the cold/pageout PMD split
Date: Wed, 18 Nov 2026 15:48:32 +0100
Message-ID: <20261118145953.009876966@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: replaced folio_trylock(folio) with trylock_page(page) to match the page-based API ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/madvise.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 5aea93718eec2..ba7a1e819f9a8 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -349,9 +349,10 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
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



