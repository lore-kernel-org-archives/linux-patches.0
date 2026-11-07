Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065247;
	b=dGUiWDBs+tMT/Yjqx64TVy8z3rQVncbrAgveIuimuDtn3CVGF/13cfe59eFEBQhOU05l
	 60bjg7I7OXHcAuJb3NV46dZ6VoaYfwwjvmoTXOHRclqDY5xQJfq13IX7va3T8OddvaVa3
	 2KdOjwmolLu+Dot6Rb6GRwifzLPI/l4LkFhrvfSI8yl1B1spxPIxEciJtv7QTBOvKNplA
	 R/4+8AZOkzksJ1WbmvBePkTfJA6ze01JCOVZXyFsDYEg/Dkh34OYsk66ns0q+/IWXiWDP
	 aiQ7rDMIZ3GPQjiV06uAUEOEAWjiawidQuL8Jx0QNZVr993SAlx5Ox+jMA/xz+fB+wA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065247;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xg17c6ywKEQXDWjUWB3mPjs4X6IJn79sfanP30gCHAA=;
	b=3GjufkNNO9oBPFC70gHgzl1LGaX3RN/a8Ao/MSmeRcz/gt2v9xxC6dctKg2HeUm7QKZx
	 tgmBsk33itB+NxJlRql5of28254GYh5b0hzauIlJMni45QiJL/UaVzGcu8UDjdbR9FFhJ
	 lQr4eMvc76tk7Nlm4ERV6ankVRjo+dIszbs+ql0ZQNZGpovBQ86NWjjxlgkuOKkm23ytb
	 27qzN6N4WSWcdVtFY3asMsCgk/QSjbsvcBNIDi+ojsPNQgC9Fm06iFknwxH5ZD+VU919L
	 vJ1btbkuLIbpZv8BHANWz9kAIcbND1uDy/HI316Ybh2OtXzp3avgOQI2LA9anPGQCBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ePKnqO/8";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE1B606A326;
	Sat,  7 Nov 2026 15:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ePKnqO/8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64D2E1F0089F;
	Sat,  7 Nov 2026 15:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065246;
	bh=xg17c6ywKEQXDWjUWB3mPjs4X6IJn79sfanP30gCHAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ePKnqO/8GPOhDeIxOhExcAGe8elSoZBOm7LIHVj2oRYzGRmDYYurbN5YsWzJW/9jX
	 DPHryYBuP6Pf3mNMoldI7W/SgRqHFo8Pl1OUol/VwjUxvWEWyPNXkI0BCWryXf122q
	 +MU7d5mDvcEw9P7bfXS++AJTyCLJSAjvL+Eh7qVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolaos Karaolidis <nick@karaolidis.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1022/1257] fs: dont lose inodes that another LRU walker is isolating
Date: Sat,  7 Nov 2026 08:55:18 -0500
Message-ID: <20261107135007.557015111@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Nikolaos Karaolidis <nick@karaolidis.com>

[ Upstream commit 8dc4116041e2b377e5e1b62ba98b37636f9f3968 ]

When inode_lru_isolate() finds an unused inode that still has page
cache, it sets I_LRU_ISOLATING, drops i_lock and the list_lru lock,
invalidates the page cache, clears the flag again and returns
LRU_RETRY so that the restarted walk can free the inode.

Another walker of the same list can reach the inode in that window.
It sees a non-zero i_state and takes the inode off the LRU, as it
would an inode that is in use. Page cache deletion requeues the inode
once the mapping is shrinkable, so this is harmless if it happens
before the last deletion. If it happens after, nothing puts the inode
back: it stays in memory, unused, clean and without page cache, out
of reach of the shrinker and of drop_caches, until it is looked up
again or the filesystem is unmounted.

Before commit 2a0629834cd8 ("vfs: Don't evict inode under the inode
lru traversing context") the pin was an i_count reference, and the
final iput() put the inode back on the LRU.

Skip inodes that are being isolated and leave them to the walker that
pinned them, which restarts its walk once it has unpinned them.

The window is reached by any unused inode with page cache on
CONFIG_HIGHMEM kernels, and otherwise by inodes whose page cache is a
single shadow entry at index 0. On an i386 HIGHMEM guest, eight
concurrent "echo 2 > /proc/sys/vm/drop_caches" over 2000 freshly read
one-page ext4 files leave roughly 400 of the inodes off the LRU per
round; on x86_64, with the files' pages first evicted through
memory.reclaim, 3 to 4 per round. With this patch, none in either case.

Fixes: 2a0629834cd8 ("vfs: Don't evict inode under the inode lru traversing context")
Cc: stable@vger.kernel.org
Signed-off-by: Nikolaos Karaolidis <nick@karaolidis.com>
Link: https://patch.msgid.link/20261009142431.713875-1-nick@karaolidis.com
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/inode.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/inode.c b/fs/inode.c
index 1614a97ce9531..bc93c1757a380 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -941,6 +941,12 @@ static enum lru_status inode_lru_isolate(struct list_head *item,
 	if (!spin_trylock(&inode->i_lock))
 		return LRU_SKIP;
 
+	/* Another walker is dropping its page cache, leave it to that one */
+	if (inode_state_read(inode) & I_LRU_ISOLATING) {
+		spin_unlock(&inode->i_lock);
+		return LRU_SKIP;
+	}
+
 	/*
 	 * Inodes can get referenced, redirtied, or repopulated while
 	 * they're already on the LRU, and this can make them
-- 
2.53.0



