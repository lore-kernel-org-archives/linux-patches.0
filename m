Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 859881C07CC;
	Tue, 15 Oct 2024 13:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997335; cv=none; b=XkqT/c7eGsiv5G8icYmmCdzC+mDq0MhpK/6v58CIiY7ahiOfKlEOf2X1duz8WHA5xV4RqvHnRqKjbebWPihblvIg6rg6Svuv4pI89WXP9o+ImtxfhEElrbuL2ULhalFysRlsg5J48SS6QWxbCod09T7VylckbYBSvJJgYQvCv9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997335; c=relaxed/simple;
	bh=m+73dSwD4h4FiQN6A6/SRIaDyUVj3SJJG8Dl2gf5UBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k7S1sLyBTGn8Y9OgD6T9IJhX4MYZm6996NenLIhQwbr4Xv5hJaemqebhbsvIhhGP2nORuM2rdJa9LxNNJlv3npiW5x6uFLEvTLtzcwlfArQiI/lDmdJ1I5O6rXWTZwlUOe7v4m/p2Q+DVaMKoJuQmknLJszucyDCri7vQApupRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jwCnPBMX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jwCnPBMX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA2F0C4CECF;
	Tue, 15 Oct 2024 13:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997335;
	bh=m+73dSwD4h4FiQN6A6/SRIaDyUVj3SJJG8Dl2gf5UBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jwCnPBMXQLgcUMIba0NPkoppkGAcX6Zj8Lv1rZNxHhc5CwXMwz3Xbh+MxdEkZDPSg
	 GCF7wRIbdLn+s0P07kNO1dTHSEn9Uckxfie65qIv9UM7jR95r+CYLfMWJTblwk187u
	 eQuq3hkUcCrT7o4M6YyeGu60qNubi07CTmajMGVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 152/518] ext4: return error on ext4_find_inline_entry
Date: Tue, 15 Oct 2024 14:40:56 +0200
Message-ID: <20241015123922.874355966@linuxfoundation.org>
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

From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>

[ Upstream commit 4d231b91a944f3cab355fce65af5871fb5d7735b ]

In case of errors when reading an inode from disk or traversing inline
directory entries, return an error-encoded ERR_PTR instead of returning
NULL. ext4_find_inline_entry only caller, __ext4_find_entry already returns
such encoded errors.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Link: https://patch.msgid.link/20240821152324.3621860-3-cascardo@igalia.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: c6b72f5d82b1 ("ext4: avoid OOB when system.data xattr changes underneath the filesystem")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inline.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 979935c078fb8..c9e497c2700ca 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1653,8 +1653,9 @@ struct buffer_head *ext4_find_inline_entry(struct inode *dir,
 	void *inline_start;
 	int inline_size;
 
-	if (ext4_get_inode_loc(dir, &iloc))
-		return NULL;
+	ret = ext4_get_inode_loc(dir, &iloc);
+	if (ret)
+		return ERR_PTR(ret);
 
 	down_read(&EXT4_I(dir)->xattr_sem);
 	if (!ext4_has_inline_data(dir)) {
@@ -1685,7 +1686,10 @@ struct buffer_head *ext4_find_inline_entry(struct inode *dir,
 
 out:
 	brelse(iloc.bh);
-	iloc.bh = NULL;
+	if (ret < 0)
+		iloc.bh = ERR_PTR(ret);
+	else
+		iloc.bh = NULL;
 out_find:
 	up_read(&EXT4_I(dir)->xattr_sem);
 	return iloc.bh;
-- 
2.43.0



