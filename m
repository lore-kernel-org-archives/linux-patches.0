Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9C22C0F97;
	Wed, 25 Feb 2026 06:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002587; cv=none; b=OLdr6rz+Au+IaA8jL+bdqGL6fI3Mr41/HQ/OZ/OwMzSD5U5xsHHTVD3hU3zPHFui25smOemftuaVfjNI84cwJHgFpsBAeIxv4cfD3r4q36y7xRBtxUs0AfUWMjBgC/WAfLLr2YtKQUsi4TsuxUooO5xT1NPxKgKxHEpapRMpYEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002587; c=relaxed/simple;
	bh=Nof224jaw1S8dxPoH/9AIp/MoIv5D48FJF+tPwUhdfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=efWRTx104XMIy7CPdlxU/mwruxdyLR+emK7WMmdnhSjkqim5Cv11YMey3KgFYEP2csHMDkmKIO4tnP4A2o/Jkyhuhe/fSxNiAxYMUgFHmMRlT6ru9uJKU9b4pjVy/zcUJSph0voIDkxU+OXofIC7xwixAnZw8AVoOcPp2/Mg908=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S0SbH50b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S0SbH50b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F31B5C116D0;
	Wed, 25 Feb 2026 06:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002587;
	bh=Nof224jaw1S8dxPoH/9AIp/MoIv5D48FJF+tPwUhdfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S0SbH50bOkPe5UA4CvQ6MGlCXoV7lHHh+p3cY6EamMOUL6soV7wvzPz6XXKtH9swQ
	 Te1hm8Jzr97V2u9gXb7jVpluMul0KdmAlAYebUbTefg1/TO3yNXappxykaf6XDcehN
	 bSXuiXSuhvyiDBhbzv9kwZnxIiGnNu9z4btNpgIM=
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
Subject: [PATCH 6.18 324/641] procfs: fix missing RCU protection when reading real_parent in do_task_stat()
Date: Tue, 24 Feb 2026 17:20:50 -0800
Message-ID: <20260225012356.553191674@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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
index 2ae63189091e0..038d4b57127fe 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -529,7 +529,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 		}
 
 		sid = task_session_nr_ns(task, ns);
-		ppid = task_tgid_nr_ns(task->real_parent, ns);
+		ppid = task_ppid_nr_ns(task, ns);
 		pgid = task_pgrp_nr_ns(task, ns);
 
 		unlock_task_sighand(task, &flags);
-- 
2.51.0



