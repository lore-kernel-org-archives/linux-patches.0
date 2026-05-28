Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23933313550;
	Thu, 28 May 2026 20:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000536; cv=none; b=tqHgYSMYzVUIhogStMRSOCGZewFf0sjd7bsgMKCLgY7p0SbY5J62kb8+nACr8Uyx281QPkZwApKUoHV5DieaddsOzVPEQopHD1lBHK0MJgyWPQABv50VykoYT2gk+V8HqvA1kqfvZbk97pLjBtIbBuvwQ8vYB//+wGROnvYU95k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000536; c=relaxed/simple;
	bh=GVE30jh0XZ9SIaNosqfb0SU82KC1ikhIULUvla3D1hE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DQn5UfLyOHjZcFOur7env0hwCArEQhxaLvqYOMFwn8H3V7uI3EQkFV8quIp237NYXZ7Cfr8k68UCtgeGE8iJ4hT/GFnzrE9E0kR6KvCkgedJtCdLkVyYX1BPVMOCKyc5WYxedrE7hiKuYYs2vnTuZUSKes1SQIWRN+00we5Wjlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DspYie8S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DspYie8S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82AC91F000E9;
	Thu, 28 May 2026 20:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000535;
	bh=yUKJ8xO7rzFyyRwbxcv2RbGO+IX/OyoYHvmQbcxH2ZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DspYie8Sz7ZE3SsRJnryaFrtEGHCiaEcH77gfuxtSV6XIwTsEOLuM7PeOXI7VzGTL
	 qGY52sGNn/Nn3OoRc2WOsH4GzmRpBgCRwy5HrC9QcE8s1pSbYeINswVfmypPKK61zi
	 jfjfPiK8M3PyZNWzehVE8PAt6cs4Zxw0LrlriVcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 078/272] sched_ext: Avoid UAF in scx_root_enable_workfn() init failure path
Date: Thu, 28 May 2026 21:47:32 +0200
Message-ID: <20260528194631.560372458@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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
[ adapted fix to pre-refactor scx_ops_enable_workfn() with scx_task_iter_relock() instead of upstream scx_root_enable_workfn() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -5406,11 +5406,11 @@ static void scx_ops_enable_workfn(struct
 
 		ret = scx_ops_init_task(p, task_group(p), false);
 		if (ret) {
-			put_task_struct(p);
 			scx_task_iter_relock(&sti);
 			scx_task_iter_stop(&sti);
 			scx_ops_error("ops.init_task() failed (%d) for %s[%d]",
 				      ret, p->comm, p->pid);
+			put_task_struct(p);
 			goto err_disable_unlock_all;
 		}
 


