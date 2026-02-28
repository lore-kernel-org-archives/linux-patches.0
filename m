Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E47F7342538
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301818; cv=none; b=n8gv+SVdLB2AsnmgbKUbdrm0fuDoHdawc3O9aG1Depj8h3KsUnfLyBG4nRrzjdomWnxPkweLutaKVW/5zRapadXnv7xWllqNND/NcVRqJ5THU0ybI5ql/beFDiPrUVli22b5XdFdW82nIysGIvMDakC3z74XAZtKAfpa+ot9JZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301818; c=relaxed/simple;
	bh=BTOMh2ULaSbVY2JWiN9WF6YEsweTA4K2OwlfNGRfwNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M+rztwIxOKRpWBgXkWITO+CWsN9QlAjHGa3STM4FiUr3kNIx9/Id2nf+5ZfequwmC1wyqltTdE33UGG0Ut4BnFDVYYgA2/Z7fUAUTjAwrhEyt0QEgvO5IcgtnQpT5901w+T/Te/mgJORPFYRQMTHFroe/Uc1oDfZMgMCYu2IM7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n01rNsLo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n01rNsLo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3FCAC19425;
	Sat, 28 Feb 2026 18:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301817;
	bh=BTOMh2ULaSbVY2JWiN9WF6YEsweTA4K2OwlfNGRfwNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n01rNsLoxe5D75mPIiIEdacUXZygJVztK95p3TYjgFYn2bmuYBsE7bLFmTHhNm9RO
	 irGUzDXt6+uK+liurSVlHrcpshKGL6QybHizOdcnIl+wsi1mopR+kgsj+tSXnU7s6H
	 tTaYkUaSr4nCvZ8Uol6eN3qq5sl3zpa5e7QNYRuIvgBWpuxc6zVZWcbypiQBLzxbKr
	 EWiVifW+6wn6G/aC1rl/EwMQ+mOjZa/MrojtZYrv/7FZWKOqoyeCkTBtAUVG/88Mh9
	 MyAQRHVKUzdK6lhShBloN/e9zh4RYkZ70OJHeN26CdcWNT2QoPcJYkghVlGs+7SzPZ
	 Mxlrq08dO8miw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jinliang Zheng <alexjlzheng@tencent.com>,
	Oleg Nesterov <oleg@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mateusz Guzik <mjguzik@gmail.com>,
	ruippan <ruippan@tencent.com>,
	Usama Arif <usamaarif642@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 232/385] procfs: fix missing RCU protection when reading real_parent in do_task_stat()
Date: Sat, 28 Feb 2026 12:57:34 -0500
Message-ID: <20260228180011.1568201-232-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jinliang Zheng <alexjlzheng@tencent.com>

[ Upstream commit 76149d53502cf17ef3ae454ff384551236fba867 ]

When reading /proc/[pid]/stat, do_task_stat() accesses task->real_parent
without proper RCU protection, which leads to:

  cpu 0                               cpu 1
  -----                               -----
  do_task_stat
    var = task->real_parent
                                      release_task
                                        call_rcu(delayed_put_task_struct)
    task_tgid_nr_ns(var)
      rcu_read_lock   <--- Too late to protect task->real_parent!
      task_pid_ptr    <--- UAF!
      rcu_read_unlock

This patch uses task_ppid_nr_ns() instead of task_tgid_nr_ns() to add
proper RCU protection for accessing task->real_parent.

Link: https://lkml.kernel.org/r/20260128083007.3173016-1-alexjlzheng@tencent.com
Fixes: 06fffb1267c9 ("do_task_stat: don't take rcu_read_lock()")
Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: ruippan <ruippan@tencent.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/array.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 5e4f7b411fbdb..363d9331216b9 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -531,7 +531,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 		}
 
 		sid = task_session_nr_ns(task, ns);
-		ppid = task_tgid_nr_ns(task->real_parent, ns);
+		ppid = task_ppid_nr_ns(task, ns);
 		pgid = task_pgrp_nr_ns(task, ns);
 
 		unlock_task_sighand(task, &flags);
-- 
2.51.0

