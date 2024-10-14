Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F72F156256;
	Mon, 14 Oct 2024 15:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919692; cv=none; b=Rvob+fwV39BQg6OL4bC+34aGue4sc8mFA35ILH7f9HUkh2d/SsJs42YLNiwaAlECv8qs5ue9tsNhw8TIhBUk7aqnHYuEEltnvF6ZCOxGDNNfMjVuWZ6BaP53i2+tJEAy3unJrUMWRLGcJLsmYGoHjT4fq1xggYiE9by7K/gR7vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919692; c=relaxed/simple;
	bh=BY7wmxtMoJ/uU+HPFDkSxrVBQtTK7SDBI+o+Ttz0YK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AnPB7xZxjbwPn13TO7B9uQDR4sJvi0MsXPoEnG55zxdw7zDP/XgeAQns//JUOOlIG52FRCoHr7AewHsgQXEvsdYQBIfKkNupZoI+fKo4bbDZmyArx9ZKOEQYVAfQ0I1Q/5ZX7RJWtioXoo9xl47Aktkm/XjKsKA02PMRdoBfJnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FoxFaIHO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FoxFaIHO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95105C4CEC3;
	Mon, 14 Oct 2024 15:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919692;
	bh=BY7wmxtMoJ/uU+HPFDkSxrVBQtTK7SDBI+o+Ttz0YK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FoxFaIHOstRSxZ8WP3GkZOsmjQP/nJFFKQLxIXqSG8vkQhwNbf66Al0rhyJzTHRUw
	 +le3/xwjapEW50eebo01JeNOjaItXALRzvA/V/wI5REkmoyyhLp9kX1s6GMHJxT54H
	 yBd81XMA2TJtN87s7ASPpNG+QZUjtESNyJWnyCiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 681/798] fs/ntfs3: Do not call file_modified if collapse range failed
Date: Mon, 14 Oct 2024 16:20:35 +0200
Message-ID: <20241014141244.824940083@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 2db86f7995fe6b62a4d6fee9f3cdeba3c6d27606 ]

Fixes: 4342306f0f0d ("fs/ntfs3: Add file operations and implementation")
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/file.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index 6f03de747e375..aedd4f5f459e6 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -516,7 +516,7 @@ static int ntfs_truncate(struct inode *inode, loff_t new_size)
 }
 
 /*
- * ntfs_fallocate
+ * ntfs_fallocate - file_operations::ntfs_fallocate
  *
  * Preallocate space for a file. This implements ntfs's fallocate file
  * operation, which gets called from sys_fallocate system call. User
@@ -647,6 +647,8 @@ static long ntfs_fallocate(struct file *file, int mode, loff_t vbo, loff_t len)
 		ni_lock(ni);
 		err = attr_collapse_range(ni, vbo, len);
 		ni_unlock(ni);
+		if (err)
+			goto out;
 	} else if (mode & FALLOC_FL_INSERT_RANGE) {
 		/* Check new size. */
 		err = inode_newsize_ok(inode, new_size);
-- 
2.43.0



