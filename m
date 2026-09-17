Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C387544884;
	Thu, 17 Sep 2026 15:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658873; cv=none; b=pfsKuIKL8tc2ih+0g6GYjRhByiTZDRGIOHqiktz8uwXHm7Zg/yZBPmGdmMjYt2O6JmzmjcrLvTCHeQ6wt8G3wEeCzlp2zJgzV5KBrWRldats1MJkdAGhcVyKi6c4LHS9C7VUQia7sCfojr4rVj234JODJJ+2vBI2Bj9Uzbg9EEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658873; c=relaxed/simple;
	bh=BCpxZOS4giE1RN4K7irsL5HL7zLpBVJTuFAxp2PmkqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kXPaaBxQJP9dKU3do+p99RShNRh1kh58LzKV9TSgbXLTa9ZWIJlw5T88UqM5d1u1uoBWlImzfLKOTbubHGDHsO1wNBN649qQiLfGrpY/VyZyRIqXZ7SRLGifmi+yzV6XXAgvbV1EMSZRh6HWU2M3lc5+NjWsyDPddcryn5X5sMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=naUd11Em; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="naUd11Em"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13F751F0089A;
	Thu, 17 Sep 2026 15:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658865;
	bh=Y7oH+j8bs1Wtw4coFuUrWNmLTOm58YUX53CMuUp8Rks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=naUd11EmysXSr7df1gWEhzeWdBUw4+hEKTVuItDmjDjYPLnS8dpOvoLoU3rXk04m0
	 4A0EUmOOl2ACSQHsh2OOKsjhyLJYndTXWSj43ruks9OR2LXllV5EcInZjFTSOcVZ5H
	 mjLUZtEjZq+BjOzfXysCfNN6EVryNNA4hOJ1hSVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huiwen He <hehuiwen@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 065/733] smb/client: validate new EOF for zero range
Date: Thu, 17 Sep 2026 16:06:13 +0100
Message-ID: <20260917151352.457598623@linuxfoundation.org>
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
 fs/smb/client/smb2ops.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 476afb4e49fd8..3b96dc3615ab4 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3441,6 +3441,13 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	trace_smb3_zero_enter(xid, cfile->fid.persistent_fid, tcon->tid,
 			      ses->Suid, offset, len);
 
+	new_size = offset + len;
+	if (!keep_size && i_size_read(inode) < new_size) {
+		rc = inode_newsize_ok(inode, new_size);
+		if (rc)
+			goto out;
+	}
+
 	filemap_invalidate_lock(inode->i_mapping);
 
 	netfs_read_sizes(inode, &i_size, &remote_i_size, &zero_point);
@@ -3471,7 +3478,6 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	/*
 	 * do we also need to change the size of the file?
 	 */
-	new_size = offset + len;
 	if (keep_size == false && (unsigned long long)i_size_read(inode) < new_size) {
 		rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
 				  cfile->fid.volatile_fid, cfile->pid, new_size);
@@ -3488,6 +3494,7 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 
  zero_range_exit:
 	filemap_invalidate_unlock(inode->i_mapping);
+ out:
 	free_xid(xid);
 	if (rc)
 		trace_smb3_zero_err(xid, cfile->fid.persistent_fid, tcon->tid,
-- 
2.53.0



