Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F019A78B61;
	Tue, 27 Feb 2024 13:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041039; cv=none; b=IbOOmvwbzuo9e4npO9BuWse1vbIvUPpZliFtjRd4i9zL+fdm6Wzz33GeVOVkoncHNTeemVXw+ypGoKWq2g4PDgsr7nYHRQBiJGhFtdtbw+Y/R0S1xRT0l/2JH4KeW46oAwholOYdEdPkWWtRFPiRlZe1M0+KDJglTeeEhBwk9To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041039; c=relaxed/simple;
	bh=5hmIbd8Qv9Th+fom9ECoTYWh5JYZ5Ykp+iXCmHBRMzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T3rzZrrzJHsmVD6rvkiUu8wdoNZRZjqmDKeXcU/rKEBfO5KZn25a2RgH2ogXzhda2+5/jw4iBYBZOPhWYxy9+5nLHyCmD1KU38cKlftD30JM0HKoczNru9jDFueKjOYxF8NJgUTZw0SxXKZjJKSM6MRp/Q/Fi3wBN3E/V8TgOHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WoBOHkFQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WoBOHkFQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24407C43399;
	Tue, 27 Feb 2024 13:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041038;
	bh=5hmIbd8Qv9Th+fom9ECoTYWh5JYZ5Ykp+iXCmHBRMzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WoBOHkFQp+Q9y0MTeeEXGu9MzO1it0MH5AyZ9lkSL/zBMPq1KQOmPl9WzAWYQfFSq
	 sQOVdWoQr+cCdVAYlpLGqT31nahCm5Oi4Jy0CBMZGsK/BgkwkM3zWJXAxEbKJOeZwz
	 cUiA7z0GvewGrXbinykzlJY9mXc60lz4WqT75uAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	David Howells <dhowells@redhat.com>,
	Jingbo Xu <jefflexu@linux.alibaba.com>,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.7 180/334] cachefiles: fix memory leak in cachefiles_add_cache()
Date: Tue, 27 Feb 2024 14:20:38 +0100
Message-ID: <20240227131636.412659947@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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


