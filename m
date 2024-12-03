Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1AD14A088;
	Tue,  3 Dec 2024 16:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241823; cv=none; b=Q+hLbSs9GK9qu4V1dv9vOeOX3zxkE/z2Uz1fzrlppQ8lYzVbo9/YM2FdwCrKVkum85f44/3Yyl+dYAZgseR7c+xVSs6dEIbVppfnoH27hPnFbhwij/Ue6cihxy6jwYUFdVHEpzWb/MqrO/p5BUiN4e8h/wqLa8bpv+hQekpZW8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241823; c=relaxed/simple;
	bh=Hg3kOUmmsXrH/AAcgVCgYN3GJWzmxBLa9J4bxitWVEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=REOvck6QQ9TyM/J1DYU6yNg+whErwXAwLZi0f3eq81UNsTaLXEWqxUk9S781k2V1OHmHGBpvQA3+AOpoX0+u9utjjgsjz7RR7pHC8mS+NDGMQvrF5hFD+IUS81a60mXKKuvetA2gGIUAYgLGWuWNL0RhzhpSF5N1x+opBBaphik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cCU5GZnJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cCU5GZnJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C21C3C4CECF;
	Tue,  3 Dec 2024 16:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241823;
	bh=Hg3kOUmmsXrH/AAcgVCgYN3GJWzmxBLa9J4bxitWVEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cCU5GZnJ66ThLldByKbygSHnYxUGglEF3UOlYARoFT8i/WsVvsNrEtD5hq5XelL9Y
	 S7lmF1HtihDdunhMl66n0+51bX8mcXeadFlYhKIWL9J853Sca5KfKCYES1ErG0ly8Z
	 xByF4EbV19mZPkr+bVY76rB87/NVJK0qf2Fk6QzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 528/826] svcrdma: fix miss destroy percpu_counter in svc_rdma_proc_init()
Date: Tue,  3 Dec 2024 15:44:15 +0100
Message-ID: <20241203144804.353452205@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Ye Bin <yebin10@huawei.com>

[ Upstream commit ce89e742a4c12b20f09a43fec1b21db33f2166cd ]

There's issue as follows:
RPC: Registered rdma transport module.
RPC: Registered rdma backchannel transport module.
RPC: Unregistered rdma transport module.
RPC: Unregistered rdma backchannel transport module.
BUG: unable to handle page fault for address: fffffbfff80c609a
PGD 123fee067 P4D 123fee067 PUD 123fea067 PMD 10c624067 PTE 0
Oops: Oops: 0000 [#1] PREEMPT SMP KASAN NOPTI
RIP: 0010:percpu_counter_destroy_many+0xf7/0x2a0
Call Trace:
 <TASK>
 __die+0x1f/0x70
 page_fault_oops+0x2cd/0x860
 spurious_kernel_fault+0x36/0x450
 do_kern_addr_fault+0xca/0x100
 exc_page_fault+0x128/0x150
 asm_exc_page_fault+0x26/0x30
 percpu_counter_destroy_many+0xf7/0x2a0
 mmdrop+0x209/0x350
 finish_task_switch.isra.0+0x481/0x840
 schedule_tail+0xe/0xd0
 ret_from_fork+0x23/0x80
 ret_from_fork_asm+0x1a/0x30
 </TASK>

If register_sysctl() return NULL, then svc_rdma_proc_cleanup() will not
destroy the percpu counters which init in svc_rdma_proc_init().
If CONFIG_HOTPLUG_CPU is enabled, residual nodes may be in the
'percpu_counters' list. The above issue may occur once the module is
removed. If the CONFIG_HOTPLUG_CPU configuration is not enabled, memory
leakage occurs.
To solve above issue just destroy all percpu counters when
register_sysctl() return NULL.

Fixes: 1e7e55731628 ("svcrdma: Restore read and write stats")
Fixes: 22df5a22462e ("svcrdma: Convert rdma_stat_sq_starve to a per-CPU counter")
Fixes: df971cd853c0 ("svcrdma: Convert rdma_stat_recv to a per-CPU counter")
Signed-off-by: Ye Bin <yebin10@huawei.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/svc_rdma.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma.c b/net/sunrpc/xprtrdma/svc_rdma.c
index 58ae6ec4f25b4..415c0310101f0 100644
--- a/net/sunrpc/xprtrdma/svc_rdma.c
+++ b/net/sunrpc/xprtrdma/svc_rdma.c
@@ -233,25 +233,34 @@ static int svc_rdma_proc_init(void)
 
 	rc = percpu_counter_init(&svcrdma_stat_read, 0, GFP_KERNEL);
 	if (rc)
-		goto out_err;
+		goto err;
 	rc = percpu_counter_init(&svcrdma_stat_recv, 0, GFP_KERNEL);
 	if (rc)
-		goto out_err;
+		goto err_read;
 	rc = percpu_counter_init(&svcrdma_stat_sq_starve, 0, GFP_KERNEL);
 	if (rc)
-		goto out_err;
+		goto err_recv;
 	rc = percpu_counter_init(&svcrdma_stat_write, 0, GFP_KERNEL);
 	if (rc)
-		goto out_err;
+		goto err_sq;
 
 	svcrdma_table_header = register_sysctl("sunrpc/svc_rdma",
 					       svcrdma_parm_table);
+	if (!svcrdma_table_header)
+		goto err_write;
+
 	return 0;
 
-out_err:
+err_write:
+	rc = -ENOMEM;
+	percpu_counter_destroy(&svcrdma_stat_write);
+err_sq:
 	percpu_counter_destroy(&svcrdma_stat_sq_starve);
+err_recv:
 	percpu_counter_destroy(&svcrdma_stat_recv);
+err_read:
 	percpu_counter_destroy(&svcrdma_stat_read);
+err:
 	return rc;
 }
 
-- 
2.43.0



