Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89B91DED7A;
	Tue,  8 Oct 2024 13:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393090; cv=none; b=c+PsH9PMxG6RAhe44rMW63zr8oTFIf1bsK28EwluiV/awmDW8eWbOzqElHUdyo+dBOkZRkP3KXQ4P/28ND/XnQ2d7PXHFu/eyxYV6FZBp0+mB5JMSzcJ+DsQhkQNPOEzAXmyxIV0Z2CVka2KH9Wjac37K7/bytHOqmrRmvyQ4t0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393090; c=relaxed/simple;
	bh=KBqTOXtwWGBQoUM9RuKBurANIr6+EFvf/4KGiwmlTXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hv96uLL7i2xGKr2f0XHuZAJCQ7rAxDXo4nIDtrazFHQwWGZv9TPHfF6wuZKAiHlJznT3rEnsgzm2w8I3A7boGxvlK52wVZUAoGsOdpZ9e3NEtCSJy/y/GmZB65XZcO3ybVnRXrdvwx1zkVLWTfbgqIR5Si7lWs8Yle9/pyDqFSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OF9/qdCI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OF9/qdCI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15098C4CEC7;
	Tue,  8 Oct 2024 13:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393090;
	bh=KBqTOXtwWGBQoUM9RuKBurANIr6+EFvf/4KGiwmlTXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OF9/qdCIqR6AZUvKW+NrkyujkLtNX9IttORVOFteF9H3mnbPL0PR0JDPPmJcQgOfc
	 v6gWOXE0L6tbc02VgzocKIx6VpdYjhYlxZxRDQ7iXR3aScANj24I8rhOH46mYyexnl
	 FtiRKn717tmtlzbtsRQhKef0GhO+f+y5sGCWe2/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 049/386] cifs: Remove intermediate object of failed create reparse call
Date: Tue,  8 Oct 2024 14:04:54 +0200
Message-ID: <20241008115631.401631462@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index dd8acd2077521..8010b3ed4b3fe 100644
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



