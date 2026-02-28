Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1CD439B946
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302578; cv=none; b=dKArFvR23KUGLhf8O2iMZGSMPOylfWgzDJSGQn1XaOmWx+Se1tjy/PpHxQBtZWGipipHHro9zlqjQ2nx5bGeXbDfaxEnWwCldS5cOPPEhJfkxlQqVNMVQmJFttvpn9a50cRXgawmwYmspz7Vu5NyugD8U+zCHQij58r6PYBN+AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302578; c=relaxed/simple;
	bh=yDvifsN7wAWrjkIo4s1cEOf9dhIFtifUSK2nXgGOghU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qTwiTNs4N7rrSOzcLbvg1vjjG1+P/pqzpElKK1LTgYehIyeqGmX3xRTUyfsXd3alf+QXzFNL0i+l4NP76j7ptdpMvxI3ZNAvyQxiYRhLDn+OBoftXSjy+zT1GQlf3x+kwSZkwjZ+bLeW6DRTOZujFAEl3BSvQbCT9X9FuvOAL50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NBg244nB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NBg244nB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72799C19425;
	Sat, 28 Feb 2026 18:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302578;
	bh=yDvifsN7wAWrjkIo4s1cEOf9dhIFtifUSK2nXgGOghU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NBg244nBFvk6ZdGTJ0T96uav3aDW+LsqAV/s3NRGQEUg1WSWC8hI8AO1+mZjpa0EX
	 8K6SdZZZrCdu4ceZ0lsd0pmhhEZuMD/mdm8nkJK9qTj2KTjxQEzmT4V2uVSrVGdEbi
	 56c8a5htvT5E97fMzyk4JGleOfVSp5sXBVYOUqM5BDzuJHm0Lyq1TLQbUDqpKxaFuk
	 l8S9Q/lHRSiBGL0r7w5jZBDk5KYUmGcqe0hbRetP2/3GAnyNHNOwr1Ki24GG2RzBJL
	 KYravzifqqv7eZXmSeqoMfqj0pMwY936ofXMICIetvYXCdeKFvi+RX9tGyZ8YGFAhJ
	 IqNxua/a9lwaA==
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
Subject: [PATCH 5.15 086/164] procfs: fix missing RCU protection when reading real_parent in do_task_stat()
Date: Sat, 28 Feb 2026 13:13:45 -0500
Message-ID: <20260228181505.1600663-86-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index 2ff568dc58387..6f30b5a316678 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -510,7 +510,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 		rsslim = READ_ONCE(sig->rlim[RLIMIT_RSS].rlim_cur);
 
 		sid = task_session_nr_ns(task, ns);
-		ppid = task_tgid_nr_ns(task->real_parent, ns);
+		ppid = task_ppid_nr_ns(task, ns);
 		pgid = task_pgrp_nr_ns(task, ns);
 
 		unlock_task_sighand(task, &flags);
-- 
2.51.0

