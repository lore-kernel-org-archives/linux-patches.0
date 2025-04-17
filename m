Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F551257ADB;
	Thu, 17 Apr 2025 17:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912497; cv=none; b=nDIIsiAYQh7GGI4+tu8C/yWCN9tXL9B9f+RgO+Z8kGwa/CjocdknL/q25WqA7pPH4HGqUOZ0H4eCCYDxK41GlTSGRZYSP8+EDidZJFib0Ve7ybqVdskaj1timr+9nQfrSurxsbl8yv5daOs6l7tMQ91NNK4Uong4+5jZQjYJfTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912497; c=relaxed/simple;
	bh=/8AhAUQLXRRVtSITZUOhKxQCFloGdCfpHIeh7mosxeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tEuOEbl0mavkXI0E5hk1sy3FF2HHJ/QDWk9k0ZyzILcJe53q8lH1YtsNuWUX/Crf/DL+k4U6HWdrRA6wQrMk0BAFd2wt/OEp6FN1P8JD18kbWkhbT8Hv8o1DbwMnB6RUeZGq/O5mEjLSz/4TQ9n4Jy/39fKd74pd75xnfGVQp+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UaQ/LZ8Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UaQ/LZ8Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A443BC4CEE4;
	Thu, 17 Apr 2025 17:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912497;
	bh=/8AhAUQLXRRVtSITZUOhKxQCFloGdCfpHIeh7mosxeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UaQ/LZ8ZDtg93YlFmgDpfe8h7mumEIdDbqulxkCrer/PNreYOVGI8urUea6P9/pWP
	 eMMc1wNG8r6YmjxN1opNLdfxSkBKANhLJVrDazxT59YR2jl6KfAxbyIv8feuLFcczO
	 fKRw2ZD56goXo4cA6vtVnHetIi+Rp94hBpUkaiBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 029/449] cifs: Fix support for WSL-style symlinks
Date: Thu, 17 Apr 2025 19:45:17 +0200
Message-ID: <20250417175119.172664431@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pali Rohár <pali@kernel.org>

[ Upstream commit c7efac7f1c71470ecd9b1a9a49b1b8164583c7dc ]

MS-FSCC in section 2.1.2.7 LX SYMLINK REPARSE_DATA_BUFFER now contains
documentation about WSL symlink reparse point buffers.

https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fscc/68337353-9153-4ee1-ac6b-419839c3b7ad

Fix the struct reparse_wsl_symlink_data_buffer to reflect buffer fields
according to the MS-FSCC documentation.

Fix the Linux SMB client to correctly fill the WSL symlink reparse point
buffer when creaing new WSL-style symlink. There was a mistake during
filling the data part of the reparse point buffer. It should starts with
bytes "\x02\x00\x00\x00" (which represents version 2) but this constant was
written as number 0x02000000 encoded in little endian, which resulted bytes
"\x00\x00\x00\x02". This change is fixing this mistake.

Fixes: 4e2043be5c14 ("cifs: Add support for creating WSL-style symlinks")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/reparse.c | 25 ++++++++++++++++---------
 fs/smb/common/smb2pdu.h |  6 +++---
 2 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 2b9e9885dc425..7a01f5def58fb 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -542,12 +542,12 @@ static int wsl_set_reparse_buf(struct reparse_data_buffer **buf,
 			kfree(symname_utf16);
 			return -ENOMEM;
 		}
-		/* Flag 0x02000000 is unknown, but all wsl symlinks have this value */
-		symlink_buf->Flags = cpu_to_le32(0x02000000);
-		/* PathBuffer is in UTF-8 but without trailing null-term byte */
+		/* Version field must be set to 2 (MS-FSCC 2.1.2.7) */
+		symlink_buf->Version = cpu_to_le32(2);
+		/* Target for Version 2 is in UTF-8 but without trailing null-term byte */
 		symname_utf8_len = utf16s_to_utf8s((wchar_t *)symname_utf16, symname_utf16_len/2,
 						   UTF16_LITTLE_ENDIAN,
-						   symlink_buf->PathBuffer,
+						   symlink_buf->Target,
 						   symname_utf8_maxlen);
 		*buf = (struct reparse_data_buffer *)symlink_buf;
 		buf_len = sizeof(struct reparse_wsl_symlink_data_buffer) + symname_utf8_len;
@@ -1016,29 +1016,36 @@ static int parse_reparse_wsl_symlink(struct reparse_wsl_symlink_data_buffer *buf
 				     struct cifs_open_info_data *data)
 {
 	int len = le16_to_cpu(buf->ReparseDataLength);
+	int data_offset = offsetof(typeof(*buf), Target) - offsetof(typeof(*buf), Version);
 	int symname_utf8_len;
 	__le16 *symname_utf16;
 	int symname_utf16_len;
 
-	if (len <= sizeof(buf->Flags)) {
+	if (len <= data_offset) {
 		cifs_dbg(VFS, "srv returned malformed wsl symlink buffer\n");
 		return -EIO;
 	}
 
-	/* PathBuffer is in UTF-8 but without trailing null-term byte */
-	symname_utf8_len = len - sizeof(buf->Flags);
+	/* MS-FSCC 2.1.2.7 defines layout of the Target field only for Version 2. */
+	if (le32_to_cpu(buf->Version) != 2) {
+		cifs_dbg(VFS, "srv returned unsupported wsl symlink version %u\n", le32_to_cpu(buf->Version));
+		return -EIO;
+	}
+
+	/* Target for Version 2 is in UTF-8 but without trailing null-term byte */
+	symname_utf8_len = len - data_offset;
 	/*
 	 * Check that buffer does not contain null byte
 	 * because Linux cannot process symlink with null byte.
 	 */
-	if (strnlen(buf->PathBuffer, symname_utf8_len) != symname_utf8_len) {
+	if (strnlen(buf->Target, symname_utf8_len) != symname_utf8_len) {
 		cifs_dbg(VFS, "srv returned null byte in wsl symlink target location\n");
 		return -EIO;
 	}
 	symname_utf16 = kzalloc(symname_utf8_len * 2, GFP_KERNEL);
 	if (!symname_utf16)
 		return -ENOMEM;
-	symname_utf16_len = utf8s_to_utf16s(buf->PathBuffer, symname_utf8_len,
+	symname_utf16_len = utf8s_to_utf16s(buf->Target, symname_utf8_len,
 					    UTF16_LITTLE_ENDIAN,
 					    (wchar_t *) symname_utf16, symname_utf8_len * 2);
 	if (symname_utf16_len < 0) {
diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index c7a0efda44036..12f0013334057 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1564,13 +1564,13 @@ struct reparse_nfs_data_buffer {
 	__u8	DataBuffer[];
 } __packed;
 
-/* For IO_REPARSE_TAG_LX_SYMLINK */
+/* For IO_REPARSE_TAG_LX_SYMLINK - see MS-FSCC 2.1.2.7 */
 struct reparse_wsl_symlink_data_buffer {
 	__le32	ReparseTag;
 	__le16	ReparseDataLength;
 	__u16	Reserved;
-	__le32	Flags;
-	__u8	PathBuffer[]; /* Variable Length UTF-8 string without nul-term */
+	__le32	Version; /* Always 2 */
+	__u8	Target[]; /* Variable Length UTF-8 string without nul-term */
 } __packed;
 
 struct validate_negotiate_info_req {
-- 
2.39.5



