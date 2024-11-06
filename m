Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD5E1F4734;
	Wed,  6 Nov 2024 13:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898609; cv=none; b=NMhk3MEOL3PKCn7oW+PYCi8wvaWymDESMuFDrxy7ZsHuxPKcca8467q+4g9c4zhjnBZ7wB8LBi76a7LYBA4DL71lOcSpcSMvZkWvqobp4iWycgnim33oNowGON/+TglAH4ceSkXO9o8o87NMKb7x0n6m/dVefem3aVpiqT+sECE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898609; c=relaxed/simple;
	bh=pXThfSNgavUvMV2XZSxfL7aBlAQt9bskUBaH2yJaBKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mCPoz0JA0cKuYWwpYZUCZmTBT+UiVepgk34l3wYIlnGRa00hA/+FoqHwsF5kZnSfIQ6P5hihsag8SeUXPMrujea7+3NFwgf+KmvuNwoujBf6voaS4CklJRNCS+/ZYHo9ZcZD49eVrE7ihGHuKDHW0tflEJPPxqXj6G6dPPz3Ark=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BzC+td2n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BzC+td2n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 930C5C4CECD;
	Wed,  6 Nov 2024 13:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898609;
	bh=pXThfSNgavUvMV2XZSxfL7aBlAQt9bskUBaH2yJaBKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BzC+td2nJo33yY78LH0j2bGJRV2+JuoAIzkKiCOTYi+NJqau/UAzrmCuVxy9llGKZ
	 Gl/AYJnIfE6vY3qxitBV5qn24s0t8Jw3afAfPoN4wNAy7mqeDn+D7R9HQNm0dyLHOk
	 gWK8+AUoC8Hk8zR90Xav5ym0oYorYIi2Jbr5jMnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhanchengbin <zhanchengbin1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Baokun Li <libaokun1@huawei.com>
Subject: [PATCH 5.4 295/462] ext4: fix inode tree inconsistency caused by ENOMEM
Date: Wed,  6 Nov 2024 13:03:08 +0100
Message-ID: <20241106120338.810725594@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3421,7 +3421,7 @@ static int ext4_split_extent_at(handle_t
 		ext4_ext_mark_unwritten(ex2);
 
 	err = ext4_ext_insert_extent(handle, inode, ppath, &newex, flags);
-	if (err != -ENOSPC && err != -EDQUOT)
+	if (err != -ENOSPC && err != -EDQUOT && err != -ENOMEM)
 		goto out;
 
 	if (EXT4_EXT_MAY_ZEROOUT & split_flag) {


