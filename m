Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062682;
	b=1oIiCkDSadqprKnIGAZ22jSxeHFf19VzRazM4Nzv2cD8v/oJB/t0Hgp7CYGGkR9ZHMSL
	 LrW59fW9Ctc11R0y/k4KgZTN0SoK9VgdhsKEX8cBYeMKUna2UNJ+IavOZD6pSCrFDjmXU
	 sxQwK0vm6itNy9uY+N/kSNB4acuFLHYYUnBBTeawPFOg2kAoUlTJUX1i4g9Xx5a2zWrjk
	 sl496RrcRyefk8lOSDIxW0uv8Kn+EHi2rSJ4xNVsZ74yW/N+n8dECDRU/AIv10mvNmT5R
	 SiiwU7L4o0Z61uI7sP+q2h6wVOONYb14FEoS6Lze4PvfEPAggjfT1ikVE0Pd03R2jbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062682;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QIWN0xEHUumODhdotngZrHl/0AA+RLhlakmGVy/8t4Q=;
	b=jqvUfmM7orbBj+c5rz10bfJ/s/AUwHPGtasoYJLBYqueL6lN3jgr+3o7leqLD84Zvs0u
	 aYTeM9LDh9M3VNC7rc5vFq/D4ahJxD6rp6iDy27Mux1xg5YVxO16ujKWAkHyLJIX2nacr
	 bwMSgRKMFTS2lkBR22wGYhvWpR30mZ36dDwkq+cRyfxxuxg/DbXOZRD5plqSDdc6ozMoh
	 6hGtuMUwkFlsanr84VEnuANpGvtTl5A0kVBcp32UEPgcYJKZnPQx8M2Bf37gcu+/lqUFh
	 FR7S1+62hC47QX1GnzZp1TW4PUyD3wYorpqGz/9eiyGFM+/ekw3YJrW4mE+j0yd0WeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="f0rSn7t/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F180606A326;
	Sat,  7 Nov 2026 14:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f0rSn7t/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C7AD1F0089F;
	Sat,  7 Nov 2026 14:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062681;
	bh=QIWN0xEHUumODhdotngZrHl/0AA+RLhlakmGVy/8t4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f0rSn7t/15uil92RTSohr8tEv3yaDjyyFsQmxIAC4IDeGJeUG98mjqTVOja+CHFVc
	 0EziDNpbdR4Nv9vu58kZ9w+7I3mVHFJjc88+e4v2q6jS99PFSyXV9SryBd1phNtX/4
	 z9ddAMs0gLikDkem7zM9Q0PjuE2UOluLkzDiNRrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1531/1536] fs: dont fail __d_obtain_alias() for unlinked inodes
Date: Sat,  7 Nov 2026 08:59:07 -0500
Message-ID: <20261107135040.883993115@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 482b8b6d0eeeb..ff9d401e18539 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -389,10 +389,9 @@ static void dentry_free(struct dentry *dentry)
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
@@ -1966,12 +1965,7 @@ static struct dentry *__d_obtain_alias(struct inode *inode, bool disconnected)
 
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
 
@@ -1983,10 +1977,7 @@ static struct dentry *__d_obtain_alias(struct inode *inode, bool disconnected)
 
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



