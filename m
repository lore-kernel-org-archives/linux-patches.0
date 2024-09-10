Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D458718B493;
	Tue, 10 Sep 2024 09:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961255; cv=none; b=qQKlRoHyl+DhJrM5Iylh2iOO89JYq7jSTeQhBEQfV9nNeMBlms/12WWp8SQfHOEoomr77kzW+APwTvTyUZi8bVnm4LJgsSOvU1RUnprv6M59dw93l8OwIjEn7zfi0LI/j0WRKoyP4yQKojNJyadUCrvjtHoG9Xziz5pJIjXXLXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961255; c=relaxed/simple;
	bh=VP0n9nwxSb46ztnMTL+ivCYO9ptZdBO9zfzEBggPeoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PTCJq+W4U4rlGM1fVo884hSEXHeZLcVPLrWL+nyO6f3YWbzk/VHrvQpYQK/AJlM/yxCPO3COLO1gOTktGk3muVUOrLi8nErVzJUt7nj+ZDoAVRYdxVOMgbvWuVMuSUuj23EP0KZRMlhR2qFy+ZSWM6pgv16nhha8WkkijXQ5e7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ekcCYS3X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ekcCYS3X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C49EC4CEC3;
	Tue, 10 Sep 2024 09:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961255;
	bh=VP0n9nwxSb46ztnMTL+ivCYO9ptZdBO9zfzEBggPeoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ekcCYS3X1qqwfibpTZLZVduFmqNGRbqS9BGoFK7dAYH7zn14OeFfdcvbMiUglr3gP
	 GKzqayh+LsK7igSVrMgibB+RtPiDj7SZbjE9VsqRFQsnvFnLhxLLsHT+1Xqo2RP1gw
	 LB6QZvFcf2LxPu1BcBN5Eiyc3CF+wxBtEygokbA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f82b36bffae7ef78b6a7@syzkaller.appspotmail.com,
	syzbot+cbe4b96e1194b0e34db6@syzkaller.appspotmail.com,
	Christian Brauner <brauner@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.10 001/375] libfs: fix get_stashed_dentry()
Date: Tue, 10 Sep 2024 11:26:38 +0200
Message-ID: <20240910092622.311269822@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit 4e32c25b58b945f976435bbe51f39b32d714052e upstream.

get_stashed_dentry() tries to optimistically retrieve a stashed dentry
from a provided location.  It needs to ensure to hold rcu lock before it
dereference the stashed location to prevent UAF issues.  Use
rcu_dereference() instead of READ_ONCE() it's effectively equivalent
with some lockdep bells and whistles and it communicates clearly that
this expects rcu protection.

Link: https://lore.kernel.org/r/20240906-vfs-hotfix-5959800ffa68@brauner
Fixes: 07fd7c329839 ("libfs: add path_from_stashed()")
Reported-by: syzbot+f82b36bffae7ef78b6a7@syzkaller.appspotmail.com
Fixes: syzbot+f82b36bffae7ef78b6a7@syzkaller.appspotmail.com
Reported-by: syzbot+cbe4b96e1194b0e34db6@syzkaller.appspotmail.com
Fixes: syzbot+cbe4b96e1194b0e34db6@syzkaller.appspotmail.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/libfs.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -2043,12 +2043,12 @@ struct timespec64 simple_inode_init_ts(s
 }
 EXPORT_SYMBOL(simple_inode_init_ts);
 
-static inline struct dentry *get_stashed_dentry(struct dentry *stashed)
+static inline struct dentry *get_stashed_dentry(struct dentry **stashed)
 {
 	struct dentry *dentry;
 
 	guard(rcu)();
-	dentry = READ_ONCE(stashed);
+	dentry = rcu_dereference(*stashed);
 	if (!dentry)
 		return NULL;
 	if (!lockref_get_not_dead(&dentry->d_lockref))
@@ -2145,7 +2145,7 @@ int path_from_stashed(struct dentry **st
 	const struct stashed_operations *sops = mnt->mnt_sb->s_fs_info;
 
 	/* See if dentry can be reused. */
-	path->dentry = get_stashed_dentry(*stashed);
+	path->dentry = get_stashed_dentry(stashed);
 	if (path->dentry) {
 		sops->put_data(data);
 		goto out_path;


