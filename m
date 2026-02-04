Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E3C4218BB;
	Wed,  4 Feb 2026 15:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218339; cv=none; b=CSckQAAnRvohNGekqGEn5cWtymWkiRlAbzRuGImhcFcx93mLNaMqtLxW+cRchsK7zbD5OMJ6WyzZ4Vry7FGM9XBWExoxRu6nKdUbNKBvurbDzHIB8zQULXV9/6dh6YlMMGcSIL91LZvhokoaNep+CA2XTG/nsBEmbF1WwyNPiZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218339; c=relaxed/simple;
	bh=U/gbr35QwpxH9lraSR0PCUkRUGRKETwGRVR2ZjO6ctI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V5D7u64iSizz6FFC1bDJIQzPUs9RgWXIhteVJHhH24mPqBxpOxchYN0zRkXcEv49UiRykZxNb3I3y2T3JKkjZfo1fTTUOt/M9owxzFAExSSePHdUsc/DPQ7TJOc8BXqh1e0MdoyViGLvOaDikTU57hvhgxH7ZEIQc96aIhZzCVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0LLm+bLR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0LLm+bLR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 439E2C4CEF7;
	Wed,  4 Feb 2026 15:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218339;
	bh=U/gbr35QwpxH9lraSR0PCUkRUGRKETwGRVR2ZjO6ctI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0LLm+bLRcflKLhlIFHsk11gxKiS5J2KZAroDwYL0cDsH25husM6ok4V4foid5KRGg
	 WOrZWIlkjwncDrsjdSYWXmnUc2bLN12qWQFm2ctTo6JtJSNMpRKLLUD7FfE9oChjL/
	 x6bfpL/NkvVglatFIHKuQBTrDgUzJGCfSq22avjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Robert McClinton <rbmccav@gmail.com>,
	Li hongliang <1468888505@139.com>
Subject: [PATCH 6.1 272/280] drm/radeon: delete radeon_fence_process in is_signaled, no deadlock
Date: Wed,  4 Feb 2026 15:40:46 +0100
Message-ID: <20260204143919.491312198@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


