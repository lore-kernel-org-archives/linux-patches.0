Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590737;
	b=lG6JpoKf/+AImpcJRchYgkuEgHM8bRFra9BL5yoQElDt8d2FJFgoXhMqlEOfTuPuTeQM
	 Av0IZH46DbNe4d5RZlE0CQc2GrtrQnZv/922fYuxHcb89cKo/MsXejs56tWoSeMmoep5j
	 oa453LX5MIH9mfmilSE5aJYo4REIkWVAhu2IhHv0QVbKaX3TNC/Z5iX0xNBKIaNFo+fa8
	 HyADsTFqs5wRMheiaokSJriVUZlS8mgqCzF/SL8pj7uOj3p9uA2ld+owRXfGtloMbUg1l
	 D7v86aCd/rzLRqFUiZ5a4YZ1yBu8KQEwx+m1OwG/y7PLIBXUD+8RhIzVwyD/JaWAutQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590737;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I1dgxrRIG2DAvBlPmCtASqHoI3O7CKtES3n0bc5kGJ4=;
	b=PSFOiowRXC4OcMaUFRJlaE+2BZ2L8pDAftX0z6vn/KeEUB3KTMYN9z6ZI4xZLIgjT8dO
	 FRvCDiFCkQlnvE5Lcr7v1eKfiH1nJBu5yawBEnvEqWcxVqJjVkIhI8IPD1jFkE4bwst8y
	 xnHUHrzS8O9GQDD19cO6zVyXAq+DdjMn5s4Tjgg0wMGUsBBER68luwPOgn2Xz8lIoWYzI
	 XuZXHMSG58Syiu6UKQwaqKVpZ2aOvkVCr1xbJCnXFPyK2ZZTaa5eyfU8A9sXWUcMvfKH7
	 XicnTW9MgzoOY8TOx351Dl+ihx0vN/Z7bMIJzX9MSk7QWUBdsjwxehcCS+AcHDfhuPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f1WiP0K5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6E8607B58F;
	Fri, 13 Nov 2026 17:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f1WiP0K5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FA651F000C4;
	Fri, 13 Nov 2026 17:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590736;
	bh=I1dgxrRIG2DAvBlPmCtASqHoI3O7CKtES3n0bc5kGJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f1WiP0K5KWqK75ksjdT2QqFh1ow4HZN6X87qQaN72ENswB3chhZhDXayRC/rUZtG6
	 BzNW//zW6FcqMjkh/X0B62id4O2bieR7sf51yX+rLQfYDKse7Vp4vECnkZegi+Plsn
	 r8BM3sSaCAVaqgfQUL7SKLLxULc2kvs67tClhh/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolaos Karaolidis <nick@karaolidis.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 639/686] fs: dont lose inodes that another LRU walker is isolating
Date: Fri, 13 Nov 2026 10:52:52 -0500
Message-ID: <20261113153843.453800712@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Replaced inode_state_read(inode) with direct inode->i_state access under the existing i_lock. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/inode.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/inode.c b/fs/inode.c
index 229ac6ff72cb9..b60111fad771a 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -924,6 +924,12 @@ static enum lru_status inode_lru_isolate(struct list_head *item,
 	if (!spin_trylock(&inode->i_lock))
 		return LRU_SKIP;
 
+	/* Another walker is dropping its page cache, leave it to that one */
+	if (inode->i_state & I_LRU_ISOLATING) {
+		spin_unlock(&inode->i_lock);
+		return LRU_SKIP;
+	}
+
 	/*
 	 * Inodes can get referenced, redirtied, or repopulated while
 	 * they're already on the LRU, and this can make them
-- 
2.53.0



