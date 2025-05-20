Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D675224677B;
	Tue, 20 May 2025 14:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750761; cv=none; b=GvIbDIHEQ1gSkhE54tmhxP9TJwO7Ffi7ZkNMKIpKzor70dwvXRj6piKm1GEqUVjji2vuS4b2buqbxiZKfp8ajyUCUHuyMKzUxONMDcHgEQYN7m9K5FTqsuvB9cQ8uXlxxmuNskBiDtOqPUsh4YAAGSzCt6+Yx9ObnWXV/6CKCQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750761; c=relaxed/simple;
	bh=gCMqmrMqIElSqyzpHnAE4FU5i48DalFaifPtrJxCVig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ptzee/NL1t51Zx8wQdSq0auei6TnFhur0gm1v5g7FAtkThbeReLtA2qMaQPg5b6C35myxkrO9CRsz261O72niYsoOJ8A3RMJIk0yYOUVsjLDHedE8fca5LeZBMJgJ34aZRtpYXNCOTbte2yUkWzhYk8spjhfj20gFjzDk39Lo58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DujR9Asg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DujR9Asg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 431B4C4CEEB;
	Tue, 20 May 2025 14:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750761;
	bh=gCMqmrMqIElSqyzpHnAE4FU5i48DalFaifPtrJxCVig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DujR9AsgNesD1ankDoCLlpmAjXdoxdlTkzUV3m1XoFyftiRz6DSA+IxSuT6REWiJd
	 Q1wFAvPgyXKp5n78Vg6Ca+rHkqVW1VGwt2JirwXs9XJCaHyrQNXuHW6WthUEi1jShD
	 11ov+8EPk+2TFB4TJU66my7V0SHKNqRyiLTg8mq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.14 082/145] drm/amdgpu: csa unmap use uninterruptible lock
Date: Tue, 20 May 2025 15:50:52 +0200
Message-ID: <20250520125813.791771974@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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


