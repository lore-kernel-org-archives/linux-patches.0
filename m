Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D75724354D;
	Thu, 12 Dec 2024 16:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020410; cv=none; b=DTMrzfA48Bn4AbJkl5B/YzCh9eY2unbK68xaiAuVt+6R4w33B4C7ybOj+KHDIcfcgu/3nVig9G3yNskanNwJXSl03YfI+kblKfHIjShF1hZM8epB8z/5s8MHIUwvfF88XLAaVqgS3SH8eEmmhijuH6sitES6wW9iMO0S79nEOZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020410; c=relaxed/simple;
	bh=Pmz6/Qfj/53LCcofZRb9IG30V5WsehzLflhFAMtF9lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mEbFqPZOsureoV3Etk5qjmMvhH9XbMOP5Ikhq7BucMEwBhlOoF2fj1NPEV4XKyAyHTdnwhqWwvSahcZ27MqEjsXoOLHXmb2p/MRAb95PCCvsRFvAA6pfjHIG3AKxJpOJJeA+df4wESf5dyXKB8uBqaQ0gp4cmUt+oqC478jlb78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f+EQkiPM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f+EQkiPM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C064CC4CECE;
	Thu, 12 Dec 2024 16:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020410;
	bh=Pmz6/Qfj/53LCcofZRb9IG30V5WsehzLflhFAMtF9lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f+EQkiPM8rEjh57gBkUDxabQOk3vGtojFd//egBdeMXqgV8ATZGBcNbKpJR4daMyd
	 htfEkQPCn4EacTOMbm4Idvwv37WNo9rz7RV+16IjrvCOwdhajDYatPoCk0DDSgJH03
	 cFKXjm9hGOQLd/3ZdagILNHeK6gs7DIuE9mO85tQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3030e17bd57a73d39bd7@syzkaller.appspotmail.com,
	Qu Wenruo <wqu@suse.com>,
	Lizhi Xu <lizhi.xu@windriver.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 453/772] btrfs: add a sanity check for btrfs root in btrfs_search_slot()
Date: Thu, 12 Dec 2024 15:56:38 +0100
Message-ID: <20241212144408.645350933@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 46550c26e6844..347934eb5198d 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1973,7 +1973,7 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		      const struct btrfs_key *key, struct btrfs_path *p,
 		      int ins_len, int cow)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_fs_info *fs_info;
 	struct extent_buffer *b;
 	int slot;
 	int ret;
@@ -1986,6 +1986,10 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
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



