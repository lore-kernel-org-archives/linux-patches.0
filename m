Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A20811D545;
	Thu, 23 May 2024 13:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470755; cv=none; b=l3PbBavi3Xb8htzykdEpKszQ/IKtr1Myi0Hdt44y0ivWBb2BEke4+Gb1ZArBS600w8NBGQAob2LShp9LKFfHx8GiY2da7mNXp2tHibddKo8mM6cAKpwyodOMPI6Ziiy+uwHpLJ/Br4m0mRR7NAEUGx4Nqe53wEKwDNvKaMkoW1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470755; c=relaxed/simple;
	bh=YTCsPldypNUqxiHbA1bCIIWhHBR4z1aFghB1UCF5K68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qxFbufNXNHKxxOxl89qDFB5Jv0Z8FmkQn6wwnj41DzTvFjbaxCF73XwSglzfZDfnoRF5TLniFKVGzsfeOauuEdd4aMjX2ew51KNwlDc4alKwGm6YQRPD0r+5phOFjhuOJdv2UWtKzDUCZLkoSStlh2n6dhjZ9BFKjc/JuokWzpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y3ihmi0N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y3ihmi0N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B05C3277B;
	Thu, 23 May 2024 13:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470755;
	bh=YTCsPldypNUqxiHbA1bCIIWhHBR4z1aFghB1UCF5K68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y3ihmi0Nj7bWjECoKcWkIEna4Fke5RWFYXj5iHhtuCMCxrM9TpbSY6EwjH3jsQIZj
	 JWD6gI3tUhUsHVV2UHRvbg76krFsNGyoZuXyAG0xysJAr7YuhD+CaQrxEqE3kujKtZ
	 +8cgdJK68xG8mEgZq+P1qEYgWTIx2OkRWOK1vpcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 076/102] smb: smb2pdu.h: Avoid -Wflex-array-member-not-at-end warnings
Date: Thu, 23 May 2024 15:13:41 +0200
Message-ID: <20240523130345.333664062@linuxfoundation.org>
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

From: Gustavo A. R. Silva <gustavoars@kernel.org>

-Wflex-array-member-not-at-end is coming in GCC-14, and we are getting
ready to enable it globally.

So, in order to avoid ending up with a flexible-array member in the
middle of multiple other structs, we use the `__struct_group()` helper
to separate the flexible array from the rest of the members in the
flexible structure, and use the tagged `struct create_context_hdr`
instead of `struct create_context`.

So, with these changes, fix 51 of the following warnings[1]:

fs/smb/client/../common/smb2pdu.h:1225:31: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]

Link: https://gist.github.com/GustavoARSilva/772526a39be3dd4db39e71497f0a9893 [1]
Link: https://github.com/KSPP/linux/issues/202
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smb2pdu.h | 12 ++++++------
 fs/smb/common/smb2pdu.h | 33 ++++++++++++++++++---------------
 fs/smb/server/smb2pdu.h | 18 +++++++++---------
 3 files changed, 33 insertions(+), 30 deletions(-)

diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
index 2fccf0d4f53d2..5c458ab3b05a4 100644
--- a/fs/smb/client/smb2pdu.h
+++ b/fs/smb/client/smb2pdu.h
@@ -145,7 +145,7 @@ struct durable_context_v2 {
 } __packed;
 
 struct create_durable_v2 {
-	struct create_context ccontext;
+	struct create_context_hdr ccontext;
 	__u8   Name[8];
 	struct durable_context_v2 dcontext;
 } __packed;
@@ -167,7 +167,7 @@ struct durable_reconnect_context_v2_rsp {
 } __packed;
 
 struct create_durable_handle_reconnect_v2 {
-	struct create_context ccontext;
+	struct create_context_hdr ccontext;
 	__u8   Name[8];
 	struct durable_reconnect_context_v2 dcontext;
 	__u8   Pad[4];
@@ -175,7 +175,7 @@ struct create_durable_handle_reconnect_v2 {
 
 /* See MS-SMB2 2.2.13.2.5 */
 struct crt_twarp_ctxt {
-	struct create_context ccontext;
+	struct create_context_hdr ccontext;
 	__u8	Name[8];
 	__le64	Timestamp;
 
@@ -183,12 +183,12 @@ struct crt_twarp_ctxt {
 
 /* See MS-SMB2 2.2.13.2.9 */
 struct crt_query_id_ctxt {
-	struct create_context ccontext;
+	struct create_context_hdr ccontext;
 	__u8	Name[8];
 } __packed;
 
 struct crt_sd_ctxt {
-	struct create_context ccontext;
+	struct create_context_hdr ccontext;
 	__u8	Name[8];
 	struct smb3_sd sd;
 } __packed;
@@ -415,7 +415,7 @@ struct smb2_posix_info_parsed {
 };
 
 struct smb2_create_ea_ctx {
-	struct create_context ctx;
+	struct create_context_hdr ctx;
 	__u8 name[8];
 	struct smb2_file_full_ea_info ea;
 } __packed;
diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index 202ff91281560..8d10be1fe18a8 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1171,12 +1171,15 @@ struct smb2_server_client_notification {
 #define SMB2_CREATE_FLAG_REPARSEPOINT 0x01
 
 struct create_context {
-	__le32 Next;
-	__le16 NameOffset;
-	__le16 NameLength;
-	__le16 Reserved;
-	__le16 DataOffset;
-	__le32 DataLength;
+	/* New members must be added within the struct_group() macro below. */
+	__struct_group(create_context_hdr, hdr, __packed,
+		__le32 Next;
+		__le16 NameOffset;
+		__le16 NameLength;
+		__le16 Reserved;
+		__le16 DataOffset;
+		__le32 DataLength;
+	);
 	__u8 Buffer[];
 } __packed;
 
@@ -1222,7 +1225,7 @@ struct smb2_create_rsp {
 } __packed;
 
 struct create_posix {
-	struct create_context ccontext;
+	struct create_context_hdr ccontext;
 	__u8    Name[16];
 	__le32  Mode;
 	__u32   Reserved;
@@ -1230,7 +1233,7 @@ struct create_posix {
 
 /* See MS-SMB2 2.2.13.2.3 and MS-SMB2 2.2.13.2.4 */
 struct create_durable {
-	struct create_context ccontext;
+	struct create_context_hdr ccontext;
 	__u8   Name[8];
 	union {
 		__u8  Reserved[16];
@@ -1243,14 +1246,14 @@ struct create_durable {
 
 /* See MS-SMB2 2.2.13.2.5 */
 struct create_mxac_req {
-	struct create_context ccontext;
+	struct create_context_hdr ccontext;
 	__u8   Name[8];
 	__le64 Timestamp;
 } __packed;
 
 /* See MS-SMB2 2.2.14.2.5 */
 struct create_mxac_rsp {
-	struct create_context ccontext;
+	struct create_context_hdr ccontext;
 	__u8   Name[8];
 	__le32 QueryStatus;
 	__le32 MaximalAccess;
@@ -1286,13 +1289,13 @@ struct lease_context_v2 {
 } __packed;
 
 struct create_lease {
-	struct create_context ccontext;
+	struct create_context_hdr ccontext;
 	__u8   Name[8];
 	struct lease_context lcontext;
 } __packed;
 
 struct create_lease_v2 {
-	struct create_context ccontext;
+	struct create_context_hdr ccontext;
 	__u8   Name[8];
 	struct lease_context_v2 lcontext;
 	__u8   Pad[4];
@@ -1300,7 +1303,7 @@ struct create_lease_v2 {
 
 /* See MS-SMB2 2.2.14.2.9 */
 struct create_disk_id_rsp {
-	struct create_context ccontext;
+	struct create_context_hdr ccontext;
 	__u8   Name[8];
 	__le64 DiskFileId;
 	__le64 VolumeId;
@@ -1309,7 +1312,7 @@ struct create_disk_id_rsp {
 
 /* See MS-SMB2 2.2.13.2.13 */
 struct create_app_inst_id {
-	struct create_context ccontext;
+	struct create_context_hdr ccontext;
 	__u8 Name[16];
 	__le32 StructureSize; /* Must be 20 */
 	__u16 Reserved;
@@ -1318,7 +1321,7 @@ struct create_app_inst_id {
 
 /* See MS-SMB2 2.2.13.2.15 */
 struct create_app_inst_id_vers {
-	struct create_context ccontext;
+	struct create_context_hdr ccontext;
 	__u8 Name[16];
 	__le32 StructureSize; /* Must be 24 */
 	__u16 Reserved;
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index bd1d2a0e9203a..643f5e1cfe357 100644
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -64,7 +64,7 @@ struct preauth_integrity_info {
 #define SMB2_SESSION_TIMEOUT		(10 * HZ)
 
 struct create_durable_req_v2 {
-	struct create_context ccontext;
+	struct create_context_hdr ccontext;
 	__u8   Name[8];
 	__le32 Timeout;
 	__le32 Flags;
@@ -73,7 +73,7 @@ struct create_durable_req_v2 {
 } __packed;
 
 struct create_durable_reconn_req {
-	struct create_context ccontext;
+	struct create_context_hdr ccontext;
 	__u8   Name[8];
 	union {
 		__u8  Reserved[16];
@@ -85,7 +85,7 @@ struct create_durable_reconn_req {
 } __packed;
 
 struct create_durable_reconn_v2_req {
-	struct create_context ccontext;
+	struct create_context_hdr ccontext;
 	__u8   Name[8];
 	struct {
 		__u64 PersistentFileId;
@@ -96,13 +96,13 @@ struct create_durable_reconn_v2_req {
 } __packed;
 
 struct create_alloc_size_req {
-	struct create_context ccontext;
+	struct create_context_hdr ccontext;
 	__u8   Name[8];
 	__le64 AllocationSize;
 } __packed;
 
 struct create_durable_rsp {
-	struct create_context ccontext;
+	struct create_context_hdr ccontext;
 	__u8   Name[8];
 	union {
 		__u8  Reserved[8];
@@ -114,7 +114,7 @@ struct create_durable_rsp {
 /* Flags */
 #define SMB2_DHANDLE_FLAG_PERSISTENT	0x00000002
 struct create_durable_v2_rsp {
-	struct create_context ccontext;
+	struct create_context_hdr ccontext;
 	__u8   Name[8];
 	__le32 Timeout;
 	__le32 Flags;
@@ -122,7 +122,7 @@ struct create_durable_v2_rsp {
 
 /* equivalent of the contents of SMB3.1.1 POSIX open context response */
 struct create_posix_rsp {
-	struct create_context ccontext;
+	struct create_context_hdr ccontext;
 	__u8    Name[16];
 	__le32 nlink;
 	__le32 reparse_tag;
@@ -381,13 +381,13 @@ struct smb2_ea_info {
 } __packed; /* level 15 Query */
 
 struct create_ea_buf_req {
-	struct create_context ccontext;
+	struct create_context_hdr ccontext;
 	__u8   Name[8];
 	struct smb2_ea_info ea;
 } __packed;
 
 struct create_sd_buf_req {
-	struct create_context ccontext;
+	struct create_context_hdr ccontext;
 	__u8   Name[8];
 	struct smb_ntsd ntsd;
 } __packed;
-- 
2.43.0



