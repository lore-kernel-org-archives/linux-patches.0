Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB16647CA69;
	Tue, 13 Oct 2026 11:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892351; cv=none; b=QU6f3Nee6gatyu5gkpiy96su8XcT6V0ZQ/eyaeOsC5ltaLhAJeDWVXPM5Sh0duMpzS6mhObin9PplbYJVDs327zlh7Z7JYHh3/vLq9ctudxr6jT24hAkyXCNnmzR1k9hib40YNSHPcXW7ZY50uUt+f/A5A+j5n8wXTDmbEICIIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892351; c=relaxed/simple;
	bh=CRXT98uXvToxWBfaTeECm7FqXEmZsXuU3vOZihqjPvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RzKmC1M7GdnK8AQparVam70uY8LUztoTC9SITfv7/PpmxnwxYA7CLwOLUX7XfjY1uBvtEKKF9W+WYlQLy9bZ4xqpCKrxvsxafCxrzVaWdzLxbvab6OWDerx1fcibaDA4+PHksRtNKZwAaZrQzD/LIv5d37muYSemB9URgw58QPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sInGzzjZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sInGzzjZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2DAE1F000FF;
	Tue, 13 Oct 2026 11:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892350;
	bh=ytHGZBihVjlXbY4V/n/uxCFcBmiM4dU+yBiUwnvrpOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sInGzzjZnMBB7YXue2mLNtJRH6RhhPG0n3fTw0TxKc18Aq3Y8VXDn4Kg+xXfkBpHu
	 xAZZGWnzSGRr6OqsbYp/0THZ9hllBh2SkL7CpTHElN2W6SYY+s4fpLPnffNLYpVchV
	 kNG7rtrEYHAj/qKAcd9LEuyjyQDtoU5RysFeuFTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 144/281] drm/amdgpu/userq: return the memdup_user() error for the user MQD
Date: Tue, 13 Oct 2026 13:37:40 +0200
Message-ID: <20261013112858.653000056@linuxfoundation.org>
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

From: Jesse Zhang <Jesse.Zhang@amd.com>

commit 76ceb6ed610cbf14341a9ba78c5c0b2199b9030a upstream.

mes_userq_mqd_create() returns -ENOMEM when copying the user MQD fails,
even though memdup_user() returns -EFAULT for a bad pointer or -EINTR
when interrupted by a signal. Return PTR_ERR() instead.

While at it drop the error messages. Neither case is a driver error and
userspace shouldn't be able to spam the log with invalid IOCTL
parameters.

v2: drop the error messages (Christian)

Fixes: 2c695d7c0720 ("drm/amdgpu: enable compute/gfx usermode queue")
Fixes: 543b61453774 ("drm/amdgpu: enable SDMA usermode queues")
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 49a443fcb829be9fc780f10850652ddea2fe81f0)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/mes_userqueue.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/mes_userqueue.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_userqueue.c
@@ -304,8 +304,7 @@ static int mes_userq_mqd_create(struct a
 
 		compute_mqd = memdup_user(u64_to_user_ptr(mqd_user->mqd), mqd_user->mqd_size);
 		if (IS_ERR(compute_mqd)) {
-			DRM_ERROR("Failed to read user MQD\n");
-			r = -ENOMEM;
+			r = PTR_ERR(compute_mqd);
 			goto free_mqd;
 		}
 
@@ -349,8 +348,7 @@ static int mes_userq_mqd_create(struct a
 
 		mqd_gfx_v11 = memdup_user(u64_to_user_ptr(mqd_user->mqd), mqd_user->mqd_size);
 		if (IS_ERR(mqd_gfx_v11)) {
-			DRM_ERROR("Failed to read user MQD\n");
-			r = -ENOMEM;
+			r = PTR_ERR(mqd_gfx_v11);
 			goto free_mqd;
 		}
 
@@ -394,8 +392,7 @@ static int mes_userq_mqd_create(struct a
 
 		mqd_sdma_v11 = memdup_user(u64_to_user_ptr(mqd_user->mqd), mqd_user->mqd_size);
 		if (IS_ERR(mqd_sdma_v11)) {
-			DRM_ERROR("Failed to read sdma user MQD\n");
-			r = -ENOMEM;
+			r = PTR_ERR(mqd_sdma_v11);
 			goto free_mqd;
 		}
 


