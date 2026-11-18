Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036469;
	b=oK7kN2bTLMutaqQ2tyt0Y3z2VtdABVpylTrcmav/popAl3DynlcvgFzAxtNdPCP1LuLi
	 5F/1OrVMM3603tMktosKIeu5N2Khz07HLwPGRoZJBu4cUEhLd3tBjSUKyxsMM8Yx8yTjn
	 LCcDU6liA3Uv+WJNd36w54V9dwXaYObsRxPk6siF3x83FeqEVDpIa3c2OXf4wOjUQJuGM
	 EVEop49hp7GawVAOZagf8dlx/ROPJ42VmMrmJFQB4SpO33jBayhzoI0LelJ9z9h8OC3pP
	 jnPpPZNtnZIUKEc1OF6bEvu2THK63geK3s/IqrqTzv1zoc/b+uI3m6/F9ggBfCosIEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036469;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dV6cpYjyty9rn1k5nI8uDLNRbp4PYKYYSJcqQDb8T6c=;
	b=TsnrQAV/dHH7nWFZLoYh2AspY4foDFKSWyH5/o8hwEBnmFBF+42ONgDHKRzMedrALDiX
	 tQaMHcxttqjw1ZCE4vE85GQi7ns2beC8oJwstHEXIMhB9wAVKa3WnthglcZ/Dg+FpxV/P
	 EqoNQUWXb9rcgrPpRQcujoBGI/YNsyAwGB8s1+K4Md1URZK6EzlWC64dTDJcAhyxrAJlw
	 oJjVgT7+c2g6hmMwyhtkcfoBWqRbPeu6F9S4pnEWrqR4GpLWIU1WpogenNT3yMegSke/0
	 5HkBwcpdWmOQPAcaeVbHdd7LCFCQGMLQDOV4YMSrJwof1P0tPoiqqUQyxmKQ6anmK3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hwS6aYJn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF102606A33E;
	Wed, 18 Nov 2026 21:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hwS6aYJn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FAA01F000C4;
	Wed, 18 Nov 2026 21:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036469;
	bh=dV6cpYjyty9rn1k5nI8uDLNRbp4PYKYYSJcqQDb8T6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hwS6aYJnfp1wHlIeeXT9GnF5O6zQblCvRsubFwQSYrgKQQ1e9PiTsVyH3b2yL4WGT
	 FL1eRugagU0a+y5gSe240fC6NG9RrRP2x3XuAVV0FHASJb/a8h8x4xWJBcfY9bNunw
	 tjqixSVCRxTWKQ0CZ//q1p66bFHXUO5eUlrE7qqs=
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
Subject: [PATCH 6.6 1072/3318] mm/madvise: use folio_trylock() in the cold/pageout PMD split
Date: Wed, 18 Nov 2026 15:28:14 +0100
Message-ID: <20261118150352.126921044@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0c30710bfd859..9b70ade86141d 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -391,9 +391,10 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
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



