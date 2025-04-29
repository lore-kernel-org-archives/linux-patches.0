Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE261917E3;
	Tue, 29 Apr 2025 17:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948365; cv=none; b=Y9pgtkfS4f18K2EYn6rcmJUfkvgUr4KNiWQR45mN+Soy+uUdZfXSvLOYpAbNla0lxRZ5GvWNmEzaxWIDlx0j7oytLp42IAHurFCQ21iB2Bk57lPGbWQYqe1PK5DTJG2dgdL9mBeSOkwAcInEaCltoklqybaEzo8pn4mKtWZQfw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948365; c=relaxed/simple;
	bh=kHHKbckXRXWgVDddo/PvA3BW0ERTe+urcNCyW1cz430=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l3D9YXHAs/2aJYInl1iHxAKPSCGzLgjE3rWUMMqvKv4P0YuGn7RBsOIiHeZLtt4GCk9pHUjV2CCIxthVfa9F670MWIDcAHEgCue86gxxY2EEVMdoLsu32zqj/qMq24l509G6x40V2Au6YOHpJ0pXujefp62QYnu6UWaBfOch+Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pu9rDHSa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pu9rDHSa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2DD7C4CEE3;
	Tue, 29 Apr 2025 17:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948365;
	bh=kHHKbckXRXWgVDddo/PvA3BW0ERTe+urcNCyW1cz430=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pu9rDHSa8xHBo15E/0ICTGfIsmZcyYZ4oEqDGG4bFnwuZTjA/DQobD3ehj1Hr5/NP
	 dQNtB/giYkBzHUjs55DjhqqK5UI8XcykPtHH+8hTA/iZ0jV7tg2rW9rpdNX9mctSoF
	 Xiw83OanC5rqHqQiLixOLeK8hdJHdM32Wq+DWcOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Liu <song@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 236/280] netfs: Only create /proc/fs/netfs with CONFIG_PROC_FS
Date: Tue, 29 Apr 2025 18:42:57 +0200
Message-ID: <20250429161124.771664840@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Song Liu <song@kernel.org>

[ Upstream commit 40cb48eba3b4b79e110c1a35d33a48cac54507a2 ]

When testing a special config:

CONFIG_NETFS_SUPPORTS=y
CONFIG_PROC_FS=n

The system crashes with something like:

[    3.766197] ------------[ cut here ]------------
[    3.766484] kernel BUG at mm/mempool.c:560!
[    3.766789] Oops: invalid opcode: 0000 [#1] SMP NOPTI
[    3.767123] CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Tainted: G        W
[    3.767777] Tainted: [W]=WARN
[    3.767968] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
[    3.768523] RIP: 0010:mempool_alloc_slab.cold+0x17/0x19
[    3.768847] Code: 50 fe ff 58 5b 5d 41 5c 41 5d 41 5e 41 5f e9 93 95 13 00
[    3.769977] RSP: 0018:ffffc90000013998 EFLAGS: 00010286
[    3.770315] RAX: 000000000000002f RBX: ffff888100ba8640 RCX: 0000000000000000
[    3.770749] RDX: 0000000000000000 RSI: 0000000000000003 RDI: 00000000ffffffff
[    3.771217] RBP: 0000000000092880 R08: 0000000000000000 R09: ffffc90000013828
[    3.771664] R10: 0000000000000001 R11: 00000000ffffffea R12: 0000000000092cc0
[    3.772117] R13: 0000000000000400 R14: ffff8881004b1620 R15: ffffea0004ef7e40
[    3.772554] FS:  0000000000000000(0000) GS:ffff8881b5f3c000(0000) knlGS:0000000000000000
[    3.773061] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    3.773443] CR2: ffffffff830901b4 CR3: 0000000004296001 CR4: 0000000000770ef0
[    3.773884] PKRU: 55555554
[    3.774058] Call Trace:
[    3.774232]  <TASK>
[    3.774371]  mempool_alloc_noprof+0x6a/0x190
[    3.774649]  ? _printk+0x57/0x80
[    3.774862]  netfs_alloc_request+0x85/0x2ce
[    3.775147]  netfs_readahead+0x28/0x170
[    3.775395]  read_pages+0x6c/0x350
[    3.775623]  ? srso_alias_return_thunk+0x5/0xfbef5
[    3.775928]  page_cache_ra_unbounded+0x1bd/0x2a0
[    3.776247]  filemap_get_pages+0x139/0x970
[    3.776510]  ? srso_alias_return_thunk+0x5/0xfbef5
[    3.776820]  filemap_read+0xf9/0x580
[    3.777054]  ? srso_alias_return_thunk+0x5/0xfbef5
[    3.777368]  ? srso_alias_return_thunk+0x5/0xfbef5
[    3.777674]  ? find_held_lock+0x32/0x90
[    3.777929]  ? netfs_start_io_read+0x19/0x70
[    3.778221]  ? netfs_start_io_read+0x19/0x70
[    3.778489]  ? srso_alias_return_thunk+0x5/0xfbef5
[    3.778800]  ? lock_acquired+0x1e6/0x450
[    3.779054]  ? srso_alias_return_thunk+0x5/0xfbef5
[    3.779379]  netfs_buffered_read_iter+0x57/0x80
[    3.779670]  __kernel_read+0x158/0x2c0
[    3.779927]  bprm_execve+0x300/0x7a0
[    3.780185]  kernel_execve+0x10c/0x140
[    3.780423]  ? __pfx_kernel_init+0x10/0x10
[    3.780690]  kernel_init+0xd5/0x150
[    3.780910]  ret_from_fork+0x2d/0x50
[    3.781156]  ? __pfx_kernel_init+0x10/0x10
[    3.781414]  ret_from_fork_asm+0x1a/0x30
[    3.781677]  </TASK>
[    3.781823] Modules linked in:
[    3.782065] ---[ end trace 0000000000000000 ]---

This is caused by the following error path in netfs_init():

        if (!proc_mkdir("fs/netfs", NULL))
                goto error_proc;

Fix this by adding ifdef in netfs_main(), so that /proc/fs/netfs is only
created with CONFIG_PROC_FS.

Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/20250409170015.2651829-1-song@kernel.org
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/netfs/main.c b/fs/netfs/main.c
index 6c7be1377ee0e..3a8433e802cc2 100644
--- a/fs/netfs/main.c
+++ b/fs/netfs/main.c
@@ -125,11 +125,13 @@ static int __init netfs_init(void)
 	if (mempool_init_slab_pool(&netfs_subrequest_pool, 100, netfs_subrequest_slab) < 0)
 		goto error_subreqpool;
 
+#ifdef CONFIG_PROC_FS
 	if (!proc_mkdir("fs/netfs", NULL))
 		goto error_proc;
 	if (!proc_create_seq("fs/netfs/requests", S_IFREG | 0444, NULL,
 			     &netfs_requests_seq_ops))
 		goto error_procfile;
+#endif
 #ifdef CONFIG_FSCACHE_STATS
 	if (!proc_create_single("fs/netfs/stats", S_IFREG | 0444, NULL,
 				netfs_stats_show))
@@ -142,9 +144,11 @@ static int __init netfs_init(void)
 	return 0;
 
 error_fscache:
+#ifdef CONFIG_PROC_FS
 error_procfile:
 	remove_proc_subtree("fs/netfs", NULL);
 error_proc:
+#endif
 	mempool_exit(&netfs_subrequest_pool);
 error_subreqpool:
 	kmem_cache_destroy(netfs_subrequest_slab);
-- 
2.39.5



