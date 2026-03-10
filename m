Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B74E63876AA;
	Tue, 10 Mar 2026 11:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142047; cv=none; b=MPKNCOVuw4KJVzDdXImqwIuKVwuNNpTNNFR88ZBV4jV+SX66ojrg4cG2xjjZ7Xd6g0tttmwkuOndEIzBxMGtkiuuheMcqZsqlGZy0e5wlD0UbOCKv53kWTsKnLsRFMXjK0d2wCWsCrs0VT5frMj3m1Oe1o3Mx9nM0Ry9IbPAYb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142047; c=relaxed/simple;
	bh=fDgnW6r6B7bRurQ2MCY/KXY4U/hFwSHaPBQoXej6cN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s0TDgnmsPzd9yhjP5M4yD6XJh527WxuXtxologcrZ/EtrWTkzzZLstpxzdnRiOsg/O2SGJFyk//V02LrWXeubQZnvuRsytARanTVlidBIG4sTcDv6bmW8mbqiu1HKYMR3Q8RVbcmNpO36sENGjva/+4/CLH3hIBih2kqTxRm4xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F7JarLdT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F7JarLdT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2159C2BC86;
	Tue, 10 Mar 2026 11:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142047;
	bh=fDgnW6r6B7bRurQ2MCY/KXY4U/hFwSHaPBQoXej6cN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F7JarLdT+dXn1jll2rr39bDnsY91Yv8T/t+Did1FHtvNUuXl2l6yWUlN46G8KJF0C
	 nYFK5OfZWrtjTyAwNqDRTt3pLwYTUpxmZIb/8M6KN3ZzIkybSyFpMC7Yd8hgYysDvs
	 pyv7BRUWeUoBZCrhtMAIv3R//CBz0Q0a9Jj4qrINgC4bPfKORvE0fHi8N4WpQiQh1D
	 Uh+AoC1KfzrUqzFrJkN0Z7/Qf2a/jF5obbEgxrbtr9ZTRTBhgejm84fRL3pg8QwP+V
	 Gz9n34cz/LRiX/H1A4hkb+rFTxbVnhc2bgp42yFj4TUXeLTJOlbYgs1UafmETshMHx
	 QyweqgXaN6DYg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kuniyuki Iwashima <kuniyu@google.com>,
	syzbot+dd3b43aa0204089217ee@syzkaller.appspotmail.com,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.18 175/314] nfsd: Fix cred ref leak in nfsd_nl_threads_set_doit().
Date: Tue, 10 Mar 2026 07:17:14 -0400
Message-ID: <d150c26dcb15223b10a1412a5862afc38e2c48c5.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Kuniyuki Iwashima <kuniyu@google.com>

commit 1cb968a2013ffa8112d52ebe605009ea1c6a582c upstream.

syzbot reported memory leak of struct cred. [0]

nfsd_nl_threads_set_doit() passes get_current_cred() to
nfsd_svc(), but put_cred() is not called after that.

The cred is finally passed down to _svc_xprt_create(),
which calls get_cred() with the cred for struct svc_xprt.

The ownership of the refcount by get_current_cred() is not
transferred to anywhere and is just leaked.

nfsd_svc() is also called from write_threads(), but it does
not bump file->f_cred there.

nfsd_nl_threads_set_doit() is called from sendmsg() and
current->cred does not go away.

Let's use current_cred() in nfsd_nl_threads_set_doit().

[0]:
BUG: memory leak
unreferenced object 0xffff888108b89480 (size 184):
  comm "syz-executor", pid 5994, jiffies 4294943386
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace (crc 369454a7):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4958 [inline]
    slab_alloc_node mm/slub.c:5263 [inline]
    kmem_cache_alloc_noprof+0x412/0x580 mm/slub.c:5270
    prepare_creds+0x22/0x600 kernel/cred.c:185
    copy_creds+0x44/0x290 kernel/cred.c:286
    copy_process+0x7a7/0x2870 kernel/fork.c:2086
    kernel_clone+0xac/0x6e0 kernel/fork.c:2651
    __do_sys_clone+0x7f/0xb0 kernel/fork.c:2792
    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
    do_syscall_64+0xa4/0xf80 arch/x86/entry/syscall_64.c:94
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

Fixes: 924f4fb003ba ("NFSD: convert write_threads to netlink command")
Cc: stable@vger.kernel.org
Reported-by: syzbot+dd3b43aa0204089217ee@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/69744674.a00a0220.33ccc7.0000.GAE@google.com/
Tested-by: syzbot+dd3b43aa0204089217ee@syzkaller.appspotmail.com
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index 8cbfb9dc3abb7..5b00b7a863b94 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1642,7 +1642,7 @@ int nfsd_nl_threads_set_doit(struct sk_buff *skb, struct genl_info *info)
 			scope = nla_data(attr);
 	}
 
-	ret = nfsd_svc(nrpools, nthreads, net, get_current_cred(), scope);
+	ret = nfsd_svc(nrpools, nthreads, net, current_cred(), scope);
 	if (ret > 0)
 		ret = 0;
 out_unlock:
-- 
2.51.0

