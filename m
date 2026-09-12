Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91C21DE4EF;
	Sat, 12 Sep 2026 14:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222184; cv=none; b=AbJrJHoYnsJSLl5Yo/csEz0OPNnCOJO5qWpcVWJEZ/zUKpQ3gBbbFPkiUPD0Eqsqq1X2OKzhCDdiGCmvtrgOmU6PL3XtyRGu0jYeY4L/f0YU+KsLOMiPxT1YhW3OMlSYd0AP59HKYlTIhLdG4ZQzXO7T5K9Mn3gkRjm5bWVEU8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222184; c=relaxed/simple;
	bh=pDxVJfrhBdWUVsBYWQkn3QH68sQy/PMHA3UJ7IvaWRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cEawV1GNCQfGXGEhJQ9Uidm0KQfl/ED0BM1jh7YnYAX5cwdbB+4LVbZc/yobrFN2iQN6GKoyUGyUoWPUV6jbpU4WqnMOV9WNQDc1t+DsAzguumycsp+yIpFeDHg6uCQom2DsEb/v+/miZszsEB4uyZoyKXLejAbscfSXFxqdypw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wMfELjaq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wMfELjaq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13DFC1F000FF;
	Sat, 12 Sep 2026 14:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222183;
	bh=dgvd6ReTXbjzrYLOrd4sdjvJ8JhLmmSaxl9rV56RSos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wMfELjaq+TV6MHHVLVOi6Fz+nQ9xKRyTNjUDyZvO2qmGk2v33yxaMYaR8U62i22IU
	 Cbzv2QUyEOWZ3ktJjkDi0fbIp+KcgyYB7xRM4Cd153jJgwb2Y41V0d3I9ichxVowCA
	 9xe3YrFLZi0YuQjW2TGsE9jJcX+EHL8TZ4xfJcww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0534/1424] mm/damon/paddr: drop last same folio access check reuse optimization
Date: Sat, 12 Sep 2026 08:49:26 +0200
Message-ID: <20260912065619.256463577@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SJ Park <sj@kernel.org>

[ Upstream commit f23f0aa62b2f32c2b12f95959fc4603ef81678b2 ]

It can race when multiple kdamonds are being used.  The problem from the
race is doubtful, but the gain from the optimization is also doubtful.
Simply drop the optimization in favor of code simplicity.

The user impact is doubtfully trivial.  After all, this kind of
interference can happen only by intentional user setup.  Even if it
happens, it will be rare, and the consequence is degradation of the
best-effort monitoring results.  No critical consequences like kernel
panic or memory corruption happen.

The race was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260715031002.108504-5-sj@kernel.org
Link: https://lore.kernel.org/20260621204050.10993-1-sj@kernel.org [1]
Fixes: a28397beb55b ("mm/damon: implement primitives for physical address space monitoring")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 5.16.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/paddr.c | 21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 909db25efb35e..fe481ae64f37e 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -111,7 +111,7 @@ static bool __damon_pa_young(struct folio *folio, struct vm_area_struct *vma,
 	return *accessed == false;
 }
 
-static bool damon_pa_young(unsigned long paddr, unsigned long *folio_sz)
+static bool damon_pa_young(unsigned long paddr)
 {
 	struct folio *folio = damon_get_folio(PHYS_PFN(paddr));
 	bool accessed = false;
@@ -143,30 +143,17 @@ static bool damon_pa_young(unsigned long paddr, unsigned long *folio_sz)
 		folio_unlock(folio);
 
 out:
-	*folio_sz = folio_size(folio);
 	folio_put(folio);
 	return accessed;
 }
 
 static void __damon_pa_check_access(struct damon_region *r)
 {
-	static unsigned long last_addr;
-	static unsigned long last_folio_sz = PAGE_SIZE;
-	static bool last_accessed;
-
-	/* If the region is in the last checked page, reuse the result */
-	if (ALIGN_DOWN(last_addr, last_folio_sz) ==
-				ALIGN_DOWN(r->sampling_addr, last_folio_sz)) {
-		if (last_accessed)
-			r->nr_accesses++;
-		return;
-	}
+	bool accessed;
 
-	last_accessed = damon_pa_young(r->sampling_addr, &last_folio_sz);
-	if (last_accessed)
+	accessed = damon_pa_young(r->sampling_addr);
+	if (accessed)
 		r->nr_accesses++;
-
-	last_addr = r->sampling_addr;
 }
 
 static unsigned int damon_pa_check_accesses(struct damon_ctx *ctx)
-- 
2.53.0



