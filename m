Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B7F2DF6E6;
	Thu, 28 May 2026 20:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999451; cv=none; b=GV2UX7uPZH3GHEE02Aaz/UeR5AtcyCRo298+7vG+kZm2GByKVMhPXrtbqYi1R+9ALkL+/JfzP4FMHtFb23SQXhtaRW+rgPWLr07Rser6FIkWYxlubiy/1XSm8TRS4a9eJ0NA/4kWseBD2SEJBe8/Egh+o2vsvrwSne8LVT5e2eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999451; c=relaxed/simple;
	bh=GTvXziHn7GWFnrRS9IIKCMZyep2WBaLrtxNyCnd3/ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KCipc/SmJ3X4SX09yfXCLdTKKoxpoJvqT2H/Rpp4iUHiRQ/oOijOBarB7Pa/iXREBYoS56Jhs9XN0I8eJc5eLpzO5RwtbO5REHpZ1LGmaCgkj7W6/reKVVkS70fvIJ4I6rjuvawumz0R0qe7yFsKGW2cwt4WZZ1VCihJL8AnckM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eJfaGy2k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eJfaGy2k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E061F000E9;
	Thu, 28 May 2026 20:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999449;
	bh=QpN0EazruR0hf7+/TtUBGwZBopMmWYb9iAjdMpYIa/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eJfaGy2kAvelA4JdP/p4BRPenUv/+U86GwejDp40QFUzNGNOw8yUe7QrOUYXrPaNe
	 VgCrHHOOUpeN0xGVZh0lZV1jSnwWtLFxxTTLzeu4vlTYQ8xkoXqDLmJrYn2ZoDHFKV
	 1f5+Mh7GK9LfLDAenuAA8gm3oMl6DlHRdFDBkPFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 070/377] sched_ext: Avoid UAF in scx_root_enable_workfn() init failure path
Date: Thu, 28 May 2026 21:45:08 +0200
Message-ID: <20260528194640.390215261@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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
@@ -4812,10 +4812,10 @@ static void scx_enable_workfn(struct kth
 
 		ret = scx_init_task(p, task_group(p), false);
 		if (ret) {
-			put_task_struct(p);
 			scx_task_iter_stop(&sti);
 			scx_error(sch, "ops.init_task() failed (%d) for %s[%d]",
 				  ret, p->comm, p->pid);
+			put_task_struct(p);
 			goto err_disable_unlock_all;
 		}
 


