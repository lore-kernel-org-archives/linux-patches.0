Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0EFA1DF267;
	Wed,  6 Nov 2024 12:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895466; cv=none; b=K0N0l4ytzpKDYYGTTAUTzyrogId40ZI5g3L2ve98/u4nqWWoyA1Fe840+r960PY2mc8uKYdFV/ht1U5pgJ7ttrwOaXIbgknJ6wfyOxSgLBtGdyTMl3zk+upQ8Sx92Q+D3X5WuFkmPVR+WsqlYTJk2c4ZYgwikX4CBw4T5hvu4no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895466; c=relaxed/simple;
	bh=2zuKzC8GugTu2YHA3ywtIdY60oPXTISWIiHiJWDTAVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dHtNTANr1ZUJpghqLy6DnQNSCfoNGNw/pUoP6W13rj5336oionuStoYUgNZFKUmgUVhEnJ5uYqnPIBZlhtp/R1uiUoz+BJdugumaRMxYWZdSKIWwUx+715UnDuqMQWsAQcNGb5Zf/oFDpHu8i7/XB5AIH7neZRwQwLfp5c3wBVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JO6mRJff; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JO6mRJff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28331C4CECD;
	Wed,  6 Nov 2024 12:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895465;
	bh=2zuKzC8GugTu2YHA3ywtIdY60oPXTISWIiHiJWDTAVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JO6mRJffJIj3OBMMazVm4u0zmWo/NS8+we3NMYwSOAAU8dCFiYjSGnX20fC/RpmnQ
	 2qpvdFTWSPIwNTyzdcSPXMFqO8Ye093HqCBjpNAeq5UWxHFXi+12fgi42yX4nMO5hD
	 wwv4MPQGWUgVnkoaH35yt9wnBsniXys43FZWox20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhanchengbin <zhanchengbin1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Baokun Li <libaokun1@huawei.com>
Subject: [PATCH 4.19 227/350] ext4: fix inode tree inconsistency caused by ENOMEM
Date: Wed,  6 Nov 2024 13:02:35 +0100
Message-ID: <20241106120326.594865305@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3293,7 +3293,7 @@ static int ext4_split_extent_at(handle_t
 		ext4_ext_mark_unwritten(ex2);
 
 	err = ext4_ext_insert_extent(handle, inode, ppath, &newex, flags);
-	if (err != -ENOSPC && err != -EDQUOT)
+	if (err != -ENOSPC && err != -EDQUOT && err != -ENOMEM)
 		goto out;
 
 	/*


