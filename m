Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804C51C4A0C;
	Tue, 15 Oct 2024 13:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998294; cv=none; b=D88X2Y8iDipCZqTXASaXPncVs4ViLiPfw3t7vA/3EU80sGqx/rJK38VtA6K7zmL9vYnw6uKpDRG9/wghfrjNXLsXOj6M8bPXBHSV33ji7RbiHeEpXuR8kcydkuhbb3coCWsnDfNVsIWt48Dm5G0V70gLc38SVwRU+mbDZ9AYjKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998294; c=relaxed/simple;
	bh=kaHrqo6wwSToQbiXpc6hcXEshZ+6r+IBAbXz8mGEm4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Usd8JvmXuGDw9U3XvtxgYDB7fiV9X1g9VHBNtrawHQValbY0B2Lb9GNCb3gVi6Ht2aj3qtvy0I6cTpChzA7EcJI5oQO432D5vNgFlsb890rAY/K6ye5EwfQ4ZLZaLNwnEHFb/k+BEl5LR+vDZ4ERoVb26zJnIP5RSD2cVR5YNcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y7sx57nJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y7sx57nJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6586C4CECF;
	Tue, 15 Oct 2024 13:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998294;
	bh=kaHrqo6wwSToQbiXpc6hcXEshZ+6r+IBAbXz8mGEm4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y7sx57nJqLb9OsAxpWmW35gqLxh5iAWHSE9r2fLRSK10OXlW4UP1Yt0ubGuc2IUrL
	 X8FippCrMrRjex3hK8jZLxjtcUo+PsV87sycLljL1GzYekKo/IMLMYwJrHPHNHvyAL
	 SzX7XhyyVnIZQi1uBg1PA4WIjnBTjAF9jEHBSM7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhanchengbin <zhanchengbin1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Baokun Li <libaokun1@huawei.com>
Subject: [PATCH 5.10 434/518] ext4: fix inode tree inconsistency caused by ENOMEM
Date: Tue, 15 Oct 2024 14:45:38 +0200
Message-ID: <20241015123933.749171281@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: zhanchengbin <zhanchengbin1@huawei.com>

commit 3f5424790d4377839093b68c12b130077a4e4510 upstream.

If ENOMEM fails when the extent is splitting, we need to restore the length
of the split extent.
In the ext4_split_extent_at function, only in ext4_ext_create_new_leaf will
it alloc memory and change the shape of the extent tree,even if an ENOMEM
is returned at this time, the extent tree is still self-consistent, Just
restore the split extent lens in the function ext4_split_extent_at.

ext4_split_extent_at
 ext4_ext_insert_extent
  ext4_ext_create_new_leaf
   1)ext4_ext_split
     ext4_find_extent
   2)ext4_ext_grow_indepth
     ext4_find_extent

Signed-off-by: zhanchengbin <zhanchengbin1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20230103022812.130603-1-zhanchengbin1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: Baokun Li <libaokun1@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/extents.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3227,7 +3227,7 @@ static int ext4_split_extent_at(handle_t
 		ext4_ext_mark_unwritten(ex2);
 
 	err = ext4_ext_insert_extent(handle, inode, ppath, &newex, flags);
-	if (err != -ENOSPC && err != -EDQUOT)
+	if (err != -ENOSPC && err != -EDQUOT && err != -ENOMEM)
 		goto out;
 
 	/*


