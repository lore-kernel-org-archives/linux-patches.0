Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B840F343880;
	Wed, 20 May 2026 18:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301904; cv=none; b=hjfm1ATIVa6t0WOOffwjQX1j97llOoKTUwZV3GO++PC4JEihTtvulNItfntPv7i7Ki/qpCBtxRPkstSl9GKEAXohBXs2jonQGuVQot82Omor5FuB4FYVmghRc4Y6ENRpYPKBxUdSWnezXVJCe92PvkS6BDetnCT8szxI22nfRJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301904; c=relaxed/simple;
	bh=MvcWL1jUkbziRQEo5bF48MwLumY9x3fhESAMUDhq75Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y6ycHunxUA9pHbtS6Y7UvxLjtvRh8UyoMkOv46i6XFLra+vKyihsgDY2yz50vYWq3LwI4hgJzkZO66DHex5ckSdgtgfPe2cMtuAzPtwDcA3iwVp5eangoT8VaWDT5mxpzBR2C57rC6+aUKzRQ5BUbYzf9eXEjUu183dp45z7wUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dA88uSHL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dA88uSHL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2863B1F000E9;
	Wed, 20 May 2026 18:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301903;
	bh=op6UmuCrMwf4ZKeVdvWx1yeN+eBI0f93xpB7c0A03WE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dA88uSHLIgBHmTtf7OcZk3TtUBI2iVfMnJ4WJGiniQovbDXtRkLBHxnfDBzW9RFw4
	 zhNveJ8GIVXwMPmwmC1ZzigeqmAX7TBqU9q/L2h8n0+Qz+AR/y9YZGJKIlh+HVqWnt
	 MUBPbFwW9OOIJsERFgxHDIxBz4ngOB9B8R789UMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sun Jian <sun.jian.kdev@gmail.com>,
	Sechang Lim <rhkrqnwk98@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 063/508] bpf: Fix RCU stall in bpf_fd_array_map_clear()
Date: Wed, 20 May 2026 18:18:06 +0200
Message-ID: <20260520162059.966319637@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sechang Lim <rhkrqnwk98@gmail.com>

[ Upstream commit 4406942e65ca128c56c67443832988873c21d2e9 ]

Add a missing cond_resched() in bpf_fd_array_map_clear() loop.

For PROG_ARRAY maps with many entries this loop calls
prog_array_map_poke_run() per entry which can be expensive, and
without yielding this can cause RCU stalls under load:

  rcu: Stack dump where RCU GP kthread last ran:
  CPU: 0 UID: 0 PID: 30932 Comm: kworker/0:2 Not tainted 6.14.0-13195-g967e8def1100 #2 PREEMPT(undef)
  Workqueue: events prog_array_map_clear_deferred
  RIP: 0010:write_comp_data+0x38/0x90 kernel/kcov.c:246
  Call Trace:
   <TASK>
   prog_array_map_poke_run+0x77/0x380 kernel/bpf/arraymap.c:1096
   __fd_array_map_delete_elem+0x197/0x310 kernel/bpf/arraymap.c:925
   bpf_fd_array_map_clear kernel/bpf/arraymap.c:1000 [inline]
   prog_array_map_clear_deferred+0x119/0x1b0 kernel/bpf/arraymap.c:1141
   process_one_work+0x898/0x19d0 kernel/workqueue.c:3238
   process_scheduled_works kernel/workqueue.c:3319 [inline]
   worker_thread+0x770/0x10b0 kernel/workqueue.c:3400
   kthread+0x465/0x880 kernel/kthread.c:464
   ret_from_fork+0x4d/0x80 arch/x86/kernel/process.c:153
   ret_from_fork_asm+0x19/0x30 arch/x86/entry/entry_64.S:245
   </TASK>

Reviewed-by: Sun Jian <sun.jian.kdev@gmail.com>
Fixes: da765a2f5993 ("bpf: Add poke dependency tracking for prog array maps")
Signed-off-by: Sechang Lim <rhkrqnwk98@gmail.com>
Link: https://lore.kernel.org/r/20260407103823.3942156-1-rhkrqnwk98@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/arraymap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 1811efcfbd6e3..ec5c489ed3131 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -938,8 +938,10 @@ static void bpf_fd_array_map_clear(struct bpf_map *map, bool need_defer)
 	struct bpf_array *array = container_of(map, struct bpf_array, map);
 	int i;
 
-	for (i = 0; i < array->map.max_entries; i++)
+	for (i = 0; i < array->map.max_entries; i++) {
 		__fd_array_map_delete_elem(map, &i, need_defer);
+		cond_resched();
+	}
 }
 
 static void prog_array_map_seq_show_elem(struct bpf_map *map, void *key,
-- 
2.53.0



