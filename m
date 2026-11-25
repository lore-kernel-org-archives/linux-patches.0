Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623851;
	b=W3DE9GRK+Xx1CEvRMqzjhdrh+Ch08rWk0+rP/11biPyqR8eDj1oafrtGrIuA0k5hLls8
	 50LLap9w42x1ouj/X7pXWrA6FQtqiklFHoKPcTs9SE0hMiVU8Ef0Y05Mk3HxMnoENBziO
	 jIyC/8DeADQT2I7D/BaMn3qnLc/6WHBJN8eyThxWnJDD97H1UgoV4UljTmyE8zor7XAWJ
	 Ub0hORKfwtRMlKHsksepyt+BPRKJyqbo/rqrBepSOTtxDv/doQJqU3VeGR/P+i+M/95Kn
	 e4IuMmZa7B9tzedYVe+mYKmWmOIpgOGwa/uAN9jayWrHHfH7LAaBtyN5NntAJJ32WLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623851;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+IWbGJ2UHyhVmG9SMWi6SdUfW2LHuK5h2mYuAkGjs9Q=;
	b=dDx05w+XTJOMRnSWbzF9xPx+u7mZ9yO8NrhOpzKS5gUJjAAPtlMZpgnHPGJYzBLD5Bh5
	 lj8zKkRzCVdyQqh0HX05afvWtDoviHvOt8JUseDW0XaKGnyaXx2U97zLqsxRqxO2rsF3H
	 bkiwAe0OTUemmoJ+Fm5tgs1uBwyxf8/kuX0YQ0sv6+MuGEjubbhSGYIrKymTAMolusIdo
	 Z9abwZntDU3gQMc5h+1YUPgodgsOpKwr5peTP4qfJGnfHx3q/nYNMle5r2O4Kr3eVgnGT
	 At/ZZN/MF+7AtH6AqsLkaEXgu8fZkOE3uY0CXcdZKyUg81asp1TMy/qH2OowDitYXxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UJrAlL5Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E8A606A321;
	Wed, 25 Nov 2026 16:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UJrAlL5Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B72061F000C0;
	Wed, 25 Nov 2026 16:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623850;
	bh=+IWbGJ2UHyhVmG9SMWi6SdUfW2LHuK5h2mYuAkGjs9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UJrAlL5ZsEY5g35S/VZS6bvy/4S+UxijS8iOdnDHitxzpgXj+HMIjTZh9RjJk9Gd3
	 qWZZnw3Mplha18Yf2C5vioTwA1ohtscVjZjjcYafmXlFS75HyPgFv8h9KP/iDh5XA5
	 e9PpBM2SBu4Oky3jEQfp94YmZQBx7KGzUxLbR8VM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 979/990] 9p: free the session after a grace period
Date: Wed, 25 Nov 2026 15:39:06 +0100
Message-ID: <20261125143844.913684452@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 fs/9p/v9fs.h      |    1 +
 fs/9p/vfs_super.c |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/fs/9p/v9fs.h
+++ b/fs/9p/v9fs.h
@@ -147,6 +147,7 @@ struct v9fs_session_info {
 	struct list_head slist; /* list of sessions registered with v9fs */
 	struct rw_semaphore rename_sem;
 	long session_lock_timeout; /* retry interval for blocking locks */
+	struct rcu_head rcu;	/* v9fs_vfs_get_link_dotl() reads ->cache in rcu pathwalk */
 };
 
 #define NDENTRY_TIMEOUT_NEVER (-1U)
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -173,8 +173,8 @@ static void v9fs_kill_super(struct super
 
 	v9fs_session_cancel(v9ses);
 	v9fs_session_close(v9ses);
-	kfree(v9ses);
-	s->s_fs_info = NULL;
+	/* v9fs_vfs_get_link_dotl() may still read ->cache in rcu pathwalk */
+	kfree_rcu(v9ses, rcu);
 	p9_debug(P9_DEBUG_VFS, "exiting kill_super\n");
 }
 


