Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794F63290B0;
	Thu, 28 May 2026 20:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998920; cv=none; b=BIOATGm4cSkn+BUKsJj7+KMpc18If6luh+5V5znANii8Jc2q6/2zz00mc8eQuYNA31wvIT5zioNvWOxn7KlwYZojMlZHNDUoTLKofq0F7j5yD4OswS4DS2zLlC+mIV192DfO8VsKqVs/KAbq7Mz4t+4tLbCkabNpRx1JfL8Jk+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998920; c=relaxed/simple;
	bh=2l66EZBcvgUhplLAHirTffYrSX7ApTbls2Dz9/XXdKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kmCrPGB97nEwH6g8exfh/ouboZndIqA1wsgLQfgpIy5GaK80t1Z6ixwFEYSZjy4JIsJrV7lOfhBMjudGGAFIPkkPgkz3zD7Q6PymP7HiaNfX7yNZ+qpcVZPxzTcRUv+txxprAC/why/ONCzW9MRCxmfLXkqTUW1WUFE6ASCJXWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m4dYqnT5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m4dYqnT5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D479C1F000E9;
	Thu, 28 May 2026 20:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998919;
	bh=5eAAy8KCsb+Jj3O1JcOtogwjlfcb0Jb19GNcb27iPq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m4dYqnT5e7T+YYKZCoB6Uv8fsVZiKq/1Il3/bVUvPbumvPcpy9OJc5KqKpuPr2mwA
	 1P0T4LNQe6+NXR14n2OIN6Y2KTHq5V0dmRUvHM6IQoFECGV79NOI2cDoVLoJbpXzA9
	 EhAeAeMKeHKQ/vqNhImOcADgm53CQH8j+ifMZzuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 343/461] cachefiles: Fix error return when vfs_mkdir() fails
Date: Thu, 28 May 2026 21:47:52 +0200
Message-ID: <20260528194657.295502328@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongling Zeng <zenghongling@kylinos.cn>

[ Upstream commit 8a220d1c312c66194f4a33dd52d1fba42bc2b341 ]

When vfs_mkdir() fails, the error code is not extracted from the
returned error pointer. This causes mkdir_error to be reached with
ret=0, which leads to returning ERR_PTR(0) (NULL) instead of a
proper error pointer.

Fix this by extracting the error code from the error pointer when
vfs_mkdir() fails.

Fixes: 406fad7698f5 ("cachefiles: Fix oops in vfs_mkdir from cachefiles_get_directory")
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Link: https://patch.msgid.link/20260513103406.202320-1-zenghongling@kylinos.cn
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cachefiles/namei.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/cachefiles/namei.c b/fs/cachefiles/namei.c
index eb9eb7683e3cc..6336d976d469b 100644
--- a/fs/cachefiles/namei.c
+++ b/fs/cachefiles/namei.c
@@ -130,6 +130,8 @@ struct dentry *cachefiles_get_directory(struct cachefiles_cache *cache,
 		ret = cachefiles_inject_write_error();
 		if (ret == 0) {
 			subdir = vfs_mkdir(&nop_mnt_idmap, d_inode(dir), subdir, 0700, NULL);
+			if (IS_ERR(subdir))
+				ret = PTR_ERR(subdir);
 		} else {
 			end_creating(subdir);
 			subdir = ERR_PTR(ret);
-- 
2.53.0



