Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6988D2ECEBA;
	Thu,  3 Jul 2025 14:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554609; cv=none; b=umLqobuMDWqaoNzE6OHhgypC4jwvmmUMm4Xy0bcn72LGZqABpBxUt7kQG9RT0Qf2+du/rvXJJvS1vzsMJxzVL/itrnEDZssNGT9rXORtUlIG35bSSgH8VnK6ba6wxGHVmAYyMBp1pS7hMRzbBHIX15UC9GxeyE+Bxrvc7N4DzkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554609; c=relaxed/simple;
	bh=S5tL8Adgw3R03M2dqmFEm1oZWA0oBTDX4TsFEl3B3zA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q8uXvQZop+RJC0V1SC2A3vUs6AcDXw9QDNY2HQg0Jk0EJYqXZGzdzr/A52GedL8WzqX8LATt+ZEHwlX/JKEOUZYdSFR57vJqzmfNR6lcEVpXHmggOZPPtPh8+qQgCxNGydRCxx1gdY7o001xPKiz8STss5KQV8gu3KSU+9sY9eI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F+L3KjwF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F+L3KjwF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC68C4CEE3;
	Thu,  3 Jul 2025 14:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554609;
	bh=S5tL8Adgw3R03M2dqmFEm1oZWA0oBTDX4TsFEl3B3zA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F+L3KjwFlunLIr6JrmO68+YqWfGUn85k7YSG2eJKERZOxXiZAmS1UUzXw3XVMh2DC
	 YykS3R4jhR4h8cv3/yzzHTKWWEb+UygPBut9oPga9kAYBd6qOIHtKa8RKbXzpTSK1d
	 lBReidsoRjWWgGKqsSAFSJWtylyT159SHNHrvSMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Turner Arthur <justinarthur@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 023/263] ksmbd: provide zero as a unique ID to the Mac client
Date: Thu,  3 Jul 2025 16:39:03 +0200
Message-ID: <20250703144005.229598633@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 572102098c108..dd3e0e3f7bf04 100644
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -108,6 +108,7 @@ struct ksmbd_conn {
 	__le16				signing_algorithm;
 	bool				binding;
 	atomic_t			refcnt;
+	bool				is_aapl;
 };
 
 struct ksmbd_conn_ops {
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index a9f9426e91acb..ad2b15ec3b561 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3541,6 +3541,15 @@ int smb2_open(struct ksmbd_work *work)
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
@@ -3980,7 +3989,10 @@ static int smb2_populate_readdir_entry(struct ksmbd_conn *conn, int info_level,
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
@@ -3997,7 +4009,10 @@ static int smb2_populate_readdir_entry(struct ksmbd_conn *conn, int info_level,
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
index 17a0b18a8406b..16ae8a10490be 100644
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



