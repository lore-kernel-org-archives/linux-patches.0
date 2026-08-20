Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343AC361640;
	Thu, 20 Aug 2026 15:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238095; cv=none; b=eCVpCVzp49C5jxJigPb1ooCQJ/xjdc/Levxe9o+g2QLPhH7xEJtSFtQcb3pyvZ88zkNn3svGHBRSYyjY01/VCPxe0xyx6f9ho/O4F0xU/C0iHxBEcZRT+zp7ezPgYLUvVBAII+wL/e+Y7oT+c6bdctgmK2OEfQS9KT3FhfdA1IE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238095; c=relaxed/simple;
	bh=smgIVXgKOeyfQRBqksC88fBTZo/38FBzXwBrPO68EMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ITUouW4kaEdl9R9dkvc0OfdOLaPR4XGlwsJlqsevwNGgLZv7M3nMou+xtiskApFDUlSg8f91LdESozw0c4ABq90p4KNtp88Dc0DxqzW4nhJ3e4GwOzHOUKkpwwfrRkREf3FS3/hv7ZubI3xIGlCBJXSyoxmou05Mj7L7vQJQIXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B1uhiIv1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B1uhiIv1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A2781F000E9;
	Thu, 20 Aug 2026 15:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238093;
	bh=uV560jDbxvlKty9jHgZJxHF6CZw33s+DdyAQRU+hJGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B1uhiIv1Vc4278BFfffhH5RzCCWBDjDliOi22nbKe3jvOVtVvsQZz2anHenrv82VA
	 nxTQoYnfOBb4ASVVUQ62gSOo7tzHrIbXdf7Exfow5RcmvtDGfq3Fjy4yNhXUwY+1ae
	 Q3tIQ20GU3yfRh6540rDz7LusSBX28zKPVmR2aJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Wang Jiang <jiangwang@kylinos.cn>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 031/228] drm/radeon: restore hardware polling in fence_is_signaled to fix performance regression
Date: Thu, 20 Aug 2026 16:52:53 +0200
Message-ID: <20260820145245.406990482@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Jiang <jiangwang@kylinos.cn>

commit 5f08eee9c3fb1a5a70966612e0ff249900f8e77b upstream.

Commit 527ba26e50ec ("drm/radeon: delete radeon_fence_process in
is_signaled, no deadlock") removed the hardware polling from
radeon_fence_is_signaled() to fix a self-deadlock caused by
wake_up_all(&rdev->fence_queue) being called with the fence queue
lock held.

However, removing the polling entirely causes significant performance
regression (e.g. glxgears FPS drop) because the fence signaled check
becomes purely passive — it only reads the cached last_seq without
probing the GPU, so completed GPU work is not detected in time,
causing unnecessary CPU stalls in sync-heavy workloads.

Fix this by calling radeon_fence_activity() directly instead of
radeon_fence_process(). radeon_fence_activity() reads the hardware
fence counter and updates last_seq via atomic ops without calling
wake_up_all(), thus avoiding the deadlock while restoring timely
fence detection.

Fixes: 527ba26e50ec ("drm/radeon: delete radeon_fence_process in is_signaled, no deadlock")
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Wang Jiang <jiangwang@kylinos.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit f59ad4cca219c7fdf934f712c5860ec5f5900fd7)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/radeon/radeon_fence.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_fence.c
+++ b/drivers/gpu/drm/radeon/radeon_fence.c
@@ -360,6 +360,13 @@ static bool radeon_fence_is_signaled(str
 	if (atomic64_read(&rdev->fence_drv[ring].last_seq) >= seq)
 		return true;
 
+	if (down_read_trylock(&rdev->exclusive_lock)) {
+		radeon_fence_activity(rdev, ring);
+		up_read(&rdev->exclusive_lock);
+
+		if (atomic64_read(&rdev->fence_drv[ring].last_seq) >= seq)
+			return true;
+	}
 	return false;
 }
 


