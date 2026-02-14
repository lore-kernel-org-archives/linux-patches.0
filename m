Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B1F17B506;
	Sat, 14 Feb 2026 01:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031019; cv=none; b=gDhnwDZm5g6SmZjBpC8TMnxIx/MMYzaEuCKPYFVRhaN40AwuOB9XcTx93Fpx7xpU5V36Xr4hFqA3zEsh4x76jHXIhDlT2NPWHAykoKe7pGc+xN0t0QElWSOnWXGHBZQHSkjBdesIGataw67/tf/jdjvN55fO3sMW7HCQB6cKZTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031019; c=relaxed/simple;
	bh=Nr6HY9tCKQiB7HyVyKbj/Vo6neuw+52XUIkxsknqJNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lwNOr244KoDL4o+YKLwUzaBts13tjl5doZguuYvFe9yPtEGBIRMIC6jPECv7+Vu55cYMQKv4jQTYrY/pqcgGI7aGwgGnyzVl1lcxf4kfrGv8hv+GA0WLwfkyPW81EWL1VFbMaXy0aOasX2snhoo3OMoY9g6LyX5UVqS1HTD6LUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ed5G0EKn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ed5G0EKn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5540CC116C6;
	Sat, 14 Feb 2026 01:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031019;
	bh=Nr6HY9tCKQiB7HyVyKbj/Vo6neuw+52XUIkxsknqJNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ed5G0EKna2vsyV887GX53Ipkz2PHgwpr2HGJe8lhV+e9igtJFU3OOSkru23mXdBvL
	 YwdpY9meZTiT62LmJh9K9jxV0HCYuhAm0oF4S49eymOjWudtv1chWXSZcO0B5/8YVX
	 82PcPYX9iDxxb6AGuyJDp9Xm1CNocXVmd7kvR0IeZRGU779d8jSzuBD71CzoEbUjvR
	 DZnedSqQ010a1b4dYWZ9GH52GflBWpj+pjSgde4jMIRwcg9ZhMFyYHbNijZs36QjKC
	 TDNMbbLXkRTTc2zqslLGY8v1+h7MWLqAVNmJaVJ/C9vYTCuoxCfl4JGJTByGt3EWSV
	 i4nyFwHbkDrWw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ludovic Desroches <ludovic.desroches@microchip.com>,
	Manikandan Muralidharan <manikandan.m@microchip.com>,
	Sasha Levin <sashal@kernel.org>,
	dharma.b@microchip.com,
	nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev,
	dri-devel@lists.freedesktop.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.19-5.10] drm/atmel-hlcdc: fix use-after-free of drm_crtc_commit after release
Date: Fri, 13 Feb 2026 19:58:25 -0500
Message-ID: <20260214010245.3671907-25-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ludovic Desroches <ludovic.desroches@microchip.com>

[ Upstream commit bc847787233277a337788568e90a6ee1557595eb ]

The atmel_hlcdc_plane_atomic_duplicate_state() callback was copying
the atmel_hlcdc_plane state structure without properly duplicating the
drm_plane_state. In particular, state->commit remained set to the old
state commit, which can lead to a use-after-free in the next
drm_atomic_commit() call.

Fix this by calling
__drm_atomic_helper_duplicate_plane_state(), which correctly clones
the base drm_plane_state (including the ->commit pointer).

It has been seen when closing and re-opening the device node while
another DRM client (e.g. fbdev) is still attached:

=============================================================================
BUG kmalloc-64 (Not tainted): Poison overwritten
-----------------------------------------------------------------------------

0xc611b344-0xc611b344 @offset=836. First byte 0x6a instead of 0x6b
FIX kmalloc-64: Restoring Poison 0xc611b344-0xc611b344=0x6b
Allocated in drm_atomic_helper_setup_commit+0x1e8/0x7bc age=178 cpu=0
pid=29
 drm_atomic_helper_setup_commit+0x1e8/0x7bc
 drm_atomic_helper_commit+0x3c/0x15c
 drm_atomic_commit+0xc0/0xf4
 drm_framebuffer_remove+0x4cc/0x5a8
 drm_mode_rmfb_work_fn+0x6c/0x80
 process_one_work+0x12c/0x2cc
 worker_thread+0x2a8/0x400
 kthread+0xc0/0xdc
 ret_from_fork+0x14/0x28
Freed in drm_atomic_helper_commit_hw_done+0x100/0x150 age=8 cpu=0
pid=169
 drm_atomic_helper_commit_hw_done+0x100/0x150
 drm_atomic_helper_commit_tail+0x64/0x8c
 commit_tail+0x168/0x18c
 drm_atomic_helper_commit+0x138/0x15c
 drm_atomic_commit+0xc0/0xf4
 drm_atomic_helper_set_config+0x84/0xb8
 drm_mode_setcrtc+0x32c/0x810
 drm_ioctl+0x20c/0x488
 sys_ioctl+0x14c/0xc20
 ret_fast_syscall+0x0/0x54
Slab 0xef8bc360 objects=21 used=16 fp=0xc611b7c0
flags=0x200(workingset|zone=0)
Object 0xc611b340 @offset=832 fp=0xc611b7c0

Signed-off-by: Ludovic Desroches <ludovic.desroches@microchip.com>
Reviewed-by: Manikandan Muralidharan <manikandan.m@microchip.com>
Link: https://patch.msgid.link/20251024-lcd_fixes_mainlining-v1-2-79b615130dc3@microchip.com
Signed-off-by: Manikandan Muralidharan <manikandan.m@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This confirms the fix. The key lines in the helper are:

```c
state->fence = NULL;
state->commit = NULL;      // THIS is the critical fix
state->fb_damage_clips = NULL;
```

The old code was missing the `state->commit = NULL` step. By using the
helper, the commit pointer is properly set to NULL in the duplicated
state, preventing the use-after-free when the old state's commit is
freed.

Additionally, `state->fence` and `state->fb_damage_clips` were also not
being properly handled in the old code — the helper fixes multiple
potential issues at once.

### 3. CLASSIFICATION

- **Bug type**: Use-after-free (UAF) — one of the most critical bug
  categories for stable
- **Severity**: HIGH — UAF can lead to kernel crashes, data corruption,
  and potentially security vulnerabilities
- **Reproducibility**: PROVEN — the commit includes a full stack trace
  from a real reproduction

### 4. SCOPE AND RISK ASSESSMENT

- **Lines changed**: Net -1 line (replaced 2 lines with 1 line)
- **Files touched**: 1 file (`atmel_hlcdc_plane.c`)
- **Complexity**: Minimal — uses the standard, well-tested DRM helper
  function
- **Risk of regression**: Extremely low — this replaces incorrect manual
  code with the standard pattern used by virtually all other DRM drivers
- **The destroy_state function already uses
  `__drm_atomic_helper_plane_destroy_state`**, so using the duplicate
  counterpart is the correct and symmetric approach

### 5. USER IMPACT

- Affects users of Atmel HLCDC display controllers (common in
  Atmel/Microchip SoCs used in embedded systems)
- The bug triggers when closing and re-opening display device nodes
  while another client (e.g., fbdev emulation) remains — a realistic
  scenario
- Impact when triggered: kernel BUG (slab corruption), which can lead to
  crashes or worse

### 6. STABILITY INDICATORS

- **Reviewed-by**: Manikandan Muralidharan (subsystem maintainer for
  this driver)
- **Author**: Ludovic Desroches from Microchip — the hardware vendor's
  own engineer
- The fix uses a well-established DRM helper function that has been
  stable for years

### 7. DEPENDENCY CHECK

- `__drm_atomic_helper_plane_duplicate_state()` has existed in the
  kernel since at least 4.x series — no dependency issues for any active
  stable tree
- The atmel-hlcdc driver exists in all active stable trees
- The fix is completely self-contained — no other patches needed

### Summary

This is a textbook stable backport candidate:
- **Obviously correct**: Replaces broken manual code with the standard
  DRM helper
- **Fixes a real bug**: UAF proven with stack trace
- **Small and contained**: 1 file, net -1 line change
- **No new features**: Pure bug fix
- **Low regression risk**: Uses established, well-tested helper function
- **Real-world impact**: Reproducible crash scenario on embedded
  hardware

**YES**

 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c b/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c
index ec1fb5f9549a2..e55e88d44e829 100644
--- a/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c
+++ b/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c
@@ -1160,8 +1160,7 @@ atmel_hlcdc_plane_atomic_duplicate_state(struct drm_plane *p)
 		return NULL;
 	}
 
-	if (copy->base.fb)
-		drm_framebuffer_get(copy->base.fb);
+	__drm_atomic_helper_plane_duplicate_state(p, &copy->base);
 
 	return &copy->base;
 }
-- 
2.51.0

