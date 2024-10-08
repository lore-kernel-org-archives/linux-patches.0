Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF947165F08;
	Tue,  8 Oct 2024 12:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389768; cv=none; b=nT7Q6DB0XCq7GSwsj+kk+0exdj48uWNxYdIzB0qzOzvsS6jJLMBjdabj24FBP1x1HqLPnNUp2800XI0olU2qwy+ha2jb942FZ8O3BhqERn9QgnZaJlZVSXBduQLpOcfYkQxbauGXYNQ9yUbD9I/hXJkAl4L8RL5iMThAbOIZ5S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389768; c=relaxed/simple;
	bh=0uA1l8vJSFw3G4eaQ5+odMIyeIsFqh7y7qSq+npcy/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CrDD5ZksLPTsMta6vtKfG6+88Dfq4P1zwjQLxGA26YAvRfQzs0CfD8HFfMmu1HO9OSGW9UytKEZmH7VVBTJfFjkYfunuJ7msBBznT3aThTau2/QY4fI3C+aPtGS61WlpMvxErWK2jdPZHGwKSNZ4GqMw59O4hFqGx4n8g0ZS7R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2A4Wd4f+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2A4Wd4f+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08866C4CECD;
	Tue,  8 Oct 2024 12:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389768;
	bh=0uA1l8vJSFw3G4eaQ5+odMIyeIsFqh7y7qSq+npcy/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2A4Wd4f+eJtoDGkfneVXt1U6Y+0O7r5QB2kK7kVbQFp9EhPYdYwAMs1gRl9ssb+MA
	 iYrP+sd2QjfwbiXWULj88beKIkFhelQHYklSHTU6WZPpSv0VunBeP/nGbTxSLG0TqI
	 eYzQ7yxQT6ZZdwaj0V8ITcr/ENXD4D76VLxUozqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 059/482] cifs: Remove intermediate object of failed create reparse call
Date: Tue,  8 Oct 2024 14:02:02 +0200
Message-ID: <20241008115650.630691563@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pali Rohár <pali@kernel.org>

[ Upstream commit c9432ad5e32f066875b1bf95939c363bc46d6a45 ]

If CREATE was successful but SMB2_OP_SET_REPARSE failed then remove the
intermediate object created by CREATE. Otherwise empty object stay on the
server when reparse call failed.

This ensures that if the creating of special files is unsupported by the
server then no empty file stay on the server as a result of unsupported
operation.

Fixes: 102466f303ff ("smb: client: allow creating special files via reparse points")
Signed-off-by: Pali Rohár <pali@kernel.org>
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2inode.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 11a1c53c64e0b..a6dab60e2c01e 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -1205,9 +1205,12 @@ struct inode *smb2_get_reparse_inode(struct cifs_open_info_data *data,
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 	struct cifsFileInfo *cfile;
 	struct inode *new = NULL;
+	int out_buftype[4] = {};
+	struct kvec out_iov[4] = {};
 	struct kvec in_iov[2];
 	int cmds[2];
 	int rc;
+	int i;
 
 	oparms = CIFS_OPARMS(cifs_sb, tcon, full_path,
 			     SYNCHRONIZE | DELETE |
@@ -1228,7 +1231,7 @@ struct inode *smb2_get_reparse_inode(struct cifs_open_info_data *data,
 		cmds[1] = SMB2_OP_POSIX_QUERY_INFO;
 		cifs_get_writable_path(tcon, full_path, FIND_WR_ANY, &cfile);
 		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path, &oparms,
-				      in_iov, cmds, 2, cfile, NULL, NULL, NULL);
+				      in_iov, cmds, 2, cfile, out_iov, out_buftype, NULL);
 		if (!rc) {
 			rc = smb311_posix_get_inode_info(&new, full_path,
 							 data, sb, xid);
@@ -1237,12 +1240,29 @@ struct inode *smb2_get_reparse_inode(struct cifs_open_info_data *data,
 		cmds[1] = SMB2_OP_QUERY_INFO;
 		cifs_get_writable_path(tcon, full_path, FIND_WR_ANY, &cfile);
 		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path, &oparms,
-				      in_iov, cmds, 2, cfile, NULL, NULL, NULL);
+				      in_iov, cmds, 2, cfile, out_iov, out_buftype, NULL);
 		if (!rc) {
 			rc = cifs_get_inode_info(&new, full_path,
 						 data, sb, xid, NULL);
 		}
 	}
+
+
+	/*
+	 * If CREATE was successful but SMB2_OP_SET_REPARSE failed then
+	 * remove the intermediate object created by CREATE. Otherwise
+	 * empty object stay on the server when reparse call failed.
+	 */
+	if (rc &&
+	    out_iov[0].iov_base != NULL && out_buftype[0] != CIFS_NO_BUFFER &&
+	    ((struct smb2_hdr *)out_iov[0].iov_base)->Status == STATUS_SUCCESS &&
+	    (out_iov[1].iov_base == NULL || out_buftype[1] == CIFS_NO_BUFFER ||
+	     ((struct smb2_hdr *)out_iov[1].iov_base)->Status != STATUS_SUCCESS))
+		smb2_unlink(xid, tcon, full_path, cifs_sb, NULL);
+
+	for (i = 0; i < ARRAY_SIZE(out_buftype); i++)
+		free_rsp_buf(out_buftype[i], out_iov[i].iov_base);
+
 	return rc ? ERR_PTR(rc) : new;
 }
 
-- 
2.43.0



