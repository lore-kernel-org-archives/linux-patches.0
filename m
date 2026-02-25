Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC86262FC0;
	Wed, 25 Feb 2026 01:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983652; cv=none; b=Kb9IiSHKNjmDaKa6QbkMBYeaVeVsvmaA3yjVHl8eZxOL4iJOWDSo9DIR6PqduUbZzY3cdQ31WXdnZH3HfAVbypW/WaIoDtOH/uZC0QuElNsoagCa6BeXQ1AOLARm+z4XqnvOgdzRDVtrtHduB2hdC8kv+vmbwkhVbb4lBiA9CbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983652; c=relaxed/simple;
	bh=XVBpZbBXquTFsn4Ql9APXExxu44O2on1TE6lv0zalgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mQNpzgqTtz2BkXwA34uLNIj/XZW8JYj+znLSVIE53aRXUADDj9C6acmglQa3JJBEMpD5+lmOX8gL3rEfpcKrnkqVo6ATZtfFsNPiyPB/avjqvKKPJ10SHbjl8qxE7stoabHelqA42JRVxP3huDbcyTHQCa2hlgiXV+7iJfHaZFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hy1x6VQ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hy1x6VQ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EACB5C116D0;
	Wed, 25 Feb 2026 01:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983652;
	bh=XVBpZbBXquTFsn4Ql9APXExxu44O2on1TE6lv0zalgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hy1x6VQ5PcPnfCQfV1eatZOvT3eMDyCbl47bxLvAouApOdQhCytM6Tjmafv3PQEOa
	 vVvrvPUzy3Y3WNtG6jHFhNlB+mE661AzChNYS3x6ilEWWu4xLeChu1tGVOwKUnXlwC
	 tjTCuVIFNzb62Xtw8LiNvH5LzL6K3wECiEOEfX6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 738/781] btrfs: fix invalid leaf access in btrfs_quota_enable() if ref key not found
Date: Tue, 24 Feb 2026 17:24:07 -0800
Message-ID: <20260225012417.830188918@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit ecb7c2484cfc83a93658907580035a8adf1e0a92 ]

If btrfs_search_slot_for_read() returns 1, it means we did not find any
key greater than or equals to the key we asked for, meaning we have
reached the end of the tree and therefore the path is not valid. If
this happens we need to break out of the loop and stop, instead of
continuing and accessing an invalid path.

Fixes: 5223cc60b40a ("btrfs: drop the path before adding qgroup items when enabling qgroups")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/qgroup.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index c634e01140514..bed9d1c11c67a 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1137,11 +1137,14 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info,
 			}
 			if (ret > 0) {
 				/*
-				 * Shouldn't happen, but in case it does we
-				 * don't need to do the btrfs_next_item, just
-				 * continue.
+				 * Shouldn't happen because the key should still
+				 * be there (return 0), but in case it does it
+				 * means we have reached the end of the tree -
+				 * there are no more leaves with items that have
+				 * a key greater than or equals to @found_key,
+				 * so just stop the search loop.
 				 */
-				continue;
+				break;
 			}
 		}
 		ret = btrfs_next_item(tree_root, path);
-- 
2.51.0



