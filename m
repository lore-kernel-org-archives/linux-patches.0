Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062761;
	b=4NrkL6agGpRz+c9NQ8E/3h2LWn6k/pjlB4jb2Hyn44H5BGuMXKB6M0IT62oJNpmaoJbd
	 Hq4VpbuXLgBqFiGj5Fd3nd8/+j9MKWll3c6/sCvLvYXDXVTxwU4hrgbVH3KRoa+uRgObn
	 ROiLbwcLQy9s0At3b6ZlNsqCQ9Hnr1GpZDuCwhhlkIU+xFKXYRM/iM48ydbbFKEpscDzM
	 OISIJEfANCjRPSfSLQTH3tgzp+tz6Ej7qgQegp0prUSmosnOMffah2R1Cn9l+s3YX3ZlS
	 HDljg5wCLIkUWwv+SrW/HsNnm8d0WFmL8Jtly6hRaVkopMFYLL/Igj1xewVoFFjweOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062761;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lIRd2byUhxkWKiwME0rKq4Nnc+YmG/1dwVY07tqT0oM=;
	b=J3EtAlF+B3af3dTRPDUiTzkUA2LzMjZKP97QaJzjpMFP6KGh4Lh1R1D6VgPGyIr7ifub
	 sdTc2fniGxeKgDXYKtXpDCS49rrNxyhgsrrbOplhIloXWcGfVSy22dEgnMsR2dQJbLXXf
	 w6ZbqhY2/0m38UYCCqvkn74ff3tFcrM3OSnW8bJOEx7LBtBJ/elHDE2yKiOtE/ZsGtK+I
	 sd425rn+bt65mnBnCZPMpnezu3GzCM2fjZB4N8MOOkAi9A4K+RmJKESO7SVUoqPxtXd0o
	 9LaJ7rZaMsa/kZL3lHmkb95Yh5eXi0KeE5LSteeqdxNSJ+fFL/1+4xRKs6PnODGfs4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rYcIRIMJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFA9606A32C;
	Sat,  7 Nov 2026 14:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rYcIRIMJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C5781F0089F;
	Sat,  7 Nov 2026 14:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062760;
	bh=lIRd2byUhxkWKiwME0rKq4Nnc+YmG/1dwVY07tqT0oM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rYcIRIMJX/s0GVWXtmzMVANSHw4jIwNKM5A5nn6DGS2ezCcXLSrQyG5FPzqFmUYqV
	 d10smwloS9IUgGa4Wze5V9yF5AB/lFIG7INlTwe55uem0xzCGOENZCuVWYEEOngSlS
	 likx4chqvMQSzR1d5jQW/H/ECJR2d4hzKlJRNtQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Daehyeon Ko <4ncienth@gmail.com>
Subject: [PATCH 6.18 071/869] fs: make sure to call fsnotify_inoderemove() only once when inode is dead
Date: Sat,  7 Nov 2026 08:45:53 -0500
Message-ID: <20261107134854.962638087@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit 669bb5af15d41a21359d00a441490f87a88eb52a ]

Daehyeon reported a race wherein fsnotify_removeinode() can be called
when inode still has a live alias.  This can lead to several undesired
outcomes such as crashes in fsnotify code or avoidance of inode mark
notifications.

Check that inode is really "dead", meaning no nlink and no more aliases
before calling fsnotify_inoderemove() for final cleanup of inode marks.
Also do not allow open_by_handle() to add new aliases to a "dead" inode.

Ideally, we'd call fsnotify_inoderemove() once last inode reference is
dropped to make things simpler. Alas fsnotify inode marks currently hold
inode references and thus this doesn't work. Once we teach fsnotify to
avoid holding inode references, these games with dead inodes can go as
well.

Reported-and-tested-by: Daehyeon Ko <4ncienth@gmail.com>
Closes: https://lore.kernel.org/linux-fsdevel/20260827045007.3831259-1-4ncienth@gmail.com/
CC: stable@vger.kernel.org
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260902164924.1333135-2-jack@suse.cz
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dcache.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 5ee1c3d592c85..1b4c210338022 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -442,6 +442,17 @@ static void dentry_free(struct dentry *dentry)
 		call_rcu(&dentry->d_u.d_rcu, __d_free);
 }
 
+/*
+ * If inode is unlinked and doesn't have any aliases (i.e., all fds pointing to
+ * it are closed), it is pretty much dead. Except that file handle lookup could
+ * still revive it which causes issues to fsnotify. So once inode reaches this
+ * state we make sure to block creating any new aliases.
+ */
+static bool inode_notify_dead(struct inode *inode)
+{
+	return !inode->i_nlink && hlist_empty(&inode->i_dentry);
+}
+
 /*
  * Release the dentry's inode, using the filesystem
  * d_iput() operation if defined.
@@ -451,14 +462,16 @@ static void dentry_unlink_inode(struct dentry * dentry)
 	__releases(dentry->d_inode->i_lock)
 {
 	struct inode *inode = dentry->d_inode;
+	bool notify_dead;
 
 	raw_write_seqcount_begin(&dentry->d_seq);
 	__d_clear_type_and_inode(dentry);
 	hlist_del_init(&dentry->d_u.d_alias);
 	raw_write_seqcount_end(&dentry->d_seq);
+	notify_dead = inode_notify_dead(inode);
 	spin_unlock(&dentry->d_lock);
 	spin_unlock(&inode->i_lock);
-	if (!inode->i_nlink)
+	if (notify_dead)
 		fsnotify_inoderemove(inode);
 	if (dentry->d_op && dentry->d_op->d_iput)
 		dentry->d_op->d_iput(dentry, inode);
@@ -2022,7 +2035,12 @@ static struct dentry *__d_obtain_alias(struct inode *inode, bool disconnected)
 
 	sb = inode->i_sb;
 
-	res = d_find_any_alias(inode); /* existing alias? */
+	spin_lock(&inode->i_lock);
+	if (!inode_notify_dead(inode))
+		res = __d_find_any_alias(inode);	/* existing alias? */
+	else
+		res = ERR_PTR(-ESTALE);
+	spin_unlock(&inode->i_lock);
 	if (res)
 		goto out;
 
@@ -2034,7 +2052,10 @@ static struct dentry *__d_obtain_alias(struct inode *inode, bool disconnected)
 
 	security_d_instantiate(new, inode);
 	spin_lock(&inode->i_lock);
-	res = __d_find_any_alias(inode); /* recheck under lock */
+	if (!inode_notify_dead(inode))
+		res = __d_find_any_alias(inode);	/* recheck under lock */
+	else
+		res = ERR_PTR(-ESTALE);
 	if (likely(!res)) { /* still no alias, attach a disconnected dentry */
 		unsigned add_flags = d_flags_for_inode(inode);
 
-- 
2.53.0



