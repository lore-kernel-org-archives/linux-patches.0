Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027604;
	b=KOf7sIU12vYALn+c3z7aRbamP/NFt3lB7WciaV6Xgsh67KMle39rWjnE2sDlWTlZyrji
	 izC5N45qILlF1I+9sQ1OAkhHnaH+D8qoshmgbrjMXOTtrm+qfz2X5LIORP/jcyT5lIoCp
	 WVWNH2WoutC3x+xSJJgVqMRzpRYU28OtTBmoq3R0jDSrILPWWUa8Ur1J/omg2YJrO+lQE
	 /O8KHP+CxvfUgR6+aP68rsFnlwZJ/9SI0/YdSPpzwYEjyv+0gaUineoU7PDtce3TQB9vn
	 HcZTuh672Y2UJZYiGKZVx9/o4sTmhQn3qhABLMfbfY2DOosiV9KHJazcuIZ3jHT6JLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027604;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eVnxn+k924SUcw401O/E9JxCpfBUdvLJiBZwpvr6pb0=;
	b=LN0cNjZas5+agMNRBCmEUS/Ch1jXxYMbQmn5h3jYINVTjmb+yWUp541OBRVtloT1Lll7
	 A5B80NE86lT4lbgOCSMTKWPHWR37Jg3mkI9UNH5Ym9gx5QDgEjto2m5nqSUCiOJSnf7aT
	 cTPrG6ykcqkH/KSm/ryLMHqd4XXqdFgNpmhgAilaZNGXrmLXV+zybaGQuhuTgvUk+W4Up
	 qCr9itWULCDyoeUchz+Bf6KRfg2ZNlGKTL7WqgIQWnTdyuXzJU0URznmD9fHbJtKNfpzZ
	 7zRhULitCv4D1xJeS+mDXTdS72ErYoppUPokszPZ3BKHfQukCypnJvTOr9KcmTjB79w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NauB81jX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F85606A32A;
	Wed, 18 Nov 2026 18:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NauB81jX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E0A01F000C4;
	Wed, 18 Nov 2026 18:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027603;
	bh=eVnxn+k924SUcw401O/E9JxCpfBUdvLJiBZwpvr6pb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NauB81jXWzOXyIM48HZXcOuFP6uaz6V+69pme9AAAWDCU0fR05T4WgCLCNFapa3sW
	 RzFLUuSfgVSUJRCEPuq2MeAU7nJEa86eG+bNiEQuGEAeBrKNOg0uuB9Rj4Eot8dqoM
	 NFzt2LKGGRr6UWBvrIxzx276+MK/iqGOiqOj8hQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1848/2151] ksmbd: preserve open change time across rename
Date: Wed, 18 Nov 2026 15:59:43 +0100
Message-ID: <20261118150229.118257557@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 24dcee8305d6ba18c69594ca6fb42eaa32f8e63e ]

inode ctime is updated when a file is renamed. ksmbd returned that
ctime directly as SMB2 ChangeTime for handle-based query information.
This makes ChangeTime change after a rename through an already-open
handle, while Windows keeps the handle's ChangeTime stable for this
case.

Store the SMB ChangeTime in struct ksmbd_file when the handle is opened
and use that value for create, close, and handle-based query information
responses.  If a client explicitly sets FILE_BASIC_INFORMATION
ChangeTime, update the stored value as well.

This fixes smbtorture smb2.rename.simple_modtime, which expects
ChangeTime and LastWriteTime to remain unchanged after renaming an
already-open file.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: aad7d86a6651 ("ksmbd: round SetAllocation to the advertised allocation unit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c   | 23 ++++++++++-------------
 fs/smb/server/vfs_cache.h |  1 +
 2 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index d464334840727..0b8fc36bd559c 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3737,6 +3737,7 @@ int smb2_open(struct ksmbd_work *work)
 		fp->create_time = ksmbd_UnixTimeToNT(stat.btime);
 	else
 		fp->create_time = ksmbd_UnixTimeToNT(stat.ctime);
+	fp->change_time = ksmbd_UnixTimeToNT(stat.ctime);
 	if (req->FileAttributes || fp->f_ci->m_fattr == 0)
 		fp->f_ci->m_fattr =
 			cpu_to_le32(smb2_get_dos_mode(&stat, le32_to_cpu(req->FileAttributes)));
@@ -3786,8 +3787,7 @@ int smb2_open(struct ksmbd_work *work)
 	rsp->LastAccessTime = cpu_to_le64(time);
 	time = ksmbd_UnixTimeToNT(stat.mtime);
 	rsp->LastWriteTime = cpu_to_le64(time);
-	time = ksmbd_UnixTimeToNT(stat.ctime);
-	rsp->ChangeTime = cpu_to_le64(time);
+	rsp->ChangeTime = cpu_to_le64(fp->change_time);
 	rsp->AllocationSize = S_ISDIR(stat.mode) ? 0 :
 		cpu_to_le64(stat.blocks << 9);
 	rsp->EndofFile = S_ISDIR(stat.mode) ? 0 : cpu_to_le64(stat.size);
@@ -5057,8 +5057,7 @@ static int get_file_basic_info(struct smb2_query_info_rsp *rsp,
 	basic_info->LastAccessTime = cpu_to_le64(time);
 	time = ksmbd_UnixTimeToNT(stat.mtime);
 	basic_info->LastWriteTime = cpu_to_le64(time);
-	time = ksmbd_UnixTimeToNT(stat.ctime);
-	basic_info->ChangeTime = cpu_to_le64(time);
+	basic_info->ChangeTime = cpu_to_le64(fp->change_time);
 	basic_info->Attributes = fp->f_ci->m_fattr;
 	basic_info->Pad1 = 0;
 	rsp->OutputBufferLength =
@@ -5158,8 +5157,7 @@ static int get_file_all_info(struct ksmbd_work *work,
 	file_info->LastAccessTime = cpu_to_le64(time);
 	time = ksmbd_UnixTimeToNT(stat.mtime);
 	file_info->LastWriteTime = cpu_to_le64(time);
-	time = ksmbd_UnixTimeToNT(stat.ctime);
-	file_info->ChangeTime = cpu_to_le64(time);
+	file_info->ChangeTime = cpu_to_le64(fp->change_time);
 	file_info->Attributes = fp->f_ci->m_fattr;
 	file_info->Pad1 = 0;
 	if (ksmbd_stream_fd(fp) == false) {
@@ -5371,8 +5369,7 @@ static int get_file_network_open_info(struct smb2_query_info_rsp *rsp,
 	file_info->LastAccessTime = cpu_to_le64(time);
 	time = ksmbd_UnixTimeToNT(stat.mtime);
 	file_info->LastWriteTime = cpu_to_le64(time);
-	time = ksmbd_UnixTimeToNT(stat.ctime);
-	file_info->ChangeTime = cpu_to_le64(time);
+	file_info->ChangeTime = cpu_to_le64(fp->change_time);
 	file_info->Attributes = fp->f_ci->m_fattr;
 	if (ksmbd_stream_fd(fp) == false) {
 		file_info->AllocationSize = cpu_to_le64(stat.blocks << 9);
@@ -5498,8 +5495,7 @@ static int find_file_posix_info(struct smb2_query_info_rsp *rsp,
 	file_info->LastAccessTime = cpu_to_le64(time);
 	time = ksmbd_UnixTimeToNT(stat.mtime);
 	file_info->LastWriteTime = cpu_to_le64(time);
-	time = ksmbd_UnixTimeToNT(stat.ctime);
-	file_info->ChangeTime = cpu_to_le64(time);
+	file_info->ChangeTime = cpu_to_le64(fp->change_time);
 	file_info->DosAttributes = fp->f_ci->m_fattr;
 	file_info->Inode = cpu_to_le64(stat.ino);
 	if (ksmbd_stream_fd(fp) == false) {
@@ -6254,8 +6250,7 @@ int smb2_close(struct ksmbd_work *work)
 		rsp->LastAccessTime = cpu_to_le64(time);
 		time = ksmbd_UnixTimeToNT(stat.mtime);
 		rsp->LastWriteTime = cpu_to_le64(time);
-		time = ksmbd_UnixTimeToNT(stat.ctime);
-		rsp->ChangeTime = cpu_to_le64(time);
+		rsp->ChangeTime = cpu_to_le64(fp->change_time);
 		ksmbd_fd_put(work, fp);
 	} else {
 		rsp->Flags = 0;
@@ -6468,9 +6463,11 @@ static int set_file_basic_info(struct ksmbd_file *fp,
 		attrs.ia_valid |= (ATTR_ATIME | ATTR_ATIME_SET);
 	}
 
-	if (file_info->ChangeTime)
+	if (file_info->ChangeTime) {
+		fp->change_time = le64_to_cpu(file_info->ChangeTime);
 		inode_set_ctime_to_ts(inode,
 				ksmbd_NTtimeToUnix(file_info->ChangeTime));
+	}
 
 	if (file_info->LastWriteTime) {
 		attrs.ia_mtime = ksmbd_NTtimeToUnix(file_info->LastWriteTime);
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index 3801872409193..1530df617415e 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -101,6 +101,7 @@ struct ksmbd_file {
 	__le32				coption;
 	__le32				cdoption;
 	__u64				create_time;
+	__u64				change_time;
 	__u64				itime;
 
 	bool				is_nt_open;
-- 
2.53.0



