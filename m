Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038599;
	b=QWHtoTb+9m7ASfxBibwnJAiqcScNOJKNYIFRgV5vkdNjp+S9foFlwZVhvwJtoFesZ1cB
	 yva8lGDHgnjCX2hRPsUFKt55Wm4+rIbpCzVhNileQa+yVbN2tSz5TdAt5PpkMt51jFxLe
	 RICagtlY89b2zm2N5gqnzunJsitFyduEjCCqul3cHG0B3qDj9ZX5ZOED51MV6A0k4D6UO
	 zyM2PW8nUu1w9fsYqkXgeOBtw4B8waTGtSm+IHyizWmzqAyXS1YzKKbxrs8its+gr0ebc
	 Qyhh/zieIqwElSAZmmjUeiDlrfZTmdza4Pis+4KibhWMXDY+9+vHHHBJL8o/GOa7hzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038599;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UFPK8+wCAabjsdzGHphMHmGLjeHrcCNPXTjPXbJtBUs=;
	b=nTyLz0d6N2zMQ1fggQu2l+C3fdiJkpB3KPRNWq1HoJICKsfx4h2Wo8rdPQUiOizrPZvN
	 oK919uJLsi0t3R2GcCa5TwV8Wbyop4QPkO1qS3hynDPW0frVfrvh+9k3naOR2fsCfqypL
	 itm/GZWwcWoIaianuBijrWmFA3lJNMzU1R40Cet0vlPTqbaKpwGTZLOB+ZBQgg3msUYJ0
	 mxNvU7Avdt4BZ5EFYxP1nmJg9ywN+pyU5vmZ8maRW5GvuB7ZJzkkJw+olWYKyhNQVvKKM
	 eiLCgomxeBPJ9itqsXgfw9dCGbJVYX9XQSK18ry6HJ4pTDTcaJThuW88z1sq1urpRWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="yeG/JVfj";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050C8606A31C;
	Wed, 18 Nov 2026 21:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yeG/JVfj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 253C91F000CD;
	Wed, 18 Nov 2026 21:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038598;
	bh=UFPK8+wCAabjsdzGHphMHmGLjeHrcCNPXTjPXbJtBUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yeG/JVfjUZzrVfaHqm2RXmMdZbsa2L1A7HRIsUQgfaBhrNvNCPYtStGb3xcHi9scN
	 CRVRnlzCtdQML+/+iuPG7hw3oZM4m1iYB1Kne2CTep8ak5vasr47273yNRetOg06P1
	 EJvy6kbXa94RyNHM/kQ8wo6NQW5DzuWnbx9dM9mA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolaos Karaolidis <nick@karaolidis.com>,
	Jan Kara <jack@suse.cz>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1783/3318] fs: rotate inodes whose page cache could not be dropped
Date: Wed, 18 Nov 2026 15:40:05 +0100
Message-ID: <20261118150415.348620676@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolaos Karaolidis <nick@karaolidis.com>

[ Upstream commit 8ee09f597763acfd31c62a578ba88b792fc41b24 ]

When inode_lru_isolate() drops the page cache of an unused inode, it
has to unlock the list, so it returns LRU_RETRY and the walk restarts
at the head of the list, where the inode still is. If
invalidate_mapping_pages() could not empty the mapping, the restarted
walk strips the same inode again, and so on until nr_to_walk runs out.
Every walk of that list then ends on this inode, and nothing behind it
is reclaimed for as long as its cache stays.

Before commit 2a0629834cd8 ("vfs: Don't evict inode under the inode lru
traversing context") the walker pinned the inode with a reference, and
dropping it in iput_final() set I_REFERENCED, so the restarted walk
rotated the inode to the tail. Set I_REFERENCED again when the mapping
is still populated after the invalidation, in the same i_lock section
that clears I_LRU_ISOLATING. inode_unpin_lru_isolating() now expects
i_lock to be held, like inode_pin_lru_isolating().

On CONFIG_HIGHMEM kernels this can happen to any unused inode: a folio
is left behind if it is locked, under writeback, spliced into a pipe,
or still in another CPU's LRU-add batch after being read. Without
HIGHMEM it happens to DAX inodes whose only entry is at index 0, which
mapping_shrinkable() lets onto the LRU and invalidate_mapping_pages()
never removes.

Fixes: 2a0629834cd8 ("vfs: Don't evict inode under the inode lru traversing context")
Cc: stable@vger.kernel.org
Signed-off-by: Nikolaos Karaolidis <nick@karaolidis.com>
Link: https://patch.msgid.link/20261016102515.111285-1-nick@karaolidis.com
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
[ sashal: Replaced inode_state_set(inode, I_REFERENCED) with direct inode->i_state |= I_REFERENCED. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/inode.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 5ebe791381096..9d11428af1f3a 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -495,12 +495,11 @@ static void inode_pin_lru_isolating(struct inode *inode)
 
 static void inode_unpin_lru_isolating(struct inode *inode)
 {
-	spin_lock(&inode->i_lock);
+	lockdep_assert_held(&inode->i_lock);
 	WARN_ON(!(inode->i_state & I_LRU_ISOLATING));
 	inode->i_state &= ~I_LRU_ISOLATING;
 	smp_mb();
 	wake_up_bit(&inode->i_state, __I_LRU_ISOLATING);
-	spin_unlock(&inode->i_lock);
 }
 
 static void inode_wait_for_lru_isolating(struct inode *inode)
@@ -894,7 +893,13 @@ static enum lru_status inode_lru_isolate(struct list_head *item,
 				__count_vm_events(PGINODESTEAL, reap);
 			mm_account_reclaimed_pages(reap);
 		}
+
+		spin_lock(&inode->i_lock);
+		/* The walk restarts here: don't retry leftovers right away */
+		if (!mapping_empty(&inode->i_data))
+			inode->i_state |= I_REFERENCED;
 		inode_unpin_lru_isolating(inode);
+		spin_unlock(&inode->i_lock);
 		spin_lock(lru_lock);
 		return LRU_RETRY;
 	}
-- 
2.53.0



