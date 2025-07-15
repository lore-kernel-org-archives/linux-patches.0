Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18562E499D;
	Tue, 15 Jul 2025 13:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586735; cv=none; b=KvecGEM15iPizAzWmlvMe+92+ebLWhq75PkgWorKDsszsdjFOmkl2nu6fIF9lhyJ0zYRxYMu1H3jknGVT7K7TIhCmjsLoF/DeXL6fswL4ofsV+ii67Vu41Zw5GErcslQ+faiiiljlMvT0QR4jAh7QxvfDTrm4SYEtk0XnUZRz8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586735; c=relaxed/simple;
	bh=pWh2azQe3VoM8ovsN2AO+viudn1PdVIzOT6XQzsR5qo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ol1CGi2Ov5osULGXiAy61W+STEljoK1cyWR4luehqrMBtB1amKitErooP+8jhiQVBZuAWGvj74blgbtQ6GsHpp0uuCoho5ExGx2eZMZxkCZaeVrzzoym3+MI9QMqkVp9/Ju8zrQb+xMcd9Hyvap+RuQtxo5xoXlmCOKqquEFXVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AHPIMA4r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AHPIMA4r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14CADC4CEE3;
	Tue, 15 Jul 2025 13:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586735;
	bh=pWh2azQe3VoM8ovsN2AO+viudn1PdVIzOT6XQzsR5qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AHPIMA4rCHCsAhoEUrERHpDjMh1/p1DPRhmtoG3dZ0DMwXZWa8c2+mkebifEpowvN
	 ljFpaKGwu9mJBsFk01vBQOKKtQPI7M1eRe6cNjqaD4CHb+FoPkB/6SZMfncjeG5hWQ
	 BARs5HZRhE2S01osSBIlEGYjWjcX0xBxeHk9kgr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@brown.name>,
	Christian Brauner <brauner@kernel.org>,
	NeilBrown <neil@brown.name>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 021/192] fix proc_sys_compare() handling of in-lookup dentries
Date: Tue, 15 Jul 2025 15:11:56 +0200
Message-ID: <20250715130815.713979082@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index a3eb3b740f766..3604b616311c2 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -42,7 +42,7 @@ static void proc_evict_inode(struct inode *inode)
 
 	head = ei->sysctl;
 	if (head) {
-		RCU_INIT_POINTER(ei->sysctl, NULL);
+		WRITE_ONCE(ei->sysctl, NULL);
 		proc_sys_evict_inode(inode, head);
 	}
 }
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index cc9d74a06ff03..08b78150cdde1 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -918,17 +918,21 @@ static int proc_sys_compare(const struct dentry *dentry,
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



