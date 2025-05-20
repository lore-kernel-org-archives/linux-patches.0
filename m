Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 919F919ABB6;
	Tue, 20 May 2025 14:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750230; cv=none; b=o9IOWQNs0/yoWOthu2zuHTFJSPh0qW7gtRFySS/hIRTEq66VUPTNmMEYHRfformX1Ar6VcYzKCLcSO20Qh1G32weo2HPLeZhNbDx+KMS6fuCZUnYgtqQ9mctK0u8OWBszmFouc5F+t1UFk68h5qIDCxvUQYV3/mcpSHwSEcpdMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750230; c=relaxed/simple;
	bh=OzVtqzdyIJhg+Gn+Pj/u4TUboVTR1puS1ib8ueSflbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qwM5FEmcOxnHcEOAHChw5qTFUgCfCQIvDhKyxRIHkbbLoNKUXyW+3+rwePdhq1Mn8W9wMOWSh47SUv7f6BorsNRCWFvZJxPqdRMiuJ6tGggSviwkNJ1bwgChr6armt3ysQ3fW23hD/T4oRdCnc/WFvetGM0biV320gMrC+LC39M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=06eivC17; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="06eivC17"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D065C4CEEA;
	Tue, 20 May 2025 14:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750230;
	bh=OzVtqzdyIJhg+Gn+Pj/u4TUboVTR1puS1ib8ueSflbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=06eivC17o6idcLENNqraS7SMiOML7FLM1e1Q24XR8srftcWzIcbtURT6RcSXfprNX
	 JNhZVMxE/xIp/w+zGHVCeWFXBk2iLy7He7fglzTz0mVbvcWjBXiFJbvt77E25uJ0K0
	 hnKddJWK0qQR2V7zIMrUT9pNxoE/m1Vw/lXJwgT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 085/143] drm/amdgpu: csa unmap use uninterruptible lock
Date: Tue, 20 May 2025 15:50:40 +0200
Message-ID: <20250520125813.406409966@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philip Yang <Philip.Yang@amd.com>

commit a0fa7873f2f869087b1e7793f7fac3713a1e3afe upstream.

After process exit to unmap csa and free GPU vm, if signal is accepted
and then waiting to take vm lock is interrupted and return, it causes
memory leaking and below warning backtrace.

Change to use uninterruptible wait lock fix the issue.

WARNING: CPU: 69 PID: 167800 at amd/amdgpu/amdgpu_kms.c:1525
 amdgpu_driver_postclose_kms+0x294/0x2a0 [amdgpu]
 Call Trace:
  <TASK>
  drm_file_free.part.0+0x1da/0x230 [drm]
  drm_close_helper.isra.0+0x65/0x70 [drm]
  drm_release+0x6a/0x120 [drm]
  amdgpu_drm_release+0x51/0x60 [amdgpu]
  __fput+0x9f/0x280
  ____fput+0xe/0x20
  task_work_run+0x67/0xa0
  do_exit+0x217/0x3c0
  do_group_exit+0x3b/0xb0
  get_signal+0x14a/0x8d0
  arch_do_signal_or_restart+0xde/0x100
  exit_to_user_mode_loop+0xc1/0x1a0
  exit_to_user_mode_prepare+0xf4/0x100
  syscall_exit_to_user_mode+0x17/0x40
  do_syscall_64+0x69/0xc0

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 7dbbfb3c171a6f63b01165958629c9c26abf38ab)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c
@@ -109,7 +109,7 @@ int amdgpu_unmap_static_csa(struct amdgp
 	struct drm_exec exec;
 	int r;
 
-	drm_exec_init(&exec, DRM_EXEC_INTERRUPTIBLE_WAIT, 0);
+	drm_exec_init(&exec, 0, 0);
 	drm_exec_until_all_locked(&exec) {
 		r = amdgpu_vm_lock_pd(vm, &exec, 0);
 		if (likely(!r))


