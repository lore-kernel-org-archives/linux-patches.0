Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213527;
	b=N5lM40BHBzCCwznU10c0nt5Rna2O3FEgUaj2M91jhG3C2IsA6HAjJhBBYzc7lh0mvutr
	 zCIh5DzvUsXl/jVSQRK2tAjlsQ+HAPVFqLiMBQ93cVhAhm+XljEyqZ8Esefi9Jxa/AUop
	 +k2YAf5rUaP8lVSo7imuh+GVlt1bwvAoAnlyUlilVW52yB8IeyzrtTauO4TyfVOfimu5R
	 dCAqyqQ8hZ4l34+NQwox4jTGWoZPFzFoGjpBYlU/E2dgdNa1FdJWaUQJ9/sO0WlTsSsVZ
	 tEvOfuU3wGRKB+FB370y578Od8sPLcXJ32RmVPvKDBWwsiDTdiPoTh4Bj0c19ICLz3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213527;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=dM509vwvjXlg4Vr+Nt48DSRzFM6OhGq+HoUv0SkMaPM=;
	b=z1GHPOvTgxCbIzdoYuS6TZOtGCvR1D83QvFXCF8oRaIHbaGUlzm5ahoM+XFVYxZ9JNTQ
	 /QAUSTy7HdL/nvJxxe0pl8dXafeVxOjd9aKw51oZBvlGr/BWQsE14Z0hqJaDEQuaOSSHJ
	 03tPFxHWNc6IosIeeaxWPb1+AlqxCW/X4Cl2+xoxy6jd6bTj+xwJvpK9a3KObWnalKuOZ
	 syr28UjB/ucJkjAPCQiwPKpBFyVtynDh644+3t1SBpXhDNM8zHHnj3WLJ7s6ehTrvLycI
	 rea43RJqOpnZqkGsKRpC/a+LfR1/CEL8V3conMWCR3HSDnz3wdzVOn7eL7LCqfRZg/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H9RFVx6p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8F7606A321;
	Wed, 28 Oct 2026 18:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H9RFVx6p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0205B1F01828;
	Wed, 28 Oct 2026 18:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213526;
	bh=dM509vwvjXlg4Vr+Nt48DSRzFM6OhGq+HoUv0SkMaPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H9RFVx6pg9dxEn9+Fr5F5VjOHRXxOVhjzqIscFQ6GkVugGYel64XlmokY6WBgHPdR
	 DlPXqkTlkLDlsEcFieq48TIJ/eveWQwq4Oip5+E8de+FJSQ7uh5e9gDIwJ8gow6mvZ
	 5QvQEs6oswzVeDq9rK9eqT1YUn/jKSEqOYH0xdC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Tom St Denis <tom.stdenis@amd.com>,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0538/1887] drm/amdgpu: copy debugfs register data outside the GRBM/SRBM locks
Date: Wed, 28 Oct 2026 17:43:54 +0100
Message-ID: <20261028170511.593216142@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>

[ Upstream commit 16c64495859f13f75602f439588883f2a4a4d6a6 ]

Reading or writing a register through the amdgpu_regs2 debugfs file
with GRBM bank selection, which umr does for every banked access (a
single "umr -b x x x -r <reg>" is enough, as is the wave dump with
"-O halt_waves"), makes lockdep report a circular locking dependency,
after which lockdep stays off until reboot:

  WARNING: possible circular locking dependency detected
  umr/63306 is trying to acquire lock:
  ffff8882cf4b8350 (&mm->mmap_lock){++++}-{4:4}, at: __might_fault+0x9b/0x140
  but task is already holding lock:
  ffff8881aec010d0 (&amdgpu_grbm_lock_key){+.+.}-{4:4}, at: amdgpu_debugfs_regs2_op.isra.0+0x20d/0xd00 [amdgpu]
  ...
  Chain exists of:
    &mm->mmap_lock --> &amdgpu_srbm_lock_key --> &amdgpu_grbm_lock_key
  ...
   __might_fault+0xc5/0x140
   amdgpu_debugfs_regs2_op.isra.0+0x441/0xd00 [amdgpu]
   full_proxy_write+0x10e/0x1d0
   vfs_write+0x1d0/0xf50
   ksys_write+0x116/0x250

amdgpu_debugfs_regs2_op() and amdgpu_debugfs_process_reg_op() call
get_user()/put_user() for every dword while holding grbm_idx_mutex or
srbm_mutex, and pm.mutex if requested, so a fault there takes mmap_lock
inside those locks. The lock hierarchy in amdgpu_lockdep.c puts
srbm_mutex and grbm_idx_mutex below notifier_lock, which
amdgpu_cs_submit() takes with the BO reservations held, and
dma_resv_lockdep() orders the reservations inside mmap_lock. So
mmap_lock is outside grbm_idx_mutex and srbm_mutex, and these two
debugfs paths nest it the other way round. The copies under the locks
are as old as the bank selection in both files; commit 1d0f5838b126
("drm/amdgpu: Add lockdep annotations for lock ordering validation")
only made them visible to lockdep.

Copy the user buffer in before any of the locks is taken and the result
out after all of them are dropped, as amdgpu_debugfs_wave_read(),
amdgpu_debugfs_gpr_read() and amdgpu_debugfs_gprwave_read() already do.
The buffer is sized by the count passed to read() or write(), so an
access larger than PAGE_SIZE is now rejected with -EINVAL; umr reads and
writes one register at a time. A fault on the user buffer of a write now
fails with -EFAULT before any register is written, instead of after a
partial write.

Fixes: 566281595037 ("drm/amd/amdgpu: Add bank selection for MMIO debugfs (v3)")
Fixes: 37df9560cd3e ("drm/amd/amdgpu: New debugfs interface for MMIO registers (v5)")
Acked-by: Christian König <christian.koenig@amd.com>
Acked-by: Tom St Denis <tom.stdenis@amd.com>
Reviewed-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit ccf9e35ed6811f2c25ba6368e7dc6481da17159d)
Cc: stable@vger.kernel.org
[ sashal: Omitted the XCC argument from amdgpu_mm_wreg_mmio_rlc() calls to match the three-argument API. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c | 76 ++++++++++++---------
 1 file changed, 45 insertions(+), 31 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
index 2300752e2fa8c..b80b34b8aa5c4 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
@@ -114,6 +114,20 @@ static int  amdgpu_debugfs_process_reg_op(bool read, struct file *f,
 
 	*pos &= (1UL << 22) - 1;
 
+	if (size > PAGE_SIZE)
+		return -EINVAL;
+
+	/*
+	 * Access the user buffer only while none of the locks below are held:
+	 * a fault takes mmap_lock, and grbm_idx_mutex and srbm_mutex nest
+	 * inside it.
+	 */
+	u32 *data __free(kfree) = kmalloc(size, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+	if (!read && copy_from_user(data, buf, size))
+		return -EFAULT;
+
 	r = pm_runtime_get_sync(adev_to_drm(adev)->dev);
 	if (r < 0) {
 		pm_runtime_put_autosuspend(adev_to_drm(adev)->dev);
@@ -146,28 +160,16 @@ static int  amdgpu_debugfs_process_reg_op(bool read, struct file *f,
 		mutex_lock(&adev->pm.mutex);
 
 	while (size) {
-		uint32_t value;
-
-		if (read) {
-			value = RREG32(*pos >> 2);
-			r = put_user(value, (uint32_t *)buf);
-		} else {
-			r = get_user(value, (uint32_t *)buf);
-			if (!r)
-				amdgpu_mm_wreg_mmio_rlc(adev, *pos >> 2, value);
-		}
-		if (r) {
-			result = r;
-			goto end;
-		}
+		if (read)
+			data[result >> 2] = RREG32(*pos >> 2);
+		else
+			amdgpu_mm_wreg_mmio_rlc(adev, *pos >> 2, data[result >> 2]);
 
 		result += 4;
-		buf += 4;
 		*pos += 4;
 		size -= 4;
 	}
 
-end:
 	if (use_bank) {
 		amdgpu_gfx_select_se_sh(adev, 0xffffffff, 0xffffffff, 0xffffffff);
 		mutex_unlock(&adev->grbm_idx_mutex);
@@ -183,6 +185,10 @@ static int  amdgpu_debugfs_process_reg_op(bool read, struct file *f,
 	pm_runtime_put_autosuspend(adev_to_drm(adev)->dev);
 
 	amdgpu_virt_disable_access_debugfs(adev);
+
+	if (read && copy_to_user(buf, data, result))
+		return -EFAULT;
+
 	return result;
 }
 
@@ -232,11 +238,24 @@ static ssize_t amdgpu_debugfs_regs2_op(struct file *f, char __user *buf, u32 off
 	struct amdgpu_device *adev = rd->adev;
 	ssize_t result = 0;
 	int r;
-	uint32_t value;
 
 	if (size & 0x3 || offset & 0x3)
 		return -EINVAL;
 
+	if (size > PAGE_SIZE)
+		return -EINVAL;
+
+	/*
+	 * Access the user buffer only while none of the locks below are held:
+	 * a fault takes mmap_lock, and grbm_idx_mutex and srbm_mutex nest
+	 * inside it.
+	 */
+	u32 *data __free(kfree) = kmalloc(size, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+	if (write_en && copy_from_user(data, buf, size))
+		return -EFAULT;
+
 	r = pm_runtime_get_sync(adev_to_drm(adev)->dev);
 	if (r < 0) {
 		pm_runtime_put_autosuspend(adev_to_drm(adev)->dev);
@@ -276,24 +295,15 @@ static ssize_t amdgpu_debugfs_regs2_op(struct file *f, char __user *buf, u32 off
 		mutex_lock(&adev->pm.mutex);
 
 	while (size) {
-		if (!write_en) {
-			value = RREG32(offset >> 2);
-			r = put_user(value, (uint32_t *)buf);
-		} else {
-			r = get_user(value, (uint32_t *)buf);
-			if (!r)
-				amdgpu_mm_wreg_mmio_rlc(adev, offset >> 2, value);
-		}
-		if (r) {
-			result = r;
-			goto end;
-		}
+		if (!write_en)
+			data[result >> 2] = RREG32(offset >> 2);
+		else
+			amdgpu_mm_wreg_mmio_rlc(adev, offset >> 2, data[result >> 2]);
 		offset += 4;
 		size -= 4;
 		result += 4;
-		buf += 4;
 	}
-end:
+
 	if (rd->id.use_grbm) {
 		amdgpu_gfx_select_se_sh(adev, 0xffffffff, 0xffffffff, 0xffffffff);
 		mutex_unlock(&adev->grbm_idx_mutex);
@@ -313,6 +323,10 @@ static ssize_t amdgpu_debugfs_regs2_op(struct file *f, char __user *buf, u32 off
 	pm_runtime_put_autosuspend(adev_to_drm(adev)->dev);
 
 	amdgpu_virt_disable_access_debugfs(adev);
+
+	if (!write_en && copy_to_user(buf, data, result))
+		return -EFAULT;
+
 	return result;
 }
 
-- 
2.53.0



