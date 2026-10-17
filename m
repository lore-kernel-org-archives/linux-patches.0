Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB7936AB6B;
	Sat, 17 Oct 2026 16:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255040; cv=none; b=qGZlq9BE79gt+lxK2WGLbCfsLLPu9fZ6sY1FhW2bmmibYNRguxIMqUW/THks3+oC7JYqqmlhw14XVxlznVf2C3f3ZeTgAFnfzwUaBO5aZZDFDmPTmkXcwCaCndw+ttYnbZEnRKd5tGFFng/2aCF87IgpmPySqm4eMWYsZfqMsO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255040; c=relaxed/simple;
	bh=Zs1SK1GryzqIMwGQLSmrUWc+/9We6gPabet8L7B8dHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ljCiVn2cJAIALVUtWOKIG1f3I0wZk2ikiFz0Z6XfRsm1e72ToGdfVEiFcBi1t1dH4BulDXDPs7a7Cay1BsMvrLNBzgT2xpk+3SW/rZap01vSnYEIt7MeFvhmXvOdE+z79lQTmwE8wea2q8Nlb14tRsxIEUs5Th5/Lnl7awNK9TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FhwEF8q2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FhwEF8q2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 841FA1F000C4;
	Sat, 17 Oct 2026 16:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255039;
	bh=SkaAQIA1KpCRsiXiEhNQTtQ1XE+CobT8xR0yoTSca64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FhwEF8q2gVVEYgDfzUJA6mQSi+CGXQJ1VeHFC0ULDTOsWSeEfZGZBC96Ime1gFucJ
	 dN+vGAJEsH6ElAP0lGZRtvXxphelpye98S7qk+Y3WBWen88fQIwiCpoto2et1i9LMa
	 ZHyyq2+mBhuMUtrL5cxa9AZPFWXFuszqCEnCbBl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 643/869] btrfs: qgroup: fix a wrong length calculation in qgroup_free_reserved_data()
Date: Sat, 17 Oct 2026 17:58:04 +0200
Message-ID: <20261017160053.500710243@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 9102b179512e11644fb0489ae62010a09afa199c ]

In that function, we round down the start position and round up the
ending position.

But during the calculation of @len, we use "round_up(start + len,
sectorsize)", which is the rounded up end position, not the rounded up
length.

Which results a much larger length, and later we are still using
"start + len", which is completely incorrect.

Fix it by declaring a local @aligned_start and @aligned_len and use them
instead.

Fixes: bc42bda22345 ("btrfs: qgroup: Fix qgroup reserved space underflow by only freeing reserved ranges")
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/qgroup.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 5b158eb25d181..57552c414b43a 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -4371,12 +4371,13 @@ static int qgroup_free_reserved_data(struct btrfs_inode *inode,
 	struct ulist_node *unode;
 	struct ulist_iterator uiter;
 	struct extent_changeset changeset;
+	const u32 sectorsize = root->fs_info->sectorsize;
+	const u64 aligned_start = round_down(start, sectorsize);
+	const u64 aligned_len = round_up(start + len, sectorsize) - aligned_start;
 	u64 freed = 0;
 	int ret;
 
 	extent_changeset_init(&changeset);
-	len = round_up(start + len, root->fs_info->sectorsize);
-	start = round_down(start, root->fs_info->sectorsize);
 
 	ULIST_ITER_INIT(&uiter);
 	while ((unode = ulist_next(&reserved->range_changed, &uiter))) {
@@ -4388,12 +4389,15 @@ static int qgroup_free_reserved_data(struct btrfs_inode *inode,
 
 		extent_changeset_release(&changeset);
 
-		/* Only free range in range [start, start + len) */
-		if (range_start >= start + len ||
-		    range_start + range_len <= start)
+		/*
+		 * Only free the range within
+		 * [aligned_start, aligned_start + aligned_len).
+		 */
+		if (range_start >= aligned_start + aligned_len ||
+		    range_start + range_len <= aligned_start)
 			continue;
-		free_start = max(range_start, start);
-		free_len = min(start + len, range_start + range_len) -
+		free_start = max(range_start, aligned_start);
+		free_len = min(aligned_start + aligned_len, range_start + range_len) -
 			   free_start;
 		/*
 		 * TODO: To also modify reserved->ranges_reserved to reflect
-- 
2.53.0



