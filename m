Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29AE303A18;
	Sat, 25 Oct 2025 16:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408971; cv=none; b=QazPRQjCa5o4uyx66LEk44KSl264cFHbt2Pm1loCTN1GJ3I9v3qINgC1o2XGrd5S9+hE9xgLmBdKVWAahslTWky1ywlQlG3l84q+8VehCHo9jkVsVxR+FXAyMaN7t1jS3zCJ1UfGEYS32k0gTbecNZCYLYDtCk1N6n+i1jtWAPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408971; c=relaxed/simple;
	bh=VUZRIOpaRwnYppqOeIiHGqkQiRwCcS71uyrgTiJ/dxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=REQogzchqmpdvd9/sKPoe9uAOzrtdUR0EvrTL+QO+YI9aef1pcLI8E5Wvcqf3dB3vxpRIJcJjjQ1Azxd12HOGOefMkQVGFGpzzDtqCpFMOroN4qaGHq8rhGmuSyO/lm1wqwUinz/ejbn2MMhdcM6StqQkVXgdn1E/VD4L+gcprc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nRu9WCw9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nRu9WCw9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D57BDC4CEFB;
	Sat, 25 Oct 2025 16:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408970;
	bh=VUZRIOpaRwnYppqOeIiHGqkQiRwCcS71uyrgTiJ/dxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nRu9WCw9LfDQcffcUkvbe0NMotVgtqKGlFchxsnIwR4GaPANjr3auXBa5sHuLgj8A
	 ONJyFBXtxJRVWV1jcYN6eQP1RY0VtPzl3do9Nn76qr+h0+fhuqtdKSStkLGR7y+fXN
	 9bamhs/t4HyDdv/Wj6HlWhQNCHlWaPoQ4nJt1vU42GHg7awuvFf97/fw6LXB3ZxP25
	 FCjzzokEWCXnJiGrm2OxtZ6HJOhAvHMATDF5Z13o/bXG6WODhJzTNM2DiJ3olJsgGN
	 fVy8HnKzC70wqrmfChtkdU3sOTyew0KktdJixO8Ylf8QZS5d6eP7iZnGVfq2WcdGGb
	 oNVYSAhpwzLiw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zizhi Wo <wozizhi@huaweicloud.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	npitre@baylibre.com,
	jirislaby@kernel.org,
	alexander.deucher@amd.com,
	alexandre.f.demers@gmail.com
Subject: [PATCH AUTOSEL 6.17-6.12] tty/vt: Add missing return value for VT_RESIZE in vt_ioctl()
Date: Sat, 25 Oct 2025 11:56:29 -0400
Message-ID: <20251025160905.3857885-158-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zizhi Wo <wozizhi@huaweicloud.com>

[ Upstream commit da7e8b3823962b13e713d4891e136a261ed8e6a2 ]

In vt_ioctl(), the handler for VT_RESIZE always returns 0, which prevents
users from detecting errors. Add the missing return value so that errors
can be properly reported to users like vt_resizex().

Signed-off-by: Zizhi Wo <wozizhi@huaweicloud.com>
Link: https://lore.kernel.org/r/20250904023955.3892120-1-wozizhi@huaweicloud.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes: VT_RESIZE ioctl silently masked errors. In the
  VT_RESIZE handler, the kernel invoked `__vc_resize(...)` but ignored
  its return value and then fell through to the function’s final `return
  0`, making user space believe resize always succeeded even when it
  failed (e.g., allocation failure, invalid dimensions, or driver
  refusal). The patch propagates the error so users can detect failures.

- Precise change: In `drivers/tty/vt/vt_ioctl.c:911`, the VT_RESIZE path
  now captures and checks the return from `__vc_resize(...)`:
  - Before: `__vc_resize(vc_cons[i].d, cc, ll, true);` then `break` →
    function ending `return 0`.
  - After: `ret = __vc_resize(vc_cons[i].d, cc, ll, true); if (ret)
    return ret;` ensuring a proper error code is returned to userspace
    on failure.
  - Context: `guard(console_lock)();` wraps the loop; early returns
    correctly release the console lock via the cleanup guard
    (include/linux/console.h:669, include/linux/cleanup.h:390).

- Consistency with VT_RESIZEX: `VT_RESIZEX` already reports errors,
  directly returning the error from `__vc_resize()`, as seen in
  `drivers/tty/vt/vt_ioctl.c:662` (inside `vt_resizex`) and the
  VT_RESIZEX case path `drivers/tty/vt/vt_ioctl.c:919`. This patch
  brings VT_RESIZE in line with VT_RESIZEX behavior, improving interface
  consistency.

- Error sources now visible to users:
  - `__vc_resize()` simply forwards the result of `vc_do_resize(...)`
    (`drivers/tty/vt/vt.c:1300`), so errors like:
    - `-EINVAL` for invalid sizes (e.g., exceeding limits) in
      `vc_do_resize` (`drivers/tty/vt/vt.c:1141` start; early checks
      inside return `-EINVAL`).
    - `-ENOMEM` for allocation failures in `vc_do_resize` (kzalloc
      failure in that function).
    - Driver-specific failures from `con_resize` via
      `resize_screen(...)`, which `vc_do_resize` propagates.
  - These conditions were previously hidden from users when using
    VT_RESIZE.

- Scope and risk:
  - Small, contained change in a single file and single switch-case path
    (`drivers/tty/vt/vt_ioctl.c`).
  - No API or ABI changes; only error return propagation.
  - Locks remain correct: early returns under `guard(console_lock)()`
    still release the lock via scope-based cleanup.
  - Behavior on success remains unchanged (still returns 0).
  - The change may expose previously masked errors to userspace, but
    that aligns with kernel/user ABI expectations for ioctls and matches
    VT_RESIZEX.

- Stable policy fit:
  - Fixes a real user-visible bug (silent success on failure).
  - Minimal and low-risk; no architectural changes.
  - Confined to the VT/TTY ioctl handling path.

Given these points, this is a clear, low-risk bugfix that improves error
reporting, aligns VT_RESIZE with VT_RESIZEX, and should be backported to
stable trees.

 drivers/tty/vt/vt_ioctl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/vt/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
index 61342e06970a0..eddb25bec996e 100644
--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -923,7 +923,9 @@ int vt_ioctl(struct tty_struct *tty,
 
 			if (vc) {
 				/* FIXME: review v tty lock */
-				__vc_resize(vc_cons[i].d, cc, ll, true);
+				ret = __vc_resize(vc_cons[i].d, cc, ll, true);
+				if (ret)
+					return ret;
 			}
 		}
 		console_unlock();
-- 
2.51.0

