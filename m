Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063775;
	b=MHQB0mpv2Xz5HQEqjlsDFDSElF6b8+wTdv8Gqyxess2VuzndDsNmk2s9OJaXOia7id4E
	 PSAqq1DUysZ09fNcSkbywxcGfkEmngtkgWsXtiKVQvkKzMBX2n94R7ilOWMcW7qpqtDqs
	 iHxZII14fCHTvkUltsUia0AB9QDgeFySaWTl0+QTarb1LKiHqXjmFqkvyCjz4NCF4Rw4q
	 CVvtwWxp3z2uRboYJ3I/3q1eASiAM1regM7r1f5pW8nizpNyQS8A7GpcYqByoZxr+N7j4
	 vQ5gSag+qAqpNQPYXPl/hG4i63YKgrG1Is0kkswee4v2d/7QfRyCr0/cTnsOHwzttxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063775;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/Dq3eH4TvPXoeBDyCX0UQ2bCgHRiGnLQzTd6ViuE8CE=;
	b=ZB8i+U8nqc/Ibe+Cbml0lyrQI8BvSIiXgcJT9pz08hYuTPW2IUbBBvQvSbKdR2udlWjj
	 AhA3twtzRmA2kB9iTmPzAV57Ci/4ODxYC3oIP9XaLxl3z8wI1l47tJB6ouB44pkDSutZW
	 fIHtG2cV2XG/5wytS53bEawanF3zeCJIJ0nkaVEgrRuog1xdrBYYiN2VzPcP7BFMBprWN
	 vFy8/RaTk0H1DAC0bLWDnD7Ug1lPy0+sQrn54ahGX2DVErlWvF17oRMMstt+fUV6CexIr
	 p7zE8WvPcnyrdy3lqmdoSbPurATduYcQBeluf1PODZWZufs74bz2GSmm44O5ipt0JwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m7wHhfm8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4001360A2615;
	Sat,  7 Nov 2026 15:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m7wHhfm8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E16201F0089F;
	Sat,  7 Nov 2026 15:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063775;
	bh=/Dq3eH4TvPXoeBDyCX0UQ2bCgHRiGnLQzTd6ViuE8CE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m7wHhfm8rRV0YNt17tJC9rxC8bdaRFN/fH7s8VPA0Xo5meS9h4M0o42zueTu5eGf7
	 d9Ti1jYfRtjhGacARXGau3MHcQSGue8e9NJmpyKI2hKAAQ5Vrkfyu2qJzoDm+SzV+/
	 NeVO2vGE+zSiBqgzO+PU9Ryth4VJ26SH9nn+DgE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 865/869] fs: dont fail __d_obtain_alias() for unlinked inodes
Date: Sat,  7 Nov 2026 08:59:07 -0500
Message-ID: <20261107134922.142358856@linuxfoundation.org>
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

[ Upstream commit a522dd871024a0f065bfa7638afdb929607f58fc ]

Commit 669bb5af15d4 ("fs: make sure to call fsnotify_inoderemove() only
once when inode is dead") did two things. It made dentry_unlink_inode()
call fsnotify_inoderemove() only once the inode has neither links nor
aliases left. And it made __d_obtain_alias() fail with -ESTALE for an
inode in that state so that open_by_handle_at() can't create a new alias
after FS_DELETE_SELF has been reported and the inode marks are gone.

The second part is wrong for network filesystems. __d_obtain_alias()
backs d_obtain_alias() and d_obtain_root(). Those are what the
->fh_to_dentry() and ->get_parent() methods use to turn the inode they
looked up into a dentry for exportfs_decode_fh_raw(), i.e., for
open_by_handle_at() and for nfsd file handle decoding.

For a local filesystem an in-core inode without links and aliases is an
orphan that goes away on the final iput(). For a network filesystem
that's not true. i_nlink is just the link count the server last
reported and whether the object is still reachable through its file
handle is up to the server. If a file is unlinked while it is still
open elsewhere, e.g., by another NFSv4 client or by a process on the
server, the server keeps the object alive and its file handle stays
valid. nfs_fh_to_dentry() fetches the attributes for such a handle,
nfs_fhget() sets i_nlink to 0 from them, the new inode has no aliases
yet and so __d_obtain_alias() now fails with -ESTALE. The same applies
to fuse_get_dentry() which takes i_nlink from the fuse server.
Filesystems that care about unlinked inodes already make that decision
themselves in ->fh_to_dentry(), e.g., ceph's __fh_to_dentry() fetches
the link count with CEPH_CAP_LINK_SHARED and only refuses an unlinked
inode if it isn't open.

Note that on a network filesystem i_nlink drops to zero through
attribute updates when another client unlinks the file. So the inode
might never have gone through dentry_unlink_inode() with i_nlink == 0,
i.e., fsnotify_inoderemove() might never have been called for it and
there's nothing for the -ESTALE to protect.

So drop the two checks from __d_obtain_alias() again and go back to the
unconditional alias lookup. While at it, update the comment above
inode_notify_dead() since it no longer blocks new aliases.

Amir sent this as v3 to replace 669bb5af15d4 but that commit was already
in mainline by then. So do it as a fix on top. The resulting code is
identical to v3.

This means open_by_handle_at() can again create a new alias for an
unlinked inode after FS_DELETE_SELF has been reported. Closing that file
reports a second FS_DELETE_SELF and the file has none of the inode marks
that were torn down. That's what Daehyeon's open_by_handle_at() LTP test
checks so it is expected to fail again. This needs to be handled
separately. A mark that is added through such a file while
fsnotify_destroy_marks() is still running is rejected with -ENOENT since
36ebddca56b9 ("fsnotify: prevent mark additions during connector
teardown") so it can't end up on a detached connector.

Christian Brauner <brauner@kernel.org> says:

Amir's v3 replaced 669bb5af15d4 as a whole. I turned it into an
incremental fix on top of mainline and wrote a new commit message.
Jan's Reviewed-by was given on v3 and the resulting code is identical.

Fixes: 669bb5af15d4 ("fs: make sure to call fsnotify_inoderemove() only once when inode is dead")
Cc: stable@vger.kernel.org
Reported-by: Daehyeon Ko <4ncienth@gmail.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Link: https://patch.msgid.link/CAOQ4uxg7Qt436SiKhKEJKOjtCjeB_XyTjazYF7HMyQAGGcgx2A@mail.gmail.com
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20261030-work-dcache-obtain_alias-v1-1-a1f7e44536d2@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dcache.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 04adb623e584e..3ad74a3abf9ad 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -443,10 +443,9 @@ static void dentry_free(struct dentry *dentry)
 }
 
 /*
- * If inode is unlinked and doesn't have any aliases (i.e., all fds pointing to
- * it are closed), it is pretty much dead. Except that file handle lookup could
- * still revive it which causes issues to fsnotify. So once inode reaches this
- * state we make sure to block creating any new aliases.
+ * When inode is unlinked and doesn't have any aliases (i.e., all fds pointing
+ * to it are closed) we report FS_DELETE_SELF to fsnotify and cleanup all inode
+ * marks.
  */
 static bool inode_notify_dead(struct inode *inode)
 {
@@ -2035,12 +2034,7 @@ static struct dentry *__d_obtain_alias(struct inode *inode, bool disconnected)
 
 	sb = inode->i_sb;
 
-	spin_lock(&inode->i_lock);
-	if (!inode_notify_dead(inode))
-		res = __d_find_any_alias(inode);	/* existing alias? */
-	else
-		res = ERR_PTR(-ESTALE);
-	spin_unlock(&inode->i_lock);
+	res = d_find_any_alias(inode); /* existing alias? */
 	if (res)
 		goto out;
 
@@ -2052,10 +2046,7 @@ static struct dentry *__d_obtain_alias(struct inode *inode, bool disconnected)
 
 	security_d_instantiate(new, inode);
 	spin_lock(&inode->i_lock);
-	if (!inode_notify_dead(inode))
-		res = __d_find_any_alias(inode);	/* recheck under lock */
-	else
-		res = ERR_PTR(-ESTALE);
+	res = __d_find_any_alias(inode); /* recheck under lock */
 	if (likely(!res)) { /* still no alias, attach a disconnected dentry */
 		unsigned add_flags = d_flags_for_inode(inode);
 
-- 
2.53.0



