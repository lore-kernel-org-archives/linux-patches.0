Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E1A3839B2;
	Sat, 17 Oct 2026 18:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260769; cv=none; b=EImBs5bctKUZ1WgVfShOktgtATcxI2QbQlzc21XA5TGmTWCeUGomfNXSvFyjN/LNXldV7fWhMYtcWL5CaoRxSP27lPPZLQ+hxiWsXofJ3PgGsofkk8n2kYhUFb1JjR9srCvvT4vk4/bzKIViMaJlGWmmHWWZYhJVB0kjzs9CPQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260769; c=relaxed/simple;
	bh=EyKiOmhmwTayFgpYTBaHhhqAxYSCMfL7IoPAMmYpGTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S/vX50WG1T9kFntnIO3383WHj43VuMOCjrjmdW/1g9gUsiuCc7svLmAzLmvM8kS71IZQquPWOvvS5rjHWLLcWvqMh4xeQNs75Up+eFGC8SyOQJEJ4o7AHeMGDKMdD/OCzcdFteyj2/VJoqKn2Uv9KoNebSly4nH72QJMqDVenFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=snHAAfM6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="snHAAfM6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 563B11F000C4;
	Sat, 17 Oct 2026 18:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260767;
	bh=QKOGhIEqxpfCIzmOv6bFI5ss1EDaxdM0zI7mL+cYBgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=snHAAfM6CW6bJ++04fisaPlqKwdt0Y+l5UmfAOKnMPYAy5EMujlAL+EdhQ5UcrDf7
	 07TJ872wcr+n84dRSZ7OmWw7d5BMMpvwsVbQHtEiDEe4EiWjXCuL+xODJ6z7qRv4GT
	 DcWOLiSBxqcYZEVvm+19LSXsBJazhfqNi6F5AuRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huiwen He <hehuiwen@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1654/1674] smb/client: validate new EOF for insert range
Date: Sat, 17 Oct 2026 18:05:26 +0200
Message-ID: <20261017160513.527892857@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1f3d1f8219b64..4da027ee4b99b 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3755,7 +3755,8 @@ static long smb3_insert_range(struct file *file, struct cifs_tcon *tcon,
 	unsigned int xid;
 	struct cifsFileInfo *cfile = file->private_data;
 	struct inode *inode = file_inode(file);
-	__u64 count, old_eof, new_eof;
+	u64 count;
+	loff_t old_eof, new_eof;
 
 	xid = get_xid();
 
@@ -3767,8 +3768,15 @@ static long smb3_insert_range(struct file *file, struct cifs_tcon *tcon,
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
 
 	/* SET_ZERO_DATA creates a hole only in a sparse file. */
 	rc = smb2_set_sparse(xid, tcon, cfile, inode, true);
-- 
2.53.0



