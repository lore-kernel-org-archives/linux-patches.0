Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA1A2C026C;
	Sat, 17 Oct 2026 18:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260053; cv=none; b=qy8SevlpEXCD2XtLdhHzzHIRTLYW5G+XM1vmy2CAJS1pJIjCy8XbD2LroNDfTL2MfVWcHkfSklqGDSlJqa+MvQPg6MT8iA0i02pJZq+a+0dOrQFc5Mw+9nmi2acmImzwU+ki56P4/4UVxEuZEf6F7ZG5zrC2JYRk40hW9KQHlU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260053; c=relaxed/simple;
	bh=uS6kdynQGZizRmnNtlFkTHy8oKWFcdEqjOFOHBHj7JM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D3hHwpwBmhDusrlyYkTxnY+3+0fDWVI9+wfd8NlliPws/pYK4YJ4FEYdO5DLWVJvkUOJmtnfwhl0NdEZmYcRvbL61cgPeTJVx+g+tl/EesIkll/JUVikSp39/Ro0PsyKKmQsJWcQCxnBCLcESx1H01287jc7C5iHLVqjPHsEGRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V9+mN5U8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V9+mN5U8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A32B21F000C4;
	Sat, 17 Oct 2026 18:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260052;
	bh=b/EYPmpsFTIgZ31aG4OWXNaDK10pwLFHPDRn4/wmdx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V9+mN5U85GCcDKe9+/36BmFIGhFVJKjwPo48bQbUZcHxPwepni5DsYluDMJTPa7hg
	 7bly4EEbyeykXZIwfy28iHS10IDQzBfnWr+MGG96ycxCC3C6GpHO4LqHVSDpDtm2Nh
	 QvWAJRiApYHBWuOcf12HhQ2bYcbeYDPskl9/m1wo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1418/1674] btrfs: qgroup: fix a wrong length calculation in qgroup_free_reserved_data()
Date: Sat, 17 Oct 2026 18:01:30 +0200
Message-ID: <20261017160507.577066993@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 622febdb61e23..e4c4d369eb8d9 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3897,12 +3897,13 @@ static int qgroup_free_reserved_data(struct btrfs_inode *inode,
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
@@ -3914,12 +3915,15 @@ static int qgroup_free_reserved_data(struct btrfs_inode *inode,
 
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



