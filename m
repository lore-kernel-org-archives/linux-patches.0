Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207517;
	b=zzQQNvoDwO90YcUS/bh81lec6gZrArXftTYi3mg+GOXJ142VXuH/QsjgYqizAsYYURSQ
	 weR7UxmYVF+aOcGftn6VHZ4af6MUQVr55RguNfPYmDMn055FBExE3f/Ab3+j6mfaXjjgC
	 NJ7v3W/ra8VSj5EO95FbAE8PVGD24QitfYbvipppkGLW26vJoghWEcwJ2WIxmnMDXg6Yc
	 sx9eZIhAnyJu+g6XYyRpCph5/XzXb4oLxioChN4bXaehZJ3mU2yyU43FHvjFc3isg/k8S
	 WZP3JQEPMzzaEhx9bDWXpSJ3i47hSLjRd2UhScSmVAUBr6pFYB3MjRzmf7XUHdwnZWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207517;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yJFUY0Qtcxq+Mbeo1MvvAYsGgy0tfJOGwZh1sYqh1JU=;
	b=dAOU0d6aqREehQqYwRKuTcB9ms08Jat7KAbeS++4Sg22yypMNYBMSlVAguBGlIYNJck2
	 mHfgvJinJM7DFNeUs/EjERDFjiKGtl+0LP9YQV/HaFIbdKuYr/jk/dR4CT7sUgOgS8xmA
	 rO55L38CldosD+UEIYA1hzMG/5RzAh+z2wIpMhnNhVeBm2UKOmeSqm66qpkCdy+l5q6fN
	 rVYITBd2lUhv9YGWn3GEfJznFcM1VwbeH7J2YgqY8YE+QSIn3LfFTXejHeY2V/LXUEZLO
	 aZOHxUzmWebSofFt3pVS4X2B4PlUnF5oqHkAgR86eKvKe+oftPZ9SnceHwimsTXcwrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MoLYeDoV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C59606A31A;
	Wed, 28 Oct 2026 17:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MoLYeDoV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F1C51F01828;
	Wed, 28 Oct 2026 17:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207516;
	bh=yJFUY0Qtcxq+Mbeo1MvvAYsGgy0tfJOGwZh1sYqh1JU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MoLYeDoVXSTUs7Bw95u7v20cYMa0cnp3tTIGHc34JmRcfYadCec4JS8cn5q7OvSxc
	 c62aiZj66YX41pkjHhkQtERoYcQOW25gak1MUT68D5BgeNYen3cLATpCe2J4R+0Koh
	 cwAQBv2MBSYbZQvXdhpW9jnk1keB8EDirJHvodhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 045/247] ocfs2/dlm: Protect the recovery list during debugfs reads
Date: Wed, 28 Oct 2026 17:57:28 +0100
Message-ID: <20261028165948.440174631@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit 4c435828932bf46f29860e4a0375bcae101b778a ]

Recovery participant records must remain alive while debug_state_print()
walks reco.node_data and formats their fields. The formatter holds
dlm->spinlock, but the recovery participant list is protected by
dlm_reco_state_lock. In particular, dlm_destroy_recovery_area() detaches
the list under dlm_reco_state_lock and frees the detached records after
releasing it. A concurrent debugfs open can therefore read freed memory.

Protect the participant traversal and field reads in debug_state_print()
with dlm_reco_state_lock, matching the existing list writers. This also
serializes the traversal against list_add_tail() during recovery-area
initialization. Make the existing lock available to the debug code
through dlmcommon.h; the lock remains internal to the OCFS2 DLM module.

Release dlm->spinlock after formatting the other domain state and before
acquiring dlm_reco_state_lock, so the debug reader does not nest the two
locks. Leave recovery list insertion, detachment and freeing unchanged.

KASAN report as below:

    BUG: KASAN: slab-use-after-free in debug_state_open+0x1169/0x12d0
    Read of size 4 at addr ffff88810662ef80 by task dlm-state-stres/896

    CPU: 1 UID: 0 PID: 896 Comm: dlm-state-stres Not tainted 7.3.0-rc4-next-20260921-pmb-ocfs2-functional-v1+ #1 PREEMPT(lazy)
    Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
    Call Trace:
     <TASK>
     dump_stack_lvl+0x93/0xd0
     print_report+0xce/0x630
     ? debug_state_open+0x1169/0x12d0
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __virt_addr_valid+0x20e/0x420
     ? debug_state_open+0x1169/0x12d0
     kasan_report+0xe0/0x110
     ? debug_state_open+0x1169/0x12d0
     debug_state_open+0x1169/0x12d0
     ? __pfx_debug_state_open+0x10/0x10
     full_proxy_open_regular+0x193/0x310
     do_dentry_open+0x595/0x12d0
     ? __pfx_full_proxy_open_regular+0x10/0x10
     vfs_open_consume+0xd1/0x400
     ? srso_alias_return_thunk+0x5/0xfbef5
     path_openat+0x18d0/0x2020
     ? __pfx_path_openat+0x10/0x10
     do_file_open+0x21e/0x470
     ? __pfx_do_file_open+0x10/0x10
     ? _raw_spin_unlock+0x23/0x40
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? alloc_fd+0x3a6/0x6b0
     do_sys_openat2+0xf4/0x1b0
     ? __pfx_do_sys_openat2+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __fput+0x5b5/0xa60
     __x64_sys_openat+0x136/0x1e0
     ? __pfx___x64_sys_openat+0x10/0x10
     do_syscall_64+0x114/0x620
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
    [Register dump omitted.]
     </TASK>

    Allocated by task 880:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     __kasan_kmalloc+0xaa/0xb0
     __kmalloc_cache_noprof+0x28d/0x610
     dlm_remaster_locks+0x147/0x1d90
     dlm_do_recovery+0xde1/0x1580
     dlm_recovery_thread+0x109/0x300
     kthread+0x351/0x460
     ret_from_fork+0x659/0x940
     ret_from_fork_asm+0x1a/0x30

    Freed by task 880:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     kasan_save_free_info+0x3b/0x60
     __kasan_slab_free+0x5f/0x80
     kfree+0x308/0x580
     dlm_destroy_recovery_area+0x285/0x460
     dlm_remaster_locks+0x17c4/0x1d90
     dlm_do_recovery+0xde1/0x1580
     dlm_recovery_thread+0x109/0x300
     kthread+0x351/0x460
     ret_from_fork+0x659/0x940
     ret_from_fork_asm+0x1a/0x30

    The buggy address belongs to the object at ffff88810662ef80
     which belongs to the cache kmalloc-32 of size 32
    The buggy address is located 0 bytes inside of
     freed 32-byte region [ffff88810662ef80, ffff88810662efa0)

    [Page and memory-state dumps omitted.]

Fixes: 007dce53a29c ("ocfs2/dlm: Dump the dlm state in a debugfs file")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Link: https://patch.msgid.link/pm-ocfs2-objects-candidate-0049-v3-184e46c47f5283f06191@gmail.com
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/dlm/dlmcommon.h   | 2 ++
 fs/ocfs2/dlm/dlmdebug.c    | 5 ++++-
 fs/ocfs2/dlm/dlmrecovery.c | 2 +-
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index 20f790a47484a..58b28dfa8d34e 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -435,6 +435,8 @@ enum {
 	DLM_DEREF_LOCKRES_DONE		= 522,
 };
 
+extern spinlock_t dlm_reco_state_lock;
+
 struct dlm_reco_node_data
 {
 	int state;
diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index e62ed98df7de4..afaea6396b6f9 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -792,8 +792,11 @@ static int debug_state_print(struct dlm_ctxt *dlm, char *buf, int len)
 				 buf + out, len - out);
 	out += scnprintf(buf + out, len - out, "\n");
 
+	spin_unlock(&dlm->spinlock);
+
 	/* Recovery Node State: */
 	out += scnprintf(buf + out, len - out, "Recovery Node State:\n");
+	spin_lock(&dlm_reco_state_lock);
 	list_for_each_entry(node, &dlm->reco.node_data, list) {
 		switch (node->state) {
 		case DLM_RECO_NODE_DATA_INIT:
@@ -825,7 +828,7 @@ static int debug_state_print(struct dlm_ctxt *dlm, char *buf, int len)
 				node->node_num, state);
 	}
 
-	spin_unlock(&dlm->spinlock);
+	spin_unlock(&dlm_reco_state_lock);
 
 	return out;
 }
diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 739da8bd7dbf0..591dd17ef4f5e 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -80,7 +80,7 @@ static int dlm_lockres_master_requery(struct dlm_ctxt *dlm,
 
 static u64 dlm_get_next_mig_cookie(void);
 
-static DEFINE_SPINLOCK(dlm_reco_state_lock);
+DEFINE_SPINLOCK(dlm_reco_state_lock);
 static DEFINE_SPINLOCK(dlm_mig_cookie_lock);
 static u64 dlm_mig_cookie = 1;
 
-- 
2.53.0



