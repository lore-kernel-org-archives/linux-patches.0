Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C61B359A8F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302435; cv=none; b=eKm6wZjEbRnAVupN5gb8ZaspNRcQ4n79ih73SRJ5zuYTqmZDZ49biB2yUXgHifzyknJiNk73eycaKfYXt4qQZPTXZ1050nkO75JF4KYiPn/GA1sQ2LXpy5QBsNo5fCuN8CXPk3qR9bynP95/txh73uS6jk6dOw97MOW+cFqmpt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302435; c=relaxed/simple;
	bh=U7+5u9HDGOsSQd1ytScckObazn13DlBQe+KNNBaXMWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aMPE64ZweiTla4HYSjnFGO6/sRkbkOXWf21LeI/0ZA0iI8exvbKy0bbtDw0nlTzNmI9WIJvpGXjSQIDhzALSMgPnGHEX9Y4qINc0thktSuI3lEQjxhleDgoVd//F1gS2qmL/MkYrbHD03tLnujN4//V3dN06m9W8ySf92vL4YKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iOemyCVj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iOemyCVj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CEEDC116D0;
	Sat, 28 Feb 2026 18:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302434;
	bh=U7+5u9HDGOsSQd1ytScckObazn13DlBQe+KNNBaXMWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iOemyCVjk/Hvbi7C2Ex/VAT/kty7JdfxSmUP2NypFe1XBx8GjTe/eXTTjH/F91nqg
	 yF8oYlJv4RsgYRps8d0gR69e/I89pjhbVHa8Z3FeoRsUL7XPhAWHStnFWwGTPSKFaf
	 a8JzYndMZG+aRynVbVu4kU8sPSzW2W8ZYUsn8mSTCxMqT5j/M6pVM3dCzrUFqWhJt8
	 CFgMH8oF8W44JSgatjG0/ozRy3KA/sMt6pXB+WxyWg6b4ELUgl3ckOyIeJg3NpbwNq
	 gMNJBvjxMd59TSFSLDSO0yM4KF39isrgbP5L0QSTNbivxY2E/AP7Yk21ncEzDAVsH3
	 0HFyo62Zqy71Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun1@huawei.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	stable@kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.1 172/232] ext4: use optimized mballoc scanning regardless of inode format
Date: Sat, 28 Feb 2026 13:10:25 -0500
Message-ID: <20260228181127.1592657-172-sashal@kernel.org>
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

From: Jan Kara <jack@suse.cz>

commit 3574c322b1d0eb32dbd76b469cb08f9a67641599 upstream.

Currently we don't used mballoc optimized scanning (using max free
extent order and avg free extent order group lists) for inodes with
indirect block based format. This is confusing for users and I don't see
a good reason for that. Even with indirect block based inode format we
can spend big amount of time searching for free blocks for large
filesystems with fragmented free space. To add to the confusion before
commit 077d0c2c78df ("ext4: make mb_optimize_scan performance mount
option work with extents") optimized scanning was applied *only* to
indirect block based inodes so that commit appears as a performance
regression to some users. Just use optimized scanning whenever it is
enabled by mount options.

Reviewed-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: stable@kernel.org
Link: https://patch.msgid.link/20260114182836.14120-4-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/mballoc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index da0c63897190b..71e15007ffdf4 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -974,8 +974,6 @@ static inline int should_optimize_scan(struct ext4_allocation_context *ac)
 		return 0;
 	if (ac->ac_criteria >= 2)
 		return 0;
-	if (!ext4_test_inode_flag(ac->ac_inode, EXT4_INODE_EXTENTS))
-		return 0;
 	return 1;
 }
 
-- 
2.51.0

