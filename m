Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8696E1D5ABA;
	Sat, 14 Feb 2026 01:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031022; cv=none; b=g1XBbXYIiP0XJ+WOAXNSev16cqzuaYb4kj5lwKd2cOtvH68T1ztd7v9H/l8nIngnkCO6MVYR4O0RLgzOVSyUHU96hEf9ORkrCxBIBy0WzBB099/8ZpducfA0pCiXSE9mlstsmKJRd5dRqpCWN1bdg4dxnx8xGFNmVtuTqZmVID0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031022; c=relaxed/simple;
	bh=i0m5jpLcq9vTx8uxxU40OSIo5rQevyWzbjML5meHEcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tvtAOM1Kx9gqZ77iCWAgLkSZvDBN8e0lnipu7aa4qzmKKi72juVJODad6wHZYbgqW7No5BRE57TGrEOBlmO8EnoywXI0CSoEux6YxpbKjmJNuMXYif7GkQzvXC5fTsDAIy7ztSIELxPiWcTssd2xazFvvhMsDZyrTuuHko/3kqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SS2lCril; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SS2lCril"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C37C16AAE;
	Sat, 14 Feb 2026 01:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031022;
	bh=i0m5jpLcq9vTx8uxxU40OSIo5rQevyWzbjML5meHEcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SS2lCrilBfPXGco1KrNlen4ztVqbwZMFgIUAwfvi3LoZ6bjb+29k1lmHD3Nva2HSI
	 S1uXiAi+swkUYYSZwAwocL/FkTwwh1RvYZSGxIzKvw+hrBzLobRSHulbKuQaDVQedf
	 gAYjhfLEGSm3TYCAro/umOxMzDJEHZzhJkVhVXr3kBIVA238kQkdzLeaTn9H5oGFDV
	 I3/jU/JIMbcRtQWXo60PPMBLw0IzzCV6dxyqBl/25/UNxk8fGAq5Kzh+PRGUPDRnPh
	 70OsBYuq7TYbbpcNdv5GKUh4xtA1kD5S43n63v8BMmG2CG4j0PyaKfWX1vE+Qgk0he
	 OQrKgX0751oYQ==
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
Subject: [PATCH AUTOSEL 6.19-5.10] drm/atmel-hlcdc: fix memory leak from the atomic_destroy_state callback
Date: Fri, 13 Feb 2026 19:58:27 -0500
Message-ID: <20260214010245.3671907-27-sashal@kernel.org>
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
Content-Transfer-Encoding: 8bit

From: Ludovic Desroches <ludovic.desroches@microchip.com>

[ Upstream commit f12352471061df83a36edf54bbb16284793284e4 ]

After several commits, the slab memory increases. Some drm_crtc_commit
objects are not freed. The atomic_destroy_state callback only put the
framebuffer. Use the __drm_atomic_helper_plane_destroy_state() function
to put all the objects that are no longer needed.

It has been seen after hours of usage of a graphics application or using
kmemleak:

unreferenced object 0xc63a6580 (size 64):
  comm "egt_basic", pid 171, jiffies 4294940784
  hex dump (first 32 bytes):
    40 50 34 c5 01 00 00 00 ff ff ff ff 8c 65 3a c6  @P4..........e:.
    8c 65 3a c6 ff ff ff ff 98 65 3a c6 98 65 3a c6  .e:......e:..e:.
  backtrace (crc c25aa925):
    kmemleak_alloc+0x34/0x3c
    __kmalloc_cache_noprof+0x150/0x1a4
    drm_atomic_helper_setup_commit+0x1e8/0x7bc
    drm_atomic_helper_commit+0x3c/0x15c
    drm_atomic_commit+0xc0/0xf4
    drm_atomic_helper_set_config+0x84/0xb8
    drm_mode_setcrtc+0x32c/0x810
    drm_ioctl+0x20c/0x488
    sys_ioctl+0x14c/0xc20
    ret_fast_syscall+0x0/0x54

Signed-off-by: Ludovic Desroches <ludovic.desroches@microchip.com>
Reviewed-by: Manikandan Muralidharan <manikandan.m@microchip.com>
Link: https://patch.msgid.link/20251024-lcd_fixes_mainlining-v1-1-79b615130dc3@microchip.com
Signed-off-by: Manikandan Muralidharan <manikandan.m@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of drm/atmel-hlcdc: fix memory leak from
atomic_destroy_state callback

### 1. Commit Message Analysis

The commit message is explicit and well-documented:
- **Subject clearly states "fix memory leak"** - this is a bug fix
- **Detailed explanation**: `drm_crtc_commit` objects are not being
  freed because the `atomic_destroy_state` callback only puts the
  framebuffer, but doesn't clean up other objects held in the plane
  state
- **Includes kmemleak backtrace** - the bug is reproducible and
  confirmed with a kernel debugging tool
- **Real-world impact described**: "seen after hours of usage of a
  graphics application" - this affects actual users running graphical
  applications on Atmel/Microchip SoCs
- **Reviewed-by tag** from the subsystem maintainer

### 2. Code Change Analysis

The fix is extremely small and surgical - it replaces a manual
`drm_framebuffer_put()` call with
`__drm_atomic_helper_plane_destroy_state()`.

**What was wrong:**
```c
// OLD - only freed the framebuffer reference
if (s->fb)
    drm_framebuffer_put(s->fb);
```

**What the fix does:**
```c
// NEW - properly cleans up ALL objects in the plane state
__drm_atomic_helper_plane_destroy_state(s);
```

The function `__drm_atomic_helper_plane_destroy_state()` is the standard
DRM helper that properly releases all resources associated with a plane
state, including:
- The framebuffer reference (what was already done)
- The fence
- The `drm_crtc_commit` object (what was being leaked)
- Any other state tracked by the DRM core

This is a textbook case of a driver not using the standard helper
function, leading to incomplete cleanup and memory leaks. The
`drm_crtc_commit` objects accumulate over time, consuming slab memory.

### 3. Classification

- **Bug type**: Memory leak (resource leak)
- **Severity**: Medium-high - progressive memory consumption over hours
  of use eventually impacts system stability
- **Category**: Missing cleanup in a standard callback that should use
  the DRM helper function

### 4. Scope and Risk Assessment

- **Lines changed**: 3 lines (2 removed, 1 added) - extremely minimal
- **Files changed**: 1 file only
- **Risk**: Very low - `__drm_atomic_helper_plane_destroy_state()` is a
  well-established DRM core helper function used by virtually all DRM
  drivers. It's a superset of what was already being done (framebuffer
  put), plus proper cleanup of other state objects. This is not
  introducing new behavior; it's completing the cleanup that should have
  always been done.
- **Could it break something?** Extremely unlikely. The helper function
  does exactly what the old code did (put framebuffer) plus additional
  necessary cleanup.

### 5. User Impact

- **Affected users**: Anyone using the Atmel HLCDC display controller
  (common in Microchip/Atmel SAM series SoCs used in embedded systems)
- **Symptoms**: Gradual memory consumption increase during graphics
  usage, eventually leading to OOM or degraded system performance
- **Trigger**: Normal graphics usage over time - this is a hot path hit
  on every atomic commit
- **Severity if triggered**: Memory leak in a frequently-called path
  leads to eventual system degradation or OOM

### 6. Stability Indicators

- **Reviewed-by** from subsystem maintainer (Manikandan Muralidharan)
- Uses a standard, well-tested DRM helper function
- The fix pattern (replacing manual cleanup with the proper helper) is a
  very common and well-understood DRM fix

### 7. Dependency Check

- `__drm_atomic_helper_plane_destroy_state()` has been available in the
  DRM subsystem for many years (since 2015+), so it exists in all active
  stable trees
- No dependency on other patches - this is a self-contained fix

### 8. Stable Kernel Rules Compliance

1. **Obviously correct and tested**: Yes - uses the standard helper,
   confirmed with kmemleak
2. **Fixes a real bug**: Yes - memory leak confirmed with kmemleak and
   observed in production use
3. **Important issue**: Yes - progressive memory leak in a hot path
   affecting embedded systems
4. **Small and contained**: Yes - 3-line change in a single file
5. **No new features**: Correct - pure bug fix
6. **Applies cleanly**: Should apply cleanly as this is a driver-
   specific change in a stable file

### Summary

This is a clear-cut memory leak fix. It's small, surgical, uses a
standard helper function, has been confirmed with kmemleak, affects real
users running graphics applications on Atmel/Microchip embedded
hardware, and carries virtually no regression risk. It meets all stable
kernel backport criteria.

**YES**

 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c b/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c
index 0ffec44c6d317..c0075894dc422 100644
--- a/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c
+++ b/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c
@@ -1190,8 +1190,7 @@ static void atmel_hlcdc_plane_atomic_destroy_state(struct drm_plane *p,
 			      state->dscrs[i]->self);
 	}
 
-	if (s->fb)
-		drm_framebuffer_put(s->fb);
+	__drm_atomic_helper_plane_destroy_state(s);
 
 	kfree(state);
 }
-- 
2.51.0

