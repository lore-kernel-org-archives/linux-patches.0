Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717C51822C6;
	Wed,  3 Jul 2024 11:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006205; cv=none; b=BUNtCZXvV5qJM3tahPv5Fw3FMQ+Fsf7lo8DBENcXeV/fX97mft0DMsCRdX9/Cbit56uWw3XDgJxQNp/WTZZHWvn/fwU2J7aIxfVbATgYuIWvPepseWeSy1eF1+ps/4ZvQWX/7GEJQUCEybsmL11Cn5RvCv7OEukSIKYvox/87Ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006205; c=relaxed/simple;
	bh=nE92TkNVtfHe3H06sM/RT2hXoRtd/RWUyxF/QgXW1HA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NsGqxjY96I+lJzVymnqqv8N9UlYHuVugpEEIVHrS7p2prMVCKFFOA8TiyEU/XP0d9ucWEWLQnrN22k5Yo2TinHBSWydEHKfQedototai7YU+5puCIBiI3h+317w5HauU7qNV9CshOoCtvsPFHGRGA97y/pciksIvj1lLL1ekU3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m8fsuQ6E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m8fsuQ6E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB0EC2BD10;
	Wed,  3 Jul 2024 11:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006205;
	bh=nE92TkNVtfHe3H06sM/RT2hXoRtd/RWUyxF/QgXW1HA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m8fsuQ6EPk/eh3WDm9+T/F4veOwT2H1SaBeuq0MECcss4EOeKM4p5OTNB4aakRzaB
	 Ti1dpVetXextgmXQJZ3JXJHBdOXpVlNXpJb9ETSYcjM7HWdzz74cdwgw4YAwsFBQvA
	 7WCkTCYyBWuY16Z6sivOHxktV0zjuaD19qLPFxlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.15 335/356] drm/i915/gt: Fix potential UAF by revoke of fence registers
Date: Wed,  3 Jul 2024 12:41:11 +0200
Message-ID: <20240703102925.783848282@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>

commit 996c3412a06578e9d779a16b9e79ace18125ab50 upstream.

CI has been sporadically reporting the following issue triggered by
igt@i915_selftest@live@hangcheck on ADL-P and similar machines:

<6> [414.049203] i915: Running intel_hangcheck_live_selftests/igt_reset_evict_fence
...
<6> [414.068804] i915 0000:00:02.0: [drm] GT0: GUC: submission enabled
<6> [414.068812] i915 0000:00:02.0: [drm] GT0: GUC: SLPC enabled
<3> [414.070354] Unable to pin Y-tiled fence; err:-4
<3> [414.071282] i915_vma_revoke_fence:301 GEM_BUG_ON(!i915_active_is_idle(&fence->active))
...
<4>[  609.603992] ------------[ cut here ]------------
<2>[  609.603995] kernel BUG at drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c:301!
<4>[  609.604003] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
<4>[  609.604006] CPU: 0 PID: 268 Comm: kworker/u64:3 Tainted: G     U  W          6.9.0-CI_DRM_14785-g1ba62f8cea9c+ #1
<4>[  609.604008] Hardware name: Intel Corporation Alder Lake Client Platform/AlderLake-P DDR4 RVP, BIOS RPLPFWI1.R00.4035.A00.2301200723 01/20/2023
<4>[  609.604010] Workqueue: i915 __i915_gem_free_work [i915]
<4>[  609.604149] RIP: 0010:i915_vma_revoke_fence+0x187/0x1f0 [i915]
...
<4>[  609.604271] Call Trace:
<4>[  609.604273]  <TASK>
...
<4>[  609.604716]  __i915_vma_evict+0x2e9/0x550 [i915]
<4>[  609.604852]  __i915_vma_unbind+0x7c/0x160 [i915]
<4>[  609.604977]  force_unbind+0x24/0xa0 [i915]
<4>[  609.605098]  i915_vma_destroy+0x2f/0xa0 [i915]
<4>[  609.605210]  __i915_gem_object_pages_fini+0x51/0x2f0 [i915]
<4>[  609.605330]  __i915_gem_free_objects.isra.0+0x6a/0xc0 [i915]
<4>[  609.605440]  process_scheduled_works+0x351/0x690
...

In the past, there were similar failures reported by CI from other IGT
tests, observed on other platforms.

Before commit 63baf4f3d587 ("drm/i915/gt: Only wait for GPU activity
before unbinding a GGTT fence"), i915_vma_revoke_fence() was waiting for
idleness of vma->active via fence_update().   That commit introduced
vma->fence->active in order for the fence_update() to be able to wait
selectively on that one instead of vma->active since only idleness of
fence registers was needed.  But then, another commit 0d86ee35097a
("drm/i915/gt: Make fence revocation unequivocal") replaced the call to
fence_update() in i915_vma_revoke_fence() with only fence_write(), and
also added that GEM_BUG_ON(!i915_active_is_idle(&fence->active)) in front.
No justification was provided on why we might then expect idleness of
vma->fence->active without first waiting on it.

The issue can be potentially caused by a race among revocation of fence
registers on one side and sequential execution of signal callbacks invoked
on completion of a request that was using them on the other, still
processed in parallel to revocation of those fence registers.  Fix it by
waiting for idleness of vma->fence->active in i915_vma_revoke_fence().

Fixes: 0d86ee35097a ("drm/i915/gt: Make fence revocation unequivocal")
Closes: https://gitlab.freedesktop.org/drm/intel/issues/10021
Signed-off-by: Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
Cc: stable@vger.kernel.org # v5.8+
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240603195446.297690-2-janusz.krzysztofik@linux.intel.com
(cherry picked from commit 24bb052d3dd499c5956abad5f7d8e4fd07da7fb1)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c
+++ b/drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c
@@ -291,6 +291,7 @@ void i915_vma_revoke_fence(struct i915_v
 		return;
 
 	GEM_BUG_ON(fence->vma != vma);
+	i915_active_wait(&fence->active);
 	GEM_BUG_ON(!i915_active_is_idle(&fence->active));
 	GEM_BUG_ON(atomic_read(&fence->pin_count));
 


