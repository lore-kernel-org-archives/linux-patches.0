Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 197B41DFD1;
	Tue,  8 Oct 2024 13:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392884; cv=none; b=tcRFpNiZtId9tBOS03WYxl1gRbT1SCsVMLlIqq0tp6iOcnMQExz/WHmgr1+V72PSISihPrnDl/V8tbz5qsKwalzMgs889okb+W06Iu1Ksvzrb5bBh6uzYAEAuCspBm5VouRhSOg5haYOpiNxtLmRWKtsZ40nWshebDNOYzX931M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392884; c=relaxed/simple;
	bh=9/4CdHiFVEwQggzQZN1efDv/h5aLDBYZxoF1tRZuTDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NhnMgBulfL8nL0yeiCpFfbLJQIuu84NIBYUl6yByXyeL2B080ZvIYjv6PTRCRx+9v+AHiQlabpXbsk8SBukmnjVODeNy66xdat+1nV5nqoQkYXo3jZtArjkY1mGS/RpzAPCQse20uJj7iqceXIyuTPC5xyjjiwwI+FuG93Uo6pE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=itzUuZmM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="itzUuZmM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 710A6C4CECD;
	Tue,  8 Oct 2024 13:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392883;
	bh=9/4CdHiFVEwQggzQZN1efDv/h5aLDBYZxoF1tRZuTDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=itzUuZmMmQawUyTxHRVJcKcvDsYEoiCvUDfwHpwFIN9Dgxpfh91NbZF+gxTZWQNPk
	 g3nOXRx+399rqOmBC9pUnFd5Oyqpyctov46nw+8tJeBh/qS09mrxuOAX2e1pD8UU8a
	 EAH19gltbHTcniu81sM34gN65URxVQKFd9qCJWqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Anshuman Gupta <anshuman.gupta@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Jani Nikula <jani.nikula@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 6.11 516/558] drm/i915/gem: fix bitwise and logical AND mixup
Date: Tue,  8 Oct 2024 14:09:06 +0200
Message-ID: <20241008115722.533826711@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit 394b52462020b6cceff1f7f47fdebd03589574f3 upstream.

CONFIG_DRM_I915_USERFAULT_AUTOSUSPEND is an int, defaulting to 250. When
the wakeref is non-zero, it's either -1 or a dynamically allocated
pointer, depending on CONFIG_DRM_I915_DEBUG_RUNTIME_PM. It's likely that
the code works by coincidence with the bitwise AND, but with
CONFIG_DRM_I915_DEBUG_RUNTIME_PM=y, there's the off chance that the
condition evaluates to false, and intel_wakeref_auto() doesn't get
called. Switch to the intended logical AND.

v2: Use != to avoid clang -Wconstant-logical-operand (Nathan)

Fixes: ad74457a6b5a ("drm/i915/dgfx: Release mmap on rpm suspend")
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Anshuman Gupta <anshuman.gupta@intel.com>
Cc: Andi Shyti <andi.shyti@linux.intel.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: stable@vger.kernel.org # v6.1+
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com> # v1
Link: https://patchwork.freedesktop.org/patch/msgid/643cc0a4d12f47fd8403d42581e83b1e9c4543c7.1726680898.git.jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit 4c1bfe259ed1d2ade826f95d437e1c41b274df04)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_ttm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_ttm.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_ttm.c
@@ -1131,7 +1131,7 @@ static vm_fault_t vm_fault_ttm(struct vm
 		GEM_WARN_ON(!i915_ttm_cpu_maps_iomem(bo->resource));
 	}
 
-	if (wakeref & CONFIG_DRM_I915_USERFAULT_AUTOSUSPEND)
+	if (wakeref && CONFIG_DRM_I915_USERFAULT_AUTOSUSPEND != 0)
 		intel_wakeref_auto(&to_i915(obj->base.dev)->runtime_pm.userfault_wakeref,
 				   msecs_to_jiffies_timeout(CONFIG_DRM_I915_USERFAULT_AUTOSUSPEND));
 


