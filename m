Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773767;
	b=ovaCPkc1FTHoXTAklqSIegYGnKUylCljG3RdYF3QfrWUDOOdxU+I2crEqHf87d8pzM1C
	 WcIAnTGRoEh7j7Tte5YGj25Ox+aYe3etBYn88K0VFcvlHxfb12M5h4LiKrQMSdbwT1NLt
	 M42yIafbPcPNXmHuEM9hJem0MZ55j4CBUZcH5hn4PP78IT7ntp52LrzSBV6fjEvAzZ0/5
	 2NYzTGRL+Zc59I7Z64j0+cBgy90XdVDrMofLbHJSnTV6Qqb2sQyZ1gupvHRkdN6/okq0w
	 MZkoSfR4qEO52VS9SIR+PPK8h0w0rTYsiSRyV7mJOHf1Ub5ogV3BLqGJEDzAWHgsJlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773767;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=NswlyblkCfQXf057shdzjzV1gh8i9YF/IY4zMeVnJ5M=;
	b=XRyN7n3F0zJbQRVlOmVU5jPTBPvZdFwWe0cTQwcPEMg+BY4wsJASo+x0XCE/2qcXSi+/
	 OAohX7F6Zl7WGVb/zr20Fte2PDXdhHRO5GjyzeGIUW8L38nZxNFDv5UQzIZoGVMGL9ciO
	 9kwd2ErbpxizPdjTg79lrmvDa5/B4zGc5t0JPTZrE8JSjd0+HKA7se6WrzkD/CZAswAjt
	 0qm5KIlp1/DoKZ4e545mtvDndzVYekAYZmTsYq3ck72S1c7USGLYQezCHvaoB+V+QW5v9
	 Z7W/VYinZ89Og2EB328W1UeRw6vxMiGTbl0Se/gpr6fAOm8FnAZQdCfutrz9MVtyKCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oOHSc3uX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9108F606A31B;
	Fri, 23 Oct 2026 16:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oOHSc3uX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C885B1F031E0;
	Fri, 23 Oct 2026 16:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773766;
	bh=NswlyblkCfQXf057shdzjzV1gh8i9YF/IY4zMeVnJ5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oOHSc3uXE0lZYGu4aiw53voV8bg0qG4SNh9ug0Ipdmr67d1SAPFPbKRURKX7Umj2S
	 dTSRd1Iz/EOw2qW0zo48O2KE1jeoH7p3ut5h06neG4dhi7/UfBh/rg76sWM2M1jXAV
	 DPo1nhDbjp2ZVJGW9Ncebxm1SS55zN5h4iEHJXQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Nikitushkin <bub4z0r@gmail.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 001/193] drm/ttm: fix swapped-out resources never leaving their bulk_move range
Date: Fri, 23 Oct 2026 18:34:38 +0200
Message-ID: <20261023163714.237943780@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vadim Nikitushkin <bub4z0r@gmail.com>

commit 3db7d7d583419f7b1f2e141e36418802dbb25cf8 upstream.

ttm_tt_swapout() returns the number of pages swapped out on success and
a negative error code on failure; for a populated ttm it never returns
zero. Commit b2ed01e7ad3d ("drm/ttm: Fix ttm_bo_swapout() infinite LRU
walk on swapout failure") moved the bulk_move bookkeeping in
ttm_bo_swapout_cb() under "if (!ret)", so the
ttm_resource_del_bulk_move_unevictable() / ttm_resource_move_to_lru_tail()
pair is now skipped on every successful swapout. The equivalent change
for the shrinker in commit 1d59f36e95f7 ("drm/ttm: Fix ttm_bo_shrink()
infinite LRU walk on backup failure") tests "lret > 0", which is what
was intended here as well.

Before b2ed01e7ad3d the resource was taken off the bulk_move before the
swapout; since then a swapped-out resource stays inside its BO's
bulk_move range (and on the manager LRU) although it is unevictable.
When it is later freed or the BO leaves the bulk_move
(ttm_resource_free(), ttm_bo_set_bulk_move() via amdgpu_vm_bo_del()),
ttm_resource_del_bulk_move() skips it because of its
!ttm_resource_unevictable() guard, so a range endpoint in pos->first /
pos->last is left pointing at freed memory. The next
ttm_lru_bulk_move_tail() or ttm_resource_add_bulk_move() on that cursor
is a use-after-free, seen as the resv WARN in ttm_lru_bulk_move_add(),
"list_del corruption" in ttm_resource_move_to_lru_tail() or a NULL
dereference in ttm_resource_manager_next() -- minutes to hours after a
hibernation, or at process exit / reboot following one. Samuel
Ainsworth's analysis of drm/amd issue 5387 (see Link) identified the
dangling cursor; the missing removal at swapout time is the reason it
dangles.

Testing the condition for success restores the removal. On an AMD
Phoenix APU (ASUS UM3406GA, gfx1103) running suspend-then-hibernate on
a 7.0.y stable kernel carrying the backport (Ubuntu 7.0.0-31) the bug
crashed 5 of 18 hibernation cycles; a function profile of one
hibernation showed 336 ttm_tt_swapout() calls and zero
ttm_resource_del_bulk_move_unevictable() calls. With this change the
removal happens for every swapped-out resource and 12 further cycles
were clean.

Fixes: b2ed01e7ad3d ("drm/ttm: Fix ttm_bo_swapout() infinite LRU walk on swapout failure")
Cc: stable@vger.kernel.org # v7.1+
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/5387
Link: https://lore.kernel.org/dri-devel/CAHYiNPa6aVacJoLOje-qZ1GyYx-9p0tN4NuP8D_eSL+UJeevXw@mail.gmail.com/
Signed-off-by: Vadim Nikitushkin <bub4z0r@gmail.com>
Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Link: https://lore.kernel.org/r/20260909205028.13799-1-bub4z0r@gmail.com
[ Squashed with commit fcfe64715b425262af1b36f498f9197f3537ceed
  ("drm/ttm: apply the swapout bulk_move fix to the intended condition"):
  upstream 3db7d7d58341 was applied to the "if (ret)" after
  ttm_resource_try_charge() in ttm_bo_alloc_at_place() instead of the
  "if (!ret)" after ttm_tt_swapout() in ttm_bo_swapout_cb(), and
  fcfe64715b42 restored the former and changed the latter. 7.2.y has no
  ttm_resource_try_charge() (dmem cgroup charging is 7.3 material), so
  neither commit applies on its own; the net effect of the two is the
  single hunk below, which is the change the changelog describes. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ttm/ttm_bo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index 493471012820e..de04814a2e967 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -1176,7 +1176,7 @@ ttm_bo_swapout_cb(struct ttm_lru_walk *walk, struct ttm_buffer_object *bo)
 
 	if (ttm_tt_is_populated(tt)) {
 		ret = ttm_tt_swapout(bdev, tt, swapout_walk->gfp_flags);
-		if (!ret) {
+		if (ret > 0) {
 			spin_lock(&bdev->lru_lock);
 			ttm_resource_del_bulk_move_unevictable(bo->resource, bo);
 			ttm_resource_move_to_lru_tail(bo->resource);
-- 
2.53.0



