Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A8F53162E;
	Wed, 23 Sep 2026 14:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174128; cv=none; b=nCkcjDYRp3wzATi+kRlsofZgfAY9oOS2g6+t7E8hSUlwgXWphCy5/X4HfID6Vtz2P6Yg4NsllBWd0sHn+Spq2ZK3ARl+wslQEU+p1hLdwRUOezqNlBInctz2lLEHcXMTlH4g7dT+P/j9bPQBdg/pPtN1NVEAXux/v8QSg1w4Xrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174128; c=relaxed/simple;
	bh=8HhCGelFzNCTiVN0x2LKjVIcyRF1NTm8XEZViarex/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MBXussRbJ73qwjeiqG6uIJbRkc3S+NTieZEZT7L3cvRVcUtn44uP0u7JLAet4gxPas5SwYDQvQpB4rv6HrHQdTQnj3LDsVuWKGyq0AA48ezDx8UcAmGY/k9iFsnNvP9WNVzcZRzpSBalkAXSr0V5Zod8pTiKVaafSK9DkaifXtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GWc77cqq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GWc77cqq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 872EC1F000FF;
	Wed, 23 Sep 2026 14:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174127;
	bh=ZulLXUS+2tcoSjXHlb5yI8xapBiexEiqmZNN2kDONGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GWc77cqqbFlapYrqL/WeFQ40mdXIrERsderVMiPXY+j4Ec2cBJLYOd4SFLYqArK2a
	 ziOrjwKzPCujXd0obFoQiOVYKCs6+NQN8UalU/OHGZoquCkPnfSdTkKHnDP9C16fEH
	 qAC96lvcsRVa9ELpFCeVV5fY0f3q0hsWZZdzaDw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Nikitushkin <bub4z0r@gmail.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 7.2 436/438] drm/ttm: fix swapped-out resources never leaving their bulk_move range
Date: Wed, 23 Sep 2026 16:07:37 +0200
Message-ID: <20260923140656.243373174@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/ttm/ttm_bo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -1178,7 +1178,7 @@ ttm_bo_swapout_cb(struct ttm_lru_walk *w
 
 	if (ttm_tt_is_populated(tt)) {
 		ret = ttm_tt_swapout(bdev, tt, swapout_walk->gfp_flags);
-		if (!ret) {
+		if (ret > 0) {
 			spin_lock(&bdev->lru_lock);
 			ttm_resource_del_bulk_move_unevictable(bo->resource, bo);
 			ttm_resource_move_to_lru_tail(bo->resource);


