Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF743C0601;
	Sat, 17 Oct 2026 18:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260766; cv=none; b=iYR2g0LKtLSDScVFWmIFOiKP2cnbcE3idD5ClQ+e9snSMOsEMh3IATLbrhktxxC3hzJTXpJ+XzXdpOg2md8Cdym3L7SsbgVOQ0gmYsVmkUz93vxCFJYveT+E13YMBelukOGy5SHey0gT31q4pogi1/44PboJlTISJY00K05PMkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260766; c=relaxed/simple;
	bh=O/k1QOp36FGSwxdoloil3yg7WB5TuwICAyvtZOt9lGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NA9htaUh9/UlkbtS+Z21fXZOo7KdHupzGePNs/JpWm/QBe8mxahnXBSBs+5z9FbRjE1G9ybvwxbaFQXo+n+mj3t5pb990crUtmtR5L8tPuTU8CLNimRsWM6Hc/mwEdYhAbEirq+Lsu5oHfJFdqgBzI3mIFz1r93ZO/9KMuV6Tzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N6lFMOEz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N6lFMOEz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E7A1F000C4;
	Sat, 17 Oct 2026 18:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260764;
	bh=W06FcbU1tw516SaPfCvexPE+XEcohhaB29k8z9LrZV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N6lFMOEzBdY+mlS8L14iPtZYcQL8ZKVvdzIGmqE29D2PSwNmXDx5UIn1KNhtGEZxV
	 3jiYxktLVtSlsjvwAxBKwFFHKOWwxxpvt63NjGbjf4NQ96QyD9cxptrG1jZQxTNcIt
	 DU5MvV19G7PLwjIcAfeMutbzMG6KFE7ZnvR3Mhog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huiwen He <hehuiwen@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1653/1674] smb/client: validate new EOF for zero range
Date: Sat, 17 Oct 2026 18:05:25 +0200
Message-ID: <20261017160513.503075087@linuxfoundation.org>
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

[ Upstream commit 88972e35750792e717af287dc71f42a03b5cbce4 ]

When FALLOC_FL_ZERO_RANGE is used without FALLOC_FL_KEEP_SIZE,
smb3_zero_range() may extend EOF without checking RLIMIT_FSIZE, allowing
the file to grow beyond the caller's file-size limit.

Fix this by calling inode_newsize_ok() before sending the zero-range
request when the operation would extend EOF.

Reproducer, using a file on a CIFS mount:

	bash -c '
	        FILE=/mnt/cifs/repro

	        trap "" SIGXFSZ
	        ulimit -f 3072

	        truncate -s 2M "$FILE"
	        fallocate --zero-range -o 0 -l 4M "$FILE"
	        echo "fallocate rc=$?"
	        stat -c "file size=%s" "$FILE"
	'

Before this change, the operation succeeds despite the 3 MiB limit:

	fallocate rc=0
	file size=4194304

After this change, fallocate fails and leaves the file at 2 MiB.

Fixes: 72c419d9b073 ("cifs: fix smb3_zero_range so it can expand the file-size when required")
Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2ops.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 3efd0fff38dd1..1f3d1f8219b64 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3268,6 +3268,14 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 			      ses->Suid, offset, len);
 
 	inode_lock(inode);
+
+	new_size = offset + len;
+	if (!keep_size && i_size_read(inode) < new_size) {
+		rc = inode_newsize_ok(inode, new_size);
+		if (rc)
+			goto out;
+	}
+
 	filemap_invalidate_lock(inode->i_mapping);
 
 	i_size = i_size_read(inode);
@@ -3304,7 +3312,6 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	/*
 	 * do we also need to change the size of the file?
 	 */
-	new_size = offset + len;
 	if (keep_size == false && (unsigned long long)i_size_read(inode) < new_size) {
 		rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
 				  cfile->fid.volatile_fid, cfile->pid, new_size);
@@ -3316,6 +3323,7 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 
  zero_range_exit:
 	filemap_invalidate_unlock(inode->i_mapping);
+ out:
 	inode_unlock(inode);
 	free_xid(xid);
 	if (rc)
-- 
2.53.0



