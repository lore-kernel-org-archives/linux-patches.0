Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C05247CA69;
	Tue, 13 Oct 2026 11:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892338; cv=none; b=twtY2DIAj7PbxYpymC8cXfZrp1nfsk58j215/fBd8csh9UrX7pCWa22UgbQwFG3YUzboO3HTVLEWge0ewgZePsjUqBaxXeHYr6t0FmKw7PyJdCxm496FkBAGcRKUWOr63wF51kZUoVTA7mCpNOyZ9iFmYLQHJNW1CcRfB0QptGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892338; c=relaxed/simple;
	bh=Sk/uIQJSHaTuSDm5LbgwHNCNCyN0y2zaav8NDFACPnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DzQdTBk8OfRZA07wj4RZwb09IugF1wIMLMzikRaC/0EQcwLOJpCuXec5zKoIeEduN0ehlHxoznCYSbABHK2VLIeC7Ft9eglAAyBmUGppLQilO0Jj0zG5aZkd7re35RDEDIRZL9wojoH51KissfdL2QoMLAL1q3RcRuwXQP8OdF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AMCIb++i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AMCIb++i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2318E1F000FF;
	Tue, 13 Oct 2026 11:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892335;
	bh=wafaINqwVlgJKRk0Xfq1d0UvRD3Jsqdvv6hk0+mdAPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AMCIb++illyX0Uqv07EuuBC+0RoXmvzNMbJN7wrh6Hd9fg/Q+MtqsKksv3Abx87wS
	 aQKd0F3ysUmymJ4dozOhLlba0wJDa43Tvhdl50WGUL0t7JtPGsF01AdiGcY5+TwuJ6
	 FMKkIQmQ9hsFdrWRJL6gmWS2AClP9qc8VMXu3J/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Sunpeng Li <sunpeng.li@amd.com>,
	Vitaly Prosyak <vitaly.prosyak@amd.com>
Subject: [PATCH 7.2 140/281] drm/amdgpu: serialize vblank counter reads against GPU reset
Date: Tue, 13 Oct 2026 13:37:36 +0200
Message-ID: <20261013112858.554647778@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

From: Vitaly Prosyak <vitaly.prosyak@amd.com>

commit 1a6023edfbb5673f55fab6348f135fb3b1428ea5 upstream.

The vblank counter callback reads display registers and scanout
position without holding reset_domain->sem. During GPU recovery,
display commit work can call the callback while reset owns the
semaphore for writing. The hardware access then triggers the
lockdep_assert_held() in amdgpu_device_skip_hw_access() and sets
TAINT_WARN when lockdep is enabled.

Try to acquire the reset semaphore for reading before accessing the
hardware, and hold it across the counter and scanout-position reads.
If reset is already in progress, return DRM's cached software vblank
count instead. This avoids blocking behind reset and avoids accessing
display hardware while it is being reset.

The cached count is less accurate than the hardware count, but is
used only when reset prevents a safe hardware read. This addresses
the reset-time warning from this vblank path; it does not suppress or
fix unrelated lockdep warnings.

Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Sunpeng Li <sunpeng.li@amd.com>
Signed-off-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Reviewed-by: Sunpeng Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 51a4359f7431a4be5e42803c8bdaf7e0e5be2934)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
@@ -30,6 +30,7 @@
 #include <drm/amdgpu_drm.h>
 #include <drm/drm_drv.h>
 #include <drm/drm_fb_helper.h>
+#include <drm/drm_vblank.h>
 #include "amdgpu_uvd.h"
 #include "amdgpu_vce.h"
 #include "atom.h"
@@ -1631,6 +1632,9 @@ u32 amdgpu_get_vblank_counter_kms(struct
 		DRM_ERROR("Invalid crtc %u\n", pipe);
 		return -EINVAL;
 	}
+	if (!down_read_trylock(&adev->reset_domain->sem))
+		return drm_crtc_vblank_count(crtc);
+
 
 	/* The hw increments its frame counter at start of vsync, not at start
 	 * of vblank, as is required by DRM core vblank counter handling.
@@ -1676,6 +1680,7 @@ u32 amdgpu_get_vblank_counter_kms(struct
 		DRM_DEBUG_VBL("NULL mode info! Returned count may be wrong.\n");
 	}
 
+	up_read(&adev->reset_domain->sem);
 	return count;
 }
 


