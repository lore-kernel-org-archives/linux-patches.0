Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064658;
	b=q+5wwf7IZoaD3BKqqKgPCIgh4iSd39wGYUW68WXv5TOFjVd/+Db2sd3glizIiXMAMWL6
	 8gri+LUN8YhuaDuy7U9bnA2mzEasUmwywjldrvblkO//vmIZqdnaBl8vrAGN5937J51Un
	 YunsK4dpkzEhLs5m8KzhtYzN3GfyivoRr/GUHU523mApITc8z+0pOdrHAR1jRTZLKLxXQ
	 5KB7FWg3OGWkKLLz/Ik6r0HmczDsqt1HqWW0iExebitkxfxhTYQo9aE/Y3KdT2daD0Gu/
	 HanOvDGzRmO9JJ6ra+tt6hc6GVFnmd4BRVhkzzslifCt+MppZhXKbolJ7gB2pNe1UEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064658;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=seTjQbpOwlIJukd067foNAqQ74YSHqVdKWTVX5jKxXI=;
	b=3ookkqbgpKhQjK4HmtMbBV5Z2rS7F7OZsEVnJ5aT4eT8r1e2byiEJ8wf8yDBZj9Pviu8
	 0pPq5BxAdiQ3WVo/O5dYE8pb0/7CQ0bZBANSqAETfRkJMxmJYGTEoADmpG3MQgghYdVb1
	 uxrSCPnlOxq73TiZKj8GHEb470yuPdzf5D2THapQYJVC77QGkEKcSSC6ezlU08dXiOmKf
	 XwtvUL14ih+Lr4/x0x65dnRPsgwm94sfCskcfxFbpj5fcTMG4FsxDIZntEdPZs48dh1OB
	 q4pZJua5wEpafbofNInz3Yz+JbvKwtM+wG+ww8BwX+hltvLRiTD6+zVCFHJTtZIgkpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AHve5c6y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3994B6082BCD;
	Sat,  7 Nov 2026 15:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AHve5c6y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC0821F0089F;
	Sat,  7 Nov 2026 15:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064658;
	bh=seTjQbpOwlIJukd067foNAqQ74YSHqVdKWTVX5jKxXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AHve5c6yy58Hn2Yjy6L69ARiBwb0da23EbubFNrtAEr1iv0dO5QUk9uoB0dOp1g2X
	 Sk0zMf0qAtUXs5wksMSs63xAtgRh/BsoKGCkzl4ICXvJbgckOMJvme3EyIuksJ7bDZ
	 SJ4VSn2BNuGVccQaWPorNJQ60rAw5WvOMF8qtJOQ=
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
Subject: [PATCH 7.3 0658/1257] mm/madvise: use folio_trylock() in the cold/pageout PMD split
Date: Sat,  7 Nov 2026 08:49:14 -0500
Message-ID: <20261107134957.434695393@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/madvise.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 47e40d240c7e6..39480d78b7ad6 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -416,9 +416,10 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 		if (next - addr != HPAGE_PMD_SIZE) {
 			int err;
 
+			if (!folio_trylock(folio))
+				goto huge_unlock;
 			folio_get(folio);
 			spin_unlock(ptl);
-			folio_lock(folio);
 			err = split_folio(folio);
 			folio_unlock(folio);
 			folio_put(folio);
-- 
2.53.0



