Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40973B9950;
	Tue, 21 Jul 2026 21:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669495; cv=none; b=QrS4ubzFmlJB8cOF6lGhTWWXzWPYmwv1gde1Hy6G5rRwHPMsQsbXyhNRW9exjQ1h76Shjrr0eqKZHijmTh499tHXfrZjDRQjZY/IboPEjUwQ1f4U7+NtkaG+YF8q3onZdk1z9qninaTvGPeyM8H2CsKWiSG4EXgw523JWzqx3QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669495; c=relaxed/simple;
	bh=J7JIf6uXCg4VHr7FZl26Zk3/g3JLPCkAmtCYY1bs4no=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Il9J0wDB5tv1VO0Ei+b2rkmN/27qDD0KgKjONYXe8AHDTG5IuTI/zC2+fEfbzk3KbiiFbyrwbpEfy71wq3xF/CKvEf5x+d3FHT40rAgu/snOA6VCPaup1dnAuBJI7KTpaLjm4dDEytB1K+1TVbXLLCFCK6utY/5Jo6y9TIQDEYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V0ItwjUH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V0ItwjUH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 065611F000E9;
	Tue, 21 Jul 2026 21:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669491;
	bh=OBtiB19as+c0zEdRkrzA5RyTt+XZfujlhr5PXq5ujP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V0ItwjUHnxbX5tno+PKHJKPtP/nFvD/xI9bfncBBKGifx2cOvoSrIcckU2XrODUFv
	 gLPgEVw/ImlBf9IaXGcE2mcyKdkKI8pAp1A42h5hSBosnkMpto2+DnTI+FgtvfSA4B
	 uqs0GLlyXg1eG8Y5oebVuVDa4yRUJm8QN+8RFcEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0576/1067] drm/amdgpu: initialize irq.lock spinlock earlier
Date: Tue, 21 Jul 2026 17:19:37 +0200
Message-ID: <20260721152437.489678452@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>

[ Upstream commit a2b270c0ecf6d95bcd14ef4c20d0301a88143ff5 ]

If there is an early failure during amdgpu probe, like missing firmware, it
will end up calling amdgpu_irq_disable_all, which takes irq.lock spinlock
without it being initialized.

Initializing irq.lock earlier at amdgpu_device_init fixes the issue.

[   79.334079] INFO: trying to register non-static key.
[   79.334081] The code is fine but needs lockdep annotation, or maybe
[   79.334083] you didn't initialize this object before use?
[   79.334084] turning off the locking correctness validator.
[   79.334088] CPU: 2 UID: 0 PID: 1819 Comm: bash Not tainted 7.1.0-rc5-gfd06300b2348 #96 PREEMPT  8e8f461221633dae3c832d6689eaf0546c0ed4cd
[   79.334092] Hardware name: Valve Jupiter/Jupiter, BIOS F7A0133 08/05/2024
[   79.334094] Call Trace:
[   79.334095]  <TASK>
[   79.334097]  dump_stack_lvl+0x5d/0x80
[   79.334103]  register_lock_class+0x7af/0x7c0
[   79.334109]  __lock_acquire+0x416/0x2610
[   79.334114]  lock_acquire+0xcf/0x310
[   79.334117]  ? amdgpu_irq_disable_all+0x3b/0xf0 [amdgpu c88bab43d391d519ad0d5c8e5a099b4aceefa180]
[   79.334503]  ? _raw_spin_lock_irqsave+0x53/0x60
[   79.334508]  _raw_spin_lock_irqsave+0x3f/0x60
[   79.334510]  ? amdgpu_irq_disable_all+0x3b/0xf0 [amdgpu c88bab43d391d519ad0d5c8e5a099b4aceefa180]
[   79.334881]  amdgpu_irq_disable_all+0x3b/0xf0 [amdgpu c88bab43d391d519ad0d5c8e5a099b4aceefa180]
[   79.335240]  amdgpu_device_fini_hw+0x90/0x32c [amdgpu c88bab43d391d519ad0d5c8e5a099b4aceefa180]
[   79.335704]  amdgpu_driver_load_kms.cold+0x22/0x44 [amdgpu c88bab43d391d519ad0d5c8e5a099b4aceefa180]
[   79.336159]  amdgpu_pci_probe+0x204/0x440 [amdgpu c88bab43d391d519ad0d5c8e5a099b4aceefa180]
[   79.336494]  local_pci_probe+0x3c/0x80
[   79.336500]  pci_call_probe+0x55/0x2e0
[   79.336505]  ? _raw_spin_unlock+0x2d/0x50
[   79.336508]  ? pci_match_device+0x157/0x180
[   79.336512]  pci_device_probe+0x9b/0x170
[   79.336516]  really_probe+0xd5/0x370
[   79.336521]  __driver_probe_device+0x84/0x150
[   79.336525]  device_driver_attach+0x47/0xb0
[   79.336528]  bind_store+0x73/0xc0
[   79.336531]  kernfs_fop_write_iter+0x176/0x250
[   79.336536]  vfs_write+0x24d/0x560
[   79.336542]  ksys_write+0x71/0xe0
[   79.336546]  do_syscall_64+0x122/0x710
[   79.336550]  ? do_syscall_64+0xd1/0x710
[   79.336553]  entry_SYSCALL_64_after_hwframe+0x4b/0x53
[   79.336557] RIP: 0033:0x7f92fd675006
[   79.336561] Code: 5d e8 41 8b 93 08 03 00 00 59 5e 48 83 f8 fc 75 19 83 e2 39 83 fa 08 75 11 e8 26 ff ff ff 66 0f 1f 44 00 00 48 8b 45 10 0f 05 <48> 8b 5d f8 c9 c3 0f 1f 40 00 f3 0f 1e fa 55 48 89 e5 48 83 ec 08
[   79.336562] RSP: 002b:00007ffe4fa867a0 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
[   79.336565] RAX: ffffffffffffffda RBX: 000000000000000d RCX: 00007f92fd675006
[   79.336567] RDX: 000000000000000d RSI: 000055b2dfce59b0 RDI: 0000000000000001
[   79.336568] RBP: 00007ffe4fa867c0 R08: 0000000000000000 R09: 0000000000000000
[   79.336569] R10: 0000000000000000 R11: 0000000000000202 R12: 000000000000000d
[   79.336570] R13: 000055b2dfce59b0 R14: 00007f92fd7ca5c0 R15: 000055b2dfdbaf70
[   79.336574]  </TASK>

Fixes: 9950cda2a018 ("drm/amdgpu: drop the drm irq pre/post/un install callbacks")
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 7dba3e10ecdeec85208e255853fcd3890880b10e)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 2 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c    | 2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 9d82edb89aab70..f45c500b9d4eaf 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3660,6 +3660,8 @@ int amdgpu_device_init(struct amdgpu_device *adev,
 	mutex_init(&adev->pm.stable_pstate_ctx_lock);
 	mutex_init(&adev->benchmark_mutex);
 
+	spin_lock_init(&adev->irq.lock);
+
 	amdgpu_device_init_apu_flags(adev);
 
 	r = amdgpu_device_check_arguments(adev);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
index c3da333f09de4c..cd112cdbfb109a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
@@ -294,8 +294,6 @@ int amdgpu_irq_init(struct amdgpu_device *adev)
 	int r = 0;
 	unsigned int irq;
 
-	spin_lock_init(&adev->irq.lock);
-
 	/* Enable MSI if not disabled by module parameter */
 	adev->irq.msi_enabled = false;
 
-- 
2.53.0



