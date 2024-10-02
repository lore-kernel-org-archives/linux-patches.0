Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59CAE1D0DD7;
	Wed,  2 Oct 2024 14:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879781; cv=none; b=ju6T1PEBRZngtm8QTJXVQnET4kLwEghfXANXWiCuCW1cjadwM+ive4l1ZBdRV5BopSIHJvMrDKngw8A4HdIS5WC9ypa3L9TxVOGanwq1gdHm9IU4rnA6OzYuOni3XgHmh6jHu21r8pId/HMhjN5DsuqmV2pnXn7j7bOpQLyr1Do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879781; c=relaxed/simple;
	bh=S8iSLxfhfUGVvOq4stUucp6Cm5zl4/KQzKQPjT0PMIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BL5MgW01KCJA/eAgx4wCC/rtv3w0VLDhzHCZzyy6pwn+2KBiH3SotVe8ZIhJuiP/kYiFRz6NmUcZJtzRVO+b9mgMUbsCv4gdZCYWMzx1ueXEzIGcKRy4teIv++IrANS9QFiq3cT7S6OAs7gaIlgO8CgF5pdC5Ta3YIL0sT7a8FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uL2vyfUp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uL2vyfUp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB754C4CEC2;
	Wed,  2 Oct 2024 14:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879781;
	bh=S8iSLxfhfUGVvOq4stUucp6Cm5zl4/KQzKQPjT0PMIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uL2vyfUpujjP0DCQpGrLaEfUUbjRZzzJJFDP8w6w9aW4DF0ZrBNLzW/lLhYNEJj+R
	 bA8qKFVgutfto3DGyeb0zyHWBDY6qPLLMN60+gRLZYf6REx7RwBlq1GcxCq2yUEUJA
	 BGW0Vvh5+MzWqr9SmzZJsy+kz1PWm7sclHfRr7ks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 229/538] ext4: return error on ext4_find_inline_entry
Date: Wed,  2 Oct 2024 14:57:48 +0200
Message-ID: <20241002125801.291644904@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a604aa1d23aed..7adc6634d5234 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1670,8 +1670,9 @@ struct buffer_head *ext4_find_inline_entry(struct inode *dir,
 	void *inline_start;
 	int inline_size;
 
-	if (ext4_get_inode_loc(dir, &iloc))
-		return NULL;
+	ret = ext4_get_inode_loc(dir, &iloc);
+	if (ret)
+		return ERR_PTR(ret);
 
 	down_read(&EXT4_I(dir)->xattr_sem);
 	if (!ext4_has_inline_data(dir)) {
@@ -1702,7 +1703,10 @@ struct buffer_head *ext4_find_inline_entry(struct inode *dir,
 
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



