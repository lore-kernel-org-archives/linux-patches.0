Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063218;
	b=nNMf/i9ATB0y/GIyk02+gtCzfFIG6Ts47rfzb7svsWE/f89AWmrpbjLDZnLmsIv/sxGj
	 e6mZXxCps7YCPjYNglTXjrZPRNvBFqLwL+gfnEzrmR7VTth75iYkGVelc1RUgHcDL6w2S
	 vRpPIwxJHb795FjKJX9xRcSEJQVVPThYZ0DTSFutPqGDH0twUPQNvNvL9AkTjk+bO7Rev
	 3PbrU2ERboNINYWEV1ljtv1OI8c+uoJdsR+DSbDlILbVsuoQvEviXazD3W0kxBYxByoy8
	 3aNHMXWlEEckkx/Yp2pg1L5igrMOiQaW9/i7y1QqbDLf63Dv2ReZ8Vx+z5H6W+6hvpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063218;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sjy+DvpetCGxH/H93EM9jjN6ENlx7uRStXzr8QNuAIA=;
	b=VqgGrxA6ACT5RkR9ccjlwmO6Qdp9jPGcmrTpBMjT/RgBeGsgb9D5GGc7mDX/DmLl05yn
	 7VUlppzWv8LUulNvkBjWuEXi6im5LaNyImltOdSfwpcnOEpUl59XU5X0NnHPIWohWElcA
	 anOb5CkmAERXCW9Ka4u0gBT40pgYYvvTr0NDteWisbUGEoCmAQXhfR8w7D4hg2gMThRLb
	 qV2PuBh4eLIJTZISoYic/LJUgR0dA4LnckEl+7CbB+79ixCJqLhNtzOcgAYljnrTqELko
	 ca3NoKl6vSHBbHN1zwRXfcxRSMsGKFI3jHHGnCj962xkyHu+pirKvYhnuW+lZYZYhdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h4nWRT9q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6953D606A326;
	Sat,  7 Nov 2026 14:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h4nWRT9q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 102301F008A2;
	Sat,  7 Nov 2026 14:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063218;
	bh=sjy+DvpetCGxH/H93EM9jjN6ENlx7uRStXzr8QNuAIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h4nWRT9qHbLR4MJa9yck+A/Q9fmetUqMM2BBN9HveFwdLzlzevF4yZkOiFMDyyfdp
	 wlYPNxTCQltInGnE/Dl6sQPQdBpmVibS4bhvOff5EtOamr5DUtG3Exa7/y+vDDCbWe
	 wwsXKiXm3zrWy2lCjTrYeVRA7wkhGGXGm3uWM3h0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Luis Chamberalin <mcgrof@kernel.org>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 427/869] mm/execmem: free ROX cache chunks only when they span an entire vm area
Date: Sat,  7 Nov 2026 08:51:49 -0500
Message-ID: <20261107134908.331458183@linuxfoundation.org>
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

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

[ Upstream commit 52d95a55a0113408acd2d4ce0294a72c527f5092 ]

Patch series "mm/execmem: fixes and cleanups for the ROX cache".

Sashiko review of the ROX cache refill path asked what happens when the
PMD_SIZE allocation fails there.  Pulling that thread uncovered a bit more
than the fallback.

Patch 1 fixes a real bug, although rare bug: execmem_cache_clean() can
free a chunk that is still partially in use, because a PMD sized and PMD
aligned free range in the middle of a larger chunk looks exactly like a
chunk that nobody uses.

Patch 2 handles maple tree allocation failures in the cache.  They are
unlikely, but silently dropping an area from the tree is not a great way
to deal with them.

Patch 3 deals with the fallback that started all this.  The cache exists
to keep the direct map free of unnecessary splits, and the fallback
happily filled it with base page mapped areas that could never be freed
from the cache again.  Ask vmalloc for a huge mapping or nothing, and
serve whatever does not fit outside the cache.

Patches 4 and 5 convert the ROX cache to scope based cleanup.

The series was tested on x86 with module load/unload cycles, with PTDUMP
confirming that the cache is using 2M mappings, and with nohugevmalloc to
exercise the uncached fallback.

This patch (of 5):

When execmem refills the ROX cache, it vmalloc()s multiples of PMD_SIZE
aligned to PMD_SIZE.  For every such allocation vmalloc creates a vm area.

The first part of the vmalloc()ed chunk is returned to the allocation that
triggered the cache refill and the remaining part is added to the cache
and handed out for subsequent allocations with execmem_alloc().

When only the first part is freed, the entire vm area remains in the ROX
cache and can be handed out again.

In the case when the first allocation is larger than PMD_SIZE and the
second allocation from the freed first part of the chunk is exactly
PMD_SIZE, execmem_cache_clean() will free the entire chunk while part of
it is still in use.

For example:

	/*
	 * vmalloc(4M), return p0 to the caller
	 * add [p0 + 3M, p0 + 4M) to the cache
	 */
	p0 = execmem_alloc(3M);

	/* return p0 + 3M from the cache to the caller */
	p1 = execmem_alloc(1M);

	/* put [p0, p0 + 3M) back into the cache */
	execmem_free(p0);

	/* return p0 from the cache to the caller */
	p2 = execmem_alloc(2M);

	/* return p0 + 2M from the cache to the caller */
	p3 = execmem_alloc(1M);

	/* bah! execmem_cache_clean() frees the entire 4M chunk */
	execmem_free(p2);

Make sure that the ranges that execmem_cache_clean() frees cover the
entire vm area.

Link: https://lore.kernel.org/20260903-execmem-rox-cache-pmd-v1-v1-0-11beb2a3d249@kernel.org
Link: https://lore.kernel.org/20260903-execmem-rox-cache-pmd-v1-v1-1-11beb2a3d249@kernel.org
Fixes: 2e45474ab14f ("execmem: add support for cache of large ROX pages")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: copilot:claude-opus-5
Cc: Benjamin Tissoires <bentiss@kernel.org>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/execmem.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/execmem.c b/mm/execmem.c
index 084a207e4278b..9560441e57ab1 100644
--- a/mm/execmem.c
+++ b/mm/execmem.c
@@ -164,9 +164,11 @@ static void execmem_cache_clean(struct work_struct *work)
 
 	mutex_lock(mutex);
 	mas_for_each(&mas, area, ULONG_MAX) {
+		struct vm_struct *vm = find_vm_area(area);
 		size_t size = mas_range_len(&mas);
 
-		if (IS_ALIGNED(size, PMD_SIZE) &&
+		if (vm && get_vm_area_size(vm) == size &&
+		    IS_ALIGNED(size, PMD_SIZE) &&
 		    IS_ALIGNED(mas.index, PMD_SIZE)) {
 			struct vm_struct *vm = find_vm_area(area);
 
-- 
2.53.0



