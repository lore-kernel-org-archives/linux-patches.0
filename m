Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27CB222576;
	Mon, 23 Jun 2025 22:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716666; cv=none; b=Ojw99t58Bv7GxJ1+kZPDE6488/c8X2E99lQZOFYqFUlT1hLlFM8ABUxPhyM6PDFkFDP5ALvmjf26PcQgzlY3YDSfIaS8jMCsCS07ShnaHY+fjWjltQt60r17LQmminFR52tw9my8TAnEpUklRdRPtL+UXZcQF9E0Z8DmofduK5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716666; c=relaxed/simple;
	bh=owMcGrlpM5c08BRisT8hWbqyOgCvIULgLE9i+Z4Ww1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nRZGFaBlws6sGsTPQpkFygrg2US1eciOACilhMBsCqkoy/swDR+E2bPl2WcLafkskMETynNOJjixo1jqZEBF+tGWjHXOM4VA5W8hy3laX4+YbvHW5pGD0uXH7QPXrbbvL3XQ4zNLto7Q8kKnuVIzXh+F5Gzg5iT9GhmjgQsEJHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aBmrhI5m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aBmrhI5m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AE39C4CEEA;
	Mon, 23 Jun 2025 22:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716666;
	bh=owMcGrlpM5c08BRisT8hWbqyOgCvIULgLE9i+Z4Ww1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aBmrhI5mIXHMohVDGDpH19dYmHJ24JT6B/u1ILcXQlE9xmzluU9zV63+JUWkP93NI
	 e1JDZWgi2zopLX27PKyMEfjANQE96lP7YR8nRmen2GD+byGf3qE02jRSuvJdUHAK1o
	 umNgtKtK7ETEL1YhjrMbee57/Uw/C2noY6+ttkx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 273/414] f2fs: fix to set atomic write status more clear
Date: Mon, 23 Jun 2025 15:06:50 +0200
Message-ID: <20250623130648.852434575@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 50e64b7b016dc..06688b9957c81 100644
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
index 769a90b609e2c..449c0acbfabc0 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -370,7 +370,13 @@ static int __f2fs_commit_atomic_write(struct inode *inode)
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
index b1ab7ee2adf9c..330f89ddb5c8f 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1516,7 +1516,9 @@ int f2fs_inode_dirtied(struct inode *inode, bool sync)
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



