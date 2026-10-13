Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201844F68BD;
	Tue, 13 Oct 2026 12:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895912; cv=none; b=a5g9cP2KwJ3FgF6t4EI9cNI3lqVIoWUKLIpRoRYz4H26GQBHMfnFdZPixuHKzqhUAwan7nOxyJNVVGX+E0WBvy5hlBO9L79OCrifBG3jaVh7VRVJTlHlQ7KrB1VMEhVyrqeav8/sChN4O03aJOei2gKIB2KjR5flvhcIliKNlws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895912; c=relaxed/simple;
	bh=nC1VIIQTYzrjo8kwTHR4+CPged4+UBKvIo22nJP8MMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V2nM7SHyEAZvCfW/mJglMTB9BZdfqVRHL/ACY/PKiPcLwveIbOAV8daH0MyDi/lwgS6jNOoKyU7hk+UjAM+Q4iis7ptF4MoKS1JlWFjCbrhkSEub5nVncNK0dS18fclp1pg8UcTEYusAIRPNP0tqJUwPwiIZ6bhCBSKtxpq3I1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JyyCvJYV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JyyCvJYV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67CA91F000FF;
	Tue, 13 Oct 2026 12:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895911;
	bh=DV5LP2Q+55zq47QB/cRYs4wgzBhWKOqSRyC7lNeXeSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JyyCvJYVvHLfDIigj2rOuhOyQF9Y33IUW+ZEFADLI05Hrc8rqW2PqcyVfGhW+Oery
	 SpVREglKfarzskkvwGUE0ITmfYGLX5AjHw7iF3OgXyyNE49nRaRZxuCEcruRAbj0jy
	 3YkfZk3bwZn7/OdNBIRgzw5K9Z5Ff2dLcn9uflO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Sunpeng Li <sunpeng.li@amd.com>,
	Vitaly Prosyak <vitaly.prosyak@amd.com>
Subject: [PATCH 6.12 434/497] drm/amdgpu: serialize vblank counter reads against GPU reset
Date: Tue, 13 Oct 2026 13:40:01 +0200
Message-ID: <20261013112918.187539517@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1483,6 +1484,9 @@ u32 amdgpu_get_vblank_counter_kms(struct
 		DRM_ERROR("Invalid crtc %u\n", pipe);
 		return -EINVAL;
 	}
+	if (!down_read_trylock(&adev->reset_domain->sem))
+		return drm_crtc_vblank_count(crtc);
+
 
 	/* The hw increments its frame counter at start of vsync, not at start
 	 * of vblank, as is required by DRM core vblank counter handling.
@@ -1528,6 +1532,7 @@ u32 amdgpu_get_vblank_counter_kms(struct
 		DRM_DEBUG_VBL("NULL mode info! Returned count may be wrong.\n");
 	}
 
+	up_read(&adev->reset_domain->sem);
 	return count;
 }
 


