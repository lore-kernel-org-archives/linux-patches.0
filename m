Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0B1322A0A;
	Mon, 18 Aug 2025 13:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523196; cv=none; b=A/2MORH+UsPH8K68r8i8owf7XxBA2WQos+jygFK3mdLcgRLz6CxiuNCutBopE2z2JMv/yzhghZIFp6kX7HFexFPJhpzcskx8PHQi235AXXo81yF444k1mntzEAU8Z4/SkX6XWWywSXj/8cjqrj2+Bu8jeGylcmXBDAYxHNEp3n8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523196; c=relaxed/simple;
	bh=lKvFVoZ6Okra1yi7MULylOPm1sno4/K8tA7+nQj+KCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tSfu2KblCrfsd2k0s0ByHSayNZuiona9U1ZYEvihL1MdTHEuPNUdWrd46lEbPyj+AOVf7ieMUu8epXZGqcjvR/rApUcd62sY75TB+lcJZodoK1ZMXBARUHTZDvTTb5L8N907rsqEcni6pl+D2gC6kiy8C9doyMQSuH6T1x3vYFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YOMOUSyO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YOMOUSyO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEBFFC4CEEB;
	Mon, 18 Aug 2025 13:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523196;
	bh=lKvFVoZ6Okra1yi7MULylOPm1sno4/K8tA7+nQj+KCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YOMOUSyO/tcfqnLg6Ut71bzMt7oHbbUi/SFcXHPK5vG3GL0H/rj2fTXFbMuWvb27k
	 jU66AbNKA10d9VZSUVRpTW6isFhlfHJPDbqGGKLH7EW3PsLUS0p1WHE8XnGfhn1wBb
	 nW2Gd/XnRZ6ZBEdcuL4RMzbOXfMn6DLujMtKxO1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+169de184e9defe7fe709@syzkaller.appspotmail.com,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 099/515] better lockdep annotations for simple_recursive_removal()
Date: Mon, 18 Aug 2025 14:41:25 +0200
Message-ID: <20250818124502.186946967@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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
index 14e0e9b18c8e..1149c62a801f 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -612,7 +612,7 @@ void simple_recursive_removal(struct dentry *dentry,
 		struct dentry *victim = NULL, *child;
 		struct inode *inode = this->d_inode;
 
-		inode_lock(inode);
+		inode_lock_nested(inode, I_MUTEX_CHILD);
 		if (d_is_dir(this))
 			inode->i_flags |= S_DEAD;
 		while ((child = find_next_child(this, victim)) == NULL) {
@@ -624,7 +624,7 @@ void simple_recursive_removal(struct dentry *dentry,
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



