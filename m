Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 628E04F218;
	Thu, 12 Dec 2024 17:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022964; cv=none; b=l93TzOPOgfJhZnmYtoc7PFsdZMfPIdW4g3Osqf8qgnGNWDALUH9K8OBLAtlgemxdRBedznQg8w9jIQGhGSYqAQnFuExeP7jXqD4qZP03CV58fj81oxWbI9pAJUcLpFZ3zxpssDM43/z/QZsqEug2Hy3xPG4nk3G+LWxfzlr4smI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022964; c=relaxed/simple;
	bh=fi7ePMHERJajQPV/eUbYdIcuBmvPcQz38a12nsvyrEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ceb1PhP1I0rAGySoeA8RseGWUZ+l+4S3DRUIualVDaGFX1+I1/gkPCI0Fu2X3YHP9y0EGurY3Qr6Rlh/7iv6w/RuUE0Qf8uVuYxtIFLyn6q4uFPWVy/SwwgFwN0fpLOpWhjSk6bNd/9DGgNGEH+FV8eMjy4qGJmSxEBhBAcyOyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WhDG/U8w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WhDG/U8w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA16FC4CECE;
	Thu, 12 Dec 2024 17:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022964;
	bh=fi7ePMHERJajQPV/eUbYdIcuBmvPcQz38a12nsvyrEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WhDG/U8w7NyHa1mlrCYtrmUHv510v9T/6HWCh3XU7zXpEL8jY7JUKRb6PHKUP+9IV
	 Wi/FAMOneMoJO6FoIa6oDRbV2Fs8Kmr9yo8OOdxM2XWLOLh2NGXmL7XDm0MPHZY+EB
	 92b9dwus4zbsL60pFPz7aIS9knvqLrPvBxSTodq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3030e17bd57a73d39bd7@syzkaller.appspotmail.com,
	Qu Wenruo <wqu@suse.com>,
	Lizhi Xu <lizhi.xu@windriver.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 380/565] btrfs: add a sanity check for btrfs root in btrfs_search_slot()
Date: Thu, 12 Dec 2024 15:59:35 +0100
Message-ID: <20241212144326.650079691@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Xu <lizhi.xu@windriver.com>

[ Upstream commit 3ed51857a50f530ac7a1482e069dfbd1298558d4 ]

Syzbot reports a null-ptr-deref in btrfs_search_slot().

The reproducer is using rescue=ibadroots, and the extent tree root is
corrupted thus the extent tree is NULL.

When scrub tries to search the extent tree to gather the needed extent
info, btrfs_search_slot() doesn't check if the target root is NULL or
not, resulting the null-ptr-deref.

Add sanity check for btrfs root before using it in btrfs_search_slot().

Reported-by: syzbot+3030e17bd57a73d39bd7@syzkaller.appspotmail.com
Fixes: 42437a6386ff ("btrfs: introduce mount option rescue=ignorebadroots")
Link: https://syzkaller.appspot.com/bug?extid=3030e17bd57a73d39bd7
CC: stable@vger.kernel.org # 5.15+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Tested-by: syzbot+3030e17bd57a73d39bd7@syzkaller.appspotmail.com
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index af6ddf1f913ae..345f205af6198 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1763,7 +1763,7 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		      const struct btrfs_key *key, struct btrfs_path *p,
 		      int ins_len, int cow)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_fs_info *fs_info;
 	struct extent_buffer *b;
 	int slot;
 	int ret;
@@ -1776,6 +1776,10 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	int min_write_lock_level;
 	int prev_cmp;
 
+	if (!root)
+		return -EINVAL;
+
+	fs_info = root->fs_info;
 	might_sleep();
 
 	lowest_level = p->lowest_level;
-- 
2.43.0



