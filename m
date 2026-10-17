Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113893A8753;
	Sat, 17 Oct 2026 18:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260388; cv=none; b=J635+PP9VDKmBostk7PfHzTO6BC0uQwa1Nq1facEHAySNWk1I6MxIPWFCfVREJoy6Ey1rnxVlblxK8h1aw8RzuFFVs24egVp6RN5OpYnOu8CUaFUMHgoMcP9SNqNlNO9OFb7jUZ99vh3Rq9KAVtdCaNx1AoUUWqlu+PEPfB9FvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260388; c=relaxed/simple;
	bh=UHN+J9C7fh/NxWMywcfF8XjNIx7pAs3x6NDu3NoouXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A+WKQX+Ofmbej0DanA5NPZRh+XFE3wAbWHiWCv53niz4fpXO/oCfpT8+wvBzNlGwkgLvhVrxAGqQ+Oh/+0jf+2lVdnWGwTf4xt9e9myb4jHuhwqeJQlUCRKdxExTkgFHeWuueD5BDYDzDfG3xsQdLE6+patt/tDyeftMkirP5+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2WIk4sr4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2WIk4sr4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F90B1F000C4;
	Sat, 17 Oct 2026 18:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260387;
	bh=9xMa58Iq34j/n1ZWKw8gdVrePE+7e8wAw4DPKDUw73o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2WIk4sr4M5Lfpm0gh3bZRP1L8mm89tbbz8FaE/DtgGQILstmp5PFT+U4UW6Ix7Xp8
	 AODWWpT80VUwGTfE0B5u/oOC1vdGkTF2GdU0Tgf7DuaRWvnT1toi1gpVoqcjYlRmDU
	 HEA8OKJCPdCeUty8tGBPoQelpUImm/GAvG9W22ZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongqiang Sun <Yongqiang.Sun@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1527/1674] drm/amdkfd: fix SMI event cross-process information leak
Date: Sat, 17 Oct 2026 18:03:19 +0200
Message-ID: <20261017160510.316781725@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/gpu/drm/amd/amdkfd/kfd_smi_events.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_smi_events.c b/drivers/gpu/drm/amd/amdkfd/kfd_smi_events.c
index 06ac835190f97..ef4c7e39a8442 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_smi_events.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_smi_events.c
@@ -244,7 +244,7 @@ void kfd_smi_event_update_vmfault(struct kfd_node *dev, uint16_t pasid)
 	if (task_info) {
 		/* Report VM faults from user applications, not retry from kernel */
 		if (task_info->pid)
-			kfd_smi_event_add(0, dev, KFD_SMI_EVENT_VMFAULT, "%x:%s\n",
+			kfd_smi_event_add(task_info->tgid, dev, KFD_SMI_EVENT_VMFAULT, "%x:%s\n",
 					 task_info->pid, task_info->task_name);
 		amdgpu_vm_put_task_info(task_info);
 	}
-- 
2.53.0



