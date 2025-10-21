Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6614927AC5C;
	Tue, 21 Oct 2025 20:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077043; cv=none; b=A8tR/Al+RRtrfAiovfe6/9f6Of9mzaHTAT8IE8wLqlcxuSQvLmjefNDpRsR9aH1LYYlgDbE4B4wtXh6nmpdAVFQE8xSMNHwjLqzvdyR3XQI/wwnQqV3GRQGjWP06C2PzELwB4cHSLDP1eE233stKA7xjT5VB0HWInm52s264qlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077043; c=relaxed/simple;
	bh=sX9DZVObilYD4skcXOGYg9x/b2Llx1kKdkux5ScjdLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jFGoqC8mM0n8tD9D2t7lT0Ybi9Era8H5vSWBxwc8MTRtZfvfBJfbLme6uw46yv0TDjcQb9p36DZuwkSb2nFJSR7cV8O75bD2dKARyxIJREYUUbCFqINGsVQevxTQzMJVXv4zs6bR5APgfYOAnv+DNT0ByYmHY//ztnDw7/r2oXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jPSXdfXq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jPSXdfXq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9661EC4CEF1;
	Tue, 21 Oct 2025 20:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077041;
	bh=sX9DZVObilYD4skcXOGYg9x/b2Llx1kKdkux5ScjdLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jPSXdfXqmv2z44LSDlaYyoQVaABpCT/RkPOJpPp5qToHWCmhJdc64z5I/f1wJ6iUC
	 j6SFeN0iHwBwnrY+vlNEH2keJMujG2iXYEGKyqzFMdXWVksmN0QRcY0CltJxo7nV8s
	 SP+tEFoUwg+rN9fg+GmWv/Fu2u99kM07eGJ+Y1iY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 117/136] d_alloc_parallel(): set DCACHE_PAR_LOOKUP earlier
Date: Tue, 21 Oct 2025 21:51:45 +0200
Message-ID: <20251021195038.784060452@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit e95db51c81f54dd12ea465b5127e4786f62a1095 ]

Do that before new dentry is visible anywhere.  It does create
a new possible state for dentries present in ->d_children/->d_sib -
DCACHE_PAR_LOOKUP present, negative, unhashed, not in in-lookup
hash chains, refcount positive.  Those are going to be skipped
by all tree-walkers (both d_walk() callbacks in fs/dcache.c and
explicit loops over children/sibling lists elsewhere) and
dput() is fine with those.

NOTE: dropping the final reference to a "normal" in-lookup dentry
(in in-lookup hash) is a bug - somebody must've forgotten to
call d_lookup_done() on it and bad things will happen.  With those
it's OK; if/when we get around to making __dentry_kill() complain
about such breakage, remember that predicate to check should
*not* be just d_in_lookup(victim) but rather a combination of that
with !hlist_bl_unhashed(&victim->d_u.d_in_lookup_hash).  Might
be worth considering later...

Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Stable-dep-of: 56094ad3eaa2 ("vfs: Don't leak disconnected dentries on umount")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/dcache.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2475,13 +2475,19 @@ struct dentry *d_alloc_parallel(struct d
 	unsigned int hash = name->hash;
 	struct hlist_bl_head *b = in_lookup_hash(parent, hash);
 	struct hlist_bl_node *node;
-	struct dentry *new = d_alloc(parent, name);
+	struct dentry *new = __d_alloc(parent->d_sb, name);
 	struct dentry *dentry;
 	unsigned seq, r_seq, d_seq;
 
 	if (unlikely(!new))
 		return ERR_PTR(-ENOMEM);
 
+	new->d_flags |= DCACHE_PAR_LOOKUP;
+	spin_lock(&parent->d_lock);
+	new->d_parent = dget_dlock(parent);
+	hlist_add_head(&new->d_sib, &parent->d_children);
+	spin_unlock(&parent->d_lock);
+
 retry:
 	rcu_read_lock();
 	seq = smp_load_acquire(&parent->d_inode->i_dir_seq);
@@ -2565,8 +2571,6 @@ retry:
 		return dentry;
 	}
 	rcu_read_unlock();
-	/* we can't take ->d_lock here; it's OK, though. */
-	new->d_flags |= DCACHE_PAR_LOOKUP;
 	new->d_wait = wq;
 	hlist_bl_add_head(&new->d_u.d_in_lookup_hash, b);
 	hlist_bl_unlock(b);


