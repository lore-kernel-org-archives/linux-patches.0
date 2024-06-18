Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F48158A01;
	Tue, 18 Jun 2024 13:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716100; cv=none; b=Gsugi8WxI5Y4vgrFcBvP/aw0zQkl13KNBXr0PX9E8jWTnfN13hO4wENHLRrpWnUFYayEzLZKE+quJ0bVE/zBD1DqwK91IiJ+ShTQh0AnmY1hyTbXqtcWxhvbAL/8F+AplNr1ELxqjWCoUExxfvhY4y9rayDOF/F1+N/fw4BY7pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716100; c=relaxed/simple;
	bh=n19eTw5+FhONwKYABCd1XKxmtnTPLgkwI32rV5HzJSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FCIjo2ZfevDpdS7W2AM7Hv2XyWrEDDZ7vQZzbv4rfDmnRkY4lcr/eBXnieNQdTphhNkEUY2/NTvwT6TO8+W33qNMLAXIDENKxeSRr8XgvVHHhf02kpxfZSVV5cToz7JkEmW7f7jIBBkXmEwt1J2UauCP9/ogwuei8AuGwli2kQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Stx+p01h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Stx+p01h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E256AC4AF4D;
	Tue, 18 Jun 2024 13:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716100;
	bh=n19eTw5+FhONwKYABCd1XKxmtnTPLgkwI32rV5HzJSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Stx+p01hOQ54tzQGSzToGOs+OC1XbdGLJhHqmM4wnbOz8Nup0XzXqqNy7FprOVfL+
	 gtppu3vAJt7W5+b+Qaa8zGdfnfrcT7w246J4l0EQAPM2PXqsbYrIiln6ckgJByUedi
	 6ut4YbWq0+jm2x8JhxWmAXT02urZmrXR6NiIXa3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 532/770] nfsd: Fix null-ptr-deref in nfsd_fill_super()
Date: Tue, 18 Jun 2024 14:36:25 +0200
Message-ID: <20240618123427.847491265@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
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



