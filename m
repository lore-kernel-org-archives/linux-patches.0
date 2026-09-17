Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B1C547059;
	Thu, 17 Sep 2026 18:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668736; cv=none; b=quOWQ2fflX+XHnwgzwgyURdqOeuZzm4fnoK+6/OiDZ0UjIAJZYR8F8ADihiPovF7OtcSZwU2iRLTUBpExqP7pQ7oVbMy2cpf/FuNfn2t9rYiwCpULkXHFl9KLD/2EYGLkTTV/T8sNgbNo/hzfaYA3C2yJvJMfF0EmuVeu2AV1Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668736; c=relaxed/simple;
	bh=kQCsphude1zBN8uvM59Bc24lJ35XeBc4/HbK598nLrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m94LnjpKwA6zNU2YFIQEJ71EsndHOS34XgxiqwxoSNW+TW9gTKgXkQQh4mZUx3NXRJ+1VNIJdlIAEWbB7+mpMUw0ND0pBpn/Yy0XrL8gUQ0hQaRF9jy51z/1LuemxUx+5fkUwr70/Xe7e1f6nwsx4wI+9+9BSiEtzv5gxkEA2Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AXz95sT/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AXz95sT/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCD3D1F000FF;
	Thu, 17 Sep 2026 18:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668735;
	bh=vaVY7sleMgg83WoIvRa3BIDfYrcXg+oYjt0CCWZShow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AXz95sT/SW/ssvZxpKMo0OfQDT5OYY+yx0nwdyOy7DgGfAF1HZ8aFMg5gsEZkFM7k
	 CZvmouYl49OnbOUkV54sGVrkhCTzrsAqZT6l7nXrNq54Q7IGEpk/ESXMkGWo4U/l0b
	 f1mElnmedj70VS+B33o4a5zQq0RoXbyQQw24NO0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huiwen He <hehuiwen@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0525/1102] smb/client: validate new EOF for zero range
Date: Thu, 17 Sep 2026 16:07:48 +0100
Message-ID: <20260917151552.968572040@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index bf9a5d890ae74..80103ac78886b 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3315,6 +3315,13 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
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
 
 	i_size = i_size_read(inode);
@@ -3346,7 +3353,6 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	/*
 	 * do we also need to change the size of the file?
 	 */
-	new_size = offset + len;
 	if (keep_size == false && (unsigned long long)i_size_read(inode) < new_size) {
 		rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
 				  cfile->fid.volatile_fid, cfile->pid, new_size);
@@ -3361,6 +3367,7 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 
  zero_range_exit:
 	filemap_invalidate_unlock(inode->i_mapping);
+ out:
 	free_xid(xid);
 	if (rc)
 		trace_smb3_zero_err(xid, cfile->fid.persistent_fid, tcon->tid,
-- 
2.53.0



