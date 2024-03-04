Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B55501C687;
	Mon,  4 Mar 2024 21:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588138; cv=none; b=VWWCYDTs84jQPCy56U0T3lUHBVWgC0P3ZAazbDVuJZG3EsH7WA5f1T7/4jOdOSpvZtRXLiaKXKe0WIhBl9C+u4/mr+0qvVgPRxye8HiJbuxs5wgKxyYeK4iDC7sTV4RTOn4tzH7YjOfLC258I0A9ZR4DFAu96WSgO0kevZxae1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588138; c=relaxed/simple;
	bh=7oop44mxW5ItFViRSPMlQkuLKhb/VM+2sRa+MQcdyhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B9AyXnlokFCrHK3cyvpOsr2zWcSpTsVVLBPmEVZ8nWGTNNcbCuctQiddstuTFs4Kb98DZVS/qeQCCSX7vWqcaSD7amcXJHaGwyDx4oaXs4N2TGp3Q6sK+T3cuRJUekX9z99IL6NbtvAzppnVAYSsCUxIdFApJ500Nh74HGpDBo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0hMCT1Lz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0hMCT1Lz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 488B4C433F1;
	Mon,  4 Mar 2024 21:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588138;
	bh=7oop44mxW5ItFViRSPMlQkuLKhb/VM+2sRa+MQcdyhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0hMCT1LzYdBY4m3BqWPJ2/VOhbX/uFxtTOqHXau/Bzgm4xUyaV4vG+LHrkTsahSSd
	 t/J3/09r5+yZKXZTSD0htf494OuikWvTMEGFcGCgoBv0v9CzVfxX2OKnOxbHRLR5B0
	 SyG0M0+n8wUi6+mK9qt8FOxVrcD0k8to2YM9ZVEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	David Howells <dhowells@redhat.com>,
	Jingbo Xu <jefflexu@linux.alibaba.com>,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.10 36/42] cachefiles: fix memory leak in cachefiles_add_cache()
Date: Mon,  4 Mar 2024 21:24:03 +0000
Message-ID: <20240304211538.870750093@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211537.631764077@linuxfoundation.org>
References: <20240304211537.631764077@linuxfoundation.org>
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
@@ -245,6 +245,8 @@ error_open_root:
 	kmem_cache_free(cachefiles_object_jar, fsdef);
 error_root_object:
 	cachefiles_end_secure(cache, saved_cred);
+	put_cred(cache->cache_cred);
+	cache->cache_cred = NULL;
 	pr_err("Failed to register: %d\n", ret);
 	return ret;
 }
@@ -265,6 +267,7 @@ void cachefiles_daemon_unbind(struct cac
 
 	dput(cache->graveyard);
 	mntput(cache->mnt);
+	put_cred(cache->cache_cred);
 
 	kfree(cache->rootdirname);
 	kfree(cache->secctx);


