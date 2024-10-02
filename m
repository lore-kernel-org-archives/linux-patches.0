Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B011D07B7;
	Wed,  2 Oct 2024 14:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878036; cv=none; b=nmAI7/7sXMfCz+QJ4B3Kj7UjjET5nMoxX/m+DChcOud0ac8OiiczoYaZF8wE+KeWGmM24nFmeFt1qeZrAcuGSb8F753YLRYZ9Pm+t/Y6A7mx25/l1BjtV1SXJMjad26N40/J+/tBjZtP+FKRS7vXjGCNvoIWAxKSbRV7z36K18c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878036; c=relaxed/simple;
	bh=ldLwIBt+8YM+7cmzwcZ11G5jDiVf8QBmfy/xTbJqTgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KXePbXhpXzlAAQLdcHRyAkX6fPV/96h6aQuZD49jMPCpzbgzG9hA7gfQUPs9rI+uKZnCAN52Twv7DG99bCJvJfnCPIjHX8yRqyqDxZ76Dkv+PwKGExkqB0HKbkvn90u/ldjz9+yTK9VGWpF16tLD9qI5V5LnYO17h+nuI0F4Cnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EG4JECq4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EG4JECq4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FAA5C4CEC2;
	Wed,  2 Oct 2024 14:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878035;
	bh=ldLwIBt+8YM+7cmzwcZ11G5jDiVf8QBmfy/xTbJqTgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EG4JECq4h4y5GS8F6FzP1SamwN/xcgugFS7iESKe8+c6KzmURAv7ZWscaN5cnjnho
	 quttLbl2tvl9Vv3YcH9ZN7cgsHT2a7tEJihyA6L8Kl8xwOAWZnXw7vkPO9uXMFyi6I
	 rDn1tJ5bU05dx7QpxIXu271ft2MCnb+RB/H+VK+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 280/634] ext4: return error on ext4_find_inline_entry
Date: Wed,  2 Oct 2024 14:56:20 +0200
Message-ID: <20241002125822.163804120@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index e7a09a99837b9..7b98b1bf1dc94 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1669,8 +1669,9 @@ struct buffer_head *ext4_find_inline_entry(struct inode *dir,
 	void *inline_start;
 	int inline_size;
 
-	if (ext4_get_inode_loc(dir, &iloc))
-		return NULL;
+	ret = ext4_get_inode_loc(dir, &iloc);
+	if (ret)
+		return ERR_PTR(ret);
 
 	down_read(&EXT4_I(dir)->xattr_sem);
 	if (!ext4_has_inline_data(dir)) {
@@ -1701,7 +1702,10 @@ struct buffer_head *ext4_find_inline_entry(struct inode *dir,
 
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



