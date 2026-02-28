Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2BB359A71
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302392; cv=none; b=oZ4ATbLH+GsLXhokinTLarCteG2xcKLhYKuJh60HdbM2sOQ05xrcRiFr3LdaCilmXgl43IwrPSb3sJeZRTD8rgsg7alFxhbUTNQBma5HfU3OJGfCDbLixCIgiYWlp5Ur6YNVufqtBUtjIG2aEBPD02XwvTZVrRQuxpwgU7/GIx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302392; c=relaxed/simple;
	bh=BW4359koPPADY/wV50PnCPM/JDDWYVGT5qZzQELZwkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wy9tm3bX3BGX9lQQ+bLrf1VXqj3LANuqShUUTJVR8TUxPb4x1+4B+hU8nRi2C/iQJII/GU5O2KIaD/kigMyJanP385pdHKIje6bN3DJb2q+Woo6iJWSX/s0jX4Wt3lNGV+v+XZZv1+h/YVU4vBmUB0soX5xRSCMAJVHRN3bd8hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XnyrgCxM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XnyrgCxM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6D75C19425;
	Sat, 28 Feb 2026 18:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302391;
	bh=BW4359koPPADY/wV50PnCPM/JDDWYVGT5qZzQELZwkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XnyrgCxM16/EhFL/4krAPKbegEOusq2FiQJ+AHXWALnrFgViI+Z0j00BtVV8LIiBL
	 sfOeYsOBtRV9FbiCa2it4gbi+jt+t9V510XxVHPOaC8gCW2slSoc2Nbs3uU4fJKZTM
	 0lmsUlu2xEnAEM9GvzpP5bdx5bBuO3ruY/ZoMs0RElpvmeG1ZuSb99hysuWWTShZDx
	 f3rMXKOy4GfJfUt9391Vr7N2+cfVVhToFGlCZ6l7CHf8dRtv7zE6JppIZ9X9720ZKK
	 HlPGnuvprFuG+kfzNooR5KnwoLP8az6zg2Tkq9JjdSSJOc6LJn2WhQ9HVVN+GSgWb7
	 DE5ol5s5mXycA==
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
Subject: [PATCH 6.1 121/232] procfs: fix missing RCU protection when reading real_parent in do_task_stat()
Date: Sat, 28 Feb 2026 13:09:34 -0500
Message-ID: <20260228181127.1592657-121-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index 86fde69ec11a2..a3212f11a1b43 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -521,7 +521,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 		}
 
 		sid = task_session_nr_ns(task, ns);
-		ppid = task_tgid_nr_ns(task->real_parent, ns);
+		ppid = task_ppid_nr_ns(task, ns);
 		pgid = task_pgrp_nr_ns(task, ns);
 
 		unlock_task_sighand(task, &flags);
-- 
2.51.0

