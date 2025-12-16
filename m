Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C51341648;
	Tue, 16 Dec 2025 11:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884812; cv=none; b=n71ik4c2tVHEjj4z6xfDO2Gp+Y/3dOv1qtWNdblYzDcX/YtlgsU+DsKWyfPcCavPQMgvlD3rEe5cXtqzvVvjABnloXReQvwEIkgMLC5bUy1rT1u1WJuUq9RpNJTbpgbChTpxbQwDRiRG6YuNzpWP7RVLy9Czjmzy/5xN2ASqy6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884812; c=relaxed/simple;
	bh=vJiF6h1j+IsIarA2e5MWyk3pAcAnRcDVt0SN8NvciCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oAMhhVrbrBeTVWtLbhm6Aqz8v4SxcJ5/cv0sNA8jMWBQSjBfPZ8yskmRrTF4Tz7wjam2Kde6NXd5vF5rldCwJ5Ve5brCfuiG9h7VMz7tF8WYlLHKREXH0cd3ZRUWsZ1HBuilccQQVjaDp1RyjFth+JZ05DlCeapZlSZfPBhHDDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=usHViSEQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="usHViSEQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E10C4CEF1;
	Tue, 16 Dec 2025 11:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884812;
	bh=vJiF6h1j+IsIarA2e5MWyk3pAcAnRcDVt0SN8NvciCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=usHViSEQ5PPk5sEPs8cZg0PJ7sw7ZumOzlA5rEEUniDk2jIHJ24CAo3NC1RZQ1/A3
	 XbZoQez49FCegS3YWTOFfaVsHIXJBytP82cN8LM+mfblsBec0wnNDnGa/OK48+6oCR
	 ABc36dIPketZ9ML/jfuzZIPg3vaLSujJUnP6JPXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	NeilBrown <neilb@suse.de>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 306/354] nfs/vfs: discard d_exact_alias()
Date: Tue, 16 Dec 2025 12:14:33 +0100
Message-ID: <20251216111331.998385521@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

From: NeilBrown <neilb@suse.de>

[ Upstream commit 3ff6c8707c9a0116d00982851ec1216a42053ace ]

d_exact_alias() is a descendent of d_add_unique() which was introduced
20 years ago mostly likely to work around problems with NFS servers of
the time.  It is now not used in several situations were it was
originally needed and there have been no reports of problems -
presumably the old NFS servers have been improved.  This only place it
is now use is in NFSv4 code and the old problematic servers are thought
to have been v2/v3 only.

There is no clear benefit in reusing a unhashed() dentry which happens
to have the same name as the dentry we are adding.

So this patch removes d_exact_alias() and the one place that it is used.

Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Link: https://lore.kernel.org/r/20250226062135.2043651-2-neilb@suse.de
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 0f900f11002f ("NFS: Initialise verifiers for visible dentries in _nfs4_open_and_get_state")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dcache.c            | 46 ------------------------------------------
 fs/nfs/nfs4proc.c      |  4 +---
 include/linux/dcache.h |  1 -
 3 files changed, 1 insertion(+), 50 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index d7814142ba7db..6b29026d25cbc 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2664,52 +2664,6 @@ void d_add(struct dentry *entry, struct inode *inode)
 }
 EXPORT_SYMBOL(d_add);
 
-/**
- * d_exact_alias - find and hash an exact unhashed alias
- * @entry: dentry to add
- * @inode: The inode to go with this dentry
- *
- * If an unhashed dentry with the same name/parent and desired
- * inode already exists, hash and return it.  Otherwise, return
- * NULL.
- *
- * Parent directory should be locked.
- */
-struct dentry *d_exact_alias(struct dentry *entry, struct inode *inode)
-{
-	struct dentry *alias;
-	unsigned int hash = entry->d_name.hash;
-
-	spin_lock(&inode->i_lock);
-	hlist_for_each_entry(alias, &inode->i_dentry, d_u.d_alias) {
-		/*
-		 * Don't need alias->d_lock here, because aliases with
-		 * d_parent == entry->d_parent are not subject to name or
-		 * parent changes, because the parent inode i_mutex is held.
-		 */
-		if (alias->d_name.hash != hash)
-			continue;
-		if (alias->d_parent != entry->d_parent)
-			continue;
-		if (!d_same_name(alias, entry->d_parent, &entry->d_name))
-			continue;
-		spin_lock(&alias->d_lock);
-		if (!d_unhashed(alias)) {
-			spin_unlock(&alias->d_lock);
-			alias = NULL;
-		} else {
-			dget_dlock(alias);
-			__d_rehash(alias);
-			spin_unlock(&alias->d_lock);
-		}
-		spin_unlock(&inode->i_lock);
-		return alias;
-	}
-	spin_unlock(&inode->i_lock);
-	return NULL;
-}
-EXPORT_SYMBOL(d_exact_alias);
-
 static void swap_names(struct dentry *dentry, struct dentry *target)
 {
 	if (unlikely(dname_external(target))) {
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 6342d360732d2..7fe71aaa18666 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3152,9 +3152,7 @@ static int _nfs4_open_and_get_state(struct nfs4_opendata *opendata,
 	if (d_really_is_negative(dentry)) {
 		struct dentry *alias;
 		d_drop(dentry);
-		alias = d_exact_alias(dentry, state->inode);
-		if (!alias)
-			alias = d_splice_alias(igrab(state->inode), dentry);
+		alias = d_splice_alias(igrab(state->inode), dentry);
 		/* d_splice_alias() can't fail here - it's a non-directory */
 		if (alias) {
 			dput(ctx->dentry);
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 3d53a60145911..51cc601b863d0 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -242,7 +242,6 @@ extern struct dentry * d_splice_alias(struct inode *, struct dentry *);
 extern struct dentry * d_add_ci(struct dentry *, struct inode *, struct qstr *);
 extern bool d_same_name(const struct dentry *dentry, const struct dentry *parent,
 			const struct qstr *name);
-extern struct dentry * d_exact_alias(struct dentry *, struct inode *);
 extern struct dentry *d_find_any_alias(struct inode *inode);
 extern struct dentry * d_obtain_alias(struct inode *);
 extern struct dentry * d_obtain_root(struct inode *);
-- 
2.51.0



