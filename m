Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7456213B7AE;
	Thu, 23 May 2024 13:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470674; cv=none; b=nhWnRSJNiz5r04L10WGQeUqs7JMOlLgA13F/Csb/sGxsBUALHpEHar+snywSdlAk5WnO8EzzOXcLYPwN+/NdNEVZfRdkEcBrI2M9uCut5chpJuYSy/bhmii6hM0wY+mMQUGtwRy4ZwbswDZpB8KP2lpxE/BUkJMEmM5/uFviE9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470674; c=relaxed/simple;
	bh=8ndBFyslHJPmwDf9+0sEsvN7ac99B8+st2VbjnKLm4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aH69kq5LYOVHAxZ1xXfOefsEBTR8cVvG1XiEe2GAAwzuGZ3wwIRta9n1J06ba9CsxmMk8SNv8DnB1Ur7jsBMlyeYF1PCm3jbeRVpEhbaTXAS+m+0vuw3JluRAKgsUCZL/KHf/s3sPsFKA3jJSj0NRP7JuR1ZmXrwaF8aqphKTxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EDoZgVUb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EDoZgVUb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F07C2C32782;
	Thu, 23 May 2024 13:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470674;
	bh=8ndBFyslHJPmwDf9+0sEsvN7ac99B8+st2VbjnKLm4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EDoZgVUb/7vKMLkXGcvhqor2qsDRMCxHSCZcwFj8sfGPC5omJptBVGUpQllr/CdIo
	 zBgWnzgJxoJ+qgz+vJNzapiE34l2q13A9ljscsx+nkcESlKRM3F0lrhmyS2yLghP8M
	 szZZd56hwghg/Xt9ARirB0aWVFY60+uZHx/VEcco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paulo Alcantara <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 047/102] smb: client: fix potential broken compound request
Date: Thu, 23 May 2024 15:13:12 +0200
Message-ID: <20240523130344.239290572@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit 6914d288c63682e20e0f6e1e0b8e8f5847012d67 ]

Now that smb2_compound_op() can accept up to 5 commands in a single
compound request, set the appropriate NextCommand and related flags to
all subsequent commands as well as handling the case where a valid
@cfile is passed and therefore skipping create and close requests in
the compound chain.

This fix a potential broken compound request that could be sent from
smb2_get_reparse_inode() if the client found a valid open
file (@cfile) prior to calling smb2_compound_op().

Signed-off-by: Paulo Alcantara <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2inode.c | 106 ++++++++++++++++++++++----------------
 1 file changed, 63 insertions(+), 43 deletions(-)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index add90eb8fc165..33f3fffcb8277 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -223,14 +223,13 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 							  SMB2_O_INFO_FILE, 0,
 							  sizeof(struct smb2_file_all_info) +
 							  PATH_MAX * 2, 0, NULL);
-				if (!rc) {
-					smb2_set_next_command(tcon, &rqst[num_rqst]);
-					smb2_set_related(&rqst[num_rqst]);
-				}
 			}
-
-			if (rc)
+			if (!rc && (!cfile || num_rqst > 1)) {
+				smb2_set_next_command(tcon, &rqst[num_rqst]);
+				smb2_set_related(&rqst[num_rqst]);
+			} else if (rc) {
 				goto finished;
+			}
 			num_rqst++;
 			trace_smb3_query_info_compound_enter(xid, ses->Suid,
 							     tcon->tid, full_path);
@@ -260,14 +259,13 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 							  sizeof(struct smb311_posix_qinfo *) +
 							  (PATH_MAX * 2) +
 							  (sizeof(struct cifs_sid) * 2), 0, NULL);
-				if (!rc) {
-					smb2_set_next_command(tcon, &rqst[num_rqst]);
-					smb2_set_related(&rqst[num_rqst]);
-				}
 			}
-
-			if (rc)
+			if (!rc && (!cfile || num_rqst > 1)) {
+				smb2_set_next_command(tcon, &rqst[num_rqst]);
+				smb2_set_related(&rqst[num_rqst]);
+			} else if (rc) {
 				goto finished;
+			}
 			num_rqst++;
 			trace_smb3_posix_query_info_compound_enter(xid, ses->Suid,
 								   tcon->tid, full_path);
@@ -325,13 +323,13 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 							FILE_END_OF_FILE_INFORMATION,
 							SMB2_O_INFO_FILE, 0,
 							data, size);
-				if (!rc) {
-					smb2_set_next_command(tcon, &rqst[num_rqst]);
-					smb2_set_related(&rqst[num_rqst]);
-				}
 			}
-			if (rc)
+			if (!rc && (!cfile || num_rqst > 1)) {
+				smb2_set_next_command(tcon, &rqst[num_rqst]);
+				smb2_set_related(&rqst[num_rqst]);
+			} else if (rc) {
 				goto finished;
+			}
 			num_rqst++;
 			trace_smb3_set_eof_enter(xid, ses->Suid, tcon->tid, full_path);
 			break;
@@ -356,14 +354,13 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 							COMPOUND_FID, current->tgid,
 							FILE_BASIC_INFORMATION,
 							SMB2_O_INFO_FILE, 0, data, size);
-				if (!rc) {
-					smb2_set_next_command(tcon, &rqst[num_rqst]);
-					smb2_set_related(&rqst[num_rqst]);
-				}
 			}
-
-			if (rc)
+			if (!rc && (!cfile || num_rqst > 1)) {
+				smb2_set_next_command(tcon, &rqst[num_rqst]);
+				smb2_set_related(&rqst[num_rqst]);
+			} else if (rc) {
 				goto finished;
+			}
 			num_rqst++;
 			trace_smb3_set_info_compound_enter(xid, ses->Suid,
 							   tcon->tid, full_path);
@@ -397,13 +394,13 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 							COMPOUND_FID, COMPOUND_FID,
 							current->tgid, FILE_RENAME_INFORMATION,
 							SMB2_O_INFO_FILE, 0, data, size);
-				if (!rc) {
-					smb2_set_next_command(tcon, &rqst[num_rqst]);
-					smb2_set_related(&rqst[num_rqst]);
-				}
 			}
-			if (rc)
+			if (!rc && (!cfile || num_rqst > 1)) {
+				smb2_set_next_command(tcon, &rqst[num_rqst]);
+				smb2_set_related(&rqst[num_rqst]);
+			} else if (rc) {
 				goto finished;
+			}
 			num_rqst++;
 			trace_smb3_rename_enter(xid, ses->Suid, tcon->tid, full_path);
 			break;
@@ -438,15 +435,27 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 			rqst[num_rqst].rq_iov = vars->io_iov;
 			rqst[num_rqst].rq_nvec = ARRAY_SIZE(vars->io_iov);
 
-			rc = SMB2_ioctl_init(tcon, server, &rqst[num_rqst],
-					     COMPOUND_FID, COMPOUND_FID,
-					     FSCTL_SET_REPARSE_POINT,
-					     in_iov[i].iov_base,
-					     in_iov[i].iov_len, 0);
-			if (rc)
+			if (cfile) {
+				rc = SMB2_ioctl_init(tcon, server, &rqst[num_rqst],
+						     cfile->fid.persistent_fid,
+						     cfile->fid.volatile_fid,
+						     FSCTL_SET_REPARSE_POINT,
+						     in_iov[i].iov_base,
+						     in_iov[i].iov_len, 0);
+			} else {
+				rc = SMB2_ioctl_init(tcon, server, &rqst[num_rqst],
+						     COMPOUND_FID, COMPOUND_FID,
+						     FSCTL_SET_REPARSE_POINT,
+						     in_iov[i].iov_base,
+						     in_iov[i].iov_len, 0);
+			}
+			if (!rc && (!cfile || num_rqst > 1)) {
+				smb2_set_next_command(tcon, &rqst[num_rqst]);
+				smb2_set_related(&rqst[num_rqst]);
+			} else if (rc) {
 				goto finished;
-			smb2_set_next_command(tcon, &rqst[num_rqst]);
-			smb2_set_related(&rqst[num_rqst++]);
+			}
+			num_rqst++;
 			trace_smb3_set_reparse_compound_enter(xid, ses->Suid,
 							      tcon->tid, full_path);
 			break;
@@ -454,14 +463,25 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 			rqst[num_rqst].rq_iov = vars->io_iov;
 			rqst[num_rqst].rq_nvec = ARRAY_SIZE(vars->io_iov);
 
-			rc = SMB2_ioctl_init(tcon, server, &rqst[num_rqst],
-					     COMPOUND_FID, COMPOUND_FID,
-					     FSCTL_GET_REPARSE_POINT,
-					     NULL, 0, CIFSMaxBufSize);
-			if (rc)
+			if (cfile) {
+				rc = SMB2_ioctl_init(tcon, server, &rqst[num_rqst],
+						     cfile->fid.persistent_fid,
+						     cfile->fid.volatile_fid,
+						     FSCTL_GET_REPARSE_POINT,
+						     NULL, 0, CIFSMaxBufSize);
+			} else {
+				rc = SMB2_ioctl_init(tcon, server, &rqst[num_rqst],
+						     COMPOUND_FID, COMPOUND_FID,
+						     FSCTL_GET_REPARSE_POINT,
+						     NULL, 0, CIFSMaxBufSize);
+			}
+			if (!rc && (!cfile || num_rqst > 1)) {
+				smb2_set_next_command(tcon, &rqst[num_rqst]);
+				smb2_set_related(&rqst[num_rqst]);
+			} else if (rc) {
 				goto finished;
-			smb2_set_next_command(tcon, &rqst[num_rqst]);
-			smb2_set_related(&rqst[num_rqst++]);
+			}
+			num_rqst++;
 			trace_smb3_get_reparse_compound_enter(xid, ses->Suid,
 							      tcon->tid, full_path);
 			break;
-- 
2.43.0



