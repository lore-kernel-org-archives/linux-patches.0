Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D3101D096F;
	Wed,  2 Oct 2024 14:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879009; cv=none; b=ZKqlSmp1fOxCB0Xel0WEu4q/yUd9lMCm3bfJxokosngEcKKkAI4Daoi/F4tyl15MIwOfPsmxPe3Oo4HvWiJVy8X7NO+g00FNgDunVqSFvHVpXmx13CKiSm9Dw7/bdUV8UaeW1YYo/Vyc/WSVQmLRwf7KYE38B3QQclBxfdGfhaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879009; c=relaxed/simple;
	bh=QsD05c/kY0XfHpOA4kaKT2NOnbFWmJsYmJHuxz3tRbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uk92pv4vmVqNLQwnPTh8clgl+FeeCkYiYDNJr1+k0I3IC09OR+T8jghpRFFT0pbMkysGjZcjNXFxxI6AxI7GpDVgTOMrLrerZoGJapKL81XVaJ16i27yT8xkyssLW8O6IjhHEEH8n+gf/csyjXFkXeucHKIMkqFEmI5fIy1apo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iWG/Ob4p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iWG/Ob4p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D1FC4CEC2;
	Wed,  2 Oct 2024 14:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879009;
	bh=QsD05c/kY0XfHpOA4kaKT2NOnbFWmJsYmJHuxz3tRbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iWG/Ob4pPKzlwsEAxbPdOHnZQMO6tLHuxGXU8k2nNOSs3U1OXH+SSDNI8Hb0Oj8t0
	 0D2iQsKZr1j//oRfOrJrBzjv37IMVzvJXDCrYVU/hsKbsiNC5b91ZsKZGYVg0BP78y
	 90CxaTyXe7XsjLfJG8jbWAS+8NAKWfqLeegr9JgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Baokun Li <libaokun1@huawei.com>,
	David Howells <dhowells@redhat.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.10 576/634] netfs: Delete subtree of fs/netfs when netfs module exits
Date: Wed,  2 Oct 2024 15:01:16 +0200
Message-ID: <20241002125833.850186790@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

commit 3c58a9575e02c2b90a3180007d57105ceaa7c246 upstream.

In netfs_init() or fscache_proc_init(), we create dentry under 'fs/netfs',
but in netfs_exit(), we only delete the proc entry of 'fs/netfs' without
deleting its subtree. This triggers the following WARNING:

==================================================================
remove_proc_entry: removing non-empty directory 'fs/netfs', leaking at least 'requests'
WARNING: CPU: 4 PID: 566 at fs/proc/generic.c:717 remove_proc_entry+0x160/0x1c0
Modules linked in: netfs(-)
CPU: 4 UID: 0 PID: 566 Comm: rmmod Not tainted 6.11.0-rc3 #860
RIP: 0010:remove_proc_entry+0x160/0x1c0
Call Trace:
 <TASK>
 netfs_exit+0x12/0x620 [netfs]
 __do_sys_delete_module.isra.0+0x14c/0x2e0
 do_syscall_64+0x4b/0x110
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
==================================================================

Therefore use remove_proc_subtree() instead of remove_proc_entry() to
fix the above problem.

Fixes: 7eb5b3e3a0a5 ("netfs, fscache: Move /proc/fs/fscache to /proc/fs/netfs and put in a symlink")
Cc: stable@kernel.org
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Link: https://lore.kernel.org/r/20240826113404.3214786-1-libaokun@huaweicloud.com
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/netfs/main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/netfs/main.c
+++ b/fs/netfs/main.c
@@ -138,7 +138,7 @@ static int __init netfs_init(void)
 
 error_fscache:
 error_procfile:
-	remove_proc_entry("fs/netfs", NULL);
+	remove_proc_subtree("fs/netfs", NULL);
 error_proc:
 	mempool_exit(&netfs_subrequest_pool);
 error_subreqpool:
@@ -155,7 +155,7 @@ fs_initcall(netfs_init);
 static void __exit netfs_exit(void)
 {
 	fscache_exit();
-	remove_proc_entry("fs/netfs", NULL);
+	remove_proc_subtree("fs/netfs", NULL);
 	mempool_exit(&netfs_subrequest_pool);
 	kmem_cache_destroy(netfs_subrequest_slab);
 	mempool_exit(&netfs_request_pool);


