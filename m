Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A276533A00E;
	Mon, 18 Aug 2025 14:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525732; cv=none; b=DTV27LYjpf8QACx+OvWYSIqUr8GR8QXnqOTS+q2doeZLg0dK5j8ZDi1KAGTqcH6iYjl9uZnUkgCdKLnIYkDaPTgORUUd54ce5MCcM8roVlKHoCVnWPS6k/hF0JJjDMO3NNN1JivcGi3cJi4w+7xZHScdgj/WrM+8lIe/40MLisM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525732; c=relaxed/simple;
	bh=pM285kOwZDw/HGxAVKFukAxfkPms6/kiH4vbU74iilM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JfQdHaoKkKCoXRzDGlShhOzH6smLK7JjLeBDpZi5sQiQSP7z0avTYshmwWE+CT6w/J/6Vuazg6tjMao8lou8XXUQOy2/zm/03vaWII+hS6AcIBaGHjezUctlCfghUHiiOmbDXC+lzPi5DPPdfZ7YFVIcHY/JQrVatrFkVSWB9Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xh8nFUIv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xh8nFUIv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11909C4CEEB;
	Mon, 18 Aug 2025 14:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525732;
	bh=pM285kOwZDw/HGxAVKFukAxfkPms6/kiH4vbU74iilM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xh8nFUIvvpPla2UAlRk9PlpTG8iT6VSvx0/074U9MucJbmvidzeCb2m3+HGy05JMV
	 xD/qfrgasSNv8rvxl4Wq15e+Tcx81JAccdnq0fRPxJVKXlzlAzifPgN+2ekqHVYiNK
	 kttl8oer3WwDLVKiu6MvVmfqmDkvohiedaAvXrnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 351/570] drm/ttm: Respect the shrinker core free target
Date: Mon, 18 Aug 2025 14:45:38 +0200
Message-ID: <20250818124519.384624998@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>

[ Upstream commit eac21f8ebeb4f84d703cf41dc3f81d16fa9dc00a ]

Currently the TTM shrinker aborts shrinking as soon as it frees pages from
any of the page order pools and by doing so it can fail to respect the
freeing target which was configured by the shrinker core.

We use the wording "can fail" because the number of freed pages will
depend on the presence of pages in the pools and the order of the pools on
the LRU list. For example if there are no free pages in the high order
pools the shrinker core may require multiple passes over the TTM shrinker
before it will free the default target of 128 pages (assuming there are
free pages in the low order pools). This inefficiency can be compounded by
the pool LRU where multiple further calls into the TTM shrinker are
required to end up looking at the pool with pages.

Improve this by never freeing less than the shrinker core has requested.

At the same time we start reporting the number of scanned pages (freed in
this case), which prevents the core shrinker from giving up on the TTM
shrinker too soon and moving on.

v2:
 * Simplify loop logic. (Christian)
 * Improve commit message.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Link: https://lore.kernel.org/r/20250603112750.34997-2-tvrtko.ursulin@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ttm/ttm_pool.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_pool.c b/drivers/gpu/drm/ttm/ttm_pool.c
index c2ea865be657..c060c90b89c0 100644
--- a/drivers/gpu/drm/ttm/ttm_pool.c
+++ b/drivers/gpu/drm/ttm/ttm_pool.c
@@ -1132,7 +1132,6 @@ void ttm_pool_fini(struct ttm_pool *pool)
 }
 EXPORT_SYMBOL(ttm_pool_fini);
 
-/* As long as pages are available make sure to release at least one */
 static unsigned long ttm_pool_shrinker_scan(struct shrinker *shrink,
 					    struct shrink_control *sc)
 {
@@ -1140,9 +1139,12 @@ static unsigned long ttm_pool_shrinker_scan(struct shrinker *shrink,
 
 	do
 		num_freed += ttm_pool_shrink();
-	while (!num_freed && atomic_long_read(&allocated_pages));
+	while (num_freed < sc->nr_to_scan &&
+	       atomic_long_read(&allocated_pages));
 
-	return num_freed;
+	sc->nr_scanned = num_freed;
+
+	return num_freed ?: SHRINK_STOP;
 }
 
 /* Return the number of pages available or SHRINK_EMPTY if we have none */
-- 
2.39.5



