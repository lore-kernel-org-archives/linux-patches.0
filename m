Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94854C10C7;
	Thu, 17 Sep 2026 15:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658870; cv=none; b=blEfLUQ1V7AtAuT2ABL7dLltD5wU5+v3NSMCYpZANjerbG8L3zpebJfynQrSDGc41A3bY13OKMczDJyftAE5suJHauL6laWFbnth+fvUbbVV2y7O2EMlhe5A3SEbRuBSGty7MXOyZiivlI/EHXvUpx6qHpIc+v0cUnSB4X7N9kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658870; c=relaxed/simple;
	bh=plLLevNdJF6cfNHuzT7DST1nU9AB1YmnHykfQ/wkjPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nwOnElqIIqx4ukVkDHJqXmFHRraaAVXv6E9ya2n/EMtfjZkexXRoFvepMPmJo6AIgS906K4nTs+qkctln0XTnq9onI8cV2RZb8uhAyulY7BZvkJyzbxiFVxMf4vvHh4M8Ryb65M0d+vLz9ttwgdOCgV+bmOR7BQu+94OTtTqGHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kBGVe2dG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kBGVe2dG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F5E61F0089D;
	Thu, 17 Sep 2026 15:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658862;
	bh=3TSxTBBEZIZldvx5wkgx10jHWEB6eZln06VGGawQ3Ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kBGVe2dGxI3dF6viS4hRUTZF895V1fjX4MQjrb+UxWTxTXOm4m8ZH91Ooiz+Wom4W
	 yKY0qA+vtFOylRMOC2NgvR9LrRFdbMb3qtp3w3hEbD3Afe/IZraOIeDW7WVu0c8RDf
	 Pn2gYAIcz4n40bye8o4w1fKJVjyiUG12hCJqfSvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huiwen He <hehuiwen@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 064/733] smb/client: validate new EOF for insert range
Date: Thu, 17 Sep 2026 16:06:12 +0100
Message-ID: <20260917151352.430068655@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 0e872d58fae7c..476afb4e49fd8 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3982,7 +3982,8 @@ static long smb3_insert_range(struct file *file, struct cifs_tcon *tcon,
 	struct cifsFileInfo *cfile = file->private_data;
 	struct inode *inode = file_inode(file);
 	struct cifsInodeInfo *cifsi = CIFS_I(inode);
-	__u64 count, old_eof, new_eof;
+	u64 count;
+	loff_t old_eof, new_eof;
 
 	xid = get_xid();
 
@@ -3992,8 +3993,15 @@ static long smb3_insert_range(struct file *file, struct cifs_tcon *tcon,
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



