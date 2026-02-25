Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D147418B0A;
	Wed, 25 Feb 2026 01:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983291; cv=none; b=FGO73mYtF7Md9WWiz+VfaZtIMrdE0KKKFK4F0I0tj7uOC1/TycZ2Z6l8ZOmR54tFVXu/OYztk+2D78G9BEflrK+tdHzon9ximODyhpcgAdRJVdaj0D3X7gfS7ET7kpDOtzwJWrhu7S4V+ORnBtqOovbvLMd9PKPR1e3JAJqVRDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983291; c=relaxed/simple;
	bh=wX1gJyuvCeAoyLndfD1dVl6zCIVhRmYkfRiquUQiDSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WgDx2Z8Zw/YjxCyMwt/OiXPTTfiZZJbg/fa/wy+JtTf6pC0vl6NbAYi1UIWupxzNv2/clf8oG8nmIZTorLsmEBaYICAJbBIzdkPI3/Q+gwVS2m7CNOWDPIO9K+l/MfwRTOGmcKWoSDm61pyvDcw/uUe6w7oizoF4wCefhPqFwZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xmTNaakF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xmTNaakF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91BB1C116D0;
	Wed, 25 Feb 2026 01:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983291;
	bh=wX1gJyuvCeAoyLndfD1dVl6zCIVhRmYkfRiquUQiDSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xmTNaakFVCxXQ0vn0hyrjweR9/1ufHbecqzR+TQKZB1KPlxCbW7471hkZ8t6TIuN/
	 GLQJFjtyNTUx5x41yjwGzpBVQklhtHjZL49IFWJFVeR03zkOeWEtjMIP+O9DyEYnm2
	 dyPV1nVpPgriN3IW5QWkq+75P1ptKDPvCjRg5Z8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinliang Zheng <alexjlzheng@tencent.com>,
	Oleg Nesterov <oleg@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mateusz Guzik <mjguzik@gmail.com>,
	ruippan <ruippan@tencent.com>,
	Usama Arif <usamaarif642@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 426/781] procfs: fix missing RCU protection when reading real_parent in do_task_stat()
Date: Tue, 24 Feb 2026 17:18:55 -0800
Message-ID: <20260225012410.150279829@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 42932f88141a9..5571177e0435d 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -528,7 +528,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 		}
 
 		sid = task_session_nr_ns(task, ns);
-		ppid = task_tgid_nr_ns(task->real_parent, ns);
+		ppid = task_ppid_nr_ns(task, ns);
 		pgid = task_pgrp_nr_ns(task, ns);
 
 		unlock_task_sighand(task, &flags);
-- 
2.51.0



