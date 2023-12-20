Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DEC04A9B9;
	Wed, 20 Dec 2023 16:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gvHXVMon"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6160C433C8;
	Wed, 20 Dec 2023 16:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088774;
	bh=eaRUTaisZQf2NcOeACVxlBJeYDKyvC0cJTg6zvkEIaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gvHXVMondGErSz2cWbZMbj+keZv3DlrPirj/TwO01zf06FUFeNEVIKj7yCFuXQesL
	 DfMHTi51tr8/99DKme+9Bg5EGyHd2P/7XtiofQbb1wD6yoh9WBsUHR3KM5mYQ1KMoZ
	 Lw5b87JToQRq1Y6OcC+qV32NCsgFEoagoEV450TQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 053/159] ksmbd: change security id to the one samba used for posix extension
Date: Wed, 20 Dec 2023 17:08:38 +0100
Message-ID: <20231220160933.809330880@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160931.251686445@linuxfoundation.org>
References: <20231220160931.251686445@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 5609bdd9ffdccd83f9003511b1801584b703baa5 ]

Samba set SIDOWNER and SIDUNIX_GROUP in create posix context and
set SIDUNIX_USER/GROUP in other sids for posix extension.
This patch change security id to the one samba used.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/oplock.c  |   17 ++++++++++++++---
 fs/ksmbd/smb2pdu.c |    9 +++++++--
 fs/ksmbd/smb2pdu.h |    6 ++++--
 3 files changed, 25 insertions(+), 7 deletions(-)

--- a/fs/ksmbd/oplock.c
+++ b/fs/ksmbd/oplock.c
@@ -1615,7 +1615,11 @@ void create_posix_rsp_buf(char *cc, stru
 	memset(buf, 0, sizeof(struct create_posix_rsp));
 	buf->ccontext.DataOffset = cpu_to_le16(offsetof
 			(struct create_posix_rsp, nlink));
-	buf->ccontext.DataLength = cpu_to_le32(52);
+	/*
+	 * DataLength = nlink(4) + reparse_tag(4) + mode(4) +
+	 * domain sid(28) + unix group sid(16).
+	 */
+	buf->ccontext.DataLength = cpu_to_le32(56);
 	buf->ccontext.NameOffset = cpu_to_le16(offsetof
 			(struct create_posix_rsp, Name));
 	buf->ccontext.NameLength = cpu_to_le16(POSIX_CTXT_DATA_LEN);
@@ -1640,12 +1644,19 @@ void create_posix_rsp_buf(char *cc, stru
 	buf->nlink = cpu_to_le32(inode->i_nlink);
 	buf->reparse_tag = cpu_to_le32(fp->volatile_id);
 	buf->mode = cpu_to_le32(inode->i_mode);
+	/*
+	 * SidBuffer(44) contain two sids(Domain sid(28), UNIX group sid(16)).
+	 * Domain sid(28) = revision(1) + num_subauth(1) + authority(6) +
+	 *		    sub_auth(4 * 4(num_subauth)) + RID(4).
+	 * UNIX group id(16) = revision(1) + num_subauth(1) + authority(6) +
+	 *		       sub_auth(4 * 1(num_subauth)) + RID(4).
+	 */
 	id_to_sid(from_kuid_munged(&init_user_ns,
 				   i_uid_into_mnt(user_ns, inode)),
-		  SIDNFS_USER, (struct smb_sid *)&buf->SidBuffer[0]);
+		  SIDOWNER, (struct smb_sid *)&buf->SidBuffer[0]);
 	id_to_sid(from_kgid_munged(&init_user_ns,
 				   i_gid_into_mnt(user_ns, inode)),
-		  SIDNFS_GROUP, (struct smb_sid *)&buf->SidBuffer[20]);
+		  SIDUNIX_GROUP, (struct smb_sid *)&buf->SidBuffer[28]);
 }
 
 /*
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -3619,10 +3619,15 @@ static int smb2_populate_readdir_entry(s
 			S_ISDIR(ksmbd_kstat->kstat->mode) ? ATTR_DIRECTORY_LE : ATTR_ARCHIVE_LE;
 		if (d_info->hide_dot_file && d_info->name[0] == '.')
 			posix_info->DosAttributes |= ATTR_HIDDEN_LE;
+		/*
+		 * SidBuffer(32) contain two sids(Domain sid(16), UNIX group sid(16)).
+		 * UNIX sid(16) = revision(1) + num_subauth(1) + authority(6) +
+		 *		  sub_auth(4 * 1(num_subauth)) + RID(4).
+		 */
 		id_to_sid(from_kuid_munged(&init_user_ns, ksmbd_kstat->kstat->uid),
-			  SIDNFS_USER, (struct smb_sid *)&posix_info->SidBuffer[0]);
+			  SIDUNIX_USER, (struct smb_sid *)&posix_info->SidBuffer[0]);
 		id_to_sid(from_kgid_munged(&init_user_ns, ksmbd_kstat->kstat->gid),
-			  SIDNFS_GROUP, (struct smb_sid *)&posix_info->SidBuffer[20]);
+			  SIDUNIX_GROUP, (struct smb_sid *)&posix_info->SidBuffer[16]);
 		memcpy(posix_info->name, conv_name, conv_len);
 		posix_info->name_len = cpu_to_le32(conv_len);
 		posix_info->NextEntryOffset = cpu_to_le32(next_entry_offset);
--- a/fs/ksmbd/smb2pdu.h
+++ b/fs/ksmbd/smb2pdu.h
@@ -724,7 +724,8 @@ struct create_posix_rsp {
 	__le32 nlink;
 	__le32 reparse_tag;
 	__le32 mode;
-	u8 SidBuffer[40];
+	/* SidBuffer contain two sids(Domain sid(28), UNIX group sid(16)) */
+	u8 SidBuffer[44];
 } __packed;
 
 #define SMB2_LEASE_NONE_LE			cpu_to_le32(0x00)
@@ -1617,7 +1618,8 @@ struct smb2_posix_info {
 	__le32 HardLinks;
 	__le32 ReparseTag;
 	__le32 Mode;
-	u8 SidBuffer[40];
+	/* SidBuffer contain two sids (UNIX user sid(16), UNIX group sid(16)) */
+	u8 SidBuffer[32];
 	__le32 name_len;
 	u8 name[1];
 	/*


