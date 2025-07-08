Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4C31CD1E4;
	Tue,  8 Jul 2025 16:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992692; cv=none; b=q6hxN7xHMZl3r8EZxRHkH+VqIUycI16ydQmUWhVlF7hYbPLT3swMO8hAAHKnzJr6lcT6LuIXPaYQBGsupB/BuJizrsNDqhd03hvLAZpxAw880QAcBj6czmj5Rixjt2XaxxDOGy/N6zL4xUpgqfze6ew3jqEknaix1p4nj5YrPfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992692; c=relaxed/simple;
	bh=sbJWAu2Dh2350x2yURw34LYIc/4zXehfOgWC0uS4F8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TJbM7ZG4FN+lCcApwqe9AZZoqKY4NG3JS6y84nrMA+OgP+hJeClX7h2niRgC2x9BWOZ5irP/LwI9h97//2PLZ6RqlPw+ge47XGq2E11lXSTsInIvf/5XFewu4ldmVLkF7r7Zyy8zevRBeu4+RvYHvBY4lTpiX0/gJp89XL7/vyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NTR2LAV8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NTR2LAV8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BEC7C4CEED;
	Tue,  8 Jul 2025 16:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992692;
	bh=sbJWAu2Dh2350x2yURw34LYIc/4zXehfOgWC0uS4F8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NTR2LAV83iMwWNeHPDmRwHgd2RFCv2X722nQhKd6HADOaOsnK++v8+2YzkcfECZWQ
	 bXd9vfDiIOFcI5mbTz28RFgIsd8mX/EjZr0sb96DMUEJ5wAb4mTFbVHrc5JRBkc6xb
	 0OuJ3NKFOoqh5brjTB4mUfz8QozwwlZAU2ozOPR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 048/232] btrfs: fix iteration of extrefs during log replay
Date: Tue,  8 Jul 2025 18:20:44 +0200
Message-ID: <20250708162242.721244639@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 54a7081ed168b72a8a2d6ef4ba3a1259705a2926 ]

At __inode_add_ref() when processing extrefs, if we jump into the next
label we have an undefined value of victim_name.len, since we haven't
initialized it before we did the goto. This results in an invalid memory
access in the next iteration of the loop since victim_name.len was not
initialized to the length of the name of the current extref.

Fix this by initializing victim_name.len with the current extref's name
length.

Fixes: e43eec81c516 ("btrfs: use struct qstr instead of name and namelen pairs")
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-log.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 40acf9ccccfe7..3ecab032907e7 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1162,13 +1162,13 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
 			struct fscrypt_str victim_name;
 
 			extref = (struct btrfs_inode_extref *)(base + cur_offset);
+			victim_name.len = btrfs_inode_extref_name_len(leaf, extref);
 
 			if (btrfs_inode_extref_parent(leaf, extref) != parent_objectid)
 				goto next;
 
 			ret = read_alloc_one_name(leaf, &extref->name,
-				 btrfs_inode_extref_name_len(leaf, extref),
-				 &victim_name);
+						  victim_name.len, &victim_name);
 			if (ret)
 				return ret;
 
-- 
2.39.5



