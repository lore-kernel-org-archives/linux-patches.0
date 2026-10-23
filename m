Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774778;
	b=j6gp41J7nz4xeXl9y3TRWJZIj547FY4pjJGof6flphTtEXQOFogV3mxq5IichHDQdaTq
	 E1EQ5Bar/MUj3iWxf8NfJ+MC0KtEhFiy+RyYYpCObBwvc7wE5RPrEmwhQo1GF/ZBI6FZV
	 KN+G7BV3sXifsKLe5N8ctO0uTDBfmo4mXRfP6H6P3dAa1aU95cA7/Cgg/r4MyyvvwLODY
	 pyFBDbppus/NmhyYcOc/xVT9leiLr8U+S4jlITayxq0IMN76zuqZ5xN0d8on+G2ib+X4D
	 kc2tYOWaO+sF8RiWVyaxsSzIlwX+ozGeZYSPVu8e8c0HrA1jWu2JJKmqSFng+6HyuTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774778;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J63N84WUFnZy6kH4d4PC1RLZzXJr1QWTl93dz1e/Bhg=;
	b=WmQZUXkMXA4tyRcV+D5r4PgVW5QtuYBqE1fXVB3h+mcaPMTaM84BfawKT9aKlQGMdmti
	 JQwYDQuW7XUdEZKqJy7iHeylACTlGY3BGTS9HRcKx8qcAw6Yza1/fg7wMhV98tx/1z6xA
	 Pc8DWxBe8x9fboRf+OHon2NnIfwgBFnPjBibHltmEhfes83UQ9URHNC4hH4d1LigxMBVl
	 t3kYXH926mGH9I0+yIAskElg7jdyYfiElXwkwN6ITf/feXT6TYQPHYtpp3taS8nQo8zSX
	 /JvHcqKtpzdwHhfzUvvq8exDNq5ymnUCRO+3TckOIECG8fpVVXbiNINI99AymLqPwpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GO5nXiNP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8072606A31B;
	Fri, 23 Oct 2026 16:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GO5nXiNP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 055251F01825;
	Fri, 23 Oct 2026 16:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774777;
	bh=J63N84WUFnZy6kH4d4PC1RLZzXJr1QWTl93dz1e/Bhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GO5nXiNPg19zyzaluEt5f51nOlqcQasqU5AFgs7x+rz3yEZz6Cu7Kl7Lo5kDPnFfv
	 wBtL3XaK/yAK/zmMfJ1S83koEjEq7IGMDDmEOuRHJOd3lPUMl8oJTTIdka13wD6Pj1
	 aevehAFFv0GXL9FNIMDs+0FX97VdSCjxbsIXsPNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>
Subject: [PATCH 7.2 155/242] drm/amdgpu: dont drop the runtime PM reference twice in amdgpu_gpr
Date: Fri, 23 Oct 2026 18:39:57 +0200
Message-ID: <20261023163717.448913639@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1265,7 +1265,6 @@ static ssize_t amdgpu_debugfs_gpr_read(s
 {
 	struct amdgpu_device *adev = f->f_inode->i_private;
 	int r;
-	ssize_t result = 0;
 	uint32_t offset, se, sh, cu, wave, simd, thread, bank, *data;
 
 	if (size > 4096 || size & 3 || *pos & 3)
@@ -1309,25 +1308,11 @@ static ssize_t amdgpu_debugfs_gpr_read(s
 	mutex_unlock(&adev->grbm_idx_mutex);
 
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


