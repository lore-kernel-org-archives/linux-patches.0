Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045EC4CB49;
	Wed, 20 Dec 2023 16:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hb58E7vD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C785C433C7;
	Wed, 20 Dec 2023 16:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088776;
	bh=oIO+Lo+KMmHnpXjeTIPctpJnCctaxsxedpaKefw74Qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hb58E7vDhKJla//ZYEQcxUmRfpfyhmXEcmb7BPuu6NlTLc1cth8iIFF3ef+Bn/H+i
	 aWBoohObYnEOr1DwbQGhr5rhJDOPB+SBYIwA0BNm8FSGRJZAUFjbrOURULkXMJUnRX
	 pVqlsySqtsHAvDvPVDz6fz5Y3WtDZd2BJ2RSKyDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 054/159] ksmbd: set file permission mode to match Samba server posix extension behavior
Date: Wed, 20 Dec 2023 17:08:39 +0100
Message-ID: <20231220160933.858952040@linuxfoundation.org>
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

[ Upstream commit f6c2b201da7588f7f7688ddc99b7bb000609129c ]

Set file permission mode to match Samba server posix extension behavior.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/oplock.c  |    2 +-
 fs/ksmbd/smb2pdu.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/fs/ksmbd/oplock.c
+++ b/fs/ksmbd/oplock.c
@@ -1643,7 +1643,7 @@ void create_posix_rsp_buf(char *cc, stru
 
 	buf->nlink = cpu_to_le32(inode->i_nlink);
 	buf->reparse_tag = cpu_to_le32(fp->volatile_id);
-	buf->mode = cpu_to_le32(inode->i_mode);
+	buf->mode = cpu_to_le32(inode->i_mode & 0777);
 	/*
 	 * SidBuffer(44) contain two sids(Domain sid(28), UNIX group sid(16)).
 	 * Domain sid(28) = revision(1) + num_subauth(1) + authority(6) +
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -3613,7 +3613,7 @@ static int smb2_populate_readdir_entry(s
 		posix_info->AllocationSize = cpu_to_le64(ksmbd_kstat->kstat->blocks << 9);
 		posix_info->DeviceId = cpu_to_le32(ksmbd_kstat->kstat->rdev);
 		posix_info->HardLinks = cpu_to_le32(ksmbd_kstat->kstat->nlink);
-		posix_info->Mode = cpu_to_le32(ksmbd_kstat->kstat->mode);
+		posix_info->Mode = cpu_to_le32(ksmbd_kstat->kstat->mode & 0777);
 		posix_info->Inode = cpu_to_le64(ksmbd_kstat->kstat->ino);
 		posix_info->DosAttributes =
 			S_ISDIR(ksmbd_kstat->kstat->mode) ? ATTR_DIRECTORY_LE : ATTR_ARCHIVE_LE;
@@ -4769,7 +4769,7 @@ static int find_file_posix_info(struct s
 	file_info->EndOfFile = cpu_to_le64(inode->i_size);
 	file_info->AllocationSize = cpu_to_le64(inode->i_blocks << 9);
 	file_info->HardLinks = cpu_to_le32(inode->i_nlink);
-	file_info->Mode = cpu_to_le32(inode->i_mode);
+	file_info->Mode = cpu_to_le32(inode->i_mode & 0777);
 	file_info->DeviceId = cpu_to_le32(inode->i_rdev);
 	rsp->OutputBufferLength =
 		cpu_to_le32(sizeof(struct smb311_posix_qinfo));


