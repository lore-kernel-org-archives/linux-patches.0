Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063335;
	b=hThK7ZHUnJyRVAKkw19mUae7vkbYyf/oahCCy6RXVxOp4Ms1hSRJmfYCycwORHUInInK
	 H4pSYx7B4Dbcc8DvtC4YaAp6841bZdxdLMvhSvBo2kpcFSD9Lng8EZPX8YyD6OydvNt/t
	 QIHEhwoh1DAtyN8bBFWVrg60lvdBop2q2r6wKhKQ1dv7se/KDD6zJxqIXYBW4FsFJRM5X
	 9sYfgAIvmpvNny64Edle+v62efN3pUC2xwDqh2cRrqeKpoDX4ZNyFU5VIEbcWkds/jLSp
	 yXcYWCK+Vem+fFotpN1dQPEqs1lK5o26PJp/No/nrwee2bVyuvLau6m8wUQFvDWtj+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063335;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VyOdfm2KiXaZ7dHkNnIJyZuUpqF0Pgx/za2gW5OoKeg=;
	b=x3h0mvDZ+JWL1p5JPtBgWZA31kPZkQbh++J30br4VIj5IpQJ/BI5yXgotDL7coMztGCs
	 UtpjUsaE+7qVNEOfelufMNE5deQdKF8zVktnNB7wSv2I64+aIrStMVPnamhhxjSt5Lgak
	 bWUhVAhKPHEkrhYHkTmEkeeNnB4YZ6xowXqmijHw8z2mTvEAbYWfHPPVB1r521tZDyHvX
	 Ec/lS6H2NNL1qBP+pteDaoOunCfN4O2MXls6zs5M5DNo3iNTPEesTxfubLaFMKegQnkDb
	 srHyI17f2X4WyV5TgWwDbjgTxWe23pLmEjqhDjnztjdWuC4DWQJ+nEMbY1zkN2TM4oA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m4FrM7GT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCCB1606A32C;
	Sat,  7 Nov 2026 14:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m4FrM7GT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77BEE1F0089F;
	Sat,  7 Nov 2026 14:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063334;
	bh=VyOdfm2KiXaZ7dHkNnIJyZuUpqF0Pgx/za2gW5OoKeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m4FrM7GT5hfZhE/vJWWDa0dGPRyNOto8OtBRSPZk9WbxmF3pfE2rgQzoHZK+xe8fx
	 U0OatnJkpTsVHKnLoQFskaOyDGsedK4eD9zGvOxOaHkhe+bHFHICwQ+wfm6qzp92yb
	 IqdvArK/FCTBdpvMu09YND05f0DAFkB6tuqQkmOM=
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
Subject: [PATCH 6.18 480/869] mm/madvise: use folio_trylock() in the cold/pageout PMD split
Date: Sat,  7 Nov 2026 08:52:42 -0500
Message-ID: <20261107134909.867035303@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 6b62e01f31911..505a580cd9c4c 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -415,9 +415,10 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
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



