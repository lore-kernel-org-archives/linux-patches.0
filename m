Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290D11922D0;
	Tue, 10 Sep 2024 10:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963107; cv=none; b=T0KuAEtevlZ794XbMbdRejR+XtWArl6jq0V4EYZOflZRg80sgfH881FRbt3CLuxek1kYjeoVBZRYKhf1hILKZdaZH1WTBYnEkuMRQ7OL56/Bkh97fZFGYOu1t0AQ2+47W+J/iPpREl0QmfvrTxBLkBk5PH+r3KGL1mcmHshd4m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963107; c=relaxed/simple;
	bh=uFY4AOG7Zivuh+QcnTYqkFAfyy+OoExM+T38oG7JLv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u3ljZk+Ox4EdvG8KDWkOA2hDS17gAT6IyGUdpy7gHOLRfOEYBJoQSAb3qsGPPXpo1UIq0Qa9IgfWJn29hsIBfh1JVFyiM1JqVdd8mFAtpTH4myXDSLFI4xkKCVGGdJzdegcB7me0DHMvH4qfoQJQoh0cQmkwup/9lwKOT5diOho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VT5rZXSk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VT5rZXSk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B32C4CECE;
	Tue, 10 Sep 2024 10:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963107;
	bh=uFY4AOG7Zivuh+QcnTYqkFAfyy+OoExM+T38oG7JLv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VT5rZXSkYLz6xN1WZQrgb3env2ikSUTemBilEc6FNkWSJ1cG0QFXwuc8MoYxtZg59
	 ffcU9gLB/uefbQUgqYX4cG+fNmWQwVq5VJ2qHgTb0XWzK77nRqQ593Nt63W0wv9lMp
	 44kwwiVB7jDV+ixeLRoRwVMDnp/ZtqGYXPIYNauo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 111/192] btrfs: replace BUG_ON() with error handling at update_ref_for_cow()
Date: Tue, 10 Sep 2024 11:32:15 +0200
Message-ID: <20240910092602.568246078@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit b56329a782314fde5b61058e2a25097af7ccb675 ]

Instead of a BUG_ON() just return an error, log an error message and
abort the transaction in case we find an extent buffer belonging to the
relocation tree that doesn't have the full backref flag set. This is
unexpected and should never happen (save for bugs or a potential bad
memory).

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index e08688844f1e..66d1f34c3fc6 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -324,8 +324,16 @@ static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
 	}
 
 	owner = btrfs_header_owner(buf);
-	BUG_ON(owner == BTRFS_TREE_RELOC_OBJECTID &&
-	       !(flags & BTRFS_BLOCK_FLAG_FULL_BACKREF));
+	if (unlikely(owner == BTRFS_TREE_RELOC_OBJECTID &&
+		     !(flags & BTRFS_BLOCK_FLAG_FULL_BACKREF))) {
+		btrfs_crit(fs_info,
+"found tree block at bytenr %llu level %d root %llu refs %llu flags %llx without full backref flag set",
+			   buf->start, btrfs_header_level(buf),
+			   btrfs_root_id(root), refs, flags);
+		ret = -EUCLEAN;
+		btrfs_abort_transaction(trans, ret);
+		return ret;
+	}
 
 	if (refs > 1) {
 		if ((owner == root->root_key.objectid ||
-- 
2.43.0



