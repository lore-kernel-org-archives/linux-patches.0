Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9A91D4154;
	Tue, 15 Oct 2024 12:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994014; cv=none; b=cc+N3yrvITKfgqYfW5T+997/wKX0FvYhU6N/f8qfN4rSQuHXs7Fvgjx5AYIET4NxVqY1XdMScI1NYSOlDuYNU5pwoyrheLnkgdLO4e9JFAhGiZ/PmGSqbQrat2iMo9D4RiFsZ6ltmMbEgWflt5dQze9jGkeMQXhxXU4G2qUjGas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994014; c=relaxed/simple;
	bh=psGYccKpgM8FpOEyJ2bvPdehn1zn4pT3aY6XB7Hu9Vo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hiwkPZwCuGsIUOnQXo6py7i2Yv9FzgwjjUrM78XOCseMCADkkI8dMoCoK5KGiFmHTQrXO+TDGFZPACI+sFWpY/Rfbln0/aICxag2zJvbvigHDOJL5QwtWaWwR4B2nY/MBCqUb0BxpE6QspH9K203sDsZknFDwaRI+Htg7ym733Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oSLlufh2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oSLlufh2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC9ECC4CEC6;
	Tue, 15 Oct 2024 12:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994014;
	bh=psGYccKpgM8FpOEyJ2bvPdehn1zn4pT3aY6XB7Hu9Vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oSLlufh2RnVF6BdKzFFzDqC5djMoA3cD/jGsjnfoJZVRg1CJ2URCV/t4MkNrLH8Ig
	 gy0PU536FGRY21svE29SOQPzY1bQ3Xe0vuQ8nrxlsDkn45BiHOXX4UHWkRsq58YIKN
	 oEg5j739SWZkhN+VF/r7gbbAJJ/2jBe+iPUuP5nY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhanchengbin <zhanchengbin1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Baokun Li <libaokun1@huawei.com>
Subject: [PATCH 5.15 580/691] ext4: fix inode tree inconsistency caused by ENOMEM
Date: Tue, 15 Oct 2024 13:28:48 +0200
Message-ID: <20241015112503.360615372@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3232,7 +3232,7 @@ static int ext4_split_extent_at(handle_t
 		ext4_ext_mark_unwritten(ex2);
 
 	err = ext4_ext_insert_extent(handle, inode, ppath, &newex, flags);
-	if (err != -ENOSPC && err != -EDQUOT)
+	if (err != -ENOSPC && err != -EDQUOT && err != -ENOMEM)
 		goto out;
 
 	/*


