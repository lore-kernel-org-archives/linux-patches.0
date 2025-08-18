Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90CB531B108;
	Mon, 18 Aug 2025 12:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521764; cv=none; b=qOMb96JJO3YpPcHj2uLnqlrXtuv9u5/Z52B5WoOOLgyzfhKodJWY1ZvHUES4eP5I8gW3OOma976Rm/EMx8FIaQ/e0rZyatr+g0g+KMgA3ek7NBREzZHVU1CLUostXV0qUk6PPLYYpMpNbrdruxRTdYpUy79m3V+clLamdGpB5Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521764; c=relaxed/simple;
	bh=+cyADRyfY2yfcgCGQf6aXzBOEYLDqJTr+voVoEzesv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jpbrgk6XzQummrVrQbXX7Zp7t+kq7Zvxxclf3FRfvHqJE2VXaWhLIjIqg2nUeUWWog8IWOc1fAc/uy+HlqtwG6xA9K4NohQ5BFoT28Pg8xZ2dz3T83+6Ed3BkcZdUwXD2l8bVOeM9LAT3XGv5r1TyyCfvUzv4IolsHM62IwIq9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j1Pw6N3H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j1Pw6N3H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 166D0C4CEEB;
	Mon, 18 Aug 2025 12:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521764;
	bh=+cyADRyfY2yfcgCGQf6aXzBOEYLDqJTr+voVoEzesv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j1Pw6N3H+MQBY0bRTFohFUPyd4Z18qoej8vZ/arFcd3f/y1bwnltTGYE9gry9BncX
	 VOTvgYlEi7AqYscEV5LSJmwp1piaDQ988ahwozrdbtthpo4vVi1j2pIueM/ufTjf4E
	 TiuIIW45TD5kmNfOKcqPdNmzadbAaWNwAAn8b4uA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+169de184e9defe7fe709@syzkaller.appspotmail.com,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 083/444] better lockdep annotations for simple_recursive_removal()
Date: Mon, 18 Aug 2025 14:41:49 +0200
Message-ID: <20250818124452.064848007@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3cb49463a849..874324167849 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -608,7 +608,7 @@ void simple_recursive_removal(struct dentry *dentry,
 		struct dentry *victim = NULL, *child;
 		struct inode *inode = this->d_inode;
 
-		inode_lock(inode);
+		inode_lock_nested(inode, I_MUTEX_CHILD);
 		if (d_is_dir(this))
 			inode->i_flags |= S_DEAD;
 		while ((child = find_next_child(this, victim)) == NULL) {
@@ -620,7 +620,7 @@ void simple_recursive_removal(struct dentry *dentry,
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



