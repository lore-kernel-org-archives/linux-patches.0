Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053996;
	b=ZmWvyj2Myn87wyQU/23S5QyAoPhHoHcm0+B2g4Dp5swkpn3rXdFI24krJWSPwC5YDEdo
	 j/2tcXlLmdpM8JppIyHEoYd925yu0UZ4OM4WRQpVdgqu3Qa4Rf1JdHhdqX6wIXRi6A7AG
	 Ety90MJM4hgvfS49IZA8Vyjs2QdPYy4UotuiXEbIVJFXfnjsuz3gZvGthwFuFval1s8/8
	 RmRJpYr2wYoYaZSEcqyz78897IYiIdLXaUN7X2lzSd14awZA2t6xPPsntK5Dau0cPFqTr
	 A3OsZHCmpk+70zD046lWa/o2Fo/SNLut/7rvJbhnzp+qFK95DXk0aX/xq2z1RjtZz4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053996;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t/QvLMomWE2h0evWSjZSPb97PiNhTnkG75YsnqF9OLc=;
	b=1g8n7OS+jxGiFvTu5IPmaE49r/thNDdc40yJH2ggQl+xrJrg09OAEL2PGiWDuMxmsNXA
	 5JY/jOwdc9yu/x6ik+fSSF/XjJjSwn3qQvp6ML6Rpqk6RuTyhyMAGsxXdxuSS+i8XN5q4
	 +Z8aTKKibgukrImr1JsrCTZ/x1hPpjlsr8CQJCWa7MV18/GcVXcRyYcGR/v4ajPFMJDSL
	 9+ps4pHr1PsGw80E5wk4DRkt5/7Y/mTIOU0YbPkhxcLHD4vQ/5y1C5ZBjDm3sPyKPSXUq
	 G+0QJQWENe8SByb3iTdvBgdPbfp3N8W8lu4vzJJzAf86WKHSL2dTmWA7TqH64XyVxVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NIWplhKU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA0E606A320;
	Thu, 19 Nov 2026 02:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NIWplhKU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B548B1F000C4;
	Thu, 19 Nov 2026 02:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053996;
	bh=t/QvLMomWE2h0evWSjZSPb97PiNhTnkG75YsnqF9OLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NIWplhKUjjauBhY99p7+LlJTP/hO3RQMX95V71amWRgJMiHE1usNxHRQBBv007IOi
	 fB07mM5qRnfQvSuhQUAXERdJjduMlkJMWquDfd8BMejvVJv7S2Xt4w6Kb3l+ARax+I
	 znOHW7N22/IPTZPCOU+JZ88cDu1zYDUsJG9EcHiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolaos Karaolidis <nick@karaolidis.com>,
	Jan Kara <jack@suse.cz>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1119/2214] fs: rotate inodes whose page cache could not be dropped
Date: Wed, 18 Nov 2026 15:46:35 +0100
Message-ID: <20261118150056.870352794@linuxfoundation.org>
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
[ sashal: replaced inode_state_set() with a direct inode->i_state bit update ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/inode.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index bfeec2830fb0d..2e03403ed50c0 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -490,12 +490,11 @@ static void inode_pin_lru_isolating(struct inode *inode)
 
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
@@ -846,7 +845,13 @@ static enum lru_status inode_lru_isolate(struct list_head *item,
 			if (current->reclaim_state)
 				current->reclaim_state->reclaimed_slab += reap;
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



