Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7CF54FDA76;
	Thu, 17 Sep 2026 17:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664944; cv=none; b=Rj1Epzl7RxBINwlUVv0YLZ2FI7LiFyvuuTs+PjKpRUXcb1hZQ49MhKjDPgK64bjTyfDV85NvghiFovDEMN5c07vb2LRQbpo2rXZkUOYlYc+0ZXifHsadfQmomc3qKLiyxF3nLz5QOu7Hp56XqGvtI3YEgw+/GseEYtssR3MJsag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664944; c=relaxed/simple;
	bh=Whb8l41xDl/sRimkLyZPJzsnOEfWlCPZ0jevcPa6CZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ecyW/Axvkb4sHolOsK5O7wQH9mNRTT3G6ONbGv0SSJ4/QsPdVb8+ARO7KH8QaemWQcBIaQIeOGE2saFyOs+9SCgxsgYuqbwUPI+rZhMr1SUPnuoIDcX4/JpSwWDRv9nTQO2lfsabfrAA0RSUc9XRPF8gCWoYRdmlpJhviJVkMQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QCQXktjy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QCQXktjy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDE5E1F000FF;
	Thu, 17 Sep 2026 17:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664942;
	bh=wdhNWWOFVrH1sszqg1bVoNpvqkc/4ZPM4cZ7T9QknLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QCQXktjyiWqBwEYdxshIxjfUN7vJxWJf598sA6PPS1svy1jTDRSHlSttd9HhGcwcK
	 4Jn3GOFvpYvELIxAxw7vqccovGW9FGZGer0ulSB03Y5PTtxSK4mWM8DjUSuLTbV3MR
	 rocYQmlZfqIGc9RZZIb61lp5yVG6FCRdWjC48Fzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Vadayath <jay@artiphishell.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0540/1250] smb: client: bound dirent name against end of SMB response in cifs_filldir
Date: Thu, 17 Sep 2026 16:05:35 +0100
Message-ID: <20260917151606.580358556@linuxfoundation.org>
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

From: Jay Vadayath <jay@artiphishell.com>

[ Upstream commit f8cf09a53a0dc1da298e9dd0ba5f21710cf119d6 ]

cifs_filldir() copies the entry name out of an SMB1 TRANS2_FIND_FIRST /
FIND_NEXT response using a length (de.namelen) supplied by the server.
The kmalloc'd SMB response buffer is bounded, but nothing checks that
de.name + de.namelen still lies inside that buffer before the eventual
filldir64() -> verify_dirent_name() -> memchr() reads namelen bytes.

A hostile SMB1 server that returns an oversized FileNameLength in a
directory entry therefore causes memchr() to read past the end of the
response slab buffer. Reachable from any user who can list a directory
on a CIFS mount served by an attacker-controlled server (getdents64()
on the mounted directory):

  BUG: KASAN: slab-out-of-bounds in memchr+0x71/0x80
  Read of size 1 at addr ffff88800e0640cc by task poc/115
  Call Trace:
   dump_stack_lvl+0x64/0x80
   print_report+0xce/0x620
   kasan_report+0xec/0x120
   memchr+0x71/0x80
   filldir64+0x4c/0x6a0
   cifs_filldir.constprop.0+0x9bb/0x1e00
   cifs_readdir+0x2101/0x3380
   iterate_dir+0x19c/0x520
   __x64_sys_getdents64+0x126/0x210
   do_syscall_64+0x107/0x5a0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

Pass the end-of-response pointer down to cifs_filldir() and reject
entries whose name would extend past that boundary.

This bug was discovered by Artiphishell's vTriage pipeline, which
generated a userspace reproducer (an emulated hostile SMB1 server plus
a getdents64() client) that reliably triggers the KASAN report on an
unpatched kernel. The fix below was drafted with the Claude coding
assistant; a userspace reproducer is available on request.

Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Jay Vadayath <jay@artiphishell.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/readdir.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index f0ce26622a140..d61ce7c6be645 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -949,7 +949,7 @@ static bool cifs_dir_emit(struct dir_context *ctx,
 static int cifs_filldir(char *find_entry, struct file *file,
 			struct dir_context *ctx,
 			char *scratch_buf, unsigned int max_len,
-			struct cached_fid *cfid)
+			char *end_of_smb, struct cached_fid *cfid)
 {
 	struct cifsFileInfo *file_info = file->private_data;
 	struct super_block *sb = file_inode(file)->i_sb;
@@ -970,6 +970,11 @@ static int cifs_filldir(char *find_entry, struct file *file,
 		return -EINVAL;
 	}
 
+	if (de.name + de.namelen > end_of_smb) {
+		cifs_dbg(VFS, "search entry name extends past end of SMB\n");
+		return -EINVAL;
+	}
+
 	/* skip . and .. since we added them first */
 	if (cifs_entry_is_dot(&de, file_info->srch_inf.unicode))
 		return 0;
@@ -1190,7 +1195,7 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 		 */
 		*tmp_buf = 0;
 		rc = cifs_filldir(current_entry, file, ctx,
-				  tmp_buf, max_len, cfid);
+				  tmp_buf, max_len, end_of_smb, cfid);
 		if (rc) {
 			if (rc > 0)
 				rc = 0;
-- 
2.53.0



