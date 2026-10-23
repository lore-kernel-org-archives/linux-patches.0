Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774608;
	b=jvbZm1giRjtCYmthGVu6JCLw2SzEmzw6QsVRo54Fb3HWxQs2HJVZixXnCo7jy52YX/gb
	 p7W2FwHdA5fGJIui5UMH8P5LHxfR5xskUsgexJULansm0ENMGW+jQfqTeJ6sWfSWT9kdw
	 DUXwt7FQPQWvC60zo2lqbwY13udLAp6gKGOfCu3CyVNBO6aws2tgxYXisf3yKMw27ge4y
	 w6X1CzmtbkbYBD+8DS0XPcCKLQ6fI2rIJ3/crGu2kqcgJr6IdmS5Puj8NTRdosUTe41SB
	 OEq66Vkn18YAoxblSYK9WejH0Ij69cJjfUGFWpXOWs0I0K7k6YcW4EbahF9c9tPJTQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774608;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oInW/Q8I8+pxooyrRqXFWwPmqkX77qFEFIgMCp8Nmq4=;
	b=qq8aCtVXJQi7X9/5/X1niyEbhVjIw9VGnrDqGSouU/elg6CwLCZ+lbg9eyrc/Crfl7pj
	 na7CyQeiD54L5F5szkKwZwZzT5jPAD2wwmeusBWHN8tCnXHMc1tom4vA0syT3sPorq1VP
	 jmvepY/OJlx7JrsPL+nR+wlOrvL+MbpedoClj3WKRwAmRYSoC9KJMJndeddwTBPuOxkIh
	 HQoEfRgQURCpzg/spjD9EuiI2O2XEGfWq2jxNWPYrRbFrfYW6I9Q6MDK7B0gXcHc7l5UM
	 /v1ix+Wcd36RKi6g443InQqZs1h1sXd5SzCENcHsnIqh8Xi15IuTMqneDjMN8J5nEnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x6QHUzcV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78491606A31B;
	Fri, 23 Oct 2026 16:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x6QHUzcV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC071F01825;
	Fri, 23 Oct 2026 16:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774608;
	bh=oInW/Q8I8+pxooyrRqXFWwPmqkX77qFEFIgMCp8Nmq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x6QHUzcVosN5LRVeSeiPTXq4wiM5ygq+57S4hheXqojFWbhyXZxnPDAqZpbq5/15I
	 cZmqQM5KILzzoJ9K20+MIiCu7Yic/WdKT28/HNnqpsYwMMuB9HEX+yzLAoHdIGmCtI
	 uYMIJriVuoQ5AIVohjsQFOcON2LOlY+026JcvP3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.2 099/242] 9p: free the session after a grace period
Date: Fri, 23 Oct 2026 18:39:01 +0200
Message-ID: <20261023163716.123054212@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit bcec7fc2e224088daf94448d663b02e0d0b9c717 upstream.

v9fs_vfs_get_link_dotl() reads ->cache from the v9fs_session_info in
sb->s_fs_info to decide whether the symlink target sits in the page
cache. It does that before it looks at the dentry, so it also does it in
rcu pathwalk mode. Without loose or metadata caching the dentries have
no ->d_revalidate() that would make the walk leave rcu mode before it
gets there.

v9fs_kill_super() frees the session and clears sb->s_fs_info without
waiting for a grace period. Right now a pathwalk can't still be in
v9fs_vfs_get_link_dotl() at that point, but only by accident. umount(2)
waits for a grace period in namespace_unlock() before it drops the
mount. And a mount whose last reference goes away elsewhere, like the
chdir out of a lazily unmounted directory, still gets a grace period
from bdi_unregister(). v9fs_fill_super() sets up a private bdi, so
generic_shutdown_super() unregisters it from kill_anon_super() and
bdi_remove_from_list() waits in synchronize_rcu_expedited() before
v9fs_kill_super() frees the session. That grace period protects the rcu
readers of bdi_list in the writeback code. It has nothing to do with
pathwalk.

Don't rely on it. Keep sb->s_fs_info and free the session after a grace
period.

Fixes: 712da38d134b ("9p: Enable symlink caching in page cache")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261009-work-fixes-rcu-v1-3-7446d2d335e6@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/9p/v9fs.h      | 1 +
 fs/9p/vfs_super.c | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/9p/v9fs.h b/fs/9p/v9fs.h
index a462bcbfc7da..2ac863dc8446 100644
--- a/fs/9p/v9fs.h
+++ b/fs/9p/v9fs.h
@@ -137,6 +137,7 @@ struct v9fs_session_info {
 	struct list_head slist; /* list of sessions registered with v9fs */
 	struct rw_semaphore rename_sem;
 	long session_lock_timeout; /* retry interval for blocking locks */
+	struct rcu_head rcu;	/* v9fs_vfs_get_link_dotl() reads ->cache in rcu pathwalk */
 };
 
 #define NDENTRY_TIMEOUT_NEVER (-1U)
diff --git a/fs/9p/vfs_super.c b/fs/9p/vfs_super.c
index 94d6b02c221b..79526044685c 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -173,8 +173,8 @@ static void v9fs_kill_super(struct super_block *s)
 
 	v9fs_session_cancel(v9ses);
 	v9fs_session_close(v9ses);
-	kfree(v9ses);
-	s->s_fs_info = NULL;
+	/* v9fs_vfs_get_link_dotl() may still read ->cache in rcu pathwalk */
+	kfree_rcu(v9ses, rcu);
 	p9_debug(P9_DEBUG_VFS, "exiting kill_super\n");
 }
 
-- 
2.56.0



