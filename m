Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39BA318EE1;
	Thu, 28 May 2026 19:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998133; cv=none; b=g5+PBiVTnrACql4HKK7eZxC2bJPVCubEHe9Y92bhv2s1uELLuQX3B7WZL1/FH+fSAyMHvxV/CVacxZX7kaYX58JSCDc9Db7YJ2lnQ5TjDmeQBmZyWsAjwrWlAEI6i4liZjFQRgIv7FsAhoF8odofblekwFNYM/UjOYjcqynvk68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998133; c=relaxed/simple;
	bh=ubhZR56gQAXsRsJDgGFv48CMtSOzK9qr7XN7NZGToLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ci71yXcNFxQRPCk0P285y1z1cORwIuJH21mrRFmGgUIJhk6HMZ6cDAb8EEuf1jki4zUxjcO98ZGldG5nNwWaxFzRoS8LaIpwpksyGG8e/MLOgDuKw9aqSSyG65qRLN63kQXzUIQngCOpTmPoBa9sHoUNJgGc5ZYcMBd/sslKndI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N9nH1Lxa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N9nH1Lxa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA461F000E9;
	Thu, 28 May 2026 19:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998132;
	bh=45kog5K8idUhlWGcKHnk9Uvplbg2IYHTdldZt7efYpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N9nH1Lxasx405grsCpLj5bP+1H90fNA6jdPDwDBxSDyy/jhir/z8rQqACbX7gAIKX
	 T8f3amdK8bZO9IJ+ccd5iaCP3N7yuyVPYq5MAQIr7ar9p7kF2pbyGSWqmqqAX2uU8L
	 7LO+CnSjVVkLFi+83zbl1RvbqTSiuoU3mz6J2KYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 065/461] sched_ext: Avoid UAF in scx_root_enable_workfn() init failure path
Date: Thu, 28 May 2026 21:43:14 +0200
Message-ID: <20260528194648.800197258@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

[ Upstream commit 9a415cc53711f2238e0f0ca8a6bcc796c003b127 ]

In scx_root_enable_workfn(), put_task_struct(p) is called before scx_error()
dereferences p->comm and p->pid. If the iterator's reference is the last
drop, the task is freed synchronously and the deref becomes a UAF.

Move put_task_struct() past scx_error().

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260511214031.AF5E9C2BCB0@smtp.kernel.org/
Fixes: f0e1a0643a59 ("sched_ext: Implement BPF extensible scheduler class")
Cc: stable@vger.kernel.org # v6.12+
Signed-off-by: Tejun Heo <tj@kernel.org>
[ kept `scx_init_task()` call site instead of `__scx_init_task()`/`task_rq_lock` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -5239,10 +5239,10 @@ static void scx_enable_workfn(struct kth
 
 		ret = scx_init_task(p, task_group(p), false);
 		if (ret) {
-			put_task_struct(p);
 			scx_task_iter_stop(&sti);
 			scx_error(sch, "ops.init_task() failed (%d) for %s[%d]",
 				  ret, p->comm, p->pid);
+			put_task_struct(p);
 			goto err_disable_unlock_all;
 		}
 


