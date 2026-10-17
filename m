Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F67A277026;
	Sat, 17 Oct 2026 16:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255285; cv=none; b=bEIEr2X8k/brhT62ImHVBQQO76wQIArhP4igp7xWIGM9rC1cHll8ccaieuQMzJwcI5el+KF57TQHc9hrooodsZrm4xuvnpot5zPozf57sNt/91Jl7zCRR8c9fKiiyyo3TcAHSbA6nB5oeamre+ECPqTKImEdMXq0VYKS5j7a9io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255285; c=relaxed/simple;
	bh=/PNIB7DLx2drE4rE2PWsRTsZnREnCh3FRQfNBkI0vM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JfR+fB3iqxDTKNPckGz276avsmfxisCnhbRquPSDfO3ojf4SM/gsBEH32dSpalhVhF2WpTgJd4jeJlShsER6M+tNNgqr9IiCCli7PbQcxNfyqCLhMxnWDYRyRD2AwIGPTBiXR6WU9YCskcvX7FgcvYbDSvOl8PgippYl8HZOo/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QypLKUtf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QypLKUtf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5CC71F000C4;
	Sat, 17 Oct 2026 16:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255284;
	bh=54+dG/JtZnbq4qyZAFYXuXwXwRRCUNDrjts18/BIvC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QypLKUtf5LKEF+Grwb440Sc8CbyOswF89vYlN/LOcjjVwX+gz8OtUiBRw1xAduewg
	 ffqEueqU8xcj65djqFRhaVIErJhtbbS/TL2V4cdeGA/KBncbx2SqraelIcJOwjk/AY
	 r2un963zlkIkbqLw8mr02KqTsm2BszyZzntJoQoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongqiang Sun <Yongqiang.Sun@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 725/869] drm/amdkfd: fix SMI event cross-process information leak
Date: Sat, 17 Oct 2026 17:59:26 +0200
Message-ID: <20261017160055.541821313@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/gpu/drm/amd/amdkfd/kfd_smi_events.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_smi_events.c b/drivers/gpu/drm/amd/amdkfd/kfd_smi_events.c
index 592953fe9afc2..8010ef10e572c 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_smi_events.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_smi_events.c
@@ -255,8 +255,10 @@ void kfd_smi_event_update_vmfault(struct kfd_node *dev, uint16_t pasid)
 	if (task_info) {
 		/* Report VM faults from user applications, not retry from kernel */
 		if (task_info->pid)
-			kfd_smi_event_add(0, dev, KFD_SMI_EVENT_VMFAULT, KFD_EVENT_FMT_VMFAULT(
-					  task_info->pid, task_info->task_name));
+			kfd_smi_event_add(task_info->tgid, dev,
+					  KFD_SMI_EVENT_VMFAULT,
+					  KFD_EVENT_FMT_VMFAULT(task_info->pid,
+								task_info->task_name));
 		amdgpu_vm_put_task_info(task_info);
 	}
 }
-- 
2.53.0



