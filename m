Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2931ED30
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EFD5C433C7;
	Tue,  1 Aug 2023 09:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883416;
	bh=qrzg14Bd8WjA574KfLC9QCX5Z//7HtoBEbiO3fZOoj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nn9IdGRAuCvZHFFl4oPUxsJee+1XPFICX9XxJ+FpNnQhfIbzggAwWOr9TzMNXWQwy
	 4D1cAEsW9S9rOHiVpXH9A5PrMbOHlTUmYYqiKMQpihhCPNRfRwKjpIg0R0dDB56Bfm
	 Z4S6o/0m2mIoE/y3VOGsOH6J7aU8FEn4WSvwZScg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
	Chris Wilson <chris.p.wilson@intel.com>,
	Fei Yang <fei.yang@intel.com>,
	Radhakrishna Sripada <radhakrishna.sripada@intel.com>,
	Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Subject: [PATCH 6.4 229/239] drm/i915/dpt: Use shmem for dpt objects
Date: Tue,  1 Aug 2023 11:21:33 +0200
Message-ID: <20230801091934.225190574@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Radhakrishna Sripada <radhakrishna.sripada@intel.com>

commit 3844ed5e78823eebb5f0f1edefc403310693d402 upstream.

Dpt objects that are created from internal get evicted when there is
memory pressure and do not get restored when pinned during scanout. The
pinned page table entries look corrupted and programming the display
engine with the incorrect pte's result in DE throwing pipe faults.

Create DPT objects from shmem and mark the object as dirty when pinning so
that the object is restored when shrinker evicts an unpinned buffer object.

v2: Unconditionally mark the dpt objects dirty during pinning(Chris).

Fixes: 0dc987b699ce ("drm/i915/display: Add smem fallback allocation for dpt")
Cc: <stable@vger.kernel.org> # v6.0+
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Suggested-by: Chris Wilson <chris.p.wilson@intel.com>
Signed-off-by: Fei Yang <fei.yang@intel.com>
Signed-off-by: Radhakrishna Sripada <radhakrishna.sripada@intel.com>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230718225118.2562132-1-radhakrishna.sripada@intel.com
(cherry picked from commit e91a777a6e602ba0e3366e053e4e094a334a1244)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dpt.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_dpt.c
+++ b/drivers/gpu/drm/i915/display/intel_dpt.c
@@ -166,6 +166,8 @@ struct i915_vma *intel_dpt_pin(struct i9
 		i915_vma_get(vma);
 	}
 
+	dpt->obj->mm.dirty = true;
+
 	atomic_dec(&i915->gpu_error.pending_fb_pin);
 	intel_runtime_pm_put(&i915->runtime_pm, wakeref);
 
@@ -261,7 +263,7 @@ intel_dpt_create(struct intel_framebuffe
 		dpt_obj = i915_gem_object_create_stolen(i915, size);
 	if (IS_ERR(dpt_obj) && !HAS_LMEM(i915)) {
 		drm_dbg_kms(&i915->drm, "Allocating dpt from smem\n");
-		dpt_obj = i915_gem_object_create_internal(i915, size);
+		dpt_obj = i915_gem_object_create_shmem(i915, size);
 	}
 	if (IS_ERR(dpt_obj))
 		return ERR_CAST(dpt_obj);


