Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590887;
	b=AraEVA8gPRukXv7ZJYnsBdReIiFFietoTSr2Ntt3VwB0+pxFIZzsaZ7QumE/U1Zkxipk
	 cqRKunydQ1ndATo/97W+rbm3MXmOOTRwDzJsCeCSowPaXuzNp4AFiLW6oX9ylSEl08bZn
	 IurRZKWpXlXqP6wIoLkuhgiKS0U/FnqgDrclymB/MLjgYbaglYbqbLpiX1X1p013mtjBy
	 l7/z06pGcAqlDZZgGUp/sst4gEEDG+OHj639vJf8bn80k1JEo8kuaF5DX75H+Xdtb9ADU
	 ThGhVioM1Bqiu61UYOKu/rHPRC3S2AgXQium50cSNgleQGmUVTbQMecbAXJZSMY9b+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590887;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FyBO0bB7Whx3+ymznYl/CDjd272pNFhOs2BCyDuVR9g=;
	b=admCVcNfw7VmEjq7VTwotUNjYLLpxf2gXcX9WxVpbHUMSu2rGdgsCDyS+CSGmiVtsxVi
	 bNu0fxPY8xMRMv+0u+w6VMVDxBKfpai2delUECE9Dcl5wyXgxtgj3aYAXemrlImch+PIm
	 zRhtVTRC19cNIdFspO9bR/mfamduRFgVn4fEaPp6/nvNELSMlGVHuOVLxxx6WM8PW8Cfc
	 3p6dNoKKNJR/irw3pRtWXXAe2e1D1vPD5eM436oRpn+hZTF0Wd72pzG2BepAWhMjMVcaJ
	 zMs6bkHKAxQlntfIe2UQJgVrihI/1VhnCpi6iYiz5mDG6pYSffxMucbszI20ZMfSwPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xwD2SrnP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8CD3606D4BF;
	Fri, 13 Nov 2026 17:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xwD2SrnP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 559731F000C6;
	Fri, 13 Nov 2026 17:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590887;
	bh=FyBO0bB7Whx3+ymznYl/CDjd272pNFhOs2BCyDuVR9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xwD2SrnP1Tig/FpuxAo98BkUgWzIhzoQ5EfGxF0RAqkKIxOvaFSizVyzBIdgqT8jH
	 gE24DdksJmfF/bCxnGe8oA5U5uBH0ZW1JcOzEn6PDXyQ+V1K3TvHNoKhNfRAnBIVLu
	 wwa74cSVOG7ZSFQf59D6boX3yl7ssNpM1lqzp9MM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 081/670] mm/damon/paddr: respect folio end for DAMOS actions except STAT
Date: Fri, 13 Nov 2026 10:44:05 -0500
Message-ID: <20261113153814.499948817@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: SJ Park <sj@kernel.org>

[ Upstream commit 1613ac9edf385c35f171a25610e2706a7e6afad6 ]

A few functions for applying DAMOS actions including pageout, lru_[de]prio
and migrate_{hot,cold} in DAMON physical address space operation set
(paddr) collect folios of the given region by getting the folios of
region-internal addresses.  Then, those functions apply the action to the
collected folios at once.  The collection starts from the region start
address and advances the address by the size of the folio of the address
until it goes out of the region.  If the start address is in the middle of
a large folio, and if the next folios are small, some of the next folios
could be skipped.  Fix the issue by advancing the address to exactly the
start address of the next folio.

The user impact is that DAMOS action is applied to less than expected
amount of memory.  Given the best effort nature of DAMON, it is no big
problem, but it is clearly a bug that is better to be fixed.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260901131850.98037-4-sj@kernel.org
Link: https://lore.kernel.org/20260517234112.89245-1-sj@kernel.org [1]
Fixes: 3a06696305e7 ("mm/damon/ops: have damon_get_folio return folio even for tail pages")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: <stable@vger.kernel.org> # 6.15.x
(cherry picked from commit 1613ac9edf385c35f171a25610e2706a7e6afad6)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/paddr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index a6b1de97b1e8a..6bac269cd679e 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -273,7 +273,7 @@ static unsigned long damon_pa_pageout(struct damon_region *r, struct damos *s)
 		else
 			list_add(&folio->lru, &folio_list);
 put_folio:
-		addr += folio_size(folio);
+		addr = PFN_PHYS(folio_pfn(folio)) + folio_size(folio);
 		folio_put(folio);
 	}
 	if (install_young_filter)
@@ -306,7 +306,7 @@ static inline unsigned long damon_pa_mark_accessed_or_deactivate(
 			folio_deactivate(folio);
 		applied += folio_nr_pages(folio);
 put_folio:
-		addr += folio_size(folio);
+		addr = PFN_PHYS(folio_pfn(folio)) + folio_size(folio);
 		folio_put(folio);
 	}
 	return applied * PAGE_SIZE;
@@ -483,7 +483,7 @@ static unsigned long damon_pa_migrate(struct damon_region *r, struct damos *s)
 				folio_is_file_lru(folio));
 		list_add(&folio->lru, &folio_list);
 put_folio:
-		addr += folio_size(folio);
+		addr = PFN_PHYS(folio_pfn(folio)) + folio_size(folio);
 		folio_put(folio);
 	}
 	applied = damon_pa_migrate_pages(&folio_list, s->target_nid);
-- 
2.53.0



