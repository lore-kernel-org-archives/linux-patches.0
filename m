Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207767;
	b=AcXjvWEcUn8W8ICW5vXGwE/Wk02SA4nJlJzAw14PhPBgLBK1CcKu+WEavhdbF2wpsrTG
	 HPQafWbPsKCVy7U8gWO1xsz4LDdm2yUycXt9I/0EQnSmAe93fVgUZyzeg88m7Hwjkojwd
	 pulifV7mSpo9ZaSj9vnQMMP0C/NLaVkZfxklou12vNZ4ADuNqwsAfRh0bJqqcd4+AYV/l
	 bpvYfzNobSpI+88foiaNSG9+jhxJr8sK8g3AHFeYv45kJrMnfaMEsguWNpk61bqYAs16o
	 T/8RdHaachpNMFCraGka5u8mCSqASbWHx1CV4mGu1ODUJkU3a1xr1FfdAEIghqkQEVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207767;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AePvx6BY4DaPP6CZOwulAoWi+RgmPGX5UF9P7m+LC+Q=;
	b=fzgHPdCU8mmTHSgAM8YZDFG9jsHvS4aSPry7hb02GTthySJAg6SajOY3BUnggxMLiwOC
	 gapfb1H5WCzFqDjyVyzXiAaJcwTMB2xWuTX6YQeIes1MucSecRvKpC7zEzw+uhZ6Y/YOw
	 mFf6iHrBZwMEdHNXyySnHBGGEkyhaTCImhfe4yc/GMIG154l9QAlzcQrt7GWCwkSbnooE
	 2R9eqySPUFUtn6OYbcXK7CIaYh+7sahXnJLqSnOYFQ7oKALSmuDv2INKuOfdGKqVWrwFo
	 dDkZx9xi8M8hhUPlFAwHv+COKKAw8UDFvVE87wJuWcDTkPPqpXrcoNz6qmXPVEH4ccA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="YOW//W1c";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CEEE606A31A;
	Wed, 28 Oct 2026 17:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YOW//W1c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CDA11F01825;
	Wed, 28 Oct 2026 17:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207767;
	bh=AePvx6BY4DaPP6CZOwulAoWi+RgmPGX5UF9P7m+LC+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YOW//W1cFucHVrn6qf14NUCayG5dqATor5eM/ENxyUprIL+CmnIfddLEKKWxfOyVR
	 SLARnv9zIxREMwIGCHjtT7ApJFWz+4EM+Tc28ujNNrv+YAPtRUXd2kfupuVQ83OzTe
	 bxQswdGhcCQRqCQFs22qqNYchcgYfUk6o1vbhIH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>
Subject: [PATCH 6.12 088/247] drm/amdgpu: dont drop the runtime PM reference twice in amdgpu_gpr
Date: Wed, 28 Oct 2026 17:58:11 +0100
Message-ID: <20261028165949.478741930@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


