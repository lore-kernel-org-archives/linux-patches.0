Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047153;
	b=cYkx17qnTh4K+CbGym51RZedWLIpypsdbQmNqhl+9alx2Ga+2xn4IoU7u3yg4PDvPnC7
	 A9/bvS/AsLkHpV2P13YrIpGS0a/cdS7QZaDZ7rdC258FjsU67uz/ii2wmpYJaYzakWEvC
	 DvA/z8eB8z1KkXbKuQF8gA9coqMVvJinnIHOvjeyJt8xfqmXSZI1EG2G0MEj3VOhRjuVP
	 GVyRaDXDX3Bq5XjzsmlNzCjvnQxKwx52yftb+gFQLW5/lYFmyizfdSv+gTx2b6LcLCLtk
	 vwFCWk2310TDT3Wu9ikgLpmBE5paLzuV7Nj3ib9q8pQtC/6PZ2unahFBS7Q6tmqAtlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047153;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HjpiFDGjN1BaFj7jUVeVTpVwLFPJf0MUpbwuDE+KvXY=;
	b=XDbzig95jAep5qZJwoNNMT7sSlp+Awt271GukLj1sForqo3wiNg2R7PGYy/m9mgMxV7t
	 jsz1DI5ZbxRglRa1JB0W32jCG0E5j/SO6OJNL99sLJPo39tSzrmWOvQVuAsYVCKLzG1bL
	 TZxHRDgKrK6zox16JA1tBqf24Hz3V9bHHtx9MvYskVLJluJP2D4VQCmOLJoVbmX3Dl9K1
	 0l032UR15vf0TuFHC0I8+P+u+unyTLqPDRvj8MMJmaPzbW1+D/3oyeT16ACXPaN4d/rM4
	 vtK4SfFNAaRZneCr4/eYR9VPI7T7k62oEAUlcCj0BunxwwXHi83vyD4GxZfwcldZKFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2XSsftg+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50768606A31C;
	Thu, 19 Nov 2026 00:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2XSsftg+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E01D1F000C4;
	Thu, 19 Nov 2026 00:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047153;
	bh=HjpiFDGjN1BaFj7jUVeVTpVwLFPJf0MUpbwuDE+KvXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2XSsftg+pn0AvpHkussLjVLqdDTqYkRqU83UeN8Cg2gd1B1ZJBv/itvVb1dnuxaY1
	 UJIS2ij8nu+ESlqWgzXD4nXYss3JmYmgutmJPJ7TKEhwHUbU6J26gqix1b84ziiWTO
	 gBSMPRXuBmnO6mzfKkmbzH9ycAE5GE9I9AZmrYKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolaos Karaolidis <nick@karaolidis.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1536/2857] fs: dont lose inodes that another LRU walker is isolating
Date: Wed, 18 Nov 2026 15:42:50 +0100
Message-ID: <20261118150256.628133854@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Replaced inode_state_read(inode) with direct inode->i_state access because the accessor is unavailable. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/inode.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/inode.c b/fs/inode.c
index 8e430ccb23c6e..08fbf3648ce78 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -867,6 +867,12 @@ static enum lru_status inode_lru_isolate(struct list_head *item,
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



