Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D502F26E166;
	Tue,  8 Apr 2025 12:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115653; cv=none; b=KKIiftyhPkDa8WtVqm4DLJwh+88uzdfHdah1He3z5+P5c0DEYUlCK0awepj6t2IlYZ5UR5Yj1RJFAAcm1ajm7HdhF4zYAEUIqqqNMmjb6AX4Y+AFYq+70rstMI13DqV6OGL/rvDyOW319868BHSWc5ASKhtASp0RbdSuRGJYN9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115653; c=relaxed/simple;
	bh=gnwzZlkNf+vFm9bZt7jqzhQPbJQcllNnoWDlZhGQdpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZSeJEwuWyooJ9oPW4snO+GKwWHCYaCJQF16rRDhUe/eE2NizGnsDGCGVdo8HSm4WVnfz4zOLxRgQX0hEDM6Wb/HrCAfPQ1cfBH3j6mfZC6ZcBn2T05w7xQ+p9d82jq3CfqzsPsWYHcgnqsYcGtTMfqEPruqT3+EvsWIRwvjkGSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2wjyXu0b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2wjyXu0b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 699C3C4CEE5;
	Tue,  8 Apr 2025 12:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115653;
	bh=gnwzZlkNf+vFm9bZt7jqzhQPbJQcllNnoWDlZhGQdpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2wjyXu0bC0d3Uzc6OONNqqXICJtxkOzW1b5GCV/tZ/h5sT0Wyu5A6rOkaI6yqgS8F
	 QjI/+xsVnUF/jp6pNSLNaJZOQMNWowkoW/0w3mh7Z/horFvkB2pgtA6e3v5S38Lgwg
	 /EuT60GIY4knljjwjkP1LB6kdcyZLZBGYkrEOV4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 054/204] remoteproc: core: Clear table_sz when rproc_shutdown
Date: Tue,  8 Apr 2025 12:49:44 +0200
Message-ID: <20250408104821.929836177@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit efdde3d73ab25cef4ff2d06783b0aad8b093c0e4 ]

There is case as below could trigger kernel dump:
Use U-Boot to start remote processor(rproc) with resource table
published to a fixed address by rproc. After Kernel boots up,
stop the rproc, load a new firmware which doesn't have resource table
,and start rproc.

When starting rproc with a firmware not have resource table,
`memcpy(loaded_table, rproc->cached_table, rproc->table_sz)` will
trigger dump, because rproc->cache_table is set to NULL during the last
stop operation, but rproc->table_sz is still valid.

This issue is found on i.MX8MP and i.MX9.

Dump as below:
Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
Mem abort info:
  ESR = 0x0000000096000004
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x04: level 0 translation fault
Data abort info:
  ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
  CM = 0, WnR = 0, TnD = 0, TagAccess = 0
  GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
user pgtable: 4k pages, 48-bit VAs, pgdp=000000010af63000
[0000000000000000] pgd=0000000000000000, p4d=0000000000000000
Internal error: Oops: 0000000096000004 [#1] PREEMPT SMP
Modules linked in:
CPU: 2 UID: 0 PID: 1060 Comm: sh Not tainted 6.14.0-rc7-next-20250317-dirty #38
Hardware name: NXP i.MX8MPlus EVK board (DT)
pstate: a0000005 (NzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __pi_memcpy_generic+0x110/0x22c
lr : rproc_start+0x88/0x1e0
Call trace:
 __pi_memcpy_generic+0x110/0x22c (P)
 rproc_boot+0x198/0x57c
 state_store+0x40/0x104
 dev_attr_store+0x18/0x2c
 sysfs_kf_write+0x7c/0x94
 kernfs_fop_write_iter+0x120/0x1cc
 vfs_write+0x240/0x378
 ksys_write+0x70/0x108
 __arm64_sys_write+0x1c/0x28
 invoke_syscall+0x48/0x10c
 el0_svc_common.constprop.0+0xc0/0xe0
 do_el0_svc+0x1c/0x28
 el0_svc+0x30/0xcc
 el0t_64_sync_handler+0x10c/0x138
 el0t_64_sync+0x198/0x19c

Clear rproc->table_sz to address the issue.

Fixes: 9dc9507f1880 ("remoteproc: Properly deal with the resource table when detaching")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Link: https://lore.kernel.org/r/20250319100106.3622619-1-peng.fan@oss.nxp.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/remoteproc_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 341787909bd2a..beae269e80b3c 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -2023,6 +2023,7 @@ int rproc_shutdown(struct rproc *rproc)
 	kfree(rproc->cached_table);
 	rproc->cached_table = NULL;
 	rproc->table_ptr = NULL;
+	rproc->table_sz = 0;
 out:
 	mutex_unlock(&rproc->lock);
 	return ret;
-- 
2.39.5



