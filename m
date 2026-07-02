Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB25F309EE9;
	Thu,  2 Jul 2026 17:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011623; cv=none; b=mkohknd3UfRv7WgtHAv+Pb7lm5BVXYQ4TUGPJcjjoMwgQBwNVR+tFuHcqP0CYOjVxfW+yJnSAgL49+9VyosffPiVNQ2tP88jU60awSW4zvbFQHAOKy5s7SBT29EU8trBWoWeVQf/0Wfr+irO2O2ymZL+B+6puYpxPjMdSCxDfm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011623; c=relaxed/simple;
	bh=4hMLFzxSe1Y4/4UVsAs7HsBkoZyH3aH8RPKMjJqaDZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lL4IqevKGtOhndLCTpPPWgal2gKkwFtm2s2tMZYlnifRZnD9djXQNWffa+ABougsoYAlx7WcMmPerXINk0b2QsROvXdAr54UKJCqNCviM4+fl4imRSJE1z7av2GcfsmhLvWFQiixWGraURh/sNsunFPvnDSysX+xfXATNGUTdf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cdUqPri8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cdUqPri8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CFB71F000E9;
	Thu,  2 Jul 2026 17:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011622;
	bh=LPHBcQrNxfYP/doUSg6ooYNXrTPHaSBBc3IRj5wj/lE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cdUqPri8pR16+Lej5mMm8QV/XyvMdFDwx2IwoGKreKKjJM814NCqhMrxOKsjRcZ0p
	 0Orkm0i6c4gsmZRAv0A1tWOD+37PNwu07M32wKUhjZulRuHJpiQJOb4YUq8a+YbRVS
	 iOq4ucXsTuX2WDc67aTVok1R/4zU+7ZfYoV1ibP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Yongpeng Yang <yangyongpeng@xiaomi.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 7.1 070/120] f2fs: fix incorrect FI_NO_EXTENT handling in __destroy_extent_node()
Date: Thu,  2 Jul 2026 18:21:06 +0200
Message-ID: <20260702155114.407659626@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.964534952@linuxfoundation.org>
References: <20260702155112.964534952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongpeng Yang <yangyongpeng@xiaomi.com>

commit 1f70ddb28a3c71df124da5fa4040c808116d6bb9 upstream.

When __destroy_extent_node() sets the inode flag FI_NO_EXTENT, it does
not reset the length of the largest extent to 0 and update the inode
folio. Since modifications to the extent tree are disallowed afterward,
the cached largest extent may become stale. This can trigger the
following error in xfstests generic/388:

F2FS-fs (dm-0): sanity_check_extent_cache: inode (ino=1761) extent info [220057, 57, 6] is incorrect, run fsck to fix

In the f2fs_drop_inode path, __destroy_extent_node() does not need to
guarantee that et->node_cnt is 0, because concurrency with writeback
is expected in this path, and writeback may update the extent cache.

This patch reverts commit ed78aeebef05 ("f2fs: fix node_cnt race between
extent node destroy and writeback"), and remove the unnecessary zero
check of et->node_cnt.

Fixes: ed78aeebef05 ("f2fs: fix node_cnt race between extent node destroy and writeback")
Cc: stable@vger.kernel.org
Reported-by: Chao Yu <chao@kernel.org>
Suggested-by: Chao Yu <chao@kernel.org>
Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/extent_cache.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

--- a/fs/f2fs/extent_cache.c
+++ b/fs/f2fs/extent_cache.c
@@ -119,10 +119,9 @@ static bool __may_extent_tree(struct ino
 	if (!__init_may_extent_tree(inode, type))
 		return false;
 
-	if (is_inode_flag_set(inode, FI_NO_EXTENT))
-		return false;
-
 	if (type == EX_READ) {
+		if (is_inode_flag_set(inode, FI_NO_EXTENT))
+			return false;
 		if (is_inode_flag_set(inode, FI_COMPRESSED_FILE) &&
 				 !f2fs_sb_has_readonly(F2FS_I_SB(inode)))
 			return false;
@@ -645,14 +644,10 @@ static unsigned int __destroy_extent_nod
 
 	while (atomic_read(&et->node_cnt)) {
 		write_lock(&et->lock);
-		if (!is_inode_flag_set(inode, FI_NO_EXTENT))
-			set_inode_flag(inode, FI_NO_EXTENT);
 		node_cnt += __free_extent_tree(sbi, et, nr_shrink);
 		write_unlock(&et->lock);
 	}
 
-	f2fs_bug_on(sbi, atomic_read(&et->node_cnt));
-
 	return node_cnt;
 }
 
@@ -691,12 +686,12 @@ static void __update_extent_tree_range(s
 
 	write_lock(&et->lock);
 
-	if (is_inode_flag_set(inode, FI_NO_EXTENT)) {
-		write_unlock(&et->lock);
-		return;
-	}
-
 	if (type == EX_READ) {
+		if (is_inode_flag_set(inode, FI_NO_EXTENT)) {
+			write_unlock(&et->lock);
+			return;
+		}
+
 		prev = et->largest;
 		dei.len = 0;
 


