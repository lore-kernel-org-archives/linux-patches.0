Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0433F359A73
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302433; cv=none; b=aAks3yEcGSIb8aBNf/N+4GyRr9J7tEW5IDf8ZIAyhTNPK8P2++pTHzbtM7fPn8+sDVdnpa9x2Mu8x6p+nXCBAKUJiEK62K0ODEh6RGS40Wj3hHLhut2vIFT9ZiZMEWahLdaWHAe3cRKi9QSsXNm9SJyZIbJN/KmKudcK6wgPVUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302433; c=relaxed/simple;
	bh=ydDWJ/2BF3aKyW9nfVs1dGbkLJVxJHoGb/nuXugozaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FMazsQ49gWJKx7OsN0RwrtkmYxzkNbO/KUkGruuVNlJwRn6YcnnxCDD0n+KlLJoOpwUqDBeqlxTL+r1F+ymEeZEgOt8hKHxhe9W1Vxngl09XAVgW2IzmF642PztgDr9vWzqvy99fH/NF4d5vZl4v8TYplhvRhf99AhL/XcJeuRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=orHj9EOP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="orHj9EOP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2763AC19425;
	Sat, 28 Feb 2026 18:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302432;
	bh=ydDWJ/2BF3aKyW9nfVs1dGbkLJVxJHoGb/nuXugozaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=orHj9EOPuUN5UoeAJOVwft3xBXLLu9LatsbiPCzP6SuAf4buVCCcd1Z9lLC+1hbt0
	 IYcQb9FISbdRb0bqULR+qTN2vibK14Ww1fAwkOc460EKF+TDPOF6ARvAedy81y2LUy
	 CoQ/Wbt66S7R7KlKBtIbFlhu9Vf3Tg7OkdkZO3SvQmhhNHUAZHWvAPz9wrml9Gjs00
	 7++5tz6JE5Jvt1b+T6eEF5uDR6E5T3VD8GMsl/njlbeYTGFChRMsoWjemsrO1hrTfk
	 PgMLmIzJLLaAkc5qMSO/Gkz5yHnvrd4oIYsUwEcQ6E8rz96s7eSOzwY0iMCHVRUNLg
	 sl1sVM3uwjfww==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Zhang Yi <yi.zhang@huawei.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Baokun Li <libaokun1@huawei.com>,
	stable@kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.1 170/232] ext4: don't cache extent during splitting extent
Date: Sat, 28 Feb 2026 13:10:23 -0500
Message-ID: <20260228181127.1592657-170-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Zhang Yi <yi.zhang@huawei.com>

commit 8b4b19a2f96348d70bfa306ef7d4a13b0bcbea79 upstream.

Caching extents during the splitting process is risky, as it may result
in stale extents remaining in the status tree. Moreover, in most cases,
the corresponding extent block entries are likely already cached before
the split happens, making caching here not particularly useful.

Assume we have an unwritten extent, and then DIO writes the first half.

  [UUUUUUUUUUUUUUUU] on-disk extent        U: unwritten extent
  [UUUUUUUUUUUUUUUU] extent status tree
  |<-   ->| ----> dio write this range

First, when ext4_split_extent_at() splits this extent, it truncates the
existing extent and then inserts a new one. During this process, this
extent status entry may be shrunk, and calls to ext4_find_extent() and
ext4_cache_extents() may occur, which could potentially insert the
truncated range as a hole into the extent status tree. After the split
is completed, this hole is not replaced with the correct status.

  [UUUUUUU|UUUUUUUU] on-disk extent        U: unwritten extent
  [UUUUUUU|HHHHHHHH] extent status tree    H: hole

Then, the outer calling functions will not correct this remaining hole
extent either. Finally, if we perform a delayed buffer write on this
latter part, it will re-insert the delayed extent and cause an error in
space accounting.

In adition, if the unwritten extent cache is not shrunk during the
splitting, ext4_cache_extents() also conflicts with existing extents
when caching extents. In the future, we will add checks when caching
extents, which will trigger a warning. Therefore, Do not cache extents
that are being split.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Reviewed-by: Baokun Li <libaokun1@huawei.com>
Cc: stable@kernel.org
Message-ID: <20251129103247.686136-6-yi.zhang@huaweicloud.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/extents.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 1aad4ae0e7ae4..1398da08fd5a3 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3174,6 +3174,9 @@ static int ext4_split_extent_at(handle_t *handle,
 	BUG_ON((split_flag & (EXT4_EXT_DATA_VALID1 | EXT4_EXT_DATA_VALID2)) ==
 	       (EXT4_EXT_DATA_VALID1 | EXT4_EXT_DATA_VALID2));
 
+	/* Do not cache extents that are in the process of being modified. */
+	flags |= EXT4_EX_NOCACHE;
+
 	ext_debug(inode, "logical block %llu\n", (unsigned long long)split);
 
 	ext4_ext_show_leaf(inode, path);
@@ -3344,6 +3347,9 @@ static int ext4_split_extent(handle_t *handle,
 	ee_len = ext4_ext_get_actual_len(ex);
 	unwritten = ext4_ext_is_unwritten(ex);
 
+	/* Do not cache extents that are in the process of being modified. */
+	flags |= EXT4_EX_NOCACHE;
+
 	if (map->m_lblk + map->m_len < ee_block + ee_len) {
 		split_flag1 = split_flag & EXT4_EXT_MAY_ZEROOUT;
 		flags1 = flags | EXT4_GET_BLOCKS_PRE_IO;
-- 
2.51.0

