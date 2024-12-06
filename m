Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02CC5148832;
	Fri,  6 Dec 2024 15:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497864; cv=none; b=PXMgLozpM2aHZqSpcAZ6TFaRaWm8fqUU+3sUsTUs1RuOtEVgyIVZK5tM6PmDP8/OqpolNfW2I92gx+OQhygF/UtrUkCFUZqUDeJteSwtUa4eVHeHZfakdx0YN/U7jguA2blHHlqLcx3pYosR70zMIf3EIK/p0A2Qm7Ef42ryzwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497864; c=relaxed/simple;
	bh=wPXOlgRjkqGHgYhjRQq1s5PX5oBdkAPZkjtgS6cZzMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GjNdT1yx3kusbn704kxw3BQrA/9Dosuq9QhlaFPiqQPDrEjqhc3yihH1y3mIPYKNm/qk+QLwzoZmjocsT3OQp0T2GIQO66ygvs2e4ulprGV7H03Kic+PyczLFA9Z40b45Sl3eezJld5Aa1oRj3bMwdDyuHgKcUUaQesZFF0Qaz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AuLzaQ2x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AuLzaQ2x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A903C4CEDF;
	Fri,  6 Dec 2024 15:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497863;
	bh=wPXOlgRjkqGHgYhjRQq1s5PX5oBdkAPZkjtgS6cZzMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AuLzaQ2xU4cd94KU43RkPdfi5NPo9ifIG3M+23BmXxr6PVt5vKEqFqshsqr5O4s8p
	 9bJsIhdzHaUddTqAJyZ11u4jgxv0kYsdrjB2r2tVRsy4X/35twK3ViBX9hnAqNpe2K
	 ZTntyZcxSY9L/qw5+/bMUxfzvxF8dOhb19Ush81w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 384/676] svcrdma: fix miss destroy percpu_counter in svc_rdma_proc_init()
Date: Fri,  6 Dec 2024 15:33:23 +0100
Message-ID: <20241206143708.344873726@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f0d5eeed4c886..e1d4e426b21fa 100644
--- a/net/sunrpc/xprtrdma/svc_rdma.c
+++ b/net/sunrpc/xprtrdma/svc_rdma.c
@@ -234,25 +234,34 @@ static int svc_rdma_proc_init(void)
 
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



