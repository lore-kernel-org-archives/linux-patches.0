Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB7E221734;
	Mon, 23 Jun 2025 21:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714731; cv=none; b=DL5IcgBlMTrY7Eu1KZBpbao1P0RZpAsYlOivkNux7cekR90rhzYou2/sb0uxM3NSXJH8J5r2dYC7gTi/5bFJzDTEP4B18x/tGhk1ylJuYwzik1GsVmZL8Wzwcp5+QQ75O2neKsewW4tq5s6VFNFNg8zUZIq04/Ss/iM3f0t8SaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714731; c=relaxed/simple;
	bh=YHwyWGE6AYUwEwpIE5mM6RU05a6hUWmLC1dBFqIDopw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cDBO0O/OwZ9uHqVWyuumL2/alSK9mcx6ZJxaFX1It0Z5fb6LWjhTAVdx2yHeXVMrJoyxnOGvnLB/qNuROsfpnXwcMf77TpczacnG1hx8mORFABN1cEXVokabp1nI5V4ebWa3p+ZIFrXHYKuQTXHo5qNFKqGN4ja5OMpZYpFil9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jOZBl0Mm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jOZBl0Mm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84CE8C4CEEA;
	Mon, 23 Jun 2025 21:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714730;
	bh=YHwyWGE6AYUwEwpIE5mM6RU05a6hUWmLC1dBFqIDopw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jOZBl0Mmmu/VFvYYaki0nfI62BVxhjhKAeqzzMkD20tw42gGbZHNwKm6UmYriiOYS
	 QuXqVwTUGX1jdqsBg2ne3Rti1DuQjZWuTIDmqaHnVAWiKXv/7NkmV8edqNzHGY9aDM
	 9P0a7gSgBPYbIbPcZdfTA07tS9A1bXNFxYaNtDuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 412/592] f2fs: fix to set atomic write status more clear
Date: Mon, 23 Jun 2025 15:06:10 +0200
Message-ID: <20250623130710.235647453@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit db03c20c0850dc8d2bcabfa54b9438f7d666c863 ]

1. After we start atomic write in a database file, before committing
all data, we'd better not set inode w/ vfs dirty status to avoid
redundant updates, instead, we only set inode w/ atomic dirty status.

2. After we commit all data, before committing metadata, we need to
clear atomic dirty status, and set vfs dirty status to allow vfs flush
dirty inode.

Cc: Daeho Jeong <daehojeong@google.com>
Reported-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Signed-off-by: Chao Yu <chao@kernel.org>
Reviewed-by: Daeho Jeong <daehojeong@google.com>
Reviewed-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/inode.c   | 4 +++-
 fs/f2fs/segment.c | 6 ++++++
 fs/f2fs/super.c   | 4 +++-
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 5c8634eaef7be..f5991e8751b9b 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -34,7 +34,9 @@ void f2fs_mark_inode_dirty_sync(struct inode *inode, bool sync)
 	if (f2fs_inode_dirtied(inode, sync))
 		return;
 
-	if (f2fs_is_atomic_file(inode))
+	/* only atomic file w/ FI_ATOMIC_COMMITTED can be set vfs dirty */
+	if (f2fs_is_atomic_file(inode) &&
+			!is_inode_flag_set(inode, FI_ATOMIC_COMMITTED))
 		return;
 
 	mark_inode_dirty_sync(inode);
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index c5d29c58f3d3e..876e97ec5f570 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -376,7 +376,13 @@ static int __f2fs_commit_atomic_write(struct inode *inode)
 	} else {
 		sbi->committed_atomic_block += fi->atomic_write_cnt;
 		set_inode_flag(inode, FI_ATOMIC_COMMITTED);
+
+		/*
+		 * inode may has no FI_ATOMIC_DIRTIED flag due to no write
+		 * before commit.
+		 */
 		if (is_inode_flag_set(inode, FI_ATOMIC_DIRTIED)) {
+			/* clear atomic dirty status and set vfs dirty status */
 			clear_inode_flag(inode, FI_ATOMIC_DIRTIED);
 			f2fs_mark_inode_dirty_sync(inode, true);
 		}
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index ee039bf02c148..bc510c91f3eba 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1531,7 +1531,9 @@ int f2fs_inode_dirtied(struct inode *inode, bool sync)
 	}
 	spin_unlock(&sbi->inode_lock[DIRTY_META]);
 
-	if (!ret && f2fs_is_atomic_file(inode))
+	/* if atomic write is not committed, set inode w/ atomic dirty */
+	if (!ret && f2fs_is_atomic_file(inode) &&
+			!is_inode_flag_set(inode, FI_ATOMIC_COMMITTED))
 		set_inode_flag(inode, FI_ATOMIC_DIRTIED);
 
 	return ret;
-- 
2.39.5



