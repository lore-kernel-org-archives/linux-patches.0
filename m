Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787A5189537;
	Tue, 30 Jul 2024 17:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359378; cv=none; b=fWmpwBieRKQLRqSTZP+8HYYo+33PFneh67tpHUx2jYXcYKNU01Nb1Q4UCXT0PcWSXJ7e+qKHYcRNhnRhyz4QfRONRntbjielZA1efWOQxpsC9lHkzCUPMGFc7uIBCw+c6SlT0LPETHfNeDUq5Y4dwmsVqsIZwJJRBwERC+iEwp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359378; c=relaxed/simple;
	bh=4EmePcw4FB4FMewVjt7Uhdu8mtAbMfynF9t5PSg8f8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jDxVkJRAzkRU4uuRyju2WiiKvRBXJAS9+o4O0QWqZ/uvPeg/HkPqRg/RBcg5p8t2iUWBsnlqgVMdL0RM7OGrqDODfprzjlVYvRUTO0dH4J6Kgf+2zE0cqK/p13QY2cz9IYsMjKlKGHprv5DGo5uYb2jnt6aitRQpV7UNYCiKa7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zGuRDjrg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zGuRDjrg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB068C32782;
	Tue, 30 Jul 2024 17:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359378;
	bh=4EmePcw4FB4FMewVjt7Uhdu8mtAbMfynF9t5PSg8f8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zGuRDjrgjeIPLa/e/HGNENoeh1VTL4BjJx5rgEIol1davmFJbtN5nrFIMth+c7eyY
	 Zdr7WY9dDAQz1F3HQi98ies6RYnaMz/PWIvI4h1HI98jjrpkCJ1kgrxov2QfdW3Z4G
	 NbZlyGztjIqkh2ERlXqGWRIzTNG3h7Hj5YAU1OVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andi Shyti <andi.shyti@intel.com>,
	Nitin Gote <nitin.r.gote@intel.com>,
	Chris Wilson <chris.p.wilson@linux.intel.com>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>
Subject: [PATCH 6.6 474/568] drm/i915/gt: Do not consider preemption during execlists_dequeue for gen8
Date: Tue, 30 Jul 2024 17:49:41 +0200
Message-ID: <20240730151658.549692409@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nitin Gote <nitin.r.gote@intel.com>

commit 65564157ae64cec0f527583f96e32f484f730f92 upstream.

We're seeing a GPU hang issue on a CHV platform, which was caused by commit
bac24f59f454 ("drm/i915/execlists: Enable coarse preemption boundaries for
Gen8").

The Gen8 platform only supports timeslicing and doesn't have a preemption
mechanism, as its engines do not have a preemption timer.

Commit 751f82b353a6 ("drm/i915/gt: Only disable preemption on Gen8 render
engines") addressed this issue only for render engines. This patch extends
that fix by ensuring that preemption is not considered for all engines on
Gen8 platforms.

v4:
 - Use the correct Fixes tag (Rodrigo Vivi)
 - Reworded commit log (Andi Shyti)

v3:
 - Inside need_preempt(), condition of can_preempt() is not required
   as simplified can_preempt() is enough. (Chris Wilson)

v2: Simplify can_preempt() function (Tvrtko Ursulin)

Fixes: 751f82b353a6 ("drm/i915/gt: Only disable preemption on gen8 render engines")
Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/11396
Suggested-by: Andi Shyti <andi.shyti@intel.com>
Signed-off-by: Nitin Gote <nitin.r.gote@intel.com>
Cc: Chris Wilson <chris.p.wilson@linux.intel.com>
CC: <stable@vger.kernel.org> # v5.12+
Reviewed-by: Jonathan Cavitt <jonathan.cavitt@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240711163208.1355736-1-nitin.r.gote@intel.com
(cherry picked from commit 7df0be6e6280c6fca01d039864bb123e5e36604b)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/intel_execlists_submission.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
+++ b/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
@@ -3315,11 +3315,7 @@ static void remove_from_engine(struct i9
 
 static bool can_preempt(struct intel_engine_cs *engine)
 {
-	if (GRAPHICS_VER(engine->i915) > 8)
-		return true;
-
-	/* GPGPU on bdw requires extra w/a; not implemented */
-	return engine->class != RENDER_CLASS;
+	return GRAPHICS_VER(engine->i915) > 8;
 }
 
 static void kick_execlists(const struct i915_request *rq, int prio)


