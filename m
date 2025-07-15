Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389A42EAB8E;
	Tue, 15 Jul 2025 13:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586142; cv=none; b=r2FESR0oflhMvk3GZ6EnfCjVieqZ1EXxhA9jBJULNns0a7LeAOLy49dgwBIX+AUfBVIPeib7ej/UylCcwwVfrUePlCkHmrIcAiTG/e468uXIZdgE152t/7nZ2u8q/knH14lJPZ+473RB+/CpuNRUsTpQflXqNE7bkYoDCtXynYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586142; c=relaxed/simple;
	bh=AotPO7yYcUlRa1Cg70OYHCglqQELskYLDUUMkfx4w9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NcPcNhzD6awq5Jmb01rysU9n/61U0v2R1U/+61kun9bUtqFj3BS+PGakRPQ19uZN5+8LutPyTctW5Y8THz2B5H5CI9Mv1LVItKIoxQDhBE3psGQa12/uVrIPwZ8TJgjczg6a0FTHpgSZkjJu4bWPYU1oL9GEV12NYtH9DcOmYtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jqzAk05f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jqzAk05f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0824C4CEF1;
	Tue, 15 Jul 2025 13:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586142;
	bh=AotPO7yYcUlRa1Cg70OYHCglqQELskYLDUUMkfx4w9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jqzAk05flPvgGMWTw5hDVdu6J5OCK3JiynG5uBqlgAeu2mGF/5AkrQnsStnn7iRBw
	 S9CPs/hNQrLVfD6bdm3GBRKpiArlzUtqJ5gSSQnISMsPqqtQNX1xC3rLxDw0310zzT
	 hBIM+1IjBllup1KkkjgFkQxgerSDapITKBpQUqW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@brown.name>,
	Christian Brauner <brauner@kernel.org>,
	NeilBrown <neil@brown.name>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 04/77] fix proc_sys_compare() handling of in-lookup dentries
Date: Tue, 15 Jul 2025 15:13:03 +0200
Message-ID: <20250715130751.859031138@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130751.668489382@linuxfoundation.org>
References: <20250715130751.668489382@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit b969f9614885c20f903e1d1f9445611daf161d6d ]

There's one case where ->d_compare() can be called for an in-lookup
dentry; usually that's nothing special from ->d_compare() point of
view, but... proc_sys_compare() is weird.

The thing is, /proc/sys subdirectories can look differently for
different processes.  Up to and including having the same name
resolve to different dentries - all of them hashed.

The way it's done is ->d_compare() refusing to admit a match unless
this dentry is supposed to be visible to this caller.  The information
needed to discriminate between them is stored in inode; it is set
during proc_sys_lookup() and until it's done d_splice_alias() we really
can't tell who should that dentry be visible for.

Normally there's no negative dentries in /proc/sys; we can run into
a dying dentry in RCU dcache lookup, but those can be safely rejected.

However, ->d_compare() is also called for in-lookup dentries, before
they get positive - or hashed, for that matter.  In case of match
we will wait until dentry leaves in-lookup state and repeat ->d_compare()
afterwards.  In other words, the right behaviour is to treat the
name match as sufficient for in-lookup dentries; if dentry is not
for us, we'll see that when we recheck once proc_sys_lookup() is
done with it.

While we are at it, fix the misspelled READ_ONCE and WRITE_ONCE there.

Fixes: d9171b934526 ("parallel lookups machinery, part 4 (and last)")
Reported-by: NeilBrown <neilb@brown.name>
Reviewed-by: Christian Brauner <brauner@kernel.org>
Reviewed-by: NeilBrown <neil@brown.name>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/inode.c       |  2 +-
 fs/proc/proc_sysctl.c | 18 +++++++++++-------
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 695471fa24fe5..de5ae2e5a97df 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -54,7 +54,7 @@ static void proc_evict_inode(struct inode *inode)
 
 	head = ei->sysctl;
 	if (head) {
-		RCU_INIT_POINTER(ei->sysctl, NULL);
+		WRITE_ONCE(ei->sysctl, NULL);
 		proc_sys_evict_inode(inode, head);
 	}
 }
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 7c5d472b193f8..1a22aa43e740d 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -910,17 +910,21 @@ static int proc_sys_compare(const struct dentry *dentry,
 	struct ctl_table_header *head;
 	struct inode *inode;
 
-	/* Although proc doesn't have negative dentries, rcu-walk means
-	 * that inode here can be NULL */
-	/* AV: can it, indeed? */
-	inode = d_inode_rcu(dentry);
-	if (!inode)
-		return 1;
 	if (name->len != len)
 		return 1;
 	if (memcmp(name->name, str, len))
 		return 1;
-	head = rcu_dereference(PROC_I(inode)->sysctl);
+
+	// false positive is fine here - we'll recheck anyway
+	if (d_in_lookup(dentry))
+		return 0;
+
+	inode = d_inode_rcu(dentry);
+	// we just might have run into dentry in the middle of __dentry_kill()
+	if (!inode)
+		return 1;
+
+	head = READ_ONCE(PROC_I(inode)->sysctl);
 	return !head || !sysctl_is_seen(head);
 }
 
-- 
2.39.5



