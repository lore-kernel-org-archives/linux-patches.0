Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C465F334C08;
	Thu, 27 Nov 2025 15:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255753; cv=none; b=PIS8bk4Oi0BRIvd/nT2X9IIZ2LjGhQJ6B5uyaJ7a8DjkA7NjB5uOj/L2xmSEumVlQaee1bQki5DSiJE+ObwdfUK9GBGG6B+c8n1EK464YNk9Os08xFelIBKCJHmi5dUFHJMe1ihkVIEdqSvHJw1bLYvUeJ2c0pTl3tBb9YwzJPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255753; c=relaxed/simple;
	bh=betEqxCN4DySOSSV5a2xR/3Ad709mg7qj4hQNlagkiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oDrOuPU3o7MX52iRyGkouOsyE6GKJLJXHUjyhKwDcY16Unk1S9t5OP4tTGVGbObsYC0331wdvxCYmYNKL/hYNePNu/9VMqADGQprp7LG2kqUlubTKilNba8t+repyMH/EBUPS4lGbV57lKcDcKo7+AxuOUU8+4KBK6y7CRQ9bCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BWmxRZk8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BWmxRZk8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D29C4CEF8;
	Thu, 27 Nov 2025 15:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255753;
	bh=betEqxCN4DySOSSV5a2xR/3Ad709mg7qj4hQNlagkiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BWmxRZk8fqxxZBSWSjh7okO6dsEPh5eSI0SQ4YQtqU6bYkWOzU+ZaA7WhzfC9O1Cq
	 VufsBsK3S5pVd+jIsC9yguCWwbJuZYdNwhKHdximHWlQdretPdZcxmO6vHVFpm/NPQ
	 NwWBwm3FXeLhhnBxhU/kLzk/aEku5mJ0GIa0ALrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Robert McClinton <rbmccav@gmail.com>
Subject: [PATCH 6.17 069/175] drm/radeon: delete radeon_fence_process in is_signaled, no deadlock
Date: Thu, 27 Nov 2025 15:45:22 +0100
Message-ID: <20251127144045.487076130@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert McClinton <rbmccav@gmail.com>

commit 9eb00b5f5697bd56baa3222c7a1426fa15bacfb5 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/radeon/radeon_fence.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_fence.c
+++ b/drivers/gpu/drm/radeon/radeon_fence.c
@@ -360,13 +360,6 @@ static bool radeon_fence_is_signaled(str
 	if (atomic64_read(&rdev->fence_drv[ring].last_seq) >= seq)
 		return true;
 
-	if (down_read_trylock(&rdev->exclusive_lock)) {
-		radeon_fence_process(rdev, ring);
-		up_read(&rdev->exclusive_lock);
-
-		if (atomic64_read(&rdev->fence_drv[ring].last_seq) >= seq)
-			return true;
-	}
 	return false;
 }
 


