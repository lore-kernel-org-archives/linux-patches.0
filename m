Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C82248BC1;
	Wed, 15 Jan 2025 10:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938243; cv=none; b=fBCDoK8IJ12MkmhMy/RUlB8ddnWhxgbUn4bnTNzomqndNpcSdD+YMbtqbkYv3UdJ/TKOUJ7OD+xmnhFazOqFTJa88awgTvt9jrKmZtxKxiDhSAJ5vxbtt1PBiHOjOSMDJXzW1LXq00u+WNF1dmOHF/OPZ+uVihqyZFWQSUqA2SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938243; c=relaxed/simple;
	bh=Jjdjsm/30XAY1JPY/U1t+M0kZsE/E+KgimqHFT6vvZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YUWxFVNjoMwJygiUkK1iduvfiGLbM68v0ePClYgK86+jNDPQljsEseYKkJFqEgIQTJoC9sp4/L4duRYSqgEyM4Ch8tbfJWpToJSbpuuA8cMF5DwjY7TKVzMsV9o6Fiyk4e+fObwIZ0wLeRAhVT2HExWnhxQ5I6U03hB4jXJUvfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NtHiavV4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NtHiavV4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21B7DC4CEDF;
	Wed, 15 Jan 2025 10:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938243;
	bh=Jjdjsm/30XAY1JPY/U1t+M0kZsE/E+KgimqHFT6vvZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NtHiavV4d3RFeUunLLeG7lS4l3awQNb9zas9vrD7ECVOZqQNBpi9yxuPpafDTapU1
	 L4EKOKjPWxmzgZ0pOzxCknq2PpcOo3H2ucKZmSaxQpus8SExQoZZa3Nh4v0u9XHmVB
	 rESrhRQyu8kIPM3zbuwOudaXHT9flmY/jsNMK2Vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Lingshan <lingshan.zhu@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 124/189] drm/amdkfd: wq_release signals dma_fence only when available
Date: Wed, 15 Jan 2025 11:37:00 +0100
Message-ID: <20250115103611.396009009@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhu Lingshan <lingshan.zhu@amd.com>

commit a993d319aebb7cce8a10c6e685344b7c2ad5c4c2 upstream.

kfd_process_wq_release() signals eviction fence by
dma_fence_signal() which wanrs if dma_fence
is NULL.

kfd_process->ef is initialized by kfd_process_device_init_vm()
through ioctl. That means the fence is NULL for a new
created kfd_process, and close a kfd_process right
after open it will trigger the warning.

This commit conditionally signals the eviction fence
in kfd_process_wq_release() only when it is available.

[  503.660882] WARNING: CPU: 0 PID: 9 at drivers/dma-buf/dma-fence.c:467 dma_fence_signal+0x74/0xa0
[  503.782940] Workqueue: kfd_process_wq kfd_process_wq_release [amdgpu]
[  503.789640] RIP: 0010:dma_fence_signal+0x74/0xa0
[  503.877620] Call Trace:
[  503.880066]  <TASK>
[  503.882168]  ? __warn+0xcd/0x260
[  503.885407]  ? dma_fence_signal+0x74/0xa0
[  503.889416]  ? report_bug+0x288/0x2d0
[  503.893089]  ? handle_bug+0x53/0xa0
[  503.896587]  ? exc_invalid_op+0x14/0x50
[  503.900424]  ? asm_exc_invalid_op+0x16/0x20
[  503.904616]  ? dma_fence_signal+0x74/0xa0
[  503.908626]  kfd_process_wq_release+0x6b/0x370 [amdgpu]
[  503.914081]  process_one_work+0x654/0x10a0
[  503.918186]  worker_thread+0x6c3/0xe70
[  503.921943]  ? srso_alias_return_thunk+0x5/0xfbef5
[  503.926735]  ? srso_alias_return_thunk+0x5/0xfbef5
[  503.931527]  ? __kthread_parkme+0x82/0x140
[  503.935631]  ? __pfx_worker_thread+0x10/0x10
[  503.939904]  kthread+0x2a8/0x380
[  503.943132]  ? __pfx_kthread+0x10/0x10
[  503.946882]  ret_from_fork+0x2d/0x70
[  503.950458]  ? __pfx_kthread+0x10/0x10
[  503.954210]  ret_from_fork_asm+0x1a/0x30
[  503.958142]  </TASK>
[  503.960328] ---[ end trace 0000000000000000 ]---

Fixes: 967d226eaae8 ("dma-buf: add WARN_ON() illegal dma-fence signaling")
Signed-off-by: Zhu Lingshan <lingshan.zhu@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 2774ef7625adb5fb9e9265c26a59dca7b8fd171e)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_process.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process.c b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
index d0ee173acf82..edfe0b4788f4 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
@@ -1160,7 +1160,8 @@ static void kfd_process_wq_release(struct work_struct *work)
 	 */
 	synchronize_rcu();
 	ef = rcu_access_pointer(p->ef);
-	dma_fence_signal(ef);
+	if (ef)
+		dma_fence_signal(ef);
 
 	kfd_process_remove_sysfs(p);
 
-- 
2.48.0



