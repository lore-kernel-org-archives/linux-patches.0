Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD9F1494DB;
	Thu,  5 Sep 2024 10:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530702; cv=none; b=Bu+JkiHrm9wa5UweYQ6yVVHf8NCvJzxiaeWYqad9b04pgSrwdNSVMLZ5zzAAnqgM/g4W+n4uTKkRJYFJQAV+5ceQL5BmRTjEapFxUxpI9Eh3cC8LiPHocCUSRJXKin2b/QN3ZHdPzd7wb0SDHbPhF6bjU+lTR3JYxVeyoOjRUHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530702; c=relaxed/simple;
	bh=CS/YmHa9dlgdbz1B0Xh4BDdnQ9IFtGgXnJn+xOlBCb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QYUSNodWBrko4FeHxfuxW0KJs+6nDolCr04bYmzfYoDlhdnfOrvAp82bZDDEZB0Berf2Y6lK5omBd36xMwBtKE/HPa/VksuhxMcGbqPwh+GW9GX3WXrAvrOaWNqswNjZYSxvu7r/s+knn0Ql7LFu65MKUHvsA412nHJZkHGZsA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nY75bF1y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nY75bF1y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09FF4C4CEC3;
	Thu,  5 Sep 2024 10:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530702;
	bh=CS/YmHa9dlgdbz1B0Xh4BDdnQ9IFtGgXnJn+xOlBCb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nY75bF1yEsaJWNDzxL6jjAP+L90/6WhvivyC2KJrM2+Y4H6gcZT2QToSAwGwislZr
	 dZ1lYHXGojPfb3RDVjxZX+supQYxOYKipcV7BeDmXpeBKt0jNaZHg1MPqIzcP/O97I
	 3zs43iHDQpNx9n/Sq+4ozQkAUNO2/miYroDbBAC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhanchengbin <zhanchengbin1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.1 097/101] ext4: fix inode tree inconsistency caused by ENOMEM
Date: Thu,  5 Sep 2024 11:42:09 +0200
Message-ID: <20240905093719.916337677@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/extents.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3229,7 +3229,7 @@ static int ext4_split_extent_at(handle_t
 		ext4_ext_mark_unwritten(ex2);
 
 	err = ext4_ext_insert_extent(handle, inode, ppath, &newex, flags);
-	if (err != -ENOSPC && err != -EDQUOT)
+	if (err != -ENOSPC && err != -EDQUOT && err != -ENOMEM)
 		goto out;
 
 	if (EXT4_EXT_MAY_ZEROOUT & split_flag) {


