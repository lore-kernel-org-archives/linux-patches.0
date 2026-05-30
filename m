Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B5E223DC6;
	Sat, 30 May 2026 18:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164801; cv=none; b=hpx8mwzUCkT1IJaWIc1J1CC/48TFxJFGlwJLrfiElJTA9rIy348O7H7QoeG7SSAiyUuJfchSO6m3XabUmIJnAl/WW6Fhdg46j6Y/UymP6FxtPC90N1op2Utn7CAPRck9HNKTbkUaM7O2w3pSrullNfl2dAb1Ildg/vH3ZtC0nmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164801; c=relaxed/simple;
	bh=cbjcytuIskpXVFOUz3TE97PhIWAAdmb1Jgr33SadYE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IXQhXjZAMhd97Z2PFFa/9KplB6UqZiZNsCzuW9J4MIqSIXVAr/v9d+9Ty7IB7eXYuUgLaP8vVRugY0ZY8VpPBshWvy23XdI1dMSjEUGUnJsPmEun2363YyLeINjbCYJ48gcaAyk8I3cUZnBDaJpZHjFvYRg1zUVbfbps5EE2/aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ynshIHbf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ynshIHbf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF1E1F00893;
	Sat, 30 May 2026 18:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164800;
	bh=E4xEX2FV4+M8rnk7dwu3WKIntHNL3HnmOTA/r6pC7Xg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ynshIHbf/ygXotVC6SgbiqShlqMgugpLDX/0NgYzDADdmxgn72osCEG01+j8sJ5a7
	 7B5hdNJCq4pgXyzMIC1TPljo/DUujbP1Ya9oa9Jld5dEDbbRay0yVAUETEMeaAKjkw
	 ztE8D3kUSDNmrtSTMo7pLYi8p+VzgQpppCHDGKMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Brzezinka <sebastian.brzezinka@intel.com>,
	Krzysztof Karas <krzysztof.karas@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>
Subject: [PATCH 5.15 664/776] drm/i915: skip __i915_request_skip() for already signaled requests
Date: Sat, 30 May 2026 18:06:18 +0200
Message-ID: <20260530160257.052007704@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -137,7 +137,8 @@ void __i915_request_reset(struct i915_re
 	rcu_read_lock(); /* protect the GEM context */
 	if (guilty) {
 		i915_request_set_error_once(rq, -EIO);
-		__i915_request_skip(rq);
+		if (!i915_request_signaled(rq))
+			__i915_request_skip(rq);
 		banned = mark_guilty(rq);
 	} else {
 		i915_request_set_error_once(rq, -EAGAIN);


