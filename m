Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC362145B2E;
	Tue, 27 Feb 2024 13:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042057; cv=none; b=nZUtcRildue2tXGGDCogsGaHW8WuCW1E7ViV1cOittRXrNI1fxv9qbHO5ZCZHJdmcn1GIqxR31YfcgPPGbmP6LTKmp12R9y7g+RASTRMrMdKgbUwMFWBh76y1uMp4y8QWIAIeEnliY9SRK3rlhHsJ7QAno6kpEfyQ1LJpA/o+Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042057; c=relaxed/simple;
	bh=3l0vgGEoiunBFkICSFk81JWC7E3SxvbaRWA3wY2XSK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d/sAf1+V6vuDQp7gEs78NeuSSi5jaVALkAWLacL2UQt5CbVkzDck/3qrEOzj0Zh1G1BhMCUF7WGzkf7FtoPgZUz+ij4w5n2Gf45RjkFpnm3zHm7lTfP9pvil9TXqqiSIGQXGAAxmgGZMcUg7+czGRQ7l8gf8r1Hg+bkjI3C21ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cRASlCKE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cRASlCKE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB99C433C7;
	Tue, 27 Feb 2024 13:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042057;
	bh=3l0vgGEoiunBFkICSFk81JWC7E3SxvbaRWA3wY2XSK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cRASlCKEAzIdW79RO/wzupk1QPB48hSDNLhQGhkP2wkgwKvsb0UlJd7rclD6pke7w
	 yQsRmxEmmbjKxuH+pHolcz8ZFpk/mSxS8slXtyX+Mnfy914qnsd/RyeHF30ZY4tgHZ
	 NYHFZMzvpqVu5rhEsG/nmA3dJ8j4C7HGlmc8oDHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	David Howells <dhowells@redhat.com>,
	Jingbo Xu <jefflexu@linux.alibaba.com>,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.6 164/299] cachefiles: fix memory leak in cachefiles_add_cache()
Date: Tue, 27 Feb 2024 14:24:35 +0100
Message-ID: <20240227131631.129821066@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

commit e21a2f17566cbd64926fb8f16323972f7a064444 upstream.

The following memory leak was reported after unbinding /dev/cachefiles:

==================================================================
unreferenced object 0xffff9b674176e3c0 (size 192):
  comm "cachefilesd2", pid 680, jiffies 4294881224
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace (crc ea38a44b):
    [<ffffffff8eb8a1a5>] kmem_cache_alloc+0x2d5/0x370
    [<ffffffff8e917f86>] prepare_creds+0x26/0x2e0
    [<ffffffffc002eeef>] cachefiles_determine_cache_security+0x1f/0x120
    [<ffffffffc00243ec>] cachefiles_add_cache+0x13c/0x3a0
    [<ffffffffc0025216>] cachefiles_daemon_write+0x146/0x1c0
    [<ffffffff8ebc4a3b>] vfs_write+0xcb/0x520
    [<ffffffff8ebc5069>] ksys_write+0x69/0xf0
    [<ffffffff8f6d4662>] do_syscall_64+0x72/0x140
    [<ffffffff8f8000aa>] entry_SYSCALL_64_after_hwframe+0x6e/0x76
==================================================================

Put the reference count of cache_cred in cachefiles_daemon_unbind() to
fix the problem. And also put cache_cred in cachefiles_add_cache() error
branch to avoid memory leaks.

Fixes: 9ae326a69004 ("CacheFiles: A cache that backs onto a mounted filesystem")
CC: stable@vger.kernel.org
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Link: https://lore.kernel.org/r/20240217081431.796809-1-libaokun1@huawei.com
Acked-by: David Howells <dhowells@redhat.com>
Reviewed-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cachefiles/cache.c  |    2 ++
 fs/cachefiles/daemon.c |    1 +
 2 files changed, 3 insertions(+)

--- a/fs/cachefiles/cache.c
+++ b/fs/cachefiles/cache.c
@@ -168,6 +168,8 @@ error_unsupported:
 	dput(root);
 error_open_root:
 	cachefiles_end_secure(cache, saved_cred);
+	put_cred(cache->cache_cred);
+	cache->cache_cred = NULL;
 error_getsec:
 	fscache_relinquish_cache(cache_cookie);
 	cache->cache = NULL;
--- a/fs/cachefiles/daemon.c
+++ b/fs/cachefiles/daemon.c
@@ -805,6 +805,7 @@ static void cachefiles_daemon_unbind(str
 	cachefiles_put_directory(cache->graveyard);
 	cachefiles_put_directory(cache->store);
 	mntput(cache->mnt);
+	put_cred(cache->cache_cred);
 
 	kfree(cache->rootdirname);
 	kfree(cache->secctx);


