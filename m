Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054038;
	b=gjLmcLmu2XNwVoaayCqTr7NTipCKoYKBI9Z5pM7VaF0orZvYqywMEao4GjuLugZFXLOx
	 j8KhzQUv9BqTt6AqWAp9elD7rgUVHspBQkbNoR6GhQ2ckHGm0VpJaO0QclnO9qR/4azBg
	 u1NFkQCGyA8+pWiF+J3lF6rGD3OwAe85OW/TZyz9ok7RNLJzK1UkTweBDVj7c3A1zQV78
	 nz2YeDRkogfOappMr1CxGmnsfazWrCHWO7QK1eQwmdjiM1UtB7LmdQfocYMw1wuRC2b4O
	 kn/JlMY3v2B1h5nNHBW0eJsrzRJshVpkQ9Cg4lHwVUBHkTZQnqh2htPfbJvWoOl5sLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054038;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X7w7Rg4fwEdIf8pgVPCnbC5O2iIVFBJWQ1gZ5Xh3mm8=;
	b=Fv4wk8khQP+2zjiiIZ9OPPJ1b/wU1ZacSkY4Hdxfan/Kot6ZDoxYefZIg4/pHAPoz8yP
	 jVLrbQ8YjAOyw4OpvJ/bes8ph7tO73asKw+OPT5W/U1ZAWxJXonYF+LQ0mrtO4v7d/+u1
	 Uujs+zTfHyIksukLld3SlT9e1N55j3lTRtBeeNrB9PPOsXBjClpUXXGORcFN5Akc4/EAB
	 9Dwh9wiLyGDbzugsw9x7dKPjR8pET+YYcK+u1cFTAfc5ChI7p5RZFNjAWMks4RJWFTUhc
	 h2Y2aNsDgHdqk6IpOE22vxGBqGW78QBtSNNP1H1ZXj4FiJkK6cKdUTCg2pTcVzjo2qQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f3xi8vq6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A44606A32A;
	Thu, 19 Nov 2026 02:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f3xi8vq6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95FFD1F000C4;
	Thu, 19 Nov 2026 02:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054038;
	bh=X7w7Rg4fwEdIf8pgVPCnbC5O2iIVFBJWQ1gZ5Xh3mm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f3xi8vq6jwEggK/qGdMxlc+lydBNGszcELOmlXT+1O8af47Ahj4E6jJKbOsRbSx1M
	 jBqSjLZgMi+MJAiei2osyE97kJy1WiCiy4ZNYbk3jf8obaqrmvqJhIlaacix7B9mVa
	 ReMP6tVwGHLd+md5br2BwlkgmGQk4l0i4ZOcoVxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolaos Karaolidis <nick@karaolidis.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1133/2214] fs: dont lose inodes that another LRU walker is isolating
Date: Wed, 18 Nov 2026 15:46:49 +0100
Message-ID: <20261118150057.374262554@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Replaced inode_state_read(inode) with direct inode->i_state access. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/inode.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/inode.c b/fs/inode.c
index 2e03403ed50c0..34e0a0482bff2 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -812,6 +812,12 @@ static enum lru_status inode_lru_isolate(struct list_head *item,
 	if (!spin_trylock(&inode->i_lock))
 		return LRU_SKIP;
 
+	/* Another walker is dropping its page cache, leave it to that one */
+	if (inode->i_state & I_LRU_ISOLATING) {
+		spin_unlock(&inode->i_lock);
+		return LRU_SKIP;
+	}
+
 	/*
 	 * Referenced or dirty inodes are still in use. Give them another pass
 	 * through the LRU as we canot reclaim them now.
-- 
2.53.0



