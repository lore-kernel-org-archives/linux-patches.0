Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D306261B97;
	Mon, 18 Aug 2025 13:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524942; cv=none; b=YOuFdd3Fqbd1xASoNDRbJDErmSpqhQiaY/a2XZoMZcAIT8PavpFQZZx8W6IpnWcPIlJ7V1lkYYkAOZ8FqLmMAcoie5CTCzud/OwAv8jWxfEQdrzluLWBjrGKYWCmoomXPlamNRw5+wLX2G8UG1lCBl/P4jxOaZA11ajvt4pZH4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524942; c=relaxed/simple;
	bh=KcuREEYYg9cGjxj3lw8GstM6psQyxJXs8tXUO15Dqz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GQhwxbZQ5BPJMNk2/FyxTdO4ufinIp0sUQ5vbEqdzX9MdSLKpp4lOIOl6O+e+k2iR1fZxKxvL+lA1V6rVON953b4T+Y0+0ZlMK/0hnRV9gEAD/YKw+lqEEmmzP3Vefo5VVPCfwW8j2BcRGJbuvF7oDG1cpf2NyE6mhkXhPDqbn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K/8hCBPB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K/8hCBPB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A6E8C4CEF1;
	Mon, 18 Aug 2025 13:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524942;
	bh=KcuREEYYg9cGjxj3lw8GstM6psQyxJXs8tXUO15Dqz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K/8hCBPBe4n8HteW3gWdlY6Vkfzhx5y2vwRcSERtvUHAi50FAR7qeJ8jjF79kc49V
	 zKye2I0BsgFFyODP0qsNij0x4OhFfwhKsnUzMlZ8Fa2BdQoTlEKmc1DorRlvbXpCAh
	 E1Dt6m+FZNSHYOzlhUAIv/NARDAzeoKUlp8aBphk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+169de184e9defe7fe709@syzkaller.appspotmail.com,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 111/570] better lockdep annotations for simple_recursive_removal()
Date: Mon, 18 Aug 2025 14:41:38 +0200
Message-ID: <20250818124510.081282823@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 6f487fc6be34..972b95cc7433 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -613,7 +613,7 @@ void simple_recursive_removal(struct dentry *dentry,
 		struct dentry *victim = NULL, *child;
 		struct inode *inode = this->d_inode;
 
-		inode_lock(inode);
+		inode_lock_nested(inode, I_MUTEX_CHILD);
 		if (d_is_dir(this))
 			inode->i_flags |= S_DEAD;
 		while ((child = find_next_child(this, victim)) == NULL) {
@@ -625,7 +625,7 @@ void simple_recursive_removal(struct dentry *dentry,
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



