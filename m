Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 762162BF3E2;
	Tue, 10 Mar 2026 11:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141143; cv=none; b=ilnz41Rso+0xLq7o5KnmVs+0I0cgOHTUJ5vNNluuLoTpf5esh+zIUsaaEU4VjijPzc6hyuWcwJBsj2z6j7CfG1HIqwSZTnKcx1l9DBXoKSzYBEk54/T4kvdhTs+f5MogPkXv1NRbHFx6vgLPVqzM0r2tYgjCmAmITecwvJg0YtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141143; c=relaxed/simple;
	bh=ke/FWrbFchbe/l3vCgNKIDjX3cHI35Ph94qwbjFXXX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MXstNWzT6Oo+0dC4PR64970aQASwkfHuaP4xerwtKzstrFBZwaFuN40G8gnwt/gkfrW8KHWICOfcKcZssiST330pYU7rernMQvedbhnYAvoXBjwu2bDfTBvSw+pC2jR8C13OpRpIXWz74IkwogXTm2SQaOIWmN5fOt2JCdbSEhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PPVZqnOH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PPVZqnOH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C98C2BC86;
	Tue, 10 Mar 2026 11:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141143;
	bh=ke/FWrbFchbe/l3vCgNKIDjX3cHI35Ph94qwbjFXXX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PPVZqnOHiNtO4pXKKj4qtfXD4D7IvP90eL0O0iI62YoQv1HXjWEPg/fOVFAYOLfCW
	 fZvlAn/qXq1uJJVGuC2oiYQ4Wcyn7wuZOVx5RS8ER6NPuOfbMKgIe4NPWnacoivXd6
	 D9PENg4CebG1e4kgF2alaOeWUydG1/ZQjxCqqaTQTw93LD0428z7npHJ2a1lFDuDsZ
	 PEf7VpcHrxS3RrLiKOv8ZarrVIllLRDHNzMGPtfQwUW14gvwF9x9a+YLPXY/8EUZAZ
	 O8DI/1KWVzNvslYiH3irabuU81I0AteDbtOI+Tohak8jFMm6I4/kPShPIdJOne0BZv
	 kijyu7OA39/RQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kuniyuki Iwashima <kuniyu@google.com>,
	syzbot+dd3b43aa0204089217ee@syzkaller.appspotmail.com,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.19 147/311] nfsd: Fix cred ref leak in nfsd_nl_threads_set_doit().
Date: Tue, 10 Mar 2026 07:03:14 -0400
Message-ID: <e31a123a727afa118b022fad7b6b0c12980eda39.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
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
index 084fc517e9e16..ec9782fd4a367 100644
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

