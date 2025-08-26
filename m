Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93DDA34DCC2;
	Tue, 26 Aug 2025 13:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216113; cv=none; b=rs/nJLwCOiQVVoubTsT8+DSAIiUk3EotHCT55Vn34ff4yfe3gwUduqxMjmnua43ooO/hO69zywmrJ+2JW1qH9ry9lZA8RZTPnA9+q84Z/7lsLdBWcKql0ONWwzFKn4ro90E4kBrnKFIc0H6hwtLg+iPu4MKe6QPjy9Ja+2qUh+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216113; c=relaxed/simple;
	bh=qBuqCuFso7rqxzOh1/fo59z+Aw3FRdpGoIctnSnDtrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HjFOQwam3sevF/LarI42GCBBvW2COSZ0lfsA++Ruin9iuRfkqR82ipNUtYqVDIhHp76KIUyyF9w9OmsNEjXPPTNwp8lTxJnZ+DXG30R0FqxeGVF+eTFUVFXNKy4Wlvw0rURiPdb4Bkg5Q7dyeCRiM9TmVDWxz0MEYrCCp5uMOKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uUR7FMHl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uUR7FMHl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26777C113D0;
	Tue, 26 Aug 2025 13:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216113;
	bh=qBuqCuFso7rqxzOh1/fo59z+Aw3FRdpGoIctnSnDtrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uUR7FMHl9KTn+Rt2f8EZZI8MihotcEDhAlUyItXoDjwtrD4KWrCLD/JceWmARd2up
	 TM/aQDzg7/NpFNPDkHpZTfKFLia8KOavnTpi/cW50ad186hRr57R9zjolvhpqdpav/
	 Xu5bjFyKRbHKjRJiM3c+Q+Rs0jvgJsIrF59nFoXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+169de184e9defe7fe709@syzkaller.appspotmail.com,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 289/644] better lockdep annotations for simple_recursive_removal()
Date: Tue, 26 Aug 2025 13:06:20 +0200
Message-ID: <20250826110953.543681547@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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
index 7bb5d90319cc..eaf96297449e 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -273,7 +273,7 @@ void simple_recursive_removal(struct dentry *dentry,
 		struct dentry *victim = NULL, *child;
 		struct inode *inode = this->d_inode;
 
-		inode_lock(inode);
+		inode_lock_nested(inode, I_MUTEX_CHILD);
 		if (d_is_dir(this))
 			inode->i_flags |= S_DEAD;
 		while ((child = find_next_child(this, victim)) == NULL) {
@@ -285,7 +285,7 @@ void simple_recursive_removal(struct dentry *dentry,
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



