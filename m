Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8242A3B8BCA;
	Tue,  3 Feb 2026 15:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770134371; cv=none; b=FImqXfnRtP1TaNIm6Mf+hKUTVObR0NvZNnEEuiqFMnc2SXIk8WsIJOUuLgIIdNdF0P4c/QLKIcWDn35vVoMnW9anCtOMciRNMFi2Ds6HxniAmzENpspkP5m1w6QrBrKVJTunxgvaxgS1k2/iaV4Ya2pupXda/d56nQ6XhNd2zRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770134371; c=relaxed/simple;
	bh=RwnFXHCSRr93XQC8pa5aGNUxua6lOjbRFetYWmw4iy4=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=ockBDuG+ctO98phoLZXj4NAshezWjvVwidMimjxnM1I8dQ6mE9cRuwEEuI+5Bz9eWZriooiaOBCcV2dehPs6ZpMc3bQP5u9VfuQF7fUE9NuEKm4bnEQqmzTUsTiTLQvqO6mNr8LXERLeXZPjv6Xpv95zrKS9adUcGxPDniuvMlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IKcJ6ec1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IKcJ6ec1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4DFC116D0;
	Tue,  3 Feb 2026 15:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770134371;
	bh=RwnFXHCSRr93XQC8pa5aGNUxua6lOjbRFetYWmw4iy4=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=IKcJ6ec1L+hToUV3KndBq3KUkclYNvMvFdBkXwJU9aYbVvyj4pnC8mFc2vQT9UI47
	 iaENlZTqoMwHTal1g8DRaRZZPCMWkRzp/MFsX7x0QExIXSUCZzRiaqsWS2L5Fee+yd
	 dTqRC0CbM+wCmTaCDErVMHyHpU25H1lmdpe2iWNI=
Subject: Patch "drm/radeon: delete radeon_fence_process in is_signaled, no deadlock" has been added to the 6.1-stable tree
To: 1468888505@139.com,Xinhui.Pan@amd.com,airlied@gmail.com,alexander.deucher@amd.com,amd-gfx@lists.freedesktop.org,christian.koenig@amd.com,daniel@ffwll.ch,dri-devel@lists.freedesktop.org,gregkh@linuxfoundation.org,patches@lists.linux.dev,rbmccav@gmail.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 03 Feb 2026 16:59:08 +0100
In-Reply-To: <20260202075855.947632-1-1468888505@139.com>
Message-ID: <2026020308-sandpit-carbon-ce38@gregkh>
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

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     drm-radeon-delete-radeon_fence_process-in-is_signaled-no-deadlock.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-213031-greg=kroah.com@vger.kernel.org Mon Feb  2 08:59:14 2026
From: Li hongliang <1468888505@139.com>
Date: Mon,  2 Feb 2026 15:58:55 +0800
Subject: drm/radeon: delete radeon_fence_process in is_signaled, no deadlock
To: gregkh@linuxfoundation.org, stable@vger.kernel.org, rbmccav@gmail.com
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org, alexander.deucher@amd.com, christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com, daniel@ffwll.ch, amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Message-ID: <20260202075855.947632-1-1468888505@139.com>

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

queue-6.1/vhost-scsi-fix-handling-of-multiple-calls-to-vhost_scsi_set_endpoint.patch
queue-6.1/fs-ntfs3-initialize-allocated-memory-before-use.patch
queue-6.1/drm-radeon-delete-radeon_fence_process-in-is_signaled-no-deadlock.patch
queue-6.1/ksmbd-fix-race-condition-in-rpc-handle-list-access.patch
queue-6.1/ksmbd-fix-use-after-free-in-ksmbd_session_rpc_open.patch
queue-6.1/drm-amdgpu-replace-mutex-with-spinlock-for-rlcg-register-access-to-avoid-priority-inversion-in-sriov.patch
queue-6.1/sctp-linearize-cloned-gso-packets-in-sctp_rcv.patch
