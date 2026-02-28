Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8081638CFFE
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302155; cv=none; b=HOj6woh+o/EeQ3AX54vheJUH0IkotGx4xPNiPxckAWJ/JhvGbcgc7aeziM74Hwivv1LRIyNk0jvEA4DwcnBzDh97Ay/WOs5Kq8zrlXVx2uSgkhY5I1Sy7R0iDmlbq+ry5N7cZBvcDbXHWaSH9WZKFU1VyEh186r5F4xgnAN+pqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302155; c=relaxed/simple;
	bh=BTOMh2ULaSbVY2JWiN9WF6YEsweTA4K2OwlfNGRfwNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SlEZoAFJuyB4GySJCYITEL63HE8R+ahC5Ms8f/XDHWXJLE+Gn9mLNhSjtzW/j15B1hrg7Ar/oJ11/N0IxDsLZ8KxOWz94anxvbleYSMsiGJqU+vvlcIep42xQtpSAWTMuFe00g8SYoY/65YUl6rZ3UP/PblerbsCsEhZY3dtjZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L5qlzOVP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L5qlzOVP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46DCBC19423;
	Sat, 28 Feb 2026 18:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302155;
	bh=BTOMh2ULaSbVY2JWiN9WF6YEsweTA4K2OwlfNGRfwNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L5qlzOVPslxePbR3zfOT34yVvxO2UUEiTl3rbtNLMZ4k1dJCqDo5jGuAkEMxFLKjv
	 G9zP2rOwj07t8gxzK09t1emEIkHu7bFraws9tuM35snGkfjgc5J3swR3BJXtzcWXj+
	 Vog5CoWSEV4lLlX/e0bgitJf4hEKKdZIJymi4cAvQi1ZD5bRNMsKN6pcLYxVCFP9d+
	 xOnPYnRMLsjUzfHjgYOQkoZA7gkoMi8D2cF8QgRpIGlGE3Pu7RYRa0DHOl9/Jd4XQr
	 OrH24/rQvFq4qFhsyHeQDUUrADp3PoaSC0UDSmG2FunCdMn1axcAb/LGQnTMT8UGtM
	 LAdIEQbygREbA==
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
Subject: [PATCH 6.6 150/283] procfs: fix missing RCU protection when reading real_parent in do_task_stat()
Date: Sat, 28 Feb 2026 13:04:52 -0500
Message-ID: <20260228180709.1583486-150-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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

