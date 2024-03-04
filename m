Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC821C6AB;
	Mon,  4 Mar 2024 21:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589394; cv=none; b=WM4AtarFNjYSVYhcmBF/zt9MNoEIMLVirVLQ9MZ0KXlqWs2IbJjcJK/fyQrKTCwL89byB+9KmmDAUJ582lvu4f7erbVM71qVLQyEMBzi8KrGCLU+oErPg6fyRVXNOUAu8+v7b9ZparK0TFba8O20YFteIjoCtSY+qHMsg0kMA5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589394; c=relaxed/simple;
	bh=Kjf2hUQtiQbDEnL0pksL2/4PQgSIGJcpUWLAC9CjYNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W6MRQyRu6x6TIoEKtSl7fiAYQswrSLGKNrc/S9t6LQe2chBsTc4OUvbJ/UjxS40rW+2lKfjIiQjjlshJgvjBV59yY8zJ684rTuN8UamXzWA64mTV7/RVXmU+Tnfpq06StpCdkeYoUfdrlMVNwNklQzS1YtRlae0egFKMdiyw324=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BrsCVM98; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BrsCVM98"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D0D2C433C7;
	Mon,  4 Mar 2024 21:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589394;
	bh=Kjf2hUQtiQbDEnL0pksL2/4PQgSIGJcpUWLAC9CjYNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BrsCVM98WzdL3st83BqSlUbH15K1xvjpPytFMqUtbqXkyFTgryzFQpEKShCKNVKs2
	 9astQ1zDDDVN0iniMiHPrLxQkY56J1jNf5ZGTm+tAurX9+2tS6037utorUi/nGImHl
	 vBzWB9xNXSzS0P69YCaQifoNedY/BoRggAe/kyt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	David Howells <dhowells@redhat.com>,
	Jingbo Xu <jefflexu@linux.alibaba.com>,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.15 70/84] cachefiles: fix memory leak in cachefiles_add_cache()
Date: Mon,  4 Mar 2024 21:24:43 +0000
Message-ID: <20240304211544.737047637@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211542.332206551@linuxfoundation.org>
References: <20240304211542.332206551@linuxfoundation.org>
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
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cachefiles/bind.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/cachefiles/bind.c
+++ b/fs/cachefiles/bind.c
@@ -249,6 +249,8 @@ error_open_root:
 	kmem_cache_free(cachefiles_object_jar, fsdef);
 error_root_object:
 	cachefiles_end_secure(cache, saved_cred);
+	put_cred(cache->cache_cred);
+	cache->cache_cred = NULL;
 	pr_err("Failed to register: %d\n", ret);
 	return ret;
 }
@@ -269,6 +271,7 @@ void cachefiles_daemon_unbind(struct cac
 
 	dput(cache->graveyard);
 	mntput(cache->mnt);
+	put_cred(cache->cache_cred);
 
 	kfree(cache->rootdirname);
 	kfree(cache->secctx);


