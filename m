Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210048;
	b=p+WR5EqhawGt6UpKzCHT6TuWkfpHzVkIBlGD60c4R/ZoLdHBartMEBj3/NEyX4XD12Tw
	 lVvvvnjiL9e9VNjKSdHp3El9igUsLldIygbBH4guwvSmCyLuDyAU0BGFMEo3ii4UYEKM9
	 F7XdGG/eygTZmsXCCAVhnUqAPdtnYBcECvehmuUd+ek7HxbQ0sn/1k8bbJTY0Ic5DH58V
	 4/Jh+s4YcvRshRC+wK9Hx89CL6MIYQSw//gJ3G9u4r1lUMSVGBaLlP+kAoGWtsl4b9q0s
	 7tKSo3PggJBb0bVj7GvfWzXsHlr8W4VQ5eXo7Hc4kxZmOvFA9Z4W2O8+iUj90veXzcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210048;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RZAerxAglkEcFJ15PPI34dDhXe4jOD2lFPU6YUEBe7o=;
	b=IcWbSmINN+s8Qf0zORDHtKIDXGnzQwOqZn03I5gQcf5f9u1VK5yGMnIAvNJNDyOSOpsw
	 RTTS54Fa/9mMMl7sAYNDyMVwa9DscSFkr0B76TIxc7NRuhqiTeSvDu06HMae2NgQVdFfe
	 EXhVCn83x+P/zdyH1YQwH//KIPK/7bDuypvWziWior+Y4K08sCT+fYkpb3VgqhBWn7F//
	 m/w80AbX/zzbVDDe7NUd62vPdqTthit6qvtQcYPJBcK5xqNapW7tW4P4pXEbaaga9JypL
	 TxgfQ7qoead9hNqHLWnnIaJ3k77a934oB3nRi0/GIMHo8FXqG9CRlQgoK/MbvX25uvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RHqVGlDr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5C0606A325;
	Wed, 28 Oct 2026 17:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RHqVGlDr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A7511F01825;
	Wed, 28 Oct 2026 17:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210047;
	bh=RZAerxAglkEcFJ15PPI34dDhXe4jOD2lFPU6YUEBe7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RHqVGlDrjq04XXUnKNN5/rpSsrXhq+R8PdOFQkoBHqQVY4OsVqQEoEfyr6bIr9Xen
	 vlFj5YIfapdA5T8BvZ66M+P7Q5n/aMfcp6BO55NCS2JlsGU713CjM/s1d2uGYeQ/UN
	 LwAfILziuC8qBRAEIBTjQRZI2ltRCh3NHl0BdHm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>
Subject: [PATCH 6.6 059/168] drm/amdgpu: dont drop the runtime PM reference twice in amdgpu_gpr
Date: Wed, 28 Oct 2026 17:59:55 +0100
Message-ID: <20261028165944.482536229@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1157,7 +1157,6 @@ static ssize_t amdgpu_debugfs_gpr_read(s
 {
 	struct amdgpu_device *adev = f->f_inode->i_private;
 	int r;
-	ssize_t result = 0;
 	uint32_t offset, se, sh, cu, wave, simd, thread, bank, *data;
 
 	if (size > 4096 || size & 3 || *pos & 3)
@@ -1202,25 +1201,11 @@ static ssize_t amdgpu_debugfs_gpr_read(s
 
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


