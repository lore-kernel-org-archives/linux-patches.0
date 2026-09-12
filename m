Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA503537FF;
	Sat, 12 Sep 2026 12:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214488; cv=none; b=TangV/em/JXhVCz80jq4k1W88HNVq+eNOZ8AfC8X1MGV4DbaMeL3FllLQEc4j5R7p+2fZJW2Lv0pkSaJZ2jElqt1lc4nK3p2+syp377UDBLIPLUaiNKicMyQqPC1cEsVzm7POM1Z1e9mZshuVM/fFOpE5mmJFdDG/C/t0Izb4LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214488; c=relaxed/simple;
	bh=TMNi2XjxkB+t1KJ81u7Ip0VMiSAbbsKRWIAIpCqOSiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EePFQZqut9ntdVBpWTaLKx/20YfHr6tLIOU5YQFF6XjXB7b3yAfRAzgr8YX2CBTau8GgKeE0vLS8xL4dpsEwRN2wyw9ZqcjATg+0nMR1rUNGylm60RpIwFeZDeOwTRRNt6x75Og+iJyIWtnkCD2pY6AFLRNNoWrW0FK9M6mH06g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f+4Ib/PP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f+4Ib/PP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F116C1F000FF;
	Sat, 12 Sep 2026 12:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214486;
	bh=P95OyW6SygCr1Qnq/kqbU8A4nE40aFbn36w5oJI5N1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f+4Ib/PPKzLAEhC46sycXW4X2Q63oZXJovQvLnmsVBm9T53eT/EaTiTx4Ufj1jd5E
	 yvfc40sfu4s1d2lI39hwy1OMatTEAwrhzLgyK6g3jwANXNGa6kAohxOAnY0A3fuut1
	 vvpc4lwOjr38kJBW5Kbs8Jjtte3EWXpi9Fqtf3kM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0293/1376] mm/damon/paddr: drop last same folio access check reuse optimization
Date: Sat, 12 Sep 2026 08:45:19 +0200
Message-ID: <20260912065614.078565548@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 mm/damon/paddr.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index d4a4d51750f5f..a6b1de97b1e8a 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -148,7 +148,7 @@ static bool damon_folio_young(struct folio *folio)
 	return accessed;
 }
 
-static bool damon_pa_young(unsigned long paddr, unsigned long *folio_sz)
+static bool damon_pa_young(unsigned long paddr)
 {
 	struct folio *folio = damon_get_folio(PHYS_PFN(paddr));
 	bool accessed;
@@ -157,7 +157,6 @@ static bool damon_pa_young(unsigned long paddr, unsigned long *folio_sz)
 		return false;
 
 	accessed = damon_folio_young(folio);
-	*folio_sz = folio_size(folio);
 	folio_put(folio);
 	return accessed;
 }
@@ -165,21 +164,10 @@ static bool damon_pa_young(unsigned long paddr, unsigned long *folio_sz)
 static void __damon_pa_check_access(struct damon_region *r,
 		struct damon_attrs *attrs)
 {
-	static unsigned long last_addr;
-	static unsigned long last_folio_sz = PAGE_SIZE;
-	static bool last_accessed;
-
-	/* If the region is in the last checked page, reuse the result */
-	if (ALIGN_DOWN(last_addr, last_folio_sz) ==
-				ALIGN_DOWN(r->sampling_addr, last_folio_sz)) {
-		damon_update_region_access_rate(r, last_accessed, attrs);
-		return;
-	}
-
-	last_accessed = damon_pa_young(r->sampling_addr, &last_folio_sz);
-	damon_update_region_access_rate(r, last_accessed, attrs);
+	bool accessed;
 
-	last_addr = r->sampling_addr;
+	accessed = damon_pa_young(r->sampling_addr);
+	damon_update_region_access_rate(r, accessed, attrs);
 }
 
 static unsigned int damon_pa_check_accesses(struct damon_ctx *ctx)
-- 
2.53.0



