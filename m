Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB5DFBEF;
	Tue, 25 Jun 2024 09:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308132; cv=none; b=EWvqK3nEupstKSfOQp3O7KG54Qa47uNnwmpnp3FvlO0A0mP8qGStFSgMar0D712I6NKG3+lbUiNSrB9Ojh5xIITH9oCw/01AZxU5MZgiAZr57Fin+NTZbrc2zDFZmeEMG5DdG2CTafCf1A882W3wBFZ09cz5aH/+49F8EdjRo1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308132; c=relaxed/simple;
	bh=9/l2FFZFF5/5PebeKPj8GmxB41BswfAL0pZHYbx6W68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ifXKVOZwLaPUuQRz9GhzMhg4C3d0RcpeoATDM5EVpagvdwMRgt3oHtASXu+gmdpdV69s09wZb5VvYOJdTNykN+qFdQtQtSYlY9YwmyDu+i/c0lEb1vqZJM/bN2A8kpi4SAWreKwXgVlrbI6YNyrgjAHblXkilKGtInPl7phuUYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V1T/IL5m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V1T/IL5m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1066DC32781;
	Tue, 25 Jun 2024 09:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308132;
	bh=9/l2FFZFF5/5PebeKPj8GmxB41BswfAL0pZHYbx6W68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V1T/IL5m4dDrIu/6Sn1rnBV6TxRF5MIi24JXsmswABqq9C2OH1ZLMjrcdt6FkntBH
	 AQOH5xdzmbpPUzCTPW784mE4+VOqQCXRGMZGZrlsM2F2vmngRzXXy1aTfafmkDtxZA
	 3oD+iFjEtj7ffBiWN2Ae9SBPEwnnV9MM0mmTWGO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Wen <wenjian1@xiaomi.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 018/250] devlink: use kvzalloc() to allocate devlink instance resources
Date: Tue, 25 Jun 2024 11:29:36 +0200
Message-ID: <20240625085548.750643737@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jian Wen <wenjianhn@gmail.com>

[ Upstream commit 730fffce4fd2eb7a0be2d0b6cd7e55e9194d76d5 ]

During live migration of a virtual machine, the SR-IOV VF need to be
re-registered. It may fail when the memory is badly fragmented.

The related log is as follows.

    kernel: hv_netvsc 6045bdaa-c0d1-6045-bdaa-c0d16045bdaa eth0: VF slot 1 added
...
    kernel: kworker/0:0: page allocation failure: order:7, mode:0x40dc0(GFP_KERNEL|__GFP_COMP|__GFP_ZERO), nodemask=(null),cpuset=/,mems_allowed=0
    kernel: CPU: 0 PID: 24006 Comm: kworker/0:0 Tainted: G            E     5.4...x86_64 #1
    kernel: Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090008  12/07/2018
    kernel: Workqueue: events work_for_cpu_fn
    kernel: Call Trace:
    kernel: dump_stack+0x8b/0xc8
    kernel: warn_alloc+0xff/0x170
    kernel: __alloc_pages_slowpath+0x92c/0xb2b
    kernel: ? get_page_from_freelist+0x1d4/0x1140
    kernel: __alloc_pages_nodemask+0x2f9/0x320
    kernel: alloc_pages_current+0x6a/0xb0
    kernel: kmalloc_order+0x1e/0x70
    kernel: kmalloc_order_trace+0x26/0xb0
    kernel: ? __switch_to_asm+0x34/0x70
    kernel: __kmalloc+0x276/0x280
    kernel: ? _raw_spin_unlock_irqrestore+0x1e/0x40
    kernel: devlink_alloc+0x29/0x110
    kernel: mlx5_devlink_alloc+0x1a/0x20 [mlx5_core]
    kernel: init_one+0x1d/0x650 [mlx5_core]
    kernel: local_pci_probe+0x46/0x90
    kernel: work_for_cpu_fn+0x1a/0x30
    kernel: process_one_work+0x16d/0x390
    kernel: worker_thread+0x1d3/0x3f0
    kernel: kthread+0x105/0x140
    kernel: ? max_active_store+0x80/0x80
    kernel: ? kthread_bind+0x20/0x20
    kernel: ret_from_fork+0x3a/0x50

Signed-off-by: Jian Wen <wenjian1@xiaomi.com>
Link: https://lore.kernel.org/r/20240327082128.942818-1-wenjian1@xiaomi.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/devlink/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/devlink/core.c b/net/devlink/core.c
index 7f0b093208d75..f49cd83f1955f 100644
--- a/net/devlink/core.c
+++ b/net/devlink/core.c
@@ -314,7 +314,7 @@ static void devlink_release(struct work_struct *work)
 	mutex_destroy(&devlink->lock);
 	lockdep_unregister_key(&devlink->lock_key);
 	put_device(devlink->dev);
-	kfree(devlink);
+	kvfree(devlink);
 }
 
 void devlink_put(struct devlink *devlink)
@@ -420,7 +420,7 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
 	if (!devlink_reload_actions_valid(ops))
 		return NULL;
 
-	devlink = kzalloc(sizeof(*devlink) + priv_size, GFP_KERNEL);
+	devlink = kvzalloc(struct_size(devlink, priv, priv_size), GFP_KERNEL);
 	if (!devlink)
 		return NULL;
 
@@ -455,7 +455,7 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
 	return devlink;
 
 err_xa_alloc:
-	kfree(devlink);
+	kvfree(devlink);
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(devlink_alloc_ns);
-- 
2.43.0



