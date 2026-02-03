Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ECA91E487;
	Tue,  3 Feb 2026 14:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770130255; cv=none; b=Rd6/jXOJwc2xdPtmS3D3wseiB3O14Zivw6k2DYV2+GiwpimqeTYRYUbDokpuJv/VSPQ2Vhuu6X7BOnvpIfTmme1uvUYNar3JmKnI35XywnW1ZiJK43bto22cZFwabSdlchLdLUmth3pTYve60ne4zf5Y/kGN8bssgmpt4ycXkkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770130255; c=relaxed/simple;
	bh=Dnu2BD4jD3XDBreBSD7AyscxzS4F6XR4ojpUsYjqxgc=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=LITn5RmdptBvgFjCUINHIz6p6/CYPxsehcjA3F74WLcv/v/PZqnTrEWGqng+9gdY3lCn86jidVfc8hsEJK++pU9RRQVd+QkGuid9SN0Ky4yB8eS6hfQVy/+Nh0O+KofxXpSMzQE0BIn8IIwivJbxHTvNH8vU0qHBYcKVX8/1Oig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NemeBfBt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NemeBfBt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6B4DC116D0;
	Tue,  3 Feb 2026 14:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770130255;
	bh=Dnu2BD4jD3XDBreBSD7AyscxzS4F6XR4ojpUsYjqxgc=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=NemeBfBtXE+ytSkQCIRqTXhoX8JINyCtX8nqQiAkSvbpa8oqyMcH5140lgKDBknMK
	 eoM0QVrMOOdfYkMhLriyidoQiG5fy0b+2JLMgbTg0a+UHhJFUAcysNEh69imrtnMg9
	 g3p3/uXplYv0oEG0F6Xb5sZVaAHHaQ436vKct1AA=
Subject: Patch "drm/radeon: delete radeon_fence_process in is_signaled, no deadlock" has been added to the 6.6-stable tree
To: 1468888505@139.com,Xinhui.Pan@amd.com,airlied@gmail.com,alexander.deucher@amd.com,amd-gfx@lists.freedesktop.org,christian.koenig@amd.com,daniel@ffwll.ch,dri-devel@lists.freedesktop.org,gregkh@linuxfoundation.org,patches@lists.linux.dev,rbmccav@gmail.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 03 Feb 2026 15:50:38 +0100
In-Reply-To: <20260202075831.947537-1-1468888505@139.com>
Message-ID: <2026020338-embargo-commuting-7a82@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    drm/radeon: delete radeon_fence_process in is_signaled, no deadlock

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     drm-radeon-delete-radeon_fence_process-in-is_signaled-no-deadlock.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From 1468888505@139.com Mon Feb  2 08:58:36 2026
From: Li hongliang <1468888505@139.com>
Date: Mon,  2 Feb 2026 15:58:31 +0800
Subject: drm/radeon: delete radeon_fence_process in is_signaled, no deadlock
To: gregkh@linuxfoundation.org, stable@vger.kernel.org, rbmccav@gmail.com
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org, alexander.deucher@amd.com, christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com, daniel@ffwll.ch, amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Message-ID: <20260202075831.947537-1-1468888505@139.com>

From: Robert McClinton <rbmccav@gmail.com>

[ Upstream commit 9eb00b5f5697bd56baa3222c7a1426fa15bacfb5 ]

Delete the attempt to progress the queue when checking if fence is
signaled. This avoids deadlock.

dma-fence_ops::signaled can be called with the fence lock in unknown
state. For radeon, the fence lock is also the wait queue lock. This can
cause a self deadlock when signaled() tries to make forward progress on
the wait queue. But advancing the queue is unneeded because incorrectly
returning false from signaled() is perfectly acceptable.

Link: https://github.com/brave/brave-browser/issues/49182
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4641
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Robert McClinton <rbmccav@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 527ba26e50ec2ca2be9c7c82f3ad42998a75d0db)
Cc: stable@vger.kernel.org
[ Minor conflict resolved. ]
Signed-off-by: Li hongliang <1468888505@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/radeon/radeon_fence.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_fence.c
+++ b/drivers/gpu/drm/radeon/radeon_fence.c
@@ -362,14 +362,6 @@ static bool radeon_fence_is_signaled(str
 		return true;
 	}
 
-	if (down_read_trylock(&rdev->exclusive_lock)) {
-		radeon_fence_process(rdev, ring);
-		up_read(&rdev->exclusive_lock);
-
-		if (atomic64_read(&rdev->fence_drv[ring].last_seq) >= seq) {
-			return true;
-		}
-	}
 	return false;
 }
 


Patches currently in stable-queue which might be from 1468888505@139.com are

queue-6.6/drm-radeon-delete-radeon_fence_process-in-is_signaled-no-deadlock.patch
queue-6.6/ksmbd-fix-race-condition-in-rpc-handle-list-access.patch
queue-6.6/wifi-ath11k-add-srng-lock-for-ath11k_hal_srng_-in-monitor-mode.patch
queue-6.6/drm-amdgpu-replace-mutex-with-spinlock-for-rlcg-register-access-to-avoid-priority-inversion-in-sriov.patch
