Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B551547D8;
	Wed,  5 Feb 2025 15:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768422; cv=none; b=L8KYP9N3MxAbSmwWCl2RuwWHmwG21wXcvp2Zl7LkiHzTPes0WQZDi+FemQpdhcXf76zuSzfOyrh98xHGxjV/QbJipEvOq6803aY1hB1ve0n4MMZpL+qBEKHqyUQXAJuixKlwAp3QsbF1uy+Y4xN9/fEsfNzLIdGcgBV5bQLZEJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768422; c=relaxed/simple;
	bh=IEtOEYWckngbhHMNZUKs0EW7ui6BRe8SwQ+pLJpDIyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R2pB9CaPiX4OMlPAZLK8q6Yj/+K/9dVGeSIp8ajC6RhYa9ccpZ3yJcpqv70XfRP3iEVfw6lUYPz+mC5YfRCWIGSkOLLBgv4ezeAIFva5hPx/5PhOOXJ7UMZJKfwEUODiDg2ihz6T5WB8cpIENx/8mU1a/cg2ix5fMo8HxPDzvGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R3a9KeVV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R3a9KeVV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6876CC4CED1;
	Wed,  5 Feb 2025 15:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768421;
	bh=IEtOEYWckngbhHMNZUKs0EW7ui6BRe8SwQ+pLJpDIyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R3a9KeVVILcHvGMQ/ToiqKroXlXJ4zk1c9PDKO4k3UvuMDU1X9eUWkcidODRO88xr
	 RTjZd3TFxI8aD656im57KsGksj1MuldgH0/TgefUa6upUBYee3KdI/SOK928YiZnqN
	 NwF4+u38kfvgz2FQWSIG3PU3mm5CwPfCE3OgerUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Fomichev <sdf@fomichev.me>,
	Joe Damato <jdamato@fastly.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 524/623] net/mlx5e: add missing cpu_to_node to kvzalloc_node in mlx5e_open_xdpredirect_sq
Date: Wed,  5 Feb 2025 14:44:26 +0100
Message-ID: <20250205134516.272545916@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Fomichev <sdf@fomichev.me>

[ Upstream commit 979284535aaf12a287a2f43d9d5dfcbdc1dc4cac ]

kvzalloc_node is not doing a runtime check on the node argument
(__alloc_pages_node_noprof does have a VM_BUG_ON, but it expands to
nothing on !CONFIG_DEBUG_VM builds), so doing any ethtool/netlink
operation that calls mlx5e_open on a CPU that's larger that MAX_NUMNODES
triggers OOB access and panic (see the trace below).

Add missing cpu_to_node call to convert cpu id to node id.

[  165.427394] mlx5_core 0000:5c:00.0 beth1: Link up
[  166.479327] BUG: unable to handle page fault for address: 0000000800000010
[  166.494592] #PF: supervisor read access in kernel mode
[  166.505995] #PF: error_code(0x0000) - not-present page
...
[  166.816958] Call Trace:
[  166.822380]  <TASK>
[  166.827034]  ? __die_body+0x64/0xb0
[  166.834774]  ? page_fault_oops+0x2cd/0x3f0
[  166.843862]  ? exc_page_fault+0x63/0x130
[  166.852564]  ? asm_exc_page_fault+0x22/0x30
[  166.861843]  ? __kvmalloc_node_noprof+0x43/0xd0
[  166.871897]  ? get_partial_node+0x1c/0x320
[  166.880983]  ? deactivate_slab+0x269/0x2b0
[  166.890069]  ___slab_alloc+0x521/0xa90
[  166.898389]  ? __kvmalloc_node_noprof+0x43/0xd0
[  166.908442]  __kmalloc_node_noprof+0x216/0x3f0
[  166.918302]  ? __kvmalloc_node_noprof+0x43/0xd0
[  166.928354]  __kvmalloc_node_noprof+0x43/0xd0
[  166.938021]  mlx5e_open_channels+0x5e2/0xc00
[  166.947496]  mlx5e_open_locked+0x3e/0xf0
[  166.956201]  mlx5e_open+0x23/0x50
[  166.963551]  __dev_open+0x114/0x1c0
[  166.971292]  __dev_change_flags+0xa2/0x1b0
[  166.980378]  dev_change_flags+0x21/0x60
[  166.988887]  do_setlink+0x38d/0xf20
[  166.996628]  ? ep_poll_callback+0x1b9/0x240
[  167.005910]  ? __nla_validate_parse.llvm.10713395753544950386+0x80/0xd70
[  167.020782]  ? __wake_up_sync_key+0x52/0x80
[  167.030066]  ? __mutex_lock+0xff/0x550
[  167.038382]  ? security_capable+0x50/0x90
[  167.047279]  rtnl_setlink+0x1c9/0x210
[  167.055403]  ? ep_poll_callback+0x1b9/0x240
[  167.064684]  ? security_capable+0x50/0x90
[  167.073579]  rtnetlink_rcv_msg+0x2f9/0x310
[  167.082667]  ? rtnetlink_bind+0x30/0x30
[  167.091173]  netlink_rcv_skb+0xb1/0xe0
[  167.099492]  netlink_unicast+0x20f/0x2e0
[  167.108191]  netlink_sendmsg+0x389/0x420
[  167.116896]  __sys_sendto+0x158/0x1c0
[  167.125024]  __x64_sys_sendto+0x22/0x30
[  167.133534]  do_syscall_64+0x63/0x130
[  167.141657]  ? __irq_exit_rcu.llvm.17843942359718260576+0x52/0xd0
[  167.155181]  entry_SYSCALL_64_after_hwframe+0x4b/0x53

Fixes: bb135e40129d ("net/mlx5e: move XDP_REDIRECT sq to dynamic allocation")
Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
Reviewed-by: Joe Damato <jdamato@fastly.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20250123000407.3464715-1-sdf@fomichev.me
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 0ec17c276bdd2..cb93f46eaa7c3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2087,7 +2087,7 @@ static struct mlx5e_xdpsq *mlx5e_open_xdpredirect_sq(struct mlx5e_channel *c,
 	struct mlx5e_xdpsq *xdpsq;
 	int err;
 
-	xdpsq = kvzalloc_node(sizeof(*xdpsq), GFP_KERNEL, c->cpu);
+	xdpsq = kvzalloc_node(sizeof(*xdpsq), GFP_KERNEL, cpu_to_node(c->cpu));
 	if (!xdpsq)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.39.5



