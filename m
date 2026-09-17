Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87AC13BD64B;
	Thu, 17 Sep 2026 17:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665205; cv=none; b=Aj9hGoCzQyYwiW8/TAYp3Bz9T+c+7ycuGo0l+spj2d7YQteNmMMHKkUuZPxfnXN6MUXnRTb0Es9SPxuVXdAJRBeFZmJqvQKkjhNFnyHQNtLF9FN8IEDEX7oqkvjBJ2JbvQQX2CG/Vq+oU/rX3USu10z32+p2UFgoQRBI5W7ppGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665205; c=relaxed/simple;
	bh=OT1yz2GVyr2z5VnIX+OMKg/IAZhUcRZCb8j8ROlAH60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JdRq2y2zMs797oH9qQU9DcNfLbDUVxun7Hp8ghnPlWZDKyur7+GAvAU9UZkfcYLutwovne8VimbWISPEEulH7C9e8bTCZJ6WEA8tl6A3ENekn2ZtxkTm5AAD0WwtOKrkT2gwRHFsEhVHxGSv/NUCx+xlF4ucJi6/1bQy/bq0JBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ylijr8GJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ylijr8GJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 713FF1F000FF;
	Thu, 17 Sep 2026 17:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665204;
	bh=VpMgRWNSTFbrSH8ZJeyj+jbUlGgAE8MEibZY6nD/HKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ylijr8GJ9SCxVXO0D+5PdgJlUKGzsjw0nH+W5gyhh6+KY5b0QXS1MlNLg6z/Yvws4
	 NSDuvVOmjXSUwfT+I7VcD4+nsRc1wfgYECAr8jJj7NuB2m4prbDyvDIStPlI4F+1UO
	 Ou+uEIGfJ/UbNxVuUg2VV5W2TYQyjD0gUPdBC8B8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huiwen He <hehuiwen@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0627/1250] smb/client: validate new EOF for insert range
Date: Thu, 17 Sep 2026 16:07:02 +0100
Message-ID: <20260917151608.874023902@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huiwen He <hehuiwen@kylinos.cn>

[ Upstream commit 1519dc88c87f5346dae0464d7d6da1b6bf1f6e8e ]

smb3_insert_range() does not check if the new file size
(i_size + len) is valid. This allows FALLOC_FL_INSERT_RANGE to bypass
RLIMIT_FSIZE, exceed s_maxbytes, or produce a size outside the loff_t
range.

Use check_add_overflow() to calculate the new EOF. Validate it with
inode_newsize_ok() before modifying the file.

Reproducer, using a file on a CIFS mount:

	bash -c '
		FILE=/mnt/cifs/repro

		trap "" SIGXFSZ
		ulimit -f 3072		# RLIMIT_FSIZE = 3 MiB

		# A regular write is stopped at 3 MiB.
		dd if=/dev/zero of="$FILE" bs=1M count=4 status=none
		stat -c "size after write: %s" "$FILE"

		# Insert 2 MiB into a 2 MiB file.
		truncate -s 2M "$FILE"
		fallocate -i -o 0 -l 2M "$FILE"
		stat -c "size after insert: %s" "$FILE"
	'

Before this change, the regular write stops at the 3 MiB limit, but
insert range grows the file to 4 MiB:

	dd: error writing '/mnt/cifs/repro': File too large
	size after write: 3145728
	size after insert: 4194304

After this change, insert range also fails at the limit and leaves the
2 MiB file unchanged:

	dd: error writing '/mnt/cifs/repro': File too large
	size after write: 3145728
	fallocate: fallocate failed: File too large
	size after insert: 2097152

Fixes: 7fe6fe95b936 ("cifs: add FALLOC_FL_INSERT_RANGE support")
Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2ops.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 9f42e5427557b..542823110c58e 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3891,7 +3891,8 @@ static long smb3_insert_range(struct file *file, struct cifs_tcon *tcon,
 	struct cifsFileInfo *cfile = file->private_data;
 	struct inode *inode = file_inode(file);
 	struct cifsInodeInfo *cifsi = CIFS_I(inode);
-	__u64 count, old_eof, new_eof;
+	u64 count;
+	loff_t old_eof, new_eof;
 
 	xid = get_xid();
 
@@ -3901,8 +3902,15 @@ static long smb3_insert_range(struct file *file, struct cifs_tcon *tcon,
 		goto out;
 	}
 
+	if (check_add_overflow(old_eof, len, &new_eof)) {
+		rc = -EFBIG;
+		goto out;
+	}
+	rc = inode_newsize_ok(inode, new_eof);
+	if (rc)
+		goto out;
+
 	count = old_eof - off;
-	new_eof = old_eof + len;
 
 	filemap_invalidate_lock(inode->i_mapping);
 	rc = filemap_write_and_wait_range(inode->i_mapping, off, new_eof - 1);
-- 
2.53.0



