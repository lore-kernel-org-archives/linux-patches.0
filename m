Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB061078F;
	Tue, 30 Jul 2024 16:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358284; cv=none; b=p8rQ+kYwP//qsoUudq2zo8pzk8NFMHUTNZ4Ijzl5eHf1kqvuGUdKkabpXAVqxrVcylaVDD4OAM2g9lek7HEmLhLwz6p2+IuHmPjFEKo+JkfnmTsrPpNFnUrl/AvXKggZwsBenKLuJJa8Qth529bcYo9aNVZU0ealNwX1Yd3GuB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358284; c=relaxed/simple;
	bh=Q8t0Skx2mRR8MkFpPF2jJ4zXoAyw3v7Pd79Y6NtF06Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o4iQ5lNwwvuSQoeegUUfF5lwbGNg5WbBTORVWLtltLR/nIXJggLnKOJ9edNZTGtirS73iGzXEbKgw5z2i85CDjb6nppokf+/LUk/qSC34ya2yv869tRtdhFFCE5nS670qpbhp7OcXiT/Pgt61RIpCH2GSH2iCrjqZWQaZLI6gfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bk2VPjZN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bk2VPjZN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5899C32782;
	Tue, 30 Jul 2024 16:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358284;
	bh=Q8t0Skx2mRR8MkFpPF2jJ4zXoAyw3v7Pd79Y6NtF06Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bk2VPjZNj2kEX4SKgX0bVE3kA+PU34kM5ZeBH4ijeT0BSjzotRSJwxB6aaQHsTYFh
	 yM3kTHj6Bm23DTwA59ZzHI9fab5juJlzbivF4y4PBmXOwj+oB1d+3hWYb3Wf2PY67f
	 3QXOnEFUPPAOBaCXHdKGhiM5D8swHz6kyaZhWlNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 332/568] fs/ntfs3: Correct undo if ntfs_create_inode failed
Date: Tue, 30 Jul 2024 17:47:19 +0200
Message-ID: <20240730151652.847349760@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit f28d0866d8ff798aa497971f93d0cc58f442d946 ]

Clusters allocated for Extended Attributes, must be freed
when rolling back inode creation.

Fixes: 82cae269cfa95 ("fs/ntfs3: Add initialization of super block")
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/inode.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 86ade4a9ec8f3..1545262995da2 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -1652,7 +1652,9 @@ struct inode *ntfs_create_inode(struct mnt_idmap *idmap, struct inode *dir,
 	 * The packed size of extended attribute is stored in direntry too.
 	 * 'fname' here points to inside new_de.
 	 */
-	ntfs_save_wsl_perm(inode, &fname->dup.ea_size);
+	err = ntfs_save_wsl_perm(inode, &fname->dup.ea_size);
+	if (err)
+		goto out6;
 
 	/*
 	 * update ea_size in file_name attribute too.
@@ -1694,6 +1696,12 @@ struct inode *ntfs_create_inode(struct mnt_idmap *idmap, struct inode *dir,
 	goto out2;
 
 out6:
+	attr = ni_find_attr(ni, NULL, NULL, ATTR_EA, NULL, 0, NULL, NULL);
+	if (attr && attr->non_res) {
+		/* Delete ATTR_EA, if non-resident. */
+		attr_set_size(ni, ATTR_EA, NULL, 0, NULL, 0, NULL, false, NULL);
+	}
+
 	if (rp_inserted)
 		ntfs_remove_reparse(sbi, IO_REPARSE_TAG_SYMLINK, &new_de->ref);
 
-- 
2.43.0



