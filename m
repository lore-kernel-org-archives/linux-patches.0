Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BAEF145A16;
	Fri,  6 Dec 2024 15:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498498; cv=none; b=lOvr+W+htsxF2DIQ/1yEdazVx8KMjMMVEpNHhdYRuVGR8oeQn05cB4mtDXHR46NstwF6IJC9fC286ARLIJkiq3ABVDZYXg7u3qcuiHuG8JRPH1bMAuO6nfKmNUrLNa73VrcuN9HDh74a7bNTz6BGbs5E3NZb3Vn9ZuL8rh+z25o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498498; c=relaxed/simple;
	bh=7LOg0OfBd7ziLXhaHemHiDS4M+Uluq6ZMSw5i3BXOmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h4rL+/tKY2TCsqP7vtKQVGl+PBwxUoBQfFTX+i/Q9I1UfOAi34BB+qWkSl6fX+Lnieun4WAKVcR+Bb6LcI1txtXk4fcwvghD26ex+j3Z7Ta2V3gmjUbMd6KohiUCV8KADmQiz0CzeQsKZaMAD+DZsbNAJ4XvhmadQruB5QqWNgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HySlmVC+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HySlmVC+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D6C3C4CEDC;
	Fri,  6 Dec 2024 15:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498498;
	bh=7LOg0OfBd7ziLXhaHemHiDS4M+Uluq6ZMSw5i3BXOmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HySlmVC+a6u+n4OiYMSG/rRg4L/Q/0XAhFjpWSQEOmRxhFpbjSneKvX64qcbXqvNX
	 4rSS//i+8TREGeE+lRN8IBDhtDdF8KrwgM6GKSzozgSscChcH2RCvw31Fo8LVIgGCd
	 I73ZPpo14qM6zoHLvxWiYjygrw7oTwqXNcvpLivE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3030e17bd57a73d39bd7@syzkaller.appspotmail.com,
	Qu Wenruo <wqu@suse.com>,
	Lizhi Xu <lizhi.xu@windriver.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 603/676] btrfs: add a sanity check for btrfs root in btrfs_search_slot()
Date: Fri,  6 Dec 2024 15:37:02 +0100
Message-ID: <20241206143716.926064696@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index bb5d317fcdbe9..25c902e7556d5 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2157,7 +2157,7 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		      const struct btrfs_key *key, struct btrfs_path *p,
 		      int ins_len, int cow)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_fs_info *fs_info;
 	struct extent_buffer *b;
 	int slot;
 	int ret;
@@ -2170,6 +2170,10 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
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



