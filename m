Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774050;
	b=SZI+KlZ+SguAlQW50cqMdG1BIWloSeyWcTqJXKPXgy1fpiKMhKHfhXFs2dPUlC+wtp22
	 nkELZPEq4P8fvaW/he/zrFbS/LUlRWrzkG6y7gbn3511FiceuMFlCMdot7PefKEKewgSX
	 tE4JlXSnMbzvZdZx4D4zdcqyr3fx6nZuYXR/ZAaWGWwVCzXaI457cmNPvrdn7bwBSPthp
	 zo2RrHX4kBKo3bR14ofw1MwL6PfKfiMNCO3S3aI1pXtrRFQCIIOghu3aD2y7PVOYiRdjl
	 AfU3d5t34SIk/VLZv7HBDsE4mrQtWs/l6lpcepyqibUoDVIbWet4ex9AtMcDCAGhoNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774050;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UBClsWiBaGLky5IanREps6N1tTYG+CyM/VGsbaR67wU=;
	b=uIy/tRr1YOtMEZBrlzUd3F7b11BKOAgvDIpH9kEwnBNBn65IaokbY2RvXe/lqXCL4f4I
	 iOGZuUuTInas5CpFBb7B5fovACeNAexgfX40xciemduhEo7wuVi/3Pmf6e2IhQ6llRHa7
	 SqU7PNX7Lvk09l6tTpU4xJXed4RBQOvbcXgclqFBxzN3rdhnfwY5OB2P4vEPkXG7G88Y5
	 mRV3AsM61XuOL0M9pNKJdqhFtB2nSn7runT9p+9Oa4Dpy7z/Qfie58yaxdaMGbga2wXjM
	 V5vJrgfpbrJJJO42dg+M5jF95ITFRrYwVavH7JPlpLOG+OEV++4jcyXt+6djFNbThCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c0ayC6jo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07040606A31B;
	Fri, 23 Oct 2026 16:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c0ayC6jo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 540BF1F01825;
	Fri, 23 Oct 2026 16:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774049;
	bh=UBClsWiBaGLky5IanREps6N1tTYG+CyM/VGsbaR67wU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c0ayC6jodAs/A4POCXZkwBHJrN5/pvVE45W1Zkl7NSgs/b1N4Y88odhFUOnme1YzW
	 qR4frF6pm8N2dJRi0CkyP9Rx6JrgWVQqQ6ap55YKKf94tyyuxeZF7TjPQP8HUzclqU
	 LPYekkWTEsXjkdWByJ8GxObKo41ywSGtBWFM5SR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>
Subject: [PATCH 6.18 105/193] drm/amdgpu: dont drop the runtime PM reference twice in amdgpu_gpr
Date: Fri, 23 Oct 2026 18:36:22 +0200
Message-ID: <20261023163716.691594655@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <Jesse.Zhang@amd.com>

commit de9f6bcdb44f0e410031002e2f103826ea6b6259 upstream.

amdgpu_debugfs_gpr_read() drops its runtime PM reference right after
reading the wave registers. When copying them to userspace fails, it
jumps to the err label, which drops the reference a second time. A read
into a bad buffer on Navi31 either steals a reference somebody else
holds (power/runtime_usage goes from 1 to 0) or underflows the count:

  amdgpu 0000:03:00.0: Runtime PM usage count underflow!

The registers are already in the kernel buffer at that point, so finish
the hardware access first and copy the buffer with a single
copy_to_user() instead of the put_user() loop with its own error path.

Fixes: 9eee152aab56 ("drm/amdgpu/debugfs: fix ref count leak when pm_runtime_get_sync fails")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 31035bbd74f7c3e10c163db875b8e67f8b50ee6a)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c |   21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
@@ -1164,7 +1164,6 @@ static ssize_t amdgpu_debugfs_gpr_read(s
 {
 	struct amdgpu_device *adev = f->f_inode->i_private;
 	int r;
-	ssize_t result = 0;
 	uint32_t offset, se, sh, cu, wave, simd, thread, bank, *data;
 
 	if (size > 4096 || size & 3 || *pos & 3)
@@ -1209,25 +1208,11 @@ static ssize_t amdgpu_debugfs_gpr_read(s
 
 	pm_runtime_mark_last_busy(adev_to_drm(adev)->dev);
 	pm_runtime_put_autosuspend(adev_to_drm(adev)->dev);
+	amdgpu_virt_disable_access_debugfs(adev);
 
-	while (size) {
-		uint32_t value;
-
-		value = data[result >> 2];
-		r = put_user(value, (uint32_t *)buf);
-		if (r) {
-			amdgpu_virt_disable_access_debugfs(adev);
-			goto err;
-		}
-
-		result += 4;
-		buf += 4;
-		size -= 4;
-	}
-
+	r = copy_to_user(buf, data, size) ? -EFAULT : size;
 	kfree(data);
-	amdgpu_virt_disable_access_debugfs(adev);
-	return result;
+	return r;
 
 err:
 	pm_runtime_put_autosuspend(adev_to_drm(adev)->dev);


