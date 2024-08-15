Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC7D19EED7;
	Thu, 15 Aug 2024 14:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731331; cv=none; b=Iywa1GYV1MqvGeXEWrpezofwITsYs0hkMf4ZnopJR32bgpeuN8217Mcw0zcwVBDRMckElR+aS/lJfNYz/bnJOskV4qxqqoowwOjgrwhdJuxJ1lspPsLKRIgldBZUAIkhqUI1wcmfaVBT8+Hz3dPNqEdmjIkmg0JjWI9mIWDRRVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731331; c=relaxed/simple;
	bh=3DYFirHrInlbN7cZ/XxuHGqEGJWFoY6EpKrcjF8BL9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VQdCz8LTNFB9a8zZzBz9sy5dHurKb5VORC/4yAgJ5Vm06WcYzH61vW89czyPdNl7wwj6nUu6i30G59IqZDsPCyBvP9uUrcdaPprSgJpV9s5mr24rWHGBtcf0ZSij1vviCVfbBXFs/PndIWorRu/J6Glbe4wYT7whbRwGS1lJg5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TZLFLtwA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TZLFLtwA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F72C4AF0A;
	Thu, 15 Aug 2024 14:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731331;
	bh=3DYFirHrInlbN7cZ/XxuHGqEGJWFoY6EpKrcjF8BL9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TZLFLtwAI7GdOy4Mp59HC75Or1R+0QmVFf720kx98uGB8KHi1b1W4Trnq+JESxv5r
	 iZtp/qcwNR3AKRyso8vzcGjOVK36xF3xdS/6TyQvRx77/KboJAZS5tAbO2kI70BBuA
	 VbFuLGa/o0cLpPx5306PBz1KG9VJnO3bNQFrVS5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9c1fe13fcb51574b249b@syzkaller.appspotmail.com,
	Hugh Dickins <hughd@google.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 064/259] ext4: avoid writing unitialized memory to disk in EA inodes
Date: Thu, 15 Aug 2024 15:23:17 +0200
Message-ID: <20240815131905.278604719@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

[ Upstream commit 65121eff3e4c8c90f8126debf3c369228691c591 ]

If the extended attribute size is not a multiple of block size, the last
block in the EA inode will have uninitialized tail which will get
written to disk. We will never expose the data to userspace but still
this is not a good practice so just zero out the tail of the block as it
isn't going to cause a noticeable performance overhead.

Fixes: e50e5129f384 ("ext4: xattr-in-inode support")
Reported-by: syzbot+9c1fe13fcb51574b249b@syzkaller.appspotmail.com
Reported-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20240613150234.25176-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/xattr.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index cb7faaa935cc6..d65f1eb85a924 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1396,6 +1396,12 @@ static int ext4_xattr_inode_write(handle_t *handle, struct inode *ea_inode,
 			goto out;
 
 		memcpy(bh->b_data, buf, csize);
+		/*
+		 * Zero out block tail to avoid writing uninitialized memory
+		 * to disk.
+		 */
+		if (csize < blocksize)
+			memset(bh->b_data + csize, 0, blocksize - csize);
 		set_buffer_uptodate(bh);
 		ext4_handle_dirty_metadata(handle, ea_inode, bh);
 
-- 
2.43.0



