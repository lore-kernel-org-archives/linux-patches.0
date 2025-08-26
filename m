Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1542BE058;
	Tue, 26 Aug 2025 13:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214224; cv=none; b=IMgwu3pJQDU2HBwBQqER8rHnkemHOoh6C03ctCoFaoD9UwCeDFRUMRoB8t/sFdHmN9n2FeZ91rMRRYNTxV36uCZB+SW4H0g2RzrAgKIk9I19NN/Tk48oPIhqGi8bEqq/LVgXCO8RvH+pH0pwDSko7HY/Ko7aiuMV8npTEVpHtYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214224; c=relaxed/simple;
	bh=1PTrbylr8Tz+b+YL259XIWH+be4WNI2bAmWIIe5Kg7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ItpguBiKT1gkMJh2N+zNa/b0LygCKtvlJz/W6tLPH56s3+fAARECPr0uYk6b56VULwChEL62SZmonblxWBBLGQ8ErXdS7z0O1YXG7a9MSwJ0XRwsRQWS7ef0JP4/Xc+V/XMsW8wywz4sz50/FLVUWKuiCfr7oXXGdbSv3Aqcqbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XoaW/9Di; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XoaW/9Di"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 990D3C4CEF1;
	Tue, 26 Aug 2025 13:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214223;
	bh=1PTrbylr8Tz+b+YL259XIWH+be4WNI2bAmWIIe5Kg7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XoaW/9Did+/UZTZXSbvaatqyBpb5ikPkGmWJcqz35UtxrvciGkANUi6YV21cZlcz1
	 plcwZq0qYoNPM1l8i49VCXa4Iuh8ufix7uUmr0P6uaKAXwUYzf5mS9+RsA2AzFpibK
	 9bN4EF1yaQg0qWxBJ8gWj+t2rHhzTiwYOGcI9+xU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+169de184e9defe7fe709@syzkaller.appspotmail.com,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 058/482] better lockdep annotations for simple_recursive_removal()
Date: Tue, 26 Aug 2025 13:05:11 +0200
Message-ID: <20250826110932.256182890@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index aada4e7c8713..cbd42d76fbd0 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -274,7 +274,7 @@ void simple_recursive_removal(struct dentry *dentry,
 		struct dentry *victim = NULL, *child;
 		struct inode *inode = this->d_inode;
 
-		inode_lock(inode);
+		inode_lock_nested(inode, I_MUTEX_CHILD);
 		if (d_is_dir(this))
 			inode->i_flags |= S_DEAD;
 		while ((child = find_next_child(this, victim)) == NULL) {
@@ -286,7 +286,7 @@ void simple_recursive_removal(struct dentry *dentry,
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



