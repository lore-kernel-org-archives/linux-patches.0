Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209415;
	b=tU3pqtJfRV92bRDV+WMrWDZDVmbAC5pTbLZ430jEusLHIGv9uszPfPWZFc+VUpq+nK6M
	 Wfzs8MEPnerXFI7E4Xucdlth2aIg7RFkeV+FY2iiuk8SeUSXW1NBEZwgFt6ASHlWfdGhf
	 wGBbrz6sEVfx3nUZ8NDW+Z6pKrubcpFYlvogTvXSC4J+VX6D2/OId34MyUTozCvzN8rpK
	 Rj9UMcpKOFtXc9b7SO9r4+wy+YLCdqX//XbIt1KWYHHqRj23gfKLlv3vU8PmwWl9GJQ4t
	 gCrEQk/SovyVMUByWmP5T1GbHCfjo10AePXUqykqmjHUF8uqa2cqv2jxYlmhGrzhdvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209415;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7RAgZLJOFYeZL17EsoyGkxiDVfiCzWFw+xzCql3QNS8=;
	b=yc+yrAFr7xaZUJTomlcvX/lsfit9RxQzWJ935+QhJY6UTjEBLPScycqxnKc2xLbnDrDl
	 n4AH5doAiq3YuuVoC0FPHNo78P5DFeBkT2r8DcvjlMWDFkg8bFQa+VTgU+fMtiMoaz2Dz
	 tbuD+NWgdjVJQntrhmXcXnRgN4+gcT5RceR3I1fU/1UReB+aYK3fmH07TV1teFksmg4de
	 K+IImeSKfpSNgZWz/pt/8IXY27WPzOhY6dUNWuzhmxyS8gAFEKzRtUSGGG1dHcaMi/Om1
	 y6coHGwx+cUVloCn/YoFUdZoszEokrZ1saCVSqBzO4ZsvKuNqd2HFG/1Z9ql4PbQ1zQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qb2zT2Nb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45BCB606A31C;
	Wed, 28 Oct 2026 17:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qb2zT2Nb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 972681F01825;
	Wed, 28 Oct 2026 17:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209415;
	bh=7RAgZLJOFYeZL17EsoyGkxiDVfiCzWFw+xzCql3QNS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qb2zT2Nbs/1OFhKSNirNSiM5oZ85oancXvn4KvLO/eCE0K7TFDhOJ7VfL/p8evghD
	 UOYaSdpY01yxc3o7CcI9TVwz2R1o88YpwQOjk5uUYgjShdVzgBL7M12muqUkbNwyjA
	 Ru0xcYbsUok0tHQDEd2Iytiz92xFxZdt05hapIec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>
Subject: [PATCH 5.10 461/516] drm/amdgpu: dont drop the runtime PM reference twice in amdgpu_gpr
Date: Wed, 28 Oct 2026 18:00:13 +0100
Message-ID: <20261028170014.399985932@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -968,7 +968,6 @@ static ssize_t amdgpu_debugfs_gpr_read(s
 {
 	struct amdgpu_device *adev = f->f_inode->i_private;
 	int r;
-	ssize_t result = 0;
 	uint32_t offset, se, sh, cu, wave, simd, thread, bank, *data;
 
 	if (size > 4096 || size & 3 || *pos & 3)
@@ -1013,25 +1012,11 @@ static ssize_t amdgpu_debugfs_gpr_read(s
 
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


