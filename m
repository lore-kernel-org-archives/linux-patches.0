Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20060248BD0;
	Wed, 15 Jan 2025 10:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938695; cv=none; b=pXfwJD7Uw/CLooeeO3Bphsuil8Hl8k7GHSmTqRW60782JEyqet9n9vFVpquxmEWwE6XZFQHkw2esc/hGz1+I3e5phJKZ03xxN6vF9KuJQd3FY0HUqzgeyW/wFKI8m6VQ9PHqgZnY8v53NKKwYGYPUprtCMht//xqSWwXXeSZTZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938695; c=relaxed/simple;
	bh=c+kFFr2v3aID+t63o403I7SFHM8URDNQ+Fe0BTb/x6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BGtbjGIQivu16GLLjUBt8T2srNxsLbKAgV3BXvUdzcPVgSYNNgnoSvDjgxng9krGdbzj7SH2wCYB7hd6O1Oo93fsf9f8NxYunVhUKX2FqXpWpWbmF4xZbB3278/HrED46p71UqLGaSzDFieshiac1JFDoS3q92QsF8ak4UNFeIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fnJtEe4d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fnJtEe4d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BEB2C4CEDF;
	Wed, 15 Jan 2025 10:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938693;
	bh=c+kFFr2v3aID+t63o403I7SFHM8URDNQ+Fe0BTb/x6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fnJtEe4dA23NdrMJrrAQi0sP9nsQah0HN5TCDZdzvob1p3tbhMUrPN26UUgQkxcIV
	 0iC1+0e+P+xva5bjmeTZGX3dxUmqvKXsTuELk1GlZs3lDvzIL0etgv05TAgo1NkX4Y
	 cRRPJij+LZ1QI1iLU74qSrcvR1bpp93elOPbzoMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 067/129] ksmbd: Implement new SMB3 POSIX type
Date: Wed, 15 Jan 2025 11:37:22 +0100
Message-ID: <20250115103557.051304741@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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

commit e8580b4c600e085b3c8e6404392de2f822d4c132 upstream.

As SMB3 posix extension specification, Give posix file type to posix
mode.

https://www.samba.org/~slow/SMB3_POSIX/fscc_posix_extensions.html#posix-file-type-definition

Cc: stable@vger.kernel.org
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |   40 ++++++++++++++++++++++++++++++++++++++++
 fs/smb/server/smb2pdu.h |   10 ++++++++++
 2 files changed, 50 insertions(+)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3989,6 +3989,26 @@ static int smb2_populate_readdir_entry(s
 		posix_info->DeviceId = cpu_to_le32(ksmbd_kstat->kstat->rdev);
 		posix_info->HardLinks = cpu_to_le32(ksmbd_kstat->kstat->nlink);
 		posix_info->Mode = cpu_to_le32(ksmbd_kstat->kstat->mode & 0777);
+		switch (ksmbd_kstat->kstat->mode & S_IFMT) {
+		case S_IFDIR:
+			posix_info->Mode |= cpu_to_le32(POSIX_TYPE_DIR << POSIX_FILETYPE_SHIFT);
+			break;
+		case S_IFLNK:
+			posix_info->Mode |= cpu_to_le32(POSIX_TYPE_SYMLINK << POSIX_FILETYPE_SHIFT);
+			break;
+		case S_IFCHR:
+			posix_info->Mode |= cpu_to_le32(POSIX_TYPE_CHARDEV << POSIX_FILETYPE_SHIFT);
+			break;
+		case S_IFBLK:
+			posix_info->Mode |= cpu_to_le32(POSIX_TYPE_BLKDEV << POSIX_FILETYPE_SHIFT);
+			break;
+		case S_IFIFO:
+			posix_info->Mode |= cpu_to_le32(POSIX_TYPE_FIFO << POSIX_FILETYPE_SHIFT);
+			break;
+		case S_IFSOCK:
+			posix_info->Mode |= cpu_to_le32(POSIX_TYPE_SOCKET << POSIX_FILETYPE_SHIFT);
+		}
+
 		posix_info->Inode = cpu_to_le64(ksmbd_kstat->kstat->ino);
 		posix_info->DosAttributes =
 			S_ISDIR(ksmbd_kstat->kstat->mode) ?
@@ -5177,6 +5197,26 @@ static int find_file_posix_info(struct s
 	file_info->AllocationSize = cpu_to_le64(stat.blocks << 9);
 	file_info->HardLinks = cpu_to_le32(stat.nlink);
 	file_info->Mode = cpu_to_le32(stat.mode & 0777);
+	switch (stat.mode & S_IFMT) {
+	case S_IFDIR:
+		file_info->Mode |= cpu_to_le32(POSIX_TYPE_DIR << POSIX_FILETYPE_SHIFT);
+		break;
+	case S_IFLNK:
+		file_info->Mode |= cpu_to_le32(POSIX_TYPE_SYMLINK << POSIX_FILETYPE_SHIFT);
+		break;
+	case S_IFCHR:
+		file_info->Mode |= cpu_to_le32(POSIX_TYPE_CHARDEV << POSIX_FILETYPE_SHIFT);
+		break;
+	case S_IFBLK:
+		file_info->Mode |= cpu_to_le32(POSIX_TYPE_BLKDEV << POSIX_FILETYPE_SHIFT);
+		break;
+	case S_IFIFO:
+		file_info->Mode |= cpu_to_le32(POSIX_TYPE_FIFO << POSIX_FILETYPE_SHIFT);
+		break;
+	case S_IFSOCK:
+		file_info->Mode |= cpu_to_le32(POSIX_TYPE_SOCKET << POSIX_FILETYPE_SHIFT);
+	}
+
 	file_info->DeviceId = cpu_to_le32(stat.rdev);
 
 	/*
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -500,4 +500,14 @@ static inline void *smb2_get_msg(void *b
 	return buf + 4;
 }
 
+#define POSIX_TYPE_FILE		0
+#define POSIX_TYPE_DIR		1
+#define POSIX_TYPE_SYMLINK	2
+#define POSIX_TYPE_CHARDEV	3
+#define POSIX_TYPE_BLKDEV	4
+#define POSIX_TYPE_FIFO		5
+#define POSIX_TYPE_SOCKET	6
+
+#define POSIX_FILETYPE_SHIFT	12
+
 #endif	/* _SMB2PDU_H */


