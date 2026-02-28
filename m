Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C110235AC38
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302719; cv=none; b=MFDFe1qQoFjKc9qmcEQuwYdQCZecaHTLxrx1VdUbDOBx1IEW/MsLWx6w0S6pwHxlOq9oFyfOLXzM8x2/GSxquV5fRTY1ndRB/N/Hg9pJZRTI5zQ0zauzlkP/hOSrmeh4hnZarBJOI+tjdQq/eit+PdMu9AW3mZUh3UaVIit48TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302719; c=relaxed/simple;
	bh=bfdrZ4ksZBW7+vOTjVXmFa98EAAonzwptM5b1BwA9Qc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ULQSK+9ZEgYZFKrIqX0dWAmLi35kX0irLx7KAnrejKKmFUjt4wwCVUQV2uMr1Pn4i2zEM+UWvi2b7kjeeYJX6/1rxAWcBcteVm60ARCe9tykOcRmHdHS6BH55pTUaNiF7WzAn5gdbQlpDWiA2dZUX5YNmj0vPgFHJOY+cjG0emM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RrCuQNQD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RrCuQNQD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EA65C116D0;
	Sat, 28 Feb 2026 18:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302719;
	bh=bfdrZ4ksZBW7+vOTjVXmFa98EAAonzwptM5b1BwA9Qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RrCuQNQDLS/eBYCwxJa6rjZ8+JrrF+TAp5m7X0iFmSI3LvbBoclo+e/L94ptCxGH2
	 SrsgLBNXKJsWrmJIxKafDdJ8lpkCMa/yS6aATHdrZAWapFoOfDCEc29Bg/+4jTDz9E
	 VkZp+P6HIaiWEolPn+26t/3GWJ1OO9fkYX1GlSldXfgIoDVeUyczM0GtyvSSw3nAyt
	 aTgRGtbNRatN8hLzgoqPdwHdEatJXkzFpY36QwbJcEUfSFL0plDOV9XoxvQK624txk
	 vc/6C8Wg9+A8Y+5Z0sGBVe+XfbNEVIo2DqCJNNwZmP/K3t18jXWwGFySieMvEYc+tV
	 7Bs1o9PW8QTeQ==
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
Subject: [PATCH 5.10 079/147] procfs: fix missing RCU protection when reading real_parent in do_task_stat()
Date: Sat, 28 Feb 2026 13:16:27 -0500
Message-ID: <20260228181736.1605592-79-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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
index 77b94c04e4aff..e97ad2bd7a9dc 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -492,7 +492,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 		rsslim = READ_ONCE(sig->rlim[RLIMIT_RSS].rlim_cur);
 
 		sid = task_session_nr_ns(task, ns);
-		ppid = task_tgid_nr_ns(task->real_parent, ns);
+		ppid = task_ppid_nr_ns(task, ns);
 		pgid = task_pgrp_nr_ns(task, ns);
 
 		unlock_task_sighand(task, &flags);
-- 
2.51.0

