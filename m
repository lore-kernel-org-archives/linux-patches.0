Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8E92D0C9F;
	Tue, 12 Aug 2025 19:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026807; cv=none; b=abY3LKIRg8p4/TpG9ocu8ud8868otV20x/hvNW4urXrZj6Xbfga+iiciDn3dpKtbfcxEKSIgBkdwirnv5H97KiBD2hon73qyyo5/KrFSOJ36NDuHNHWrtByVL4M7F7aEUt182o4PvmV2mQGnP2p4hrkO6aC9PiTJU+eM5GV2yjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026807; c=relaxed/simple;
	bh=sM/5vuTVuDxnwGA71CBKbiKKmq/ajXKVn9VftS7qq5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qn/PpNYdRuxhI+y5ppZuhoxdR9S1/YEH/Hh7slT7pEnbawYU5UbCqyRo4Bo96sgffoqcShMBtHFwxpIBcvVAGcrLJDSbIfbZOB08C6NVMWg2FzA0HCn9evp0fZtjgctwPmJpehv5igR+o7HWOJ/6Si7Oml2XUV+fmhF8XuutmgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1hg5NyPs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1hg5NyPs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3656C4CEF0;
	Tue, 12 Aug 2025 19:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026807;
	bh=sM/5vuTVuDxnwGA71CBKbiKKmq/ajXKVn9VftS7qq5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1hg5NyPsghWMQIy1XCAP6f2zcjMlxuYVqdo8GpAxOTKNkaPQMaIO43OX3BKgRaNhW
	 Ps78GoH8idQhgAWD71ZFLrAI8imUsvkyGexbNWSjwOy3lmsq81BHzUCLDk8bajBeNQ
	 /Y2wuWozkYhRkXKnbDNhh1nEirQtdXPAecdd2k8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Enzo Matsumiya <ematsumiya@suse.de>,
	Wang Zhaolong <wangzhaolong@huaweicloud.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.15 447/480] smb: client: fix netns refcount leak after net_passive changes
Date: Tue, 12 Aug 2025 19:50:55 +0200
Message-ID: <20250812174415.834110155@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Zhaolong <wangzhaolong@huaweicloud.com>

commit 59b33fab4ca4d7dacc03367082777627e05d0323 upstream.

After commit 5c70eb5c593d ("net: better track kernel sockets lifetime"),
kernel sockets now use net_passive reference counting. However, commit
95d2b9f693ff ("Revert "smb: client: fix TCP timers deadlock after rmmod"")
restored the manual socket refcount manipulation without adapting to this
new mechanism, causing a memory leak.

The issue can be reproduced by[1]:
1. Creating a network namespace
2. Mounting and Unmounting CIFS within the namespace
3. Deleting the namespace

Some memory leaks may appear after a period of time following step 3.

unreferenced object 0xffff9951419f6b00 (size 256):
  comm "ip", pid 447, jiffies 4294692389 (age 14.730s)
  hex dump (first 32 bytes):
    1b 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 80 77 c2 44 51 99 ff ff  .........w.DQ...
  backtrace:
    __kmem_cache_alloc_node+0x30e/0x3d0
    __kmalloc+0x52/0x120
    net_alloc_generic+0x1d/0x30
    copy_net_ns+0x86/0x200
    create_new_namespaces+0x117/0x300
    unshare_nsproxy_namespaces+0x60/0xa0
    ksys_unshare+0x148/0x360
    __x64_sys_unshare+0x12/0x20
    do_syscall_64+0x59/0x110
    entry_SYSCALL_64_after_hwframe+0x78/0xe2
...
unreferenced object 0xffff9951442e7500 (size 32):
  comm "mount.cifs", pid 475, jiffies 4294693782 (age 13.343s)
  hex dump (first 32 bytes):
    40 c5 38 46 51 99 ff ff 18 01 96 42 51 99 ff ff  @.8FQ......BQ...
    01 00 00 00 6f 00 c5 07 6f 00 d8 07 00 00 00 00  ....o...o.......
  backtrace:
    __kmem_cache_alloc_node+0x30e/0x3d0
    kmalloc_trace+0x2a/0x90
    ref_tracker_alloc+0x8e/0x1d0
    sk_alloc+0x18c/0x1c0
    inet_create+0xf1/0x370
    __sock_create+0xd7/0x1e0
    generic_ip_connect+0x1d4/0x5a0 [cifs]
    cifs_get_tcp_session+0x5d0/0x8a0 [cifs]
    cifs_mount_get_session+0x47/0x1b0 [cifs]
    dfs_mount_share+0xfa/0xa10 [cifs]
    cifs_mount+0x68/0x2b0 [cifs]
    cifs_smb3_do_mount+0x10b/0x760 [cifs]
    smb3_get_tree+0x112/0x2e0 [cifs]
    vfs_get_tree+0x29/0xf0
    path_mount+0x2d4/0xa00
    __se_sys_mount+0x165/0x1d0

Root cause:
When creating kernel sockets, sk_alloc() calls net_passive_inc() for
sockets with sk_net_refcnt=0. The CIFS code manually converts kernel
sockets to user sockets by setting sk_net_refcnt=1, but doesn't call
the corresponding net_passive_dec(). This creates an imbalance in the
net_passive counter, which prevents the network namespace from being
destroyed when its last user reference is dropped. As a result, the
entire namespace and all its associated resources remain allocated.

Timeline of patches leading to this issue:
- commit ef7134c7fc48 ("smb: client: Fix use-after-free of network
  namespace.") in v6.12 fixed the original netns UAF by manually
  managing socket refcounts
- commit e9f2517a3e18 ("smb: client: fix TCP timers deadlock after
  rmmod") in v6.13 attempted to use kernel sockets but introduced
  TCP timer issues
- commit 5c70eb5c593d ("net: better track kernel sockets lifetime")
  in v6.14-rc5 introduced the net_passive mechanism with
  sk_net_refcnt_upgrade() for proper socket conversion
- commit 95d2b9f693ff ("Revert "smb: client: fix TCP timers deadlock
  after rmmod"") in v6.15-rc3 reverted to manual refcount management
  without adapting to the new net_passive changes

Fix this by using sk_net_refcnt_upgrade() which properly handles the
net_passive counter when converting kernel sockets to user sockets.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220343 [1]
Fixes: 95d2b9f693ff ("Revert "smb: client: fix TCP timers deadlock after rmmod"")
Cc: stable@vger.kernel.org
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Wang Zhaolong <wangzhaolong@huaweicloud.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/connect.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -3362,18 +3362,15 @@ generic_ip_connect(struct TCP_Server_Inf
 		struct net *net = cifs_net_ns(server);
 		struct sock *sk;
 
-		rc = __sock_create(net, sfamily, SOCK_STREAM,
-				   IPPROTO_TCP, &server->ssocket, 1);
+		rc = sock_create_kern(net, sfamily, SOCK_STREAM,
+				      IPPROTO_TCP, &server->ssocket);
 		if (rc < 0) {
 			cifs_server_dbg(VFS, "Error %d creating socket\n", rc);
 			return rc;
 		}
 
 		sk = server->ssocket->sk;
-		__netns_tracker_free(net, &sk->ns_tracker, false);
-		sk->sk_net_refcnt = 1;
-		get_net_track(net, &sk->ns_tracker, GFP_KERNEL);
-		sock_inuse_add(net, 1);
+		sk_net_refcnt_upgrade(sk);
 
 		/* BB other socket options to set KEEPALIVE, NODELAY? */
 		cifs_dbg(FYI, "Socket created\n");


