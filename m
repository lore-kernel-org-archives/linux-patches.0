Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063160;
	b=GOydDZnD80RPhyZ8fnRFQcU+kfupK8nyjSQZQFghWc6sORX9W5UK64SID3qrG7TRCBDR
	 1ELKkxQZFVNnsBtcfqqvx8VAh1DdZebhFX+dqfBXY5pAgJC8KH9YqDBYvSS8d1dOxTEu/
	 9ZpjZ+oWSfFePZ5jzO2zbXCJXHqzmm/upqsaulfDR/bUf1Wh8VT3UpTg2tQ7+BDKWthLW
	 hlB6tDQvp8DetEr9ch8u81tSMnYcHXRWDN4/xTiXbZ0DaAGLKduSTG8ebY5Jm3xefO/Ua
	 jecM0AHmzwJuuoC5RpID+G/VqISYQweZv2/L1g8XY7gC8jw9HNiKe4ti7raksztE9aA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063160;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aLaV1U+snqhLEDvFuVR2ZjMBAFyd36OJOZHDQl1AQZY=;
	b=R1l6kcXtDjxfwVrf1OxrBtiThfFzuqQGUoE6ik9o3kyUF5kokOo/y6T2dETPrBfZsUc1
	 331/6jCyWwxTDlxp4KGe97h6Gl5xQoCaXn9S0kZ9eZ2PSkQB/y33/vp0jIuqDvbSJq2qC
	 U90MlishHmCBNBfxSHmN11lDu+4Kk1Oup2sFI3fE+RBFiC/ZRneM+11kZitTY8Rj8qe9F
	 VtP4O9M6e7s4BuSl0R12qcgq0KfTG7DEhthVVBCypKn4qsr6tfvf+QkdI9oXAxTLKrVUH
	 Fv3yJXAPU38Qmw1e2tX8Ibue1+owpE14ds2UI0t78cusSlx4qbliW3W9KZZ+Ca6+AKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tQlTsIus;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9DC9606A331;
	Sat,  7 Nov 2026 14:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tQlTsIus
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 654291F0089F;
	Sat,  7 Nov 2026 14:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063159;
	bh=aLaV1U+snqhLEDvFuVR2ZjMBAFyd36OJOZHDQl1AQZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tQlTsIusnnib7Eja1YUOovGfYNh+S8hEuB2zd9RVL/Lq/0gz+LY68TfXf6UUoYL3u
	 LtBJMZyK/lepW09oOVGV0lWr9DB9k6BHVz6phIwIPCwi2Jlpcr/Io0PeVzfE98CFfN
	 OwRb7bdmX5uZH+ChhwyyFupJGlvxf8sCo1rRGzYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 382/869] mm/damon/paddr: respect folio end for DAMOS actions except STAT
Date: Sat,  7 Nov 2026 08:51:04 -0500
Message-ID: <20261107134906.151052060@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/paddr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 5720e73930f84..ddd26a78a9bc6 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -183,7 +183,7 @@ static unsigned long damon_pa_pageout(struct damon_region *r,
 		else
 			list_add(&folio->lru, &folio_list);
 put_folio:
-		addr += folio_size(folio);
+		addr = PFN_PHYS(folio_pfn(folio)) + folio_size(folio);
 		folio_put(folio);
 	}
 	if (install_young_filter)
@@ -221,7 +221,7 @@ static inline unsigned long damon_pa_mark_accessed_or_deactivate(
 			folio_deactivate(folio);
 		applied += folio_nr_pages(folio);
 put_folio:
-		addr += folio_size(folio);
+		addr = PFN_PHYS(folio_pfn(folio)) + folio_size(folio);
 		folio_put(folio);
 	}
 	s->last_applied = folio;
@@ -271,7 +271,7 @@ static unsigned long damon_pa_migrate(struct damon_region *r,
 				folio_is_file_lru(folio));
 		list_add(&folio->lru, &folio_list);
 put_folio:
-		addr += folio_size(folio);
+		addr = PFN_PHYS(folio_pfn(folio)) + folio_size(folio);
 		folio_put(folio);
 	}
 	applied = damon_migrate_pages(&folio_list, s->target_nid);
-- 
2.53.0



