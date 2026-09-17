Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FBFD4FC331;
	Thu, 17 Sep 2026 17:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664403; cv=none; b=k+mW+hy9D8A/5+SnMjbbBWNRNKySs/k3UGTgYqUnx6cJZU4pa/hOTidWasdAlxjZLCpAb7dFsVW5+hO1pFLKUmEkkV6vzhMPuCU7XkcWHMXEn3nUmbnhneZ5Cy7WjxMmRIy2+UzuDKdwHub/bonKJ5vaN+WzFlbfyWgEGCtdVCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664403; c=relaxed/simple;
	bh=J0E/nb6Ez22H1iQqIhFzGJb6UUxLgkwuXN9aJPMZg4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N00rHMDrEcWftbyBiTqjZxIyRn808tFAdxIJBAnZ07vU1iGThXYBO3qlN/FF/B67I9eCXCLtU5Gsnob5MFNXyGTpS1u+/85C2lFSpdB3nYh1VFF9SQ3NWLiPAQwUU8Ge/xL3mTAWIMbguN/jvzl8LUbVEL4WQ/yyvZi58UlZPio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TARV3Aaz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TARV3Aaz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77FD31F000FF;
	Thu, 17 Sep 2026 17:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664402;
	bh=ytJ15U9FpTulmYKtty2QsH2rrZ/AHMyfd/WTUukgkNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TARV3AazU2IeZCf5vQqtOYK13elnbmhpd27ZtnMWqhS7sP5+yDaxRyZIidndXcGGa
	 rpT5/mTtrPuvrdMmW6G4+iKh5SDid5lRO18dmvJmIOt5qjxbtCR7BjiSw2Cgw67BFW
	 vh+CrfDAsaCE+0b1p+bD3gF3TBGFCAbt1M5w7Ve8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongqiang Sun <Yongqiang.Sun@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0334/1250] drm/amdkfd: fix SMI event cross-process information leak
Date: Thu, 17 Sep 2026 16:02:09 +0100
Message-ID: <20260917151601.140405030@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongqiang Sun <Yongqiang.Sun@amd.com>

[ Upstream commit 92a8dba246d371fe268280e5fd74b0955688e6df ]

kfd_smi_ev_enabled() skips the suser privilege check when pid=0.
PROCESS_START, PROCESS_END, and VMFAULT events are emitted with
pid=0 while carrying another process's PID and command name, so any
/dev/kfd user in the render group can monitor all GPU workloads.

Pass the target process PID into kfd_smi_event_add() for these events
so the existing per-client filter restricts delivery to the owning
process or CAP_SYS_ADMIN subscribers.

Signed-off-by: Yongqiang Sun <Yongqiang.Sun@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_smi_events.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_smi_events.c b/drivers/gpu/drm/amd/amdkfd/kfd_smi_events.c
index d2bc169e84b0b..fe4b936923854 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_smi_events.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_smi_events.c
@@ -254,8 +254,10 @@ void kfd_smi_event_update_vmfault(struct kfd_node *dev, uint16_t pasid)
 	if (task_info) {
 		/* Report VM faults from user applications, not retry from kernel */
 		if (task_info->task.pid)
-			kfd_smi_event_add(0, dev, KFD_SMI_EVENT_VMFAULT, KFD_EVENT_FMT_VMFAULT(
-					  task_info->task.pid, task_info->task.comm));
+			kfd_smi_event_add(task_info->tgid, dev,
+					  KFD_SMI_EVENT_VMFAULT,
+					  KFD_EVENT_FMT_VMFAULT(task_info->task.pid,
+								task_info->task.comm));
 		amdgpu_vm_put_task_info(task_info);
 	}
 }
@@ -356,7 +358,7 @@ void kfd_smi_event_process(struct kfd_process_device *pdd, bool start)
 	task_info = amdgpu_vm_get_task_info_vm(avm);
 
 	if (task_info) {
-		kfd_smi_event_add(0, pdd->dev,
+		kfd_smi_event_add(task_info->tgid, pdd->dev,
 				  start ? KFD_SMI_EVENT_PROCESS_START :
 				  KFD_SMI_EVENT_PROCESS_END,
 				  KFD_EVENT_FMT_PROCESS(task_info->task.pid,
-- 
2.53.0



