Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 984232F4A0A;
	Tue, 12 Aug 2025 18:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023823; cv=none; b=V3E5jg+iNAwdMv0N8aMjfGznkTPE+S/86+wYYrfyEsdUZ/3u9Vzn2NywIJxMhSAYDaJyIR+swu07CVzSFoYutH788oIPovtUW7VBRdcqmdXFUGssnevTvbXcnAU/X3oCb2igR6NiLB8RWX8i1Co49QHY6wOBNh3eE/DS4Rt961o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023823; c=relaxed/simple;
	bh=IHfH7fUFPJ+HMenj244kBf+Cs+9KL7BcGD6x4r29jKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PA0jX0hnqMV1G752w/rIsPKHxOuY8PYVUce0nq+DvKdtHBdHfI3yn0Ojwx/z83ggNMmMMHULVqsHyZEUTsmle1zXQ9konkTK2Ta7HC0ZqMtc2m4ifI/mPUdM2mvTqF2WcusRJ4GJTssSUV6ottqbNIL4ak5HkX4scWcKdZkJnWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2WtOkSIO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2WtOkSIO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0987FC4CEF0;
	Tue, 12 Aug 2025 18:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023823;
	bh=IHfH7fUFPJ+HMenj244kBf+Cs+9KL7BcGD6x4r29jKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2WtOkSIOh87MQMAW8c4kby2HeshscO+2RzoiIRvTWSxkdZnKTedMxdYVwMKXAdYD1
	 SzJLgHqsUPIjmjy3EKYEkEcLmny4IXswfvnUyr9DSuUFZgdw9VZSUTVVAcxQs0sR1N
	 5XwXwjySSL6S4jInFNwVbQ7B64q/bOzkDs8qV6sU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 192/627] Revert "drm/amdgpu: fix slab-use-after-free in amdgpu_userq_mgr_fini"
Date: Tue, 12 Aug 2025 19:28:07 +0200
Message-ID: <20250812173426.572271279@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitaly Prosyak <vitaly.prosyak@amd.com>

[ Upstream commit a73345b866ff8bbd93135af667c973a8fb4b2c40 ]

This reverts commit 5fb90421fa0fbe0a968274912101fe917bf1c47b.

The original patch moved `amdgpu_userq_mgr_fini()` to the driver's
`postclose` callback, which is called after `drm_gem_release()` in
the DRM file cleanup sequence.If a user application crashes or aborts
without cleaning up its user queues, 'drm_gem_release()` may free
GEM objects that are still referenced by active user queues, leading
to use-after-free. By reverting, we ensure that user queues are
disabled and cleaned up before any GEM objects are released,
preventing this class of bug. However, this reintroduces a race
during PCI hot-unplug, where device removal can race with per-file
cleanup, leading to use-after-free in suspend/unplug paths.
This will be fixed in the next patch.

Fixes: 5fb90421fa0f ("drm/amdgpu: fix slab-use-after-free in amdgpu_userq_mgr_fini+0x70c")
Signed-off-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c | 16 +++++++++++++++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c |  3 ---
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index 501bb82f2a37..4db92e0a60da 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2906,6 +2906,20 @@ static int amdgpu_pmops_runtime_idle(struct device *dev)
 	return ret;
 }
 
+static int amdgpu_drm_release(struct inode *inode, struct file *filp)
+{
+	struct drm_file *file_priv = filp->private_data;
+	struct amdgpu_fpriv *fpriv = file_priv->driver_priv;
+
+	if (fpriv) {
+		fpriv->evf_mgr.fd_closing = true;
+		amdgpu_eviction_fence_destroy(&fpriv->evf_mgr);
+		amdgpu_userq_mgr_fini(&fpriv->userq_mgr);
+	}
+
+	return drm_release(inode, filp);
+}
+
 long amdgpu_drm_ioctl(struct file *filp,
 		      unsigned int cmd, unsigned long arg)
 {
@@ -2957,7 +2971,7 @@ static const struct file_operations amdgpu_driver_kms_fops = {
 	.owner = THIS_MODULE,
 	.open = drm_open,
 	.flush = amdgpu_flush,
-	.release = drm_release,
+	.release = amdgpu_drm_release,
 	.unlocked_ioctl = amdgpu_drm_ioctl,
 	.mmap = drm_gem_mmap,
 	.poll = drm_poll,
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
index 195ed81d39ff..d2ce7d86dbc8 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
@@ -1501,9 +1501,6 @@ void amdgpu_driver_postclose_kms(struct drm_device *dev,
 		amdgpu_vm_bo_del(adev, fpriv->prt_va);
 		amdgpu_bo_unreserve(pd);
 	}
-	fpriv->evf_mgr.fd_closing = true;
-	amdgpu_eviction_fence_destroy(&fpriv->evf_mgr);
-	amdgpu_userq_mgr_fini(&fpriv->userq_mgr);
 
 	amdgpu_ctx_mgr_fini(&fpriv->ctx_mgr);
 	amdgpu_vm_fini(adev, &fpriv->vm);
-- 
2.39.5



