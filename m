Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5257F395AEA;
	Sat, 30 May 2026 17:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161431; cv=none; b=CZ780vd3vxrUl/B7NrMrpABDK203ShXzPuD/fQFsCBnKplzBTvlFNHVYouboWwLQ2vowaUJTWPfIsp+sNeqfhs0GFHjuaeoQHwgs5roqnzhu4gPn7+OTWHrdzxE8wP9/Iog0rBt3oX3IOxw1+koSYaCUwhevYlyUb/uld1PuUPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161431; c=relaxed/simple;
	bh=KzyNA6MsYBtn8tOvMwVhCUZz5RO0OZK8wnSwd5hg9mk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=psJ7sfkZa1MbZRh83p6wpd60rE7nTvaEicaQEjgnyg8oE3oz1sKmjMkGQPjOXN2UwUYrL1Ny5l29kS+9FTAdKSAMHyFre8DoRSk48AKUmN14lTOZ+qRH6FeQhtBWZswd3UYJD/bL+RhxLHIh6fnq2yG/uvDVMtqNviwrVNZ8Tkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tYMq0tEz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tYMq0tEz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E6651F00893;
	Sat, 30 May 2026 17:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161430;
	bh=B05JV6g+UVCkPfGHvgCRQch2MhnwOBltQ+xuPk5r+nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tYMq0tEzJRx7wgEP4vm2gbLEXIDeW6Rq5ppVTy84UWuBQtcbGnz4DxAeZPHEdKV7M
	 i2y5zhI56EPomhvLxTXy2aH7XnuWtRjyCyVHb5SVP92BGtlRkk0uk9hwzeZwf/F3pI
	 5ZBSbN8ghWg66RWQ352Jvn709eFzDuphgJKNjn8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Michal Luczaj <mhal@rbox.co>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 621/969] bpf, sockmap: Take state lock for af_unix iter
Date: Sat, 30 May 2026 18:02:25 +0200
Message-ID: <20260530160317.589774750@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Luczaj <mhal@rbox.co>

[ Upstream commit 64c2f93fc3254d3bf5de4445fb732ee5c451edb6 ]

When a BPF iterator program updates a sockmap, there is a race condition in
unix_stream_bpf_update_proto() where the `peer` pointer can become stale[1]
during a state transition TCP_ESTABLISHED -> TCP_CLOSE.

        CPU0 bpf                          CPU1 close
        --------                          ----------
// unix_stream_bpf_update_proto()
sk_pair = unix_peer(sk)
if (unlikely(!sk_pair))
   return -EINVAL;
                                     // unix_release_sock()
                                     skpair = unix_peer(sk);
                                     unix_peer(sk) = NULL;
                                     sock_put(skpair)
sock_hold(sk_pair) // UaF

More practically, this fix guarantees that the iterator program is
consistently provided with a unix socket that remains stable during
iterator execution.

[1]:
BUG: KASAN: slab-use-after-free in unix_stream_bpf_update_proto+0x155/0x490
Write of size 4 at addr ffff8881178c9a00 by task test_progs/2231
Call Trace:
 dump_stack_lvl+0x5d/0x80
 print_report+0x170/0x4f3
 kasan_report+0xe4/0x1c0
 kasan_check_range+0x125/0x200
 unix_stream_bpf_update_proto+0x155/0x490
 sock_map_link+0x71c/0xec0
 sock_map_update_common+0xbc/0x600
 sock_map_update_elem+0x19a/0x1f0
 bpf_prog_bbbf56096cdd4f01_selective_dump_unix+0x20c/0x217
 bpf_iter_run_prog+0x21e/0xae0
 bpf_iter_unix_seq_show+0x1e0/0x2a0
 bpf_seq_read+0x42c/0x10d0
 vfs_read+0x171/0xb20
 ksys_read+0xff/0x200
 do_syscall_64+0xf7/0x5e0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

Allocated by task 2236:
 kasan_save_stack+0x30/0x50
 kasan_save_track+0x14/0x30
 __kasan_slab_alloc+0x63/0x80
 kmem_cache_alloc_noprof+0x1d5/0x680
 sk_prot_alloc+0x59/0x210
 sk_alloc+0x34/0x470
 unix_create1+0x86/0x8a0
 unix_stream_connect+0x318/0x15b0
 __sys_connect+0xfd/0x130
 __x64_sys_connect+0x72/0xd0
 do_syscall_64+0xf7/0x5e0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

Freed by task 2236:
 kasan_save_stack+0x30/0x50
 kasan_save_track+0x14/0x30
 kasan_save_free_info+0x3b/0x70
 __kasan_slab_free+0x47/0x70
 kmem_cache_free+0x11c/0x590
 __sk_destruct+0x432/0x6e0
 unix_release_sock+0x9b3/0xf60
 unix_release+0x8a/0xf0
 __sock_release+0xb0/0x270
 sock_close+0x18/0x20
 __fput+0x36e/0xac0
 fput_close_sync+0xe5/0x1a0
 __x64_sys_close+0x7d/0xd0
 do_syscall_64+0xf7/0x5e0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

Fixes: 2c860a43dd77 ("bpf: af_unix: Implement BPF iterator for UNIX domain socket.")
Suggested-by: Kuniyuki Iwashima <kuniyu@google.com>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260414-unix-proto-update-null-ptr-deref-v4-5-2af6fe97918e@rbox.co
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -3604,6 +3604,7 @@ static int bpf_iter_unix_seq_show(struct
 		return 0;
 
 	lock_sock(sk);
+	unix_state_lock(sk);
 
 	if (unlikely(sock_flag(sk, SOCK_DEAD))) {
 		ret = SEQ_SKIP;
@@ -3615,6 +3616,7 @@ static int bpf_iter_unix_seq_show(struct
 	prog = bpf_iter_get_info(&meta, false);
 	ret = unix_prog_seq_show(prog, &meta, v, uid);
 unlock:
+	unix_state_unlock(sk);
 	release_sock(sk);
 	return ret;
 }


