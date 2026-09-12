Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA78360EF5;
	Sat, 12 Sep 2026 08:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200729; cv=none; b=HBu961qmWOK1Rh9kLuGvTBAiTJcd/C8VwJEQKEKAAerBLaYVkbvXQqkRgT4+GmxVAIDCewzpXTk/seQxWTG5OHrxj+qefLd637AkSDe7Zi/T0Ds2qE5dH4+bNcCTGje+n77AmTpTH6F0XSbaC5onyOUft5l18oZBPZ+536lBemc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200729; c=relaxed/simple;
	bh=BnIXBNpBO/OLOjdK3SbqZaxIn8HHD5LsJyfgbJkAT+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C3AgO7L+9tMJtx1OcAOiH/4TS9lIa8jvRWDTU+8fMEytt0SSPyQj8Nw6LveDumD0y/PGUMygbi3hlksxrHEzQnV+ermScCu5A5MrqZd7B+h+bQUuspc2aLn5fgSsHih1nApK+3oVrC3RTaz2+Ekd8V37sgkhoQ5pnm9vODClTK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WJfhCz63; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WJfhCz63"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 066301F000FF;
	Sat, 12 Sep 2026 08:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200728;
	bh=KFcK+BlekXYXq9UrSRj2mo9XrwxvLHkUAMc9aEkQHbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WJfhCz63QNqjD436ZjHqCtGTIXH4TBIheKDZn9RJJNlyXXZKKqFcLpcKZvnpO7nBJ
	 p3qDcOuSfPVQOfJbd6R0Aa5WzJkZ4iIuyA2g+T1MY6fzejywdUpqgJrsswTRJyxXg4
	 qvVp0u/I+gzs9BW6h2uw5091WVmHoxYYlFKCfGjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0849/1815] dcache: keep shrink_dcache_for_umount() making progress on busy roots
Date: Sat, 12 Sep 2026 08:43:19 +0200
Message-ID: <20260912065708.849904155@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 78db93943210df61c8446aae35af6836e2cf04aa ]

Commit e9895609cb7f ("wind ->s_roots via ->d_sib instead of ->d_hash")
moved secondary roots from ->d_hash to ->d_sib.  Secondary roots are now
d_unhashed(), so __d_drop() returns without removing them from
->s_roots.  Consequently, d_drop() in do_one_tree() no longer
guarantees progress through the list.

If a secondary root is still busy once do_one_tree() is done with it,
its final dput() cannot evict it.  The root remains ->s_roots.first and
the loop selects it forever, holding ->s_umount for write and repeatedly
reporting the same dentry.

The root does not need a leaked reference of its own for that.  Every
child pins its parent (d_alloc() takes a reference on it) and
umount_check() deliberately reports a busy descendant instead of
complaining about its ancestors, so a single leaked dentry reference
anywhere below a secondary root is enough.  For filesystems that build
->s_root with d_obtain_root() - nfs, ceph, nilfs2 snapshot mounts -
that is the entire tree.

Before e9895609cb7f, ___d_drop() special-cased IS_ROOT dentries and
removed them from ->s_roots regardless of their refcount, so the
d_drop() in do_one_tree() detached the root from the superblock no
matter what.  Commit 9c8c10e262e0 ("more graceful recovery in
umount_collect()") deliberately made busy dentries nonfatal: report
them and finish the unmount rather than BUG() while holding
->s_umount.

Restore that by detaching the root in do_one_tree() itself, next to
the d_drop() that used to do it.  That covers both callers - the
->s_roots loop and ->s_root, which for the filesystems above is a
secondary root as well.  In the normal case dentry_unlist() finds
->d_sib already unhashed when eviction occurs.

A permanently leaked reference remains leaked after unmount, as it did
before e9895609cb7f; if the extra reference is merely delayed, its
final dput() may run after teardown has advanced.  Leaving the root on
->s_roots is not an alternative: the superblock would then be freed
with a live dentry still linked into it, and that dentry's
dentry_unlist() would take ->s_roots_lock on freed memory.

Christian Brauner <brauner@kernel.org> says:
Moved the ->s_roots removal from the shrink_dcache_for_umount() loop
into do_one_tree(), so a busy ->s_root obtained from d_obtain_root() is
detached on the first pass instead of being reported a second time when
the loop picks it off ->s_roots.  Extended the commit message with the
pinned-ancestor case.

Fixes: e9895609cb7f ("wind ->s_roots via ->d_sib instead of ->d_hash")
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260729005933.15858-1-kmehltretter@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dcache.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 3e9af9de70746..073c2ce2d4448 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1794,7 +1794,12 @@ static void do_one_tree(struct dentry *dentry)
 {
 	shrink_dcache_tree(dentry, true);
 	d_walk(dentry, dentry, umount_check);
-	d_drop(dentry);
+	spin_lock(&dentry->d_lock);
+	__d_drop(dentry);
+	/* A busy root survives the dput() below so don't leave it on ->s_roots. */
+	if (unlikely(!hlist_unhashed(&dentry->d_sib)))
+		unlink_secondary_root(dentry);
+	spin_unlock(&dentry->d_lock);
 	dput(dentry);
 }
 
-- 
2.53.0



