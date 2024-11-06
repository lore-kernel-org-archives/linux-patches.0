Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5C6646;
	Wed,  6 Nov 2024 13:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898029; cv=none; b=tDA6vRA3HkWJuk4TqWjtmDhABIrVV0WWxZZA/G6cxzp/Rhmu4jslCtGWgAO5DJvLaZiZ1wKgIkZ3NQiUfHzUywGTOmuWi0eU+m4Uv3zWtjghVU9C9lMvMYka50Ew+aWe8Hs3MFDldsB06bo69aCfQ4lalyLESHwnhykMYZ01BvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898029; c=relaxed/simple;
	bh=9aIS3Q3Qiid3OHRozrONU4/BTcmU1turFee6QzYB3mA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tnjk3dACfv67wqC+Yrjfs16Pku721DbuJ0fdgtJ7pe4djUcjYdC9QMApryEr23/5P+7OLWl/4kvhn113SjevVebDdLUpVtClZzqQTlKrVw+m9bBrc4PX3M9BmlBsccHL9MRi0o3zLlpXB8ZlPkZ6kA5adYCOX/xE2FxVm5CeDFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IOwkVqp7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IOwkVqp7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E7AAC4CECD;
	Wed,  6 Nov 2024 13:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898029;
	bh=9aIS3Q3Qiid3OHRozrONU4/BTcmU1turFee6QzYB3mA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IOwkVqp7xsvq2hLm1SXtfofm+yUxtiH+Nq4u9vNGT4Kqc2x3UVL3bW6wn/GlAPHzS
	 A26L7cJLWQsO3rHA4UBSCkJ9IWwb7nC8FI/LdiKPgIrsSUlgXhN0qM1LAX/ifJ6wct
	 qDk+fNy6JJXJbeb7jVL0Q9rPRxmbzKxG/1RoB0No=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 099/462] ext4: return error on ext4_find_inline_entry
Date: Wed,  6 Nov 2024 12:59:52 +0100
Message-ID: <20241106120333.954181330@linuxfoundation.org>
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
index 549ceac9099ca..95ac5bcb2882e 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1651,8 +1651,9 @@ struct buffer_head *ext4_find_inline_entry(struct inode *dir,
 	void *inline_start;
 	int inline_size;
 
-	if (ext4_get_inode_loc(dir, &iloc))
-		return NULL;
+	ret = ext4_get_inode_loc(dir, &iloc);
+	if (ret)
+		return ERR_PTR(ret);
 
 	down_read(&EXT4_I(dir)->xattr_sem);
 	if (!ext4_has_inline_data(dir)) {
@@ -1683,7 +1684,10 @@ struct buffer_head *ext4_find_inline_entry(struct inode *dir,
 
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



