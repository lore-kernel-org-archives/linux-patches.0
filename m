Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053789;
	b=2UR7W26YnKBAk8YH7g7lTsxtBTEJfiD+z5/4dCsOrx4jG+wVWJaPr+iviANghCPuSyTS
	 5fdzCEW/7XjSj5y/H3/hi35zRTwuvibMajbeGpo2lddI0sNOHfE49W9LgPulxO7IMGOj2
	 5gJbdnSnJvEpJeDEV0WzV6P/1pQUtWk2iFFq6J1vvE8MHuIDhgfcJbGH40Ygrl6TN0bAV
	 CCWi7zHlXR9rGm+ZamrYdpQT1RuNzY4h9uxVdYggLRhXV3FV6KOh47rqvFGCt+b7w90xk
	 IYnjuXIiNqDI0CKDoOOMZ9Ilpj/P8Sh2F9Xy3WgC6MBd9PXqSqXnqZ+m2FdP1j1yCrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053789;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0aGgErfw2UmoEMkW7YFTLEbPRT/qfElRgEXHfaj3IxA=;
	b=P/KrdMLksNbBOwhbP+ilGPNOknyiD8mLRmLD2WRBUN0KRhJ/6xu4H7VkSKuiXZzKYR4e
	 hzf/S4tgZVe3ICY9gAmeO4oVedyJEeY/EflgxTAy7/VoD8/DSY1mpcD4SSHHfWAzlb605
	 B7amKSixCvIAVLHOrVz+oLQR0/mA0R/DV51HN1XPKQIaJJD+yJ66MPwY6lzzQSiRatZRL
	 VhQiuhrYunDAnOExIvmNyU0o9VhQwOWCWYao1ViJYJ4UYtkI9DdECWgJkbX3ymB+rBXpg
	 CnkyReu3YoxiQw/9BK6jpngK9bbt/WYQgmSU4/+V7yOI3oGnnT9D273gfhNle/xusAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ja2248kj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3296F606A325;
	Thu, 19 Nov 2026 02:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ja2248kj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 862991F000C4;
	Thu, 19 Nov 2026 02:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053789;
	bh=0aGgErfw2UmoEMkW7YFTLEbPRT/qfElRgEXHfaj3IxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ja2248kj/HE0nO1GfDlYM+vgwLjPPIbWQhv9Bi72uDFMn6H+VGiEqjvlZlJKRzx9j
	 6mQv+FN77O1mXL4GeO6t2Os1oBXUcgxqQOnHW+X1MfW8LBPH2EFv4yvwco4VelF2Q/
	 UnpbJSmVmtDem4ZGiZrAZ2DcVxeO0VScMapp1bZc=
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
Subject: [PATCH 5.15 1043/2214] mm/madvise: use folio_trylock() in the cold/pageout PMD split
Date: Wed, 18 Nov 2026 15:45:19 +0100
Message-ID: <20261118150054.064253873@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: replaced folio_trylock(folio) with trylock_page(page) to match the existing page-based API ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/madvise.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 668d2fa835d4e..fba17d32cc1d0 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -351,9 +351,10 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
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



