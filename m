Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C45E21FF4C;
	Wed,  4 Feb 2026 15:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218516; cv=none; b=Uu5uNmpCKXUyxPTLlaPboqHBrJ7eyOTmJJ7ynPkvEDwMwUxhRA6UHcgnPYnPBAA96ku3UpYQXvTEtq8Dltd/vIbTBjNZFck/3S9e6Vs/duPykF1WmQING/UWHfJW77G4AU7+sBVeDvynQdglgvxfQNnN2yCuP6jtniLJIxvn9gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218516; c=relaxed/simple;
	bh=KgEG+fr7EBFrWVtyAc1bdAZgG630vkzmwNxdRpFNly4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pyp9vCduS6GVvvMztaxP89QSyw92fhnJP9TitlGM6JXiJ5KXv72chEfdBEsNjRABFzrPzL9BfRa2cuyz3oXornNIXTmdC1Kqioqx11xwXzTO7jFyNwYFuZAgd4vrdAbZ5HasmcUEO3vB1K3oOjDtFnUfFQ2cRoEB3a8KtEO3t9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d8LJiYA+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d8LJiYA+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93961C4CEF7;
	Wed,  4 Feb 2026 15:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218516;
	bh=KgEG+fr7EBFrWVtyAc1bdAZgG630vkzmwNxdRpFNly4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d8LJiYA+djdnSXjvluUzUm/0oGaAZnT3N6vsWVyrqLkqfmIJyddHV7q/VwVOapodi
	 FmungB5WL2SruzISjlRdi8trszA1E90RvP55HuavbBm/G5gvZn8hqLNPPjrqKhXWxm
	 NoyHg/X2qcYsT92Q8c79jiVbwSwaSPZLm+tUEAlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Robert McClinton <rbmccav@gmail.com>,
	Li hongliang <1468888505@139.com>
Subject: [PATCH 6.6 54/72] drm/radeon: delete radeon_fence_process in is_signaled, no deadlock
Date: Wed,  4 Feb 2026 15:40:57 +0100
Message-ID: <20260204143847.591590326@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143845.603454952@linuxfoundation.org>
References: <20260204143845.603454952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

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
 


