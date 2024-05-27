Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18681863F;
	Mon, 27 May 2024 19:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837328; cv=none; b=KZ1wPuZx8nyZtErbTxwzazshg+yFWm6EoNpsZz83/0H/neurS83gwOdXpzbDiaESpaGdAwNsdQHtUo5iUZh6LGMjWCjFWn59CEKGJ+CnhmDkbwBsCSWwl9SHl6mjl7iQ7rVyVa3HXg0KqAGw135l1PzpWZuSzEz8bJOwfFX0C5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837328; c=relaxed/simple;
	bh=yIOfJZSgpwGy828iKf5Hjlys1YuXKF46WCmB9X4PQAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Js6JoxNjkPESYYAcsQ5VNuwJOiUx/A+JfQq7ael4AJA5pZNUNCyYwfTG2sz4YjwMNqgnagMg2QXM3y4wOy6fgMM1h8fsp5UXQ8cijxCqu0AFbzhbBvQ9vASDOf7CUMwJDVGVd7t/LrupmoE92Fm4yyyPUWu8ZwpdetG6ir8BfU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hdr+I13P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hdr+I13P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57A3FC2BBFC;
	Mon, 27 May 2024 19:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837328;
	bh=yIOfJZSgpwGy828iKf5Hjlys1YuXKF46WCmB9X4PQAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hdr+I13Pauc/UqdAnrSWQ+vcdUOXkQeU2t4NeyKjGpL1cssR185XpPsYlh7XO3t4t
	 k3Z+z597OF96jA+WrFxf+f7ux7oagVsG+OKvbxbfFj3h1uQi/JaFZHgfmOF36xGFrG
	 Dxxt5QUVtOdFWc/9qx1anq1AJochHHxhdpIs0y2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 397/427] ext4: remove the redundant folio_wait_stable()
Date: Mon, 27 May 2024 20:57:24 +0200
Message-ID: <20240527185635.002478021@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit df0b5afc62f3368d657a8fe4a8d393ac481474c2 ]

__filemap_get_folio() with FGP_WRITEBEGIN parameter has already wait
for stable folio, so remove the redundant folio_wait_stable() in
ext4_da_write_begin(), it was left over from the commit cc883236b792
("ext4: drop unnecessary journal handle in delalloc write") that
removed the retry getting page logic.

Fixes: cc883236b792 ("ext4: drop unnecessary journal handle in delalloc write")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20240419023005.2719050-1-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 537803250ca9a..6de6bf57699be 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2887,9 +2887,6 @@ static int ext4_da_write_begin(struct file *file, struct address_space *mapping,
 	if (IS_ERR(folio))
 		return PTR_ERR(folio);
 
-	/* In case writeback began while the folio was unlocked */
-	folio_wait_stable(folio);
-
 #ifdef CONFIG_FS_ENCRYPTION
 	ret = ext4_block_write_begin(folio, pos, len, ext4_da_get_block_prep);
 #else
-- 
2.43.0



