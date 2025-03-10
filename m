Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F53422D786;
	Mon, 10 Mar 2025 17:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626552; cv=none; b=lqOMiiTLfykUG4wr35KEiH9gQrPbbkqh72jGIm7GG1AdWLbCgx/SQeNbDPtZabMBquU70A7zm2ZgOP8+WFrYMrSpHGrHATzADt2IX0ixMKbvipCMfPvrHmx0THeS/sj6J7eqXiLgV6abS/gROogqmWZLwTLXiWU+cndsXUPYna4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626552; c=relaxed/simple;
	bh=GpfBPjqPUa+gY4qYBcq7tvky5tWRYyG0n6vPDD4pe9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ikvN/a8SCVwdHpjgovccFMqcTOryEvYYNyz2SzQU+dPHmn2rd2k9FQA3V8iJuM19VONvl0GuXY438dkp7As+7RZ2NnjAbFcg63VvpfqhB8SeCSsDDuc/YBdl6C2LXIJhw1jUuW6dZXE5zof/AvMyz9icGPx5OnLO9sL6iJ7he6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wxbN+1b3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wxbN+1b3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E60FFC4CEE5;
	Mon, 10 Mar 2025 17:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626552;
	bh=GpfBPjqPUa+gY4qYBcq7tvky5tWRYyG0n6vPDD4pe9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wxbN+1b3lp/2cyJ6pj5gocTsPrwwONuHaPFAEZIrVKgPLDPQM6xWgh2lRfrFKpgSf
	 spGywlmbQx9XqTCWYcbuMzukHk2/4GO0OeBCC21yPrnfmUHYsXEfGCcDO9hq7LWLP1
	 DyTy+EVH56/XwJ1udZS5WlgJbPPLtxtz/lFPnKw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleh Nykyforchyn <oleh.nyk@gmail.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 004/207] smb311: failure to open files of length 1040 when mounting with SMB3.1.1 POSIX extensions
Date: Mon, 10 Mar 2025 18:03:17 +0100
Message-ID: <20250310170447.926613061@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <stfrench@microsoft.com>

[ Upstream commit 9df23801c83d3e12b4c09be39d37d2be385e52f9 ]

If a file size has bits 0x410 = ATTR_DIRECTORY | ATTR_REPARSE set
then during queryinfo (stat) the file is regarded as a directory
and subsequent opens can fail. A simple test example is trying
to open any file 1040 bytes long when mounting with "posix"
(SMB3.1.1 POSIX/Linux Extensions).

The cause of this bug is that Attributes field in smb2_file_all_info
struct occupies the same place that EndOfFile field in
smb311_posix_qinfo, and sometimes the latter struct is incorrectly
processed as if it was the first one.

Reported-by: Oleh Nykyforchyn <oleh.nyk@gmail.com>
Tested-by: Oleh Nykyforchyn <oleh.nyk@gmail.com>
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsglob.h  |  1 +
 fs/smb/client/reparse.h   | 28 ++++++++++++++++++++++------
 fs/smb/client/smb2inode.c |  4 ++++
 fs/smb/client/smb2ops.c   |  3 ++-
 4 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 3877b861529ea..37b7d84e26913 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -216,6 +216,7 @@ struct cifs_cred {
 struct cifs_open_info_data {
 	bool adjust_tz;
 	bool reparse_point;
+	bool contains_posix_file_info;
 	struct {
 		/* ioctl response buffer */
 		struct {
diff --git a/fs/smb/client/reparse.h b/fs/smb/client/reparse.h
index ff05b0e75c928..f080f92cb1e74 100644
--- a/fs/smb/client/reparse.h
+++ b/fs/smb/client/reparse.h
@@ -97,14 +97,30 @@ static inline bool reparse_inode_match(struct inode *inode,
 
 static inline bool cifs_open_data_reparse(struct cifs_open_info_data *data)
 {
-	struct smb2_file_all_info *fi = &data->fi;
-	u32 attrs = le32_to_cpu(fi->Attributes);
+	u32 attrs;
 	bool ret;
 
-	ret = data->reparse_point || (attrs & ATTR_REPARSE);
-	if (ret)
-		attrs |= ATTR_REPARSE;
-	fi->Attributes = cpu_to_le32(attrs);
+	if (data->contains_posix_file_info) {
+		struct smb311_posix_qinfo *fi = &data->posix_fi;
+
+		attrs = le32_to_cpu(fi->DosAttributes);
+		if (data->reparse_point) {
+			attrs |= ATTR_REPARSE;
+			fi->DosAttributes = cpu_to_le32(attrs);
+		}
+
+	} else {
+		struct smb2_file_all_info *fi = &data->fi;
+
+		attrs = le32_to_cpu(fi->Attributes);
+		if (data->reparse_point) {
+			attrs |= ATTR_REPARSE;
+			fi->Attributes = cpu_to_le32(attrs);
+		}
+	}
+
+	ret = attrs & ATTR_REPARSE;
+
 	return ret;
 }
 
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 7dfd3eb3847b3..6048b3fed3e78 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -648,6 +648,7 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 		switch (cmds[i]) {
 		case SMB2_OP_QUERY_INFO:
 			idata = in_iov[i].iov_base;
+			idata->contains_posix_file_info = false;
 			if (rc == 0 && cfile && cfile->symlink_target) {
 				idata->symlink_target = kstrdup(cfile->symlink_target, GFP_KERNEL);
 				if (!idata->symlink_target)
@@ -671,6 +672,7 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 			break;
 		case SMB2_OP_POSIX_QUERY_INFO:
 			idata = in_iov[i].iov_base;
+			idata->contains_posix_file_info = true;
 			if (rc == 0 && cfile && cfile->symlink_target) {
 				idata->symlink_target = kstrdup(cfile->symlink_target, GFP_KERNEL);
 				if (!idata->symlink_target)
@@ -768,6 +770,7 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 				idata = in_iov[i].iov_base;
 				idata->reparse.io.iov = *iov;
 				idata->reparse.io.buftype = resp_buftype[i + 1];
+				idata->contains_posix_file_info = false; /* BB VERIFY */
 				rbuf = reparse_buf_ptr(iov);
 				if (IS_ERR(rbuf)) {
 					rc = PTR_ERR(rbuf);
@@ -789,6 +792,7 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 		case SMB2_OP_QUERY_WSL_EA:
 			if (!rc) {
 				idata = in_iov[i].iov_base;
+				idata->contains_posix_file_info = false;
 				qi_rsp = rsp_iov[i + 1].iov_base;
 				data[0] = (u8 *)qi_rsp + le16_to_cpu(qi_rsp->OutputBufferOffset);
 				size[0] = le32_to_cpu(qi_rsp->OutputBufferLength);
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 793e9b2b79d6f..17c3063a9ca5b 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1001,6 +1001,7 @@ static int smb2_query_file_info(const unsigned int xid, struct cifs_tcon *tcon,
 		if (!data->symlink_target)
 			return -ENOMEM;
 	}
+	data->contains_posix_file_info = false;
 	return SMB2_query_info(xid, tcon, fid->persistent_fid, fid->volatile_fid, &data->fi);
 }
 
@@ -5150,7 +5151,7 @@ int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
 			     FILE_CREATE, CREATE_NOT_DIR |
 			     CREATE_OPTION_SPECIAL, ACL_NO_MODE);
 	oparms.fid = &fid;
-
+	idata.contains_posix_file_info = false;
 	rc = server->ops->open(xid, &oparms, &oplock, &idata);
 	if (rc)
 		goto out;
-- 
2.39.5



