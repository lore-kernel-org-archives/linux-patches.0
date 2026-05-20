Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3433F88B5;
	Wed, 20 May 2026 17:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299927; cv=none; b=NCGa8lNdoCm56nZ6yBgC9VAxuS+RGe1hM0dV+pwy4Yr/cohjHSZGb+uJJfCaXThxEeJIowz0sgiehI3qwVaE+Vqt3g3TOHXEWgF+9pbFSuyx6xUAvW6Uie/LozkQiPe958+Qadts9/yDdrM5LAL5pDkrydR9gFqycR22E2AyCsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299927; c=relaxed/simple;
	bh=5TIYkwmsC2AFOoCOSjEczJ6mKnzPWNqPWSMyjfDA7qU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jl5ax6ANzNcNLNj/gbjNm23qDiw0iyyb/HKKMeO+Cr83OxHh14A3iaOPxSE1VR/wOTezz/m4OgcFYTq77PmRiFsVAn79UUy3YckRfqBFXpipWGC/se7hDJuSI8OSEKSL0ObCP3TkFkoWg+u+m3ZKXX1fWJkjCiY2JJNMG6E3Y6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jmIpnCdw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jmIpnCdw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EEFB1F000E9;
	Wed, 20 May 2026 17:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299926;
	bh=LMgqzq2ZmhiAosn1LfiWUQcA3WP0z4nXKi0FDLxPE0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jmIpnCdwoPVc3Vb/yfyeX85eloTN1MnI/iM07czSyJ4y1Se/ZpcdA1Pj/lJKNP+jO
	 Ar+wC2eTHQ8coLOrPxzqdaw22xz86kQ/dxA1SV63bCs6jFdeY2YH8MBNa2+sZbtCMY
	 Efv7quEn4h/I43o1Uo9AEu/NqBAUJ8RaPNj9v//E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Brzezinka <sebastian.brzezinka@intel.com>,
	Krzysztof Karas <krzysztof.karas@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>
Subject: [PATCH 6.18 940/957] drm/i915: skip __i915_request_skip() for already signaled requests
Date: Wed, 20 May 2026 18:23:43 +0200
Message-ID: <20260520162154.982804438@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Brzezinka <sebastian.brzezinka@intel.com>

commit 4cfe4c0efbdcde742a47813180cc69b132d7598e upstream.

After a GPU reset the HWSP is zeroed, so previously completed
requests appear incomplete. If such a request is picked up during
reset_rewind() and marked guilty, i915_request_set_error_once()
returns early (fence already signaled), leaving fence.error without
a fatal error code. The subsequent __i915_request_skip() then hits:
```
GEM_BUG_ON(!fatal_error(rq->fence.error))
```

Fixes a kernel BUG observed on Sandy Bridge (Gen6) during
heartbeat-triggered engine resets.
```
kernel BUG at drivers/gpu/drm/i915/i915_request.c:556!
RIP: __i915_request_skip+0x15e/0x1d0 [i915]
...
__i915_request_reset+0x212/0xa70 [i915]
reset_rewind+0xe4/0x280 [i915]
intel_gt_reset+0x30d/0x5b0 [i915]
heartbeat+0x516/0x530 [i915]
```

Guard __i915_request_skip() with i915_request_signaled(), if the
fence is already signaled, the ring content is committed and there
is nothing left to skip.

Fixes: 36e191f0644b ("drm/i915: Apply i915_request_skip() on submission")
Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/work_items/13729
Signed-off-by: Sebastian Brzezinka <sebastian.brzezinka@intel.com>
Cc: stable@vger.kernel.org # v5.7+
Reviewed-by: Krzysztof Karas <krzysztof.karas@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://lore.kernel.org/r/fe76921d35b6ae85aa651822726d0d9815aa5362.1776339012.git.sebastian.brzezinka@intel.com
(cherry picked from commit 5ba54393dcd7adf75a9f39f5a933b1538349cad5)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/intel_reset.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gt/intel_reset.c
+++ b/drivers/gpu/drm/i915/gt/intel_reset.c
@@ -132,7 +132,8 @@ void __i915_request_reset(struct i915_re
 	rcu_read_lock(); /* protect the GEM context */
 	if (guilty) {
 		i915_request_set_error_once(rq, -EIO);
-		__i915_request_skip(rq);
+		if (!i915_request_signaled(rq))
+			__i915_request_skip(rq);
 		banned = mark_guilty(rq);
 	} else {
 		i915_request_set_error_once(rq, -EAGAIN);


