Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FACC13FD86;
	Tue, 26 Aug 2025 12:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212717; cv=none; b=IbazcHJulW2K9qItAPLbDzgSlSxQlm5CicOFnvH4FQhDntln5HJmAZ5kH5+qOGCdTTPVYoegmCtAQTSubeaKBNIVFa1YOjhu1xqNsxOO0RJvdeoGZZ37WXI8vjapDiLrbABwzAUN+jkskrjCGxnozLvbRKBgCpabw6yRYzU+A2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212717; c=relaxed/simple;
	bh=LpZM6NHQwTkst2t78qOjdJVi/op7pGjRzdqQH9KQ4U8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bhWEggaGy8xsWyagjAVX5CLXO7yA43M89p3ml3u+mbeQNrs/ebr2w6L6qY5uSdSORFUBueyT7jRXQMPlqk/zimGs30qiggeqzbLKalEHUXZpaDdwn9QC16B6dXoLsSlMEZzeWSrVykVlsaQr96EaZzneGggOhJ4q6CVFAN57+Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bcfp6+rl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bcfp6+rl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03CA8C4CEF4;
	Tue, 26 Aug 2025 12:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212717;
	bh=LpZM6NHQwTkst2t78qOjdJVi/op7pGjRzdqQH9KQ4U8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bcfp6+rlHdYD7uf6BSxTVO+Z+K6R4wc0+rRcbaf5bfF4t/3707oQjMFORgr6t6OLV
	 7OWopFhF3Uce14mJo2hml77R6j1cpu3HsXl7Z8bTW+A0JauwwNsBsEd6bdRDI8ZokG
	 7g40IpUBgtwUIdEIXNMEy1TSmBL06fixm6IlAIRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+169de184e9defe7fe709@syzkaller.appspotmail.com,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 075/587] better lockdep annotations for simple_recursive_removal()
Date: Tue, 26 Aug 2025 13:03:44 +0200
Message-ID: <20250826110954.841628673@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 2a8061ee5e41034eb14170ec4517b5583dbeff9f ]

We want a class that nests outside of I_MUTEX_NORMAL (for the sake of
callbacks that might want to lock the victim) and inside I_MUTEX_PARENT
(so that a variant of that could be used with parent of the victim
held locked by the caller).

In reality, simple_recursive_removal()
	* never holds two locks at once
	* holds the lock on parent of dentry passed to callback
	* is used only on the trees with fixed topology, so the depths
are not changing.

So the locking order is actually fine.

AFAICS, the best solution is to assign I_MUTEX_CHILD to the locks
grabbed by that thing.

Reported-by: syzbot+169de184e9defe7fe709@syzkaller.appspotmail.com
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/libfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index f5566964aa7d..b913ab238cc1 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -610,7 +610,7 @@ void simple_recursive_removal(struct dentry *dentry,
 		struct dentry *victim = NULL, *child;
 		struct inode *inode = this->d_inode;
 
-		inode_lock(inode);
+		inode_lock_nested(inode, I_MUTEX_CHILD);
 		if (d_is_dir(this))
 			inode->i_flags |= S_DEAD;
 		while ((child = find_next_child(this, victim)) == NULL) {
@@ -622,7 +622,7 @@ void simple_recursive_removal(struct dentry *dentry,
 			victim = this;
 			this = this->d_parent;
 			inode = this->d_inode;
-			inode_lock(inode);
+			inode_lock_nested(inode, I_MUTEX_CHILD);
 			if (simple_positive(victim)) {
 				d_invalidate(victim);	// avoid lost mounts
 				if (d_is_dir(victim))
-- 
2.39.5



