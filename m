Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDC734E765;
	Tue, 16 Dec 2025 11:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886122; cv=none; b=fVlV/H+qp9xIr/Ms7xBb1+CqVVfxGM715ibZxguQAPrcVUmWjMY+ljRYyjnt/r+C1XVi0oivl2GPKvWjQ8ttU6nLFtw1QQyCLQIDSHUrOpf6k2wmVi8jQbVJ6slDwpmfoNVyc6sM5EfmNm959WBVB1ATUSybbYW2rOb7ZJTv3EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886122; c=relaxed/simple;
	bh=ohH+PWaRBGr/TJYXDUqcgyBRKoHy8LWVgbRaEcywoFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=afxW9I/iQxzFAaMkzLwhGhrisbFpc6Cm7x5r+GW3QRa/7h4vGSafd6EQMM/V87fEZwa2c4x27f28lKSIw5XgFN60+5KNrMjO3OhIIERUA11oVYZGzgIENZ3e5JYrQ8V1lrr63lW1mAWPjykdk//TZuSAkvdjIUbfv8ISgsmzacg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BVn85dvq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BVn85dvq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6650C4CEF1;
	Tue, 16 Dec 2025 11:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886122;
	bh=ohH+PWaRBGr/TJYXDUqcgyBRKoHy8LWVgbRaEcywoFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BVn85dvq1Tw6+0B2emaFOflpO53L9CSam+fGSPLR35THGkz95P+mCMvpH2iOdrojD
	 CFLWX7rDm8ijoStVbD8v4sOCLluBEA+vVn9S7m1zAfLTjarHwBLsuKuhTFcFox4rq7
	 tIIMbLxOUG7k13dvqhsuMzXp7XhLMIM0WrDq95mI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 343/507] btrfs: fix leaf leak in an error path in btrfs_del_items()
Date: Tue, 16 Dec 2025 12:13:04 +0100
Message-ID: <20251216111357.886721819@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit e7dd1182fcedee7c6097c9f49eba8de94a4364e3 ]

If the call to btrfs_del_leaf() fails we return without decrementing the
extra ref we took on the leaf, therefore leaking it. Fix this by ensuring
we drop the ref count before returning the error.

Fixes: 751a27615dda ("btrfs: do not BUG_ON() on tree mod log failures at btrfs_del_ptr()")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 74e6d7f3d2660..47776c4487bcd 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -4557,9 +4557,9 @@ int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 			if (btrfs_header_nritems(leaf) == 0) {
 				path->slots[1] = slot;
 				ret = btrfs_del_leaf(trans, root, path, leaf);
+				free_extent_buffer(leaf);
 				if (ret < 0)
 					return ret;
-				free_extent_buffer(leaf);
 				ret = 0;
 			} else {
 				/* if we're still in the path, make sure
-- 
2.51.0



