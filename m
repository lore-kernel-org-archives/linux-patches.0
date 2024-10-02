Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7411D0164;
	Wed,  2 Oct 2024 13:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877047; cv=none; b=aPBfsWuPGMDGFD2l18YWHbfkDd5mjed3G2HWKNuPNKOVl7CjpSLbeRNmFrGgpyCyvey7Pz0qzmNWGcttkSV4wayadXFt0n+Mb+8IJobI2H7ZmvTkm6j5YAMG3gPHLCZjo2IXwSGaicl6VR7UGYhHVBqPzngcE/phkRKsC3f6c8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877047; c=relaxed/simple;
	bh=nid5o35iYclYxmZc3r6XwE0n6AeRjJLLgfWgco+uqyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f6YdU7w+g5c9T1BHWZvad0aHxuEnpywh8qU5JLtN+qT+E1FchlCfi6MT/x7xncE/tVQ3+jZHxGm8SwI3phQKkPOenLvN0o8D8b6DqCAlCNLdoPDcX32dWSGzmwsmT1luVzNwqNnUuCwPATiyc8jmu1aiWjuqSPrQEXwvAzxlVjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zlmIT8UW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zlmIT8UW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46371C4CECE;
	Wed,  2 Oct 2024 13:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877047;
	bh=nid5o35iYclYxmZc3r6XwE0n6AeRjJLLgfWgco+uqyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zlmIT8UWv4JHP09ojyyXiNxk7iopE13z+DXhQbR63as2k60dGr/O2GC+W8zjDJlQi
	 3va55QGzIR75HxvKb2aI2oOejC5r9QoaISfpafJUVrOpLaPJid028fXFDuL0TX7vLQ
	 P6JTwPCt8GJtGeUfG9BXZopupUrTIN9J82CUVO1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Baokun Li <libaokun1@huawei.com>,
	David Howells <dhowells@redhat.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.11 646/695] netfs: Delete subtree of fs/netfs when netfs module exits
Date: Wed,  2 Oct 2024 15:00:44 +0200
Message-ID: <20241002125848.301483898@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -142,7 +142,7 @@ static int __init netfs_init(void)
 
 error_fscache:
 error_procfile:
-	remove_proc_entry("fs/netfs", NULL);
+	remove_proc_subtree("fs/netfs", NULL);
 error_proc:
 	mempool_exit(&netfs_subrequest_pool);
 error_subreqpool:
@@ -159,7 +159,7 @@ fs_initcall(netfs_init);
 static void __exit netfs_exit(void)
 {
 	fscache_exit();
-	remove_proc_entry("fs/netfs", NULL);
+	remove_proc_subtree("fs/netfs", NULL);
 	mempool_exit(&netfs_subrequest_pool);
 	kmem_cache_destroy(netfs_subrequest_slab);
 	mempool_exit(&netfs_request_pool);


