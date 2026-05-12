Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D0C377567;
	Tue, 12 May 2026 17:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608642; cv=none; b=tqOh3Gy9dOsCetCvZhIFalIdzkLh+fjYjmKuyB7g9zUjC+a5dqU7DgFdD9uyxXNBtzSQI1vauyi8qXb8LpXl3w+Y4N7G3cltUA9OMz3ORyF0yW0ZV7WtWRWJAvPoZxnY36oJGPHrMU0TWYNv8duuQFuqMHS75iS1GWP9PKlLOWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608642; c=relaxed/simple;
	bh=3xdMN296sD/Vd/xOANQuQXBLy5xOhp6CSHBwPltMOSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jev0EnHLPDbNoyx5s0kpzkqFY/dGovl6ZQJ+uTV2zp7lJRNpgn75hw7nOk0/j53PA3yFt6EvLQpZFfO0RtuN0FJHpazXRZYDTgRiprAJD0cwnB/ZIYFNtRVljTNLwLC5VB62AZNif13K5mKjcsuiRKK+QU9VgwC0qjx/Pv+Udz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zetH97Lv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zetH97Lv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C21DC2BCB0;
	Tue, 12 May 2026 17:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608641;
	bh=3xdMN296sD/Vd/xOANQuQXBLy5xOhp6CSHBwPltMOSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zetH97LvH6yLStHhD5PkbYMrJilLZywhd2PZoa1S9MCRaLW+iy8o83H/doTIEm8MB
	 mQHTwfeTvPCLIo6nSctP7QVQdaiT+ezxBoDhyfeksVLzTP9vZdP0syDouDKY1+sDEA
	 EwwOOHbuZIyWQCXFpbhlZduR85xQhWusFsc7l0tY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 6.18 157/270] isofs: validate block number from NFS file handle in isofs_export_iget
Date: Tue, 12 May 2026 19:39:18 +0200
Message-ID: <20260512173941.753524144@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 24376458138387fb251e782e624c7776e9826796 upstream.

isofs_fh_to_dentry() and isofs_fh_to_parent() pass an attacker-
controlled block number (ifid->block or ifid->parent_block) from
the NFS file handle to isofs_export_iget(), which only rejects
block == 0 before calling isofs_iget() and ultimately sb_bread().
A crafted file handle with fh_len sufficient to pass the check
added by commit 0405d4b63d08 ("isofs: Prevent the use of too small
fid") can still drive the server to read any in-range block on the
backing device as if it were an iso_directory_record.  That earlier
fix was assigned CVE-2025-37780.

sb_bread() on an out-of-range block returns NULL cleanly via the
EIO path, so there is no memory-safety violation.  For in-range
reads of adjacent-partition data on the same block device, the
unrelated bytes end up in iso_inode_info fields that reach the NFS
client as dentry metadata.  The deployment surface (isofs exported
over NFS from loop-mounted images) is narrow and requires an
authenticated NFS peer, but the malformed-file-handle class is
reportable as hardening next to the existing CVE-2025-37780 fix.

Reject block >= ISOFS_SB(sb)->s_nzones in isofs_export_iget() so
the check covers both isofs_fh_to_dentry() and isofs_fh_to_parent()
call sites with a single line.

Fixes: 0405d4b63d08 ("isofs: Prevent the use of too small fid")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Link: https://patch.msgid.link/20260419212155.2169382-3-michael.bommarito@gmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/isofs/export.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/isofs/export.c
+++ b/fs/isofs/export.c
@@ -24,7 +24,7 @@ isofs_export_iget(struct super_block *sb
 {
 	struct inode *inode;
 
-	if (block == 0)
+	if (block == 0 || block >= ISOFS_SB(sb)->s_nzones)
 		return ERR_PTR(-ESTALE);
 	inode = isofs_iget(sb, block, offset);
 	if (IS_ERR(inode))


