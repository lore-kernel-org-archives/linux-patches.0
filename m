Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C49BB51CF41;
	Wed, 30 Sep 2026 16:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784786; cv=none; b=kLoQtmElvBDtfBCGppRuAagCYSqKPYrUoK2DXaamVJhVNPuLXJTRRuRUSPf66YMoaUVIbFi5WTpBSR2/WjnPLvcmH3U9s3EwQUNWW674Lm8PF1bjQX8DAZRUK1UlY91sQveJ3gaQLrP27IPYnGq/COmfTLKRBiQLB1mnvTl04No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784786; c=relaxed/simple;
	bh=1+ZOuceTTSHlb5/gaMsZ2eWyc92Qbrni+rZaf1bErsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K6OhGMTiXXHaUIuf5GujqrCZZyPQP5UgV+5ml/h9JxKSDrJ0CITeRUUfUe8RiAtqKOHEb4vqps0U8xQAERKOY2L5VC1HwydqSJY/cpaB13FgSDPkpDPX658DLuA6mF+N1KHvNqkkPiQvLcaiH26r230mRIW8s1tPcUtgZ6AG79o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lRarZQBx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lRarZQBx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E5111F000FF;
	Wed, 30 Sep 2026 16:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784779;
	bh=UD5pcWXmhyYrBpxlE2J0xFU64kv7Sk8fGaTjsUnhyfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lRarZQBxAKaUHBOcFqzneOomKgmKo5x9v96Umov7CUWuQeENkhTkoQeILt68i4Q8w
	 +ztYMN+DCHK1wvkNnUGz6OaEj8mJtkR9sMbhyO5429fec+FAN1AkYpjguzXfkhGvGE
	 NllCiCMc7ek7014pUXhsLaQZS++BB80MtR92RkQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Vadayath <jay@artiphishell.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 276/982] smb: client: bound dirent name against end of SMB response in cifs_filldir
Date: Wed, 30 Sep 2026 17:16:52 +0200
Message-ID: <20260930152422.728681649@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 20955d595e6a5..7564927e2c427 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -966,7 +966,7 @@ static bool cifs_dir_emit(struct dir_context *ctx,
 static int cifs_filldir(char *find_entry, struct file *file,
 			struct dir_context *ctx,
 			char *scratch_buf, unsigned int max_len,
-			struct cached_fid *cfid)
+			char *end_of_smb, struct cached_fid *cfid)
 {
 	struct cifsFileInfo *file_info = file->private_data;
 	struct super_block *sb = file_inode(file)->i_sb;
@@ -987,6 +987,11 @@ static int cifs_filldir(char *find_entry, struct file *file,
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
@@ -1207,7 +1212,7 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
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



