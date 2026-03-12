Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4631E349B03;
	Thu, 12 Mar 2026 20:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346890; cv=none; b=OIv9a9D1HYzN/mN7LCN7m4GnXefre7mbGL5+lDsKpVl1dE1a8aMTjC+i4j/H9Evl7xKPzD72RAIA/r4nJVS3Nby38PGyR84w/qPEV8DOmQQs+5Eg2b6ljqrSyJCsamef7VEw7izpq6RBHIoJ46MxOIxVhWGNPU+/0QXIDEMEXDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346890; c=relaxed/simple;
	bh=j1lVwE2zb+7lO4b0Alnr/UAC9Z0gt7YRtktnik/RxHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bP3U6vgv6pEZ014JTpp29NXTnMXMrTKG7wA3xlXsImJIaj71FOqeS3u4HDWY11mmnI0xs7ADG4J7cKPnz5Fh61hrwL0Qc/mc8M9+4f0JVaPQDSTZYFGZ57neRYT+lbLuPr1ymLCEsGDnEY1ULQ6fCRTbGrp2MDSE4oLFE1ehJCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PsKciZWx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PsKciZWx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E328C4CEF7;
	Thu, 12 Mar 2026 20:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346890;
	bh=j1lVwE2zb+7lO4b0Alnr/UAC9Z0gt7YRtktnik/RxHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PsKciZWxE2NvsV8cNgBF7MDU/ebeUpdJipUgzEXsmc5oJTFUY/5i7Gq38tryUDwS0
	 IkSQ1Naup+9tyO+ULgreKuoQDnQr9rJqZGd9O70aRvokmib3i/TdwkiHNrLIY7p7UH
	 3TQ3iiTR0yKfAOdoC4niMma0LLsKC6ucw37t5M0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+dd3b43aa0204089217ee@syzkaller.appspotmail.com,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 151/265] nfsd: Fix cred ref leak in nfsd_nl_threads_set_doit().
Date: Thu, 12 Mar 2026 21:08:58 +0100
Message-ID: <20260312201023.716097660@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

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
 fs/nfsd/nfsctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1724,7 +1724,7 @@ int nfsd_nl_threads_set_doit(struct sk_b
 			scope = nla_data(attr);
 	}
 
-	ret = nfsd_svc(nrpools, nthreads, net, get_current_cred(), scope);
+	ret = nfsd_svc(nrpools, nthreads, net, current_cred(), scope);
 	if (ret > 0)
 		ret = 0;
 out_unlock:


