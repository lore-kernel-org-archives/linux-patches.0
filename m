Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2AD4315A;
	Mon, 23 Jun 2025 21:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714873; cv=none; b=pl21VeN9eBSV90O7fLu7jvfKOGlSvFqiAF4Qwn7sW4lhzItMGdOQlvlBrV6hSqnGNzux5unAyr/6yLmfdLlqL20aNj7DXCTgFbYWv98Iisi8E2Q4jv3+7qSxFmg7litqKvTq2UqkliQQz+PnhrQiJnbBI9h6oH7YL1vil/la41Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714873; c=relaxed/simple;
	bh=8Jd+p6XIzYjzojaFSEKwUYl5iTJGcgC5/N2t4yFPckw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HbszTkR11aLOlsFRthzyq8p7iM5d8pONmzzxv6p5MNiJXkEDLFgVWqkA1LElbCPQ7qwnEkQ7L0Xcwyvbt5L92Vnh0VkQF1UUf24vJYacJpF+PcfaA5fHWF3inlKuaVseEi/lhcQOB5qKfnW1LYYQ0OCYn5BMEBnZYFi1gom8GW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fPNwmDNy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fPNwmDNy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 878B3C4CEEA;
	Mon, 23 Jun 2025 21:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714872;
	bh=8Jd+p6XIzYjzojaFSEKwUYl5iTJGcgC5/N2t4yFPckw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fPNwmDNyFhq7mHrhRC/jrF8sVjArlXFza1jbgCzqKFh8mMyJgOyPStkFG797L1srl
	 VkYTTM/xYeiUFLi7wQvnSbuo9woM9xVeVRsToWxmX+vIz7a+mWM9hsw3YSvNP9bdgX
	 6QBcnbRS5Kbs5zeZlBQj6IZDBNLWWObpzxu7PnKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 186/290] f2fs: fix to set atomic write status more clear
Date: Mon, 23 Jun 2025 15:07:27 +0200
Message-ID: <20250623130632.466039049@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 21d3eabe95e00..66721c2093c02 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -35,7 +35,9 @@ void f2fs_mark_inode_dirty_sync(struct inode *inode, bool sync)
 	if (f2fs_inode_dirtied(inode, sync))
 		return;
 
-	if (f2fs_is_atomic_file(inode))
+	/* only atomic file w/ FI_ATOMIC_COMMITTED can be set vfs dirty */
+	if (f2fs_is_atomic_file(inode) &&
+			!is_inode_flag_set(inode, FI_ATOMIC_COMMITTED))
 		return;
 
 	mark_inode_dirty_sync(inode);
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 156d92b945258..c7714e954cb54 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -372,7 +372,13 @@ static int __f2fs_commit_atomic_write(struct inode *inode)
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
index 50170e7cf3f9b..702137eafaa67 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1500,7 +1500,9 @@ int f2fs_inode_dirtied(struct inode *inode, bool sync)
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



