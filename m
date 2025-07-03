Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276A12EFD8A;
	Thu,  3 Jul 2025 15:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555441; cv=none; b=tFknzTjkucgNKN3ATwu2YP0mAJldiuz8NrfmT1Eto9m73uYhQffeYPT/MZGrkGhrOMniE9Ei3f20tefCJk0UjYSCYxPL5repqgfmtlhwBnUiC8uginX2HBwPzZ0k2FIdxmTbUc+sVSlhMU+ZJcqQkZq9WKjLMTc88HbboPtyrz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555441; c=relaxed/simple;
	bh=grkgfNIGIhrLmY6+StATeo+ufF+Krxw2NVWqf+dqgLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h7jyYSkoICfbQ81gl+u2VBCs/N23/gcfLqsm4Qx2QhTAefOtYihR2yt1mAUGejHzu4M8Cxp5CJp1nDWEC5OQ1O/C/dWj3iQ5EMrBK3URUgGP9MGZ5AmXEagkydR58zmEY4CRtv/6veIrz02Hz7wt1fsl/eIzH/S4GTTm12wyW1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MCS6epYH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MCS6epYH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83492C4CEF4;
	Thu,  3 Jul 2025 15:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555441;
	bh=grkgfNIGIhrLmY6+StATeo+ufF+Krxw2NVWqf+dqgLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MCS6epYHkEScfDnXv/izwk9WAgnXdxSdqmCt7rmEI3Ks/eJXhvNTpNPrr6CV3Rvkn
	 caGDAR1JHRQXJ1myp7lN4c769v+E8d5gx/em43R5u1B4tgmk/VbCtgUbPsiTWRBInX
	 I6yx+uSihB87rfCYFbBmxPoxij+q4j/wwh5wp848=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Turner Arthur <justinarthur@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 015/139] ksmbd: provide zero as a unique ID to the Mac client
Date: Thu,  3 Jul 2025 16:41:18 +0200
Message-ID: <20250703143941.774026114@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 571781eb7ffefa65b0e922c8031e42b4411a40d4 ]

The Mac SMB client code seems to expect the on-disk file identifier
to have the semantics of HFS+ Catalog Node Identifier (CNID).
ksmbd provides the inode number as a unique ID to the client,
but in the case of subvolumes of btrfs, there are cases where different
files have the same inode number, so the mac smb client treats it
as an error. There is a report that a similar problem occurs
when the share is ZFS.
Returning UniqueId of zero will make the Mac client to stop using and
trusting the file id returned from the server.

Reported-by: Justin Turner Arthur <justinarthur@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/connection.h |  1 +
 fs/smb/server/smb2pdu.c    | 19 +++++++++++++++++--
 fs/smb/server/smb2pdu.h    |  3 +++
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/connection.h b/fs/smb/server/connection.h
index 4fdd76ce53b90..dc07c6eb8c192 100644
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -107,6 +107,7 @@ struct ksmbd_conn {
 	__le16				signing_algorithm;
 	bool				binding;
 	atomic_t			refcnt;
+	bool				is_aapl;
 };
 
 struct ksmbd_conn_ops {
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index b851cd7d19b48..185f7e0744f8a 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3527,6 +3527,15 @@ int smb2_open(struct ksmbd_work *work)
 			ksmbd_debug(SMB, "get query on disk id context\n");
 			query_disk_id = 1;
 		}
+
+		if (conn->is_aapl == false) {
+			context = smb2_find_context_vals(req, SMB2_CREATE_AAPL, 4);
+			if (IS_ERR(context)) {
+				rc = PTR_ERR(context);
+				goto err_out1;
+			} else if (context)
+				conn->is_aapl = true;
+		}
 	}
 
 	rc = ksmbd_vfs_getattr(&path, &stat);
@@ -3965,7 +3974,10 @@ static int smb2_populate_readdir_entry(struct ksmbd_conn *conn, int info_level,
 		if (dinfo->EaSize)
 			dinfo->ExtFileAttributes = FILE_ATTRIBUTE_REPARSE_POINT_LE;
 		dinfo->Reserved = 0;
-		dinfo->UniqueId = cpu_to_le64(ksmbd_kstat->kstat->ino);
+		if (conn->is_aapl)
+			dinfo->UniqueId = 0;
+		else
+			dinfo->UniqueId = cpu_to_le64(ksmbd_kstat->kstat->ino);
 		if (d_info->hide_dot_file && d_info->name[0] == '.')
 			dinfo->ExtFileAttributes |= FILE_ATTRIBUTE_HIDDEN_LE;
 		memcpy(dinfo->FileName, conv_name, conv_len);
@@ -3982,7 +3994,10 @@ static int smb2_populate_readdir_entry(struct ksmbd_conn *conn, int info_level,
 			smb2_get_reparse_tag_special_file(ksmbd_kstat->kstat->mode);
 		if (fibdinfo->EaSize)
 			fibdinfo->ExtFileAttributes = FILE_ATTRIBUTE_REPARSE_POINT_LE;
-		fibdinfo->UniqueId = cpu_to_le64(ksmbd_kstat->kstat->ino);
+		if (conn->is_aapl)
+			fibdinfo->UniqueId = 0;
+		else
+			fibdinfo->UniqueId = cpu_to_le64(ksmbd_kstat->kstat->ino);
 		fibdinfo->ShortNameLength = 0;
 		fibdinfo->Reserved = 0;
 		fibdinfo->Reserved2 = cpu_to_le16(0);
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index 25cc81aac350f..2821e6c8298f4 100644
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -63,6 +63,9 @@ struct preauth_integrity_info {
 
 #define SMB2_SESSION_TIMEOUT		(10 * HZ)
 
+/* Apple Defined Contexts */
+#define SMB2_CREATE_AAPL		"AAPL"
+
 struct create_durable_req_v2 {
 	struct create_context_hdr ccontext;
 	__u8   Name[8];
-- 
2.39.5



