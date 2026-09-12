Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F9594189B9;
	Sat, 12 Sep 2026 09:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205095; cv=none; b=eBi20jKS35xJGZ5eydUm9WD6jtcCaIimjMuk+9AxlR+WBeGGIZrqbmb6xyuS883zf59acs5Lw3RlKCwa0quec8fEOiAWMJxIRzoz983c7xr24ShiVVnUzVzu/A0JHwbpo5P0m2CkqIwRjvaNZl8dNJd8+92/WGC/uoBSIWGSznM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205095; c=relaxed/simple;
	bh=nA4a2vsnszAUBJ1joag3wTXp577h4gZfjoxyT4+s9OY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LkJs+pjtl3rOPvo94GT+67Ya49yuLi67mhgywVJ6lHePRMg+RcUb4ozqjpIvRtlWU0rwGvrWqXxFcL/lRnfFS81B1QXEgkTN/NcZ/bAM4YEI/ErgN9pwnEVY1RulxX3rcQXrOudND71YBCBgoOER3gZAT8UIRDuqb2LpyzlOUUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z5T9XreK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z5T9XreK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E896F1F000FF;
	Sat, 12 Sep 2026 09:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205093;
	bh=jwhlsNs7csLQhLPvPhulQQNxgYjfmrZOt1PiH7esKKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z5T9XreKbRAGJ0hWOKnO7Y0TRPwDhtbzKsIOio1LJXiNL1quFK/Pl+WELgtEkd107
	 1F5wSCfjemdsmSBHgJXJxoSzN+nOHiUi2ePES58fdHRphN4MZsaVdxuTXVK9OZnMKZ
	 txY0WHUeSdHIjF8qSlnv/3+75DzT89losAK+g8gA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ze Tan <tanze@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1748/1815] smb/client: preserve open info type across compound queries
Date: Sat, 12 Sep 2026 08:58:18 +0200
Message-ID: <20260912065730.020797312@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Ze Tan <tanze@kylinos.cn>

[ Upstream commit 9437f2113b60a5a8593aa4b41b6f6632f5cabcfd ]

contains_posix_file_info describes the metadata stored in the
fi/posix_fi union. GET_REPARSE and QUERY_WSL_EA do not update that
union, so clearing the flag while processing those responses can make
POSIX metadata look like FILE_ALL_INFORMATION.

Set the flag when CREATE or a validated query response actually
populates the union, and leave it unchanged for auxiliary compound
operations. This also avoids changing the type when a query fails
before copying any metadata.

The issue can be reproduced against a Samba server with SMB3 UNIX
extensions enabled:

  mount -t cifs //<server>/<share> /mnt/cifs \
        -o vers=3.1.1,posix,reparse=nfs,actimeo=0
  mkfifo /mnt/cifs/test-fifo
  umount /mnt/cifs
  mount -t cifs //<server>/<share> /mnt/cifs \
        -o vers=3.1.1,posix,reparse=nfs,actimeo=0
  stat -c '%F %s' /mnt/cifs/test-fifo

Before this change, stat reports "fifo 1024" although the server-side
EOF is zero. After this change, it reports "fifo 0".

Fixes: 9df23801c83d ("smb311: failure to open files of length 1040 when mounting with SMB3.1.1 POSIX extensions")
Signed-off-by: Ze Tan <tanze@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2inode.c | 9 +++++----
 fs/smb/client/smb2pdu.c   | 1 +
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 2946391bb992d..457442af1222e 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -576,6 +576,7 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 		idata->fi.Attributes = create_rsp->FileAttributes;
 		idata->fi.AllocationSize = create_rsp->AllocationSize;
 		idata->fi.EndOfFile = create_rsp->EndofFile;
+		idata->contains_posix_file_info = false;
 		if (le32_to_cpu(idata->fi.NumberOfLinks) == 0)
 			idata->fi.NumberOfLinks = cpu_to_le32(1); /* dummy value */
 		idata->fi.DeletePending = 0; /* successful open = not delete pending */
@@ -598,7 +599,6 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 		switch (cmds[i]) {
 		case SMB2_OP_QUERY_INFO:
 			idata = in_iov[i].iov_base;
-			idata->contains_posix_file_info = false;
 			if (rc == 0 && cfile && cfile->symlink_target) {
 				idata->symlink_target = kstrdup(cfile->symlink_target, GFP_KERNEL);
 				if (!idata->symlink_target)
@@ -611,6 +611,8 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 					le16_to_cpu(qi_rsp->OutputBufferOffset),
 					le32_to_cpu(qi_rsp->OutputBufferLength),
 					&rsp_iov[i + 1], sizeof(idata->fi), (char *)&idata->fi);
+				if (!rc)
+					idata->contains_posix_file_info = false;
 			}
 			SMB2_query_info_free(&rqst[num_rqst++]);
 			if (rc)
@@ -622,7 +624,6 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 			break;
 		case SMB2_OP_POSIX_QUERY_INFO:
 			idata = in_iov[i].iov_base;
-			idata->contains_posix_file_info = true;
 			if (rc == 0 && cfile && cfile->symlink_target) {
 				idata->symlink_target = kstrdup(cfile->symlink_target, GFP_KERNEL);
 				if (!idata->symlink_target)
@@ -636,6 +637,8 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 					le32_to_cpu(qi_rsp->OutputBufferLength),
 					&rsp_iov[i + 1], sizeof(idata->posix_fi) /* add SIDs */,
 					(char *)&idata->posix_fi);
+				if (!rc)
+					idata->contains_posix_file_info = true;
 			}
 			if (rc == 0)
 				rc = parse_posix_sids(idata, &rsp_iov[i + 1]);
@@ -707,7 +710,6 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 				idata = in_iov[i].iov_base;
 				idata->reparse.io.iov = *iov;
 				idata->reparse.io.buftype = resp_buftype[i + 1];
-				idata->contains_posix_file_info = false; /* BB VERIFY */
 				rbuf = reparse_buf_ptr(iov);
 				if (IS_ERR(rbuf)) {
 					rc = PTR_ERR(rbuf);
@@ -729,7 +731,6 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 		case SMB2_OP_QUERY_WSL_EA:
 			if (!rc) {
 				idata = in_iov[i].iov_base;
-				idata->contains_posix_file_info = false;
 				qi_rsp = rsp_iov[i + 1].iov_base;
 				data[0] = (u8 *)qi_rsp + le16_to_cpu(qi_rsp->OutputBufferOffset);
 				size[0] = le32_to_cpu(qi_rsp->OutputBufferLength);
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index d207591cc889c..dea05aeb53a18 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3372,6 +3372,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 #endif /* CIFS_DEBUG2 */
 
 	if (file_info) {
+		buf->contains_posix_file_info = false;
 		file_info->CreationTime = rsp->CreationTime;
 		file_info->LastAccessTime = rsp->LastAccessTime;
 		file_info->LastWriteTime = rsp->LastWriteTime;
-- 
2.53.0



