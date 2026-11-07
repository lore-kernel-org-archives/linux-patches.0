Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065502;
	b=BJTMoQuxQyAaRap+AV5SYIvdUWa7Cz1gJGg4ByneM+bMXSF3k59v/zEMTiGm+veRXkpI
	 rfUBBsUuOgoUEmk7KjlesMvZwdEN4PJ8zvGwzzgyu/lL/bMOlGDWzeNn1A29RrYQRJOv+
	 CeZmOQY6cXyGwyym6Ubgeqimnfc5/nbG8Lnsy25JosYDjBXEFuiLYWy/DpaT6TZLbCztH
	 mWQg3ZcDsxV2jq8Byu9P064eLlxVC52y7k8G804v2JIh/BzPoDHbQpni2kFx5qHF5UWym
	 TGyPBhcWTNvDyRxi0bs8iqrPZsSlvU1lHLsjKcKboJd4PUy/Pbxuer564fW8AV+6sTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065502;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cKL1hf9HkrBZZEewleruNvYjXZWV+a+0qmU6oaMb1WY=;
	b=bSUtnLQft76j+g2j8nyMLNJbtm3rF1YusIwAUumBjSekU7h2z3waz2vevj1j5RCMxNXo
	 8l32KbSCdpITylhsZwsSaxfZtGCJcomkd0supgix5TvC2SFQBL67a1UymPhdkP04MCKKj
	 QgJr9L9JUDQ7/LyjmLz6xvY//YP17gFEWt15SPNCVkVLCQothUUFhooHjsJZO9yjWzgh/
	 mNGTp85aVOWq47BXwc6LF0uhQDwNTIvl75r/1vrrXIgOgbdBSqsLOZ5x+PElzalartOrT
	 kWSjr4GOh35ps74V/Cum6KkQWu3cINJlVN4NIAA6ikr7T1o89gfZB7+hDpBZk2Udyqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vugo3YbG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A1FC606D803;
	Sat,  7 Nov 2026 15:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vugo3YbG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E72011F0089F;
	Sat,  7 Nov 2026 15:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065502;
	bh=cKL1hf9HkrBZZEewleruNvYjXZWV+a+0qmU6oaMb1WY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vugo3YbGQ+8ZgYQtYu2RRnZ1BONCu/4dwP6/MKdzpLCzT4MjEEiPCnjx7F0ppJRKG
	 1VcVzNmSXPBSBPbRIDWKawQPSRFd3f4moK5WssGNj8cAnYvuC3VNWORKU3k7/2seTW
	 VaSl1oHCGNyPj5kq15V0TSz6GeMigsWeEcJrFkec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <felix.kuehling@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1189/1257] drm/amdkfd: evict the queues only once for CRIU PROCESS_INFO
Date: Sat,  7 Nov 2026 08:58:05 -0500
Message-ID: <20261107135012.007403080@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index cad60ccdb2166..d65ae53c81a5c 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -2876,6 +2876,7 @@ static int criu_process_info(struct file *filep,
 				struct kfd_process *p,
 				struct kfd_ioctl_criu_args *args)
 {
+	bool paused_here = false;
 	int ret = 0;
 
 	mutex_lock(&p->mutex);
@@ -2886,11 +2887,15 @@ static int criu_process_info(struct file *filep,
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
@@ -2905,7 +2910,7 @@ static int criu_process_info(struct file *filep,
 				args->priv_data_size);
 
 err_unlock:
-	if (ret) {
+	if (ret && paused_here) {
 		kfd_process_restore_queues(p);
 		p->queues_paused = false;
 	}
-- 
2.53.0



