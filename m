Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022344;
	b=Ds92UpoEFvP8K79cLN1gD1TWwQ6KF0q04q3oJFlFdI0vYBctqNXI9FYJTgJ6RpbAgTK8
	 8wMnbEt4ZyNBiwloaIyAZ7/gYndNQq+cGAGyd98bATE23PuyOqqVN9tfY1pocepZFuvBc
	 W4MOqSpsxONJzdx1jItaPmXstbMl1Q+wmATdgbjlvXRcBvfVlb07jljB3063HXPrkJtHV
	 JGABXp/88C26dKulc5v7+5KMAK4TJtj2Ax7XFdWcCHrJ95cmqNQo5DET1/rrBnJiSneVm
	 qtGyevqxc6kcgxa6uhozuStBq1SSv1n1+6WUcpy9exrbzlLeTMVIbIH9iWpqod1WCcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022344;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6M1dJUFmTFI164+InsdhWgZdA/7Y1Hz60Z+PUGDk4FE=;
	b=lMyaSeWplIiNib8OX6vjoUGt7Ogdc63TS6QPWhFHfzhQ0iTlBPPQhTz2tUT7554OkKyP
	 Ybz0L/UwLWLFQTPWrj3p1PDZeHyMjgJwsAxFhzTCgich35m3gfCX9lczW/JuJIe/ayLjY
	 iYledJrIRxgKGZa/YUMZ7Oi+uZayO9/BGIQZJtVPdq7Y8zVPp0wFPJODGH7q+N0sEObgX
	 G1rJSFLbdHPJY0bRQF028c6HY+NrIKwTkkl1aL5WHvIVtsrAXMqfhR0HqVmIUnagi77CG
	 aaIVraQhR3YkzxbEH2mxcYzhh5v4fNfuNhZLX0P0EU8mhH3PI0KZJAZ8PUEpBtFre2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2a3uzTrL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62EB3606A32A;
	Wed, 18 Nov 2026 17:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2a3uzTrL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D631F000C5;
	Wed, 18 Nov 2026 17:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022344;
	bh=6M1dJUFmTFI164+InsdhWgZdA/7Y1Hz60Z+PUGDk4FE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2a3uzTrLnyU0fMxDL0QAyFw27Lndxnk0fGf+tzYb7Kmc47eS2R81jfKqNy1wUlw3S
	 wQocOKSa6H1AiKhzlzI2m/GZmfriLHOMeHmtDey+BTMWCg0rAHQkIiba4KF6QerL1o
	 bTAqnU0SqgSZ8vFrdLfspqnib6+3WmyumtrmwQCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2578/2651] namei: dont assert S_ISDIR on a stale rcu-walk inode
Date: Wed, 18 Nov 2026 16:03:38 +0100
Message-ID: <20261118150417.146844712@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit e227cdac03dffa896e02ed7260f9149c4c382715 ]

lookup_inode_permission_may_exec() asserts that it is only ever handed a
directory, on the grounds that link_path_walk() has already checked
d_can_lookup().  In rcu-walk that does not follow.  step_into() samples
->d_inode and validates it against ->d_seq, but link_path_walk() loads
->d_flags again afterwards, and nothing orders that load against changes
of the dentry:

  CPU0 (rcu-walk of "x/y")              CPU1
  step_into(x)
    inode = x->d_inode   // regular file
    read_seqcount_retry(&x->d_seq) == 0
    nd->inode = inode
                                        unlink("x")
                                          d_delete()  // x goes negative
                                        mkdir("x")
                                          d_instantiate()  // same dentry
  d_can_lookup(x)        // true now
  may_lookup()
    VFS_BUG_ON_INODE(!S_ISDIR(nd->inode->i_mode))

With CONFIG_PREEMPT_RCU the walker can be preempted in that window, so it
is not limited to a few instructions.  mkdir() only gets the same dentry
back if the filesystem keeps negative dentries around.  tmpfs doesn't,
ext4 does.

Apart from the assertion the stale inode is harmless, and has been there
since before the assertion was added: nd->seq no longer matches x->d_seq,
so lookup_fast(), follow_dotdot_rcu() and try_to_unlazy() all fail with
-ECHILD and the walk is redone in ref-walk, whatever the permission check
on the old inode said.

Keep the assertion for ref-walk, where the dentry is pinned and can't
change type, and skip it for rcu-walk.  No change for kernels without
CONFIG_DEBUG_VFS.

Fixes: e631df89cd5d ("fs: speed up path lookup with cheaper handling of MAY_EXEC")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namei.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index e45e30603215d..00ef70a4eaf56 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -683,8 +683,14 @@ EXPORT_SYMBOL(inode_permission);
 static __always_inline int lookup_inode_permission_may_exec(struct mnt_idmap *idmap,
 	struct inode *inode, int mask)
 {
-	/* Lookup already checked this to return -ENOTDIR */
-	VFS_BUG_ON_INODE(!S_ISDIR(inode->i_mode), inode);
+	/*
+	 * Lookup already checked this to return -ENOTDIR.  In rcu-walk that
+	 * check looks at ->d_flags after ->d_seq had been validated, so it can
+	 * see a dentry which went negative and then became a directory while
+	 * nd->inode is still the old non-directory.  Any such walk fails the
+	 * next ->d_seq check and gets redone in ref-walk.
+	 */
+	VFS_BUG_ON_INODE(!S_ISDIR(inode->i_mode) && !(mask & MAY_NOT_BLOCK), inode);
 	VFS_BUG_ON((mask & ~MAY_NOT_BLOCK) != 0);
 
 	mask |= MAY_EXEC;
-- 
2.53.0



