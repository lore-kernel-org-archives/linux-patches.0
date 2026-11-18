Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045904;
	b=Omr4JST5GUHC7bK9NpPywpGdTUZ6RY64ZjmtSzPo8OFhtZxyQ1K28dh9L1U4ZhQjKaNr
	 BX123vvsD2p2b7DtPE1Wd0h+fPww573MPAHJJ4zYxdV3pb3B1aED7DOGYrL+rnSD4gEVy
	 uy0hwu59spunsC8DqMZnWO/bWPxTBMvoy1ZoSHhREV4QBEABH0BjMOwCuLxfPCWH3ofX/
	 8pXkMAmdHFZTvevysBgHYGQ6JP5shOXjBJbpuEqN3ZFtgHLa2UPQIDEVBzFIIumwzZv8J
	 HLrKA8Rzv8wL8nGQsa7Gipa2/3kL8bqe1naKVZt1IZPtazr5E2Gz2V6X0xCJxiVPOIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045904;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nKOmEFpSFKQCGYdfOVvHrs21t7qsYngxwI2/YR6Unpg=;
	b=DS8xUYrRDVGee3gkZlFvFyhqgu5mQMjRysIhO63xBcEWbD6NN8jvR64hk6XFKnf33Uxm
	 D+W+UJkZrFGco5EoMEXqSivVvfIZ0390OH7zvSwvsHcP093rl6C1ry9YtT54LvUS1+sQw
	 e2quDD9zAdK8ddofJquPlmLXmjF0ilUsslKn6Z+4yAKEP9g4dRhTw4ED9Lb3iJZxzSe65
	 8uUd1O0Horv8d8WFSfPSkCv/7csOqpIAqXs5nv2cOHyzFLIMsUdxQGOvU53CVVlFyV+3Y
	 F7RY+MhbZ2EE2RBIZEpnwX6zWxFepQIZcO5MbreqmPswHSOvemHPkAWu8pbURL2zFpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LXlJCr1e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39524606A32A;
	Wed, 18 Nov 2026 23:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LXlJCr1e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9035B1F000C4;
	Wed, 18 Nov 2026 23:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045904;
	bh=nKOmEFpSFKQCGYdfOVvHrs21t7qsYngxwI2/YR6Unpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LXlJCr1eyQrMjVEfa2BMtQgwYhFkRlzXk48GzL/mlWN37OUKU8pWf5+CUAmackJtW
	 0gq//PhSNXbxcrraadsMWkjLbBAIeonOr3zcXU4fdyuLARwZnCHV6IqjjaN63Gn/9d
	 qE2mp3ZXfn6Op5TgwAtqXrO/H91lxkOmi/uVuEMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <felix.kuehling@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1073/2857] drm/amdkfd: evict the queues only once for CRIU PROCESS_INFO
Date: Wed, 18 Nov 2026 15:35:07 +0100
Message-ID: <20261118150240.243751622@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <Jesse.Zhang@amd.com>

[ Upstream commit 8f3ecda0ab42fb5ba7310fe848013d3eff31b416 ]

criu_process_info() evicts the queues of the process on every call, and
each kfd_process_evict_queues() increments qpd->evicted, but CRIU UNPAUSE
restores them only once. After PROCESS_INFO twice and UNPAUSE the queues
stay evicted for good. On navi31, a barrier-AND packet on an HSA queue
completes after PROCESS_INFO + UNPAUSE, but times out after
PROCESS_INFO, PROCESS_INFO, UNPAUSE.

The error path has a related problem: when kfd_process_evict_queues()
itself fails, it has already rolled back its partial eviction, and the
kfd_process_restore_queues() in the error path restores once more.

Evict only when the queues are not paused yet, and on errors only undo
an eviction done by this call. The barrier now completes after any
number of PROCESS_INFO calls followed by UNPAUSE.

Fixes: cd9f79103003 ("drm/amdkfd: CRIU Implement KFD unpause operation")
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 4d79c9e3c32c677fcadf5ca10ab81ee0a4b81f99)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index 0bcbf4ac458ef..43bfd668c5480 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -2611,6 +2611,7 @@ static int criu_process_info(struct file *filep,
 				struct kfd_process *p,
 				struct kfd_ioctl_criu_args *args)
 {
+	bool paused_here = false;
 	int ret = 0;
 
 	mutex_lock(&p->mutex);
@@ -2621,11 +2622,15 @@ static int criu_process_info(struct file *filep,
 		goto err_unlock;
 	}
 
-	ret = kfd_process_evict_queues(p, KFD_QUEUE_EVICTION_CRIU_CHECKPOINT);
-	if (ret)
-		goto err_unlock;
+	/* UNPAUSE restores the queues once, so evict them only once */
+	if (!p->queues_paused) {
+		ret = kfd_process_evict_queues(p, KFD_QUEUE_EVICTION_CRIU_CHECKPOINT);
+		if (ret)
+			goto err_unlock;
 
-	p->queues_paused = true;
+		p->queues_paused = true;
+		paused_here = true;
+	}
 
 	args->pid = task_pid_nr_ns(p->lead_thread,
 					task_active_pid_ns(p->lead_thread));
@@ -2640,7 +2645,7 @@ static int criu_process_info(struct file *filep,
 				args->priv_data_size);
 
 err_unlock:
-	if (ret) {
+	if (ret && paused_here) {
 		kfd_process_restore_queues(p);
 		p->queues_paused = false;
 	}
-- 
2.53.0



