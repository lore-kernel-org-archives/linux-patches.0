Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C47027FB32;
	Wed, 28 Jan 2026 14:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769610407; cv=none; b=Llo5k5pOdha2I6eVkyDwcJ06ne+YOa6a5fF8qqAqtadAJglJmuq/Rix9Pp3/8/cgJ0Ts0fuve3or+hrRV4j+csGDwA6AJcf+R7mrN3b6xViIbDfB5GtgbqYKpLhZ4/iN9VEzMra0obpEy1entWVtk55bafzuc8NfJq4nvTxma0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769610407; c=relaxed/simple;
	bh=DEcMvfStz6GaeSY2VfHx8DKRhaQVCZvezFr2H8IYaLw=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=tlwSOryW6Dz6sIetQ5CPcmmWcXhexAsfzW495x4iNTf+2RcfInOoe1WvdRzCtPGH5B0L2mgLpt+tDgzmPMd2KYffNcw70EEXm8lq31IAqeqeeHLJAbSv+2p8DPwr3nzdW3irKxVthczr7K1uvDSkLgWS3lNDDh5vuiXJCrA7nlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l/Qnt8c5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l/Qnt8c5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29FA9C4CEF1;
	Wed, 28 Jan 2026 14:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769610407;
	bh=DEcMvfStz6GaeSY2VfHx8DKRhaQVCZvezFr2H8IYaLw=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=l/Qnt8c5VbQesnQ0osimKULNHFOwHMZMA0D4rYQAHcRMyiVg4yHELVfgpCaYdgSHf
	 PAY4YafyxXJJW1pPwLDBBoseDk3UqL2YWJPRWvv2enOXGbfqpZAWufbv7kazfwoMh0
	 4fX4cwYq8YR6cc6oM3MLCqDNnyLg7tV09Ytfveb0=
Subject: Patch "drm/amdgpu: csa unmap use uninterruptible lock" has been added to the 6.6-stable tree
To: 1468888505@139.com,Philip.Yang@amd.com,alexander.deucher@amd.com,christian.koenig@amd.com,gregkh@linuxfoundation.org,patches@lists.linux.dev
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Wed, 28 Jan 2026 15:24:54 +0100
In-Reply-To: <20260128032238.1182576-1-1468888505@139.com>
Message-ID: <2026012854-liqueur-tumble-43fc@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    drm/amdgpu: csa unmap use uninterruptible lock

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     drm-amdgpu-csa-unmap-use-uninterruptible-lock.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-211919-greg=kroah.com@vger.kernel.org Wed Jan 28 04:22:57 2026
From: Li hongliang <1468888505@139.com>
Date: Wed, 28 Jan 2026 11:22:38 +0800
Subject: drm/amdgpu: csa unmap use uninterruptible lock
To: gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org
Message-ID: <20260128032238.1182576-1-1468888505@139.com>

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit a0fa7873f2f869087b1e7793f7fac3713a1e3afe ]

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
[The third parameter of drm_exec_init() was introduced by commit
 05d249352f1a ("drm/exec: Pass in initial # of objects") after Linux 6.8.
 This code targets linux 6.6, so the current implementation is used
 and the third parameter is not needed.]
Signed-off-by: Li hongliang <1468888505@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c
@@ -110,7 +110,7 @@ int amdgpu_unmap_static_csa(struct amdgp
 	struct drm_exec exec;
 	int r;
 
-	drm_exec_init(&exec, DRM_EXEC_INTERRUPTIBLE_WAIT);
+	drm_exec_init(&exec, 0);
 	drm_exec_until_all_locked(&exec) {
 		r = amdgpu_vm_lock_pd(vm, &exec, 0);
 		if (likely(!r))


Patches currently in stable-queue which might be from 1468888505@139.com are

queue-6.6/fs-ntfs3-initialize-allocated-memory-before-use.patch
queue-6.6/drm-amdgpu-csa-unmap-use-uninterruptible-lock.patch
queue-6.6/wifi-ath11k-fix-rcu-stall-while-reaping-monitor-destination-ring.patch
queue-6.6/ksmbd-fix-use-after-free-in-ksmbd_session_rpc_open.patch
