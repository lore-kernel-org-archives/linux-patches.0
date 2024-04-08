Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0FD80620;
	Mon,  8 Apr 2024 13:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584063; cv=none; b=R8rWgfwxZovf5V7HlPr3FMnTpz8dUkCQKErkFtJtvnFAIfvi/byzIc+8uNGyNUiYWD0jlxvM+GG9l1D5DPB5heVmFP1PcI+gAm5pdsO1yHCV2dUzGdPVESSLTjipx3S1unyDd0d/dcqJFuamPJP6UQ7MkLf0CXtBz11CKE2c/ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584063; c=relaxed/simple;
	bh=F/cVF08eJ71y/vyeVYb4Nbf+f3kJWO3IQXsgNEWXYIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eZFmbawctwXWEgIpEafZ4ZSX96Q4M9RwpVmxgnNy40U7cxL+7IVKlVHjkoBOQghilYYc3WPin0skci0vUOVo7PzHXVhCiAd2ziJGtYdQGrWYYSdpcjKMLZSM+GkmrF9uVvTDwlGCoTWSohg43GCl1m3DnMUhFpTXog5e4JRJod4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WVnIei52; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WVnIei52"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE95EC433F1;
	Mon,  8 Apr 2024 13:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584063;
	bh=F/cVF08eJ71y/vyeVYb4Nbf+f3kJWO3IQXsgNEWXYIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WVnIei52HFDm8upMLllp36ncS1U/Yl+jY9rmNaC6MUr/qfCEYs+3/eW7RzygpDdKc
	 fTEfSKoCwfjMyq6ufNlNMdL3nB6oC1ifBcHJMY8u23DlzJBmUT0n+5fdMFsIu5rmtd
	 fqTBxrskL/dvBwt7975sbUw9fmf1n1bGXqlNm84Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 328/690] nfsd: Fix null-ptr-deref in nfsd_fill_super()
Date: Mon,  8 Apr 2024 14:53:14 +0200
Message-ID: <20240408125411.496796521@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

[ Upstream commit 6f6f84aa215f7b6665ccbb937db50860f9ec2989 ]

KASAN report null-ptr-deref as follows:

  BUG: KASAN: null-ptr-deref in nfsd_fill_super+0xc6/0xe0 [nfsd]
  Write of size 8 at addr 000000000000005d by task a.out/852

  CPU: 7 PID: 852 Comm: a.out Not tainted 5.18.0-rc7-dirty #66
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-1.fc33 04/01/2014
  Call Trace:
   <TASK>
   dump_stack_lvl+0x34/0x44
   kasan_report+0xab/0x120
   ? nfsd_mkdir+0x71/0x1c0 [nfsd]
   ? nfsd_fill_super+0xc6/0xe0 [nfsd]
   nfsd_fill_super+0xc6/0xe0 [nfsd]
   ? nfsd_mkdir+0x1c0/0x1c0 [nfsd]
   get_tree_keyed+0x8e/0x100
   vfs_get_tree+0x41/0xf0
   __do_sys_fsconfig+0x590/0x670
   ? fscontext_read+0x180/0x180
   ? anon_inode_getfd+0x4f/0x70
   do_syscall_64+0x35/0x80
   entry_SYSCALL_64_after_hwframe+0x44/0xae

This can be reproduce by concurrent operations:
        1. fsopen(nfsd)/fsconfig
        2. insmod/rmmod nfsd

Since the nfsd file system is registered before than nfsd_net allocated,
the caller may get the file_system_type and use the nfsd_net before it
allocated, then null-ptr-deref occurred.

So init_nfsd() should call register_filesystem() last.

Fixes: bd5ae9288d64 ("nfsd: register pernet ops last, unregister first")
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfsctl.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index 55949e60897d5..0621c2faf2424 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1535,25 +1535,25 @@ static int __init init_nfsd(void)
 	retval = create_proc_exports_entry();
 	if (retval)
 		goto out_free_lockd;
-	retval = register_filesystem(&nfsd_fs_type);
-	if (retval)
-		goto out_free_exports;
 	retval = register_pernet_subsys(&nfsd_net_ops);
 	if (retval < 0)
-		goto out_free_filesystem;
+		goto out_free_exports;
 	retval = register_cld_notifier();
 	if (retval)
 		goto out_free_subsys;
 	retval = nfsd4_create_laundry_wq();
+	if (retval)
+		goto out_free_cld;
+	retval = register_filesystem(&nfsd_fs_type);
 	if (retval)
 		goto out_free_all;
 	return 0;
 out_free_all:
+	nfsd4_destroy_laundry_wq();
+out_free_cld:
 	unregister_cld_notifier();
 out_free_subsys:
 	unregister_pernet_subsys(&nfsd_net_ops);
-out_free_filesystem:
-	unregister_filesystem(&nfsd_fs_type);
 out_free_exports:
 	remove_proc_entry("fs/nfs/exports", NULL);
 	remove_proc_entry("fs/nfs", NULL);
@@ -1571,6 +1571,7 @@ static int __init init_nfsd(void)
 
 static void __exit exit_nfsd(void)
 {
+	unregister_filesystem(&nfsd_fs_type);
 	nfsd4_destroy_laundry_wq();
 	unregister_cld_notifier();
 	unregister_pernet_subsys(&nfsd_net_ops);
@@ -1581,7 +1582,6 @@ static void __exit exit_nfsd(void)
 	nfsd_lockd_shutdown();
 	nfsd4_free_slabs();
 	nfsd4_exit_pnfs();
-	unregister_filesystem(&nfsd_fs_type);
 }
 
 MODULE_AUTHOR("Olaf Kirch <okir@monad.swb.de>");
-- 
2.43.0



