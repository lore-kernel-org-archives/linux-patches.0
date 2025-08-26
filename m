Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 697913469F4;
	Tue, 26 Aug 2025 14:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217635; cv=none; b=f4itaBedaXpemvGljAdPY/O8IdlrgGCqzAcVKpGRnW1n1QPd3BZyFBvrLSxA7XEzof5t1w2UnICYqjCnRGsjlpHjjOQ8fivu7qDg+P2HUQ+RjE6r42l+/gMDtOnJxlk3Xt+XZP9GXo4IY9X3Rh/wYHU/steJrrWguD5N6/JoFRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217635; c=relaxed/simple;
	bh=Det0Xni6gpMAFbWqjamw92d6l2jAhdJTd7Nw3Yd9IiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F2o01+6l7aoiTbPD7/lhHH09YYr95cv73WRzvhYunkBs+5Wlu3G2rybFyfd5YQMbvXwgOMXh5y/jIKMFlPWRgkZMCHIoYgUDLaF/tWH0Zpce4p3SHNaASlPkAv/pIq3LvW9ImQYDuXW23ssWt/XL68skgHhqawH0DXzY31Lpjjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TMYx8afY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TMYx8afY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF2B2C113CF;
	Tue, 26 Aug 2025 14:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217635;
	bh=Det0Xni6gpMAFbWqjamw92d6l2jAhdJTd7Nw3Yd9IiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TMYx8afYO8LARg/Z6IkLdPcVWwOV94Kb/Joq2ulSNeuNhmrJOE7WnPmGrF710XY2D
	 jS+fgyaDx5ON/lyDPFa4PoeEF3vOSGxqJOHC8ooTopMxp4X0GQ+vj7w/OSdS0FxHYq
	 2NgXMC+7TLfmb7cuidVZo55UKikwauYzpeFFKJ0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+169de184e9defe7fe709@syzkaller.appspotmail.com,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 218/523] better lockdep annotations for simple_recursive_removal()
Date: Tue, 26 Aug 2025 13:07:08 +0200
Message-ID: <20250826110929.837644501@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index aa0fbd720409..c6ed6c58dee6 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -272,7 +272,7 @@ void simple_recursive_removal(struct dentry *dentry,
 		struct dentry *victim = NULL, *child;
 		struct inode *inode = this->d_inode;
 
-		inode_lock(inode);
+		inode_lock_nested(inode, I_MUTEX_CHILD);
 		if (d_is_dir(this))
 			inode->i_flags |= S_DEAD;
 		while ((child = find_next_child(this, victim)) == NULL) {
@@ -284,7 +284,7 @@ void simple_recursive_removal(struct dentry *dentry,
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



