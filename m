Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E824C1BDE9;
	Wed,  3 Jan 2024 16:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BHj+zLeN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD83FC433C7;
	Wed,  3 Jan 2024 16:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704300988;
	bh=0ukWPjaB+wF0Ag6BO8cBAWuSZrGq0GmjcV4w9EtIAG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BHj+zLeNqxt1ylMI7bPHiQfyN9MGrSsGWa8xuKgh51qkOFHKS/hsrgD3mcN3JWDJW
	 dtj1lskN7N+xwgl31k+4PloFFGkvLFOtmZjg+kcBWm2OtT01qp8J3pQaqhgt7eeGrI
	 oFdZ8IRtc4700EILhYmObknKevuNpu6UI4++L/YU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 001/100] ksmbd: replace one-element arrays with flexible-array members
Date: Wed,  3 Jan 2024 17:53:50 +0100
Message-ID: <20240103164856.399893922@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164856.169912722@linuxfoundation.org>
References: <20240103164856.169912722@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gustavo A. R. Silva <gustavoars@kernel.org>

[ Upstream commit d272e01fa0a2f15c5c331a37cd99c6875c7b7186 ]

One-element arrays are deprecated, and we are replacing them with flexible
array members instead. So, replace one-element arrays with flexible-array
members in multiple structs in fs/ksmbd/smb_common.h and one in
fs/ksmbd/smb2pdu.h.

Important to mention is that doing a build before/after this patch results
in no binary output differences.

This helps with the ongoing efforts to tighten the FORTIFY_SOURCE routines
on memcpy() and help us make progress towards globally enabling
-fstrict-flex-arrays=3 [1].

Link: https://github.com/KSPP/linux/issues/242
Link: https://github.com/KSPP/linux/issues/79
Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [1]
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/Y3OxronfaPYv9qGP@work
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c    |  4 ++--
 fs/smb/server/smb2pdu.h    |  2 +-
 fs/smb/server/smb_common.h | 12 ++++++------
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 1598ad6155fef..3f4f6b0385655 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3525,7 +3525,7 @@ static int smb2_populate_readdir_entry(struct ksmbd_conn *conn, int info_level,
 		goto free_conv_name;
 	}
 
-	struct_sz = readdir_info_level_struct_sz(info_level) - 1 + conv_len;
+	struct_sz = readdir_info_level_struct_sz(info_level) + conv_len;
 	next_entry_offset = ALIGN(struct_sz, KSMBD_DIR_INFO_ALIGNMENT);
 	d_info->last_entry_off_align = next_entry_offset - struct_sz;
 
@@ -3777,7 +3777,7 @@ static int reserve_populate_dentry(struct ksmbd_dir_info *d_info,
 		return -EOPNOTSUPP;
 
 	conv_len = (d_info->name_len + 1) * 2;
-	next_entry_offset = ALIGN(struct_sz - 1 + conv_len,
+	next_entry_offset = ALIGN(struct_sz + conv_len,
 				  KSMBD_DIR_INFO_ALIGNMENT);
 
 	if (next_entry_offset > d_info->out_buf_len) {
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index 665a837378540..f13bd65993ccc 100644
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -446,7 +446,7 @@ struct smb2_posix_info {
 	/* SidBuffer contain two sids (UNIX user sid(16), UNIX group sid(16)) */
 	u8 SidBuffer[32];
 	__le32 name_len;
-	u8 name[1];
+	u8 name[];
 	/*
 	 * var sized owner SID
 	 * var sized group SID
diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index 1cbb492cdefec..f0134d16067fb 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -263,14 +263,14 @@ struct file_directory_info {
 	__le64 AllocationSize;
 	__le32 ExtFileAttributes;
 	__le32 FileNameLength;
-	char FileName[1];
+	char FileName[];
 } __packed;   /* level 0x101 FF resp data */
 
 struct file_names_info {
 	__le32 NextEntryOffset;
 	__u32 FileIndex;
 	__le32 FileNameLength;
-	char FileName[1];
+	char FileName[];
 } __packed;   /* level 0xc FF resp data */
 
 struct file_full_directory_info {
@@ -285,7 +285,7 @@ struct file_full_directory_info {
 	__le32 ExtFileAttributes;
 	__le32 FileNameLength;
 	__le32 EaSize;
-	char FileName[1];
+	char FileName[];
 } __packed; /* level 0x102 FF resp */
 
 struct file_both_directory_info {
@@ -303,7 +303,7 @@ struct file_both_directory_info {
 	__u8   ShortNameLength;
 	__u8   Reserved;
 	__u8   ShortName[24];
-	char FileName[1];
+	char FileName[];
 } __packed; /* level 0x104 FFrsp data */
 
 struct file_id_both_directory_info {
@@ -323,7 +323,7 @@ struct file_id_both_directory_info {
 	__u8   ShortName[24];
 	__le16 Reserved2;
 	__le64 UniqueId;
-	char FileName[1];
+	char FileName[];
 } __packed;
 
 struct file_id_full_dir_info {
@@ -340,7 +340,7 @@ struct file_id_full_dir_info {
 	__le32 EaSize; /* EA size */
 	__le32 Reserved;
 	__le64 UniqueId; /* inode num - le since Samba puts ino in low 32 bit*/
-	char FileName[1];
+	char FileName[];
 } __packed; /* level 0x105 FF rsp data */
 
 struct smb_version_values {
-- 
2.43.0



