Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027606;
	b=of6gA6xatb+terQey4A4pNu9c21txq83kmJsfZo8O7rU5BymP63r+no1my+tT29Gq++W
	 Zdbr4kTmYZSeGsEs12BQvuw6lCKlt8phzIsNNPTX8aLPuGxiRD22SoDuuzDKk6B8uFJn3
	 EggOZz+yLCnlqbcFJiureruiUxIta6lQEqzX31WAeHn6gpMIYiZeTcGqh800kmso4mEWz
	 gaXfHzoOGYFhAxAM//2Dr3ZXiYFwfzzeSohSOZfe4Qu6K7c1T148m5gtXmSY5rbALgm7D
	 YWHQuuoyVsyJXZpd450WYBMiGMsZH71scNhN+PGioBq0wBnRv4XArATmxM0DfJRT5iQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027606;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O1WDfGMb1YmhkOYfg7duM1zk2ysQedFDH353Cxy87TM=;
	b=GJ3ujLAUgddVa+Z8zQEpEiM4wxLK5sAFJUgzOhHjNSPIvcB9vt7dLEx/uvr8VvIDgtIb
	 LhCvEOMPGOS6p5Bk+ZhPd01Qk181oRY98Td9FT1JMxjApwG1YNVtVAD4IRbZ8IgavdD67
	 uzUIBL6N20SqjcmdBk4D/pttTwNfHoNhGGwI7yXl++PS0DaQXJsuoD6cZRyy2u3Z4MTCe
	 5C8oyqdER8NOErzpjNZM9dJ3cHNUnZ9SGiUYXkMlr1QFT7KZlp2tXC2h2hEhnxcUA7EeL
	 Cb8Xgx8rnEEcEYrAqDkxzzlDe+mR53PxcIOg15jVoRcD6GKC4kST2/qRibjJXV37OUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1mergMXS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA396606A331;
	Wed, 18 Nov 2026 18:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1mergMXS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 375531F000C4;
	Wed, 18 Nov 2026 18:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027606;
	bh=O1WDfGMb1YmhkOYfg7duM1zk2ysQedFDH353Cxy87TM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1mergMXSHO66oDdB7HP1J1TwQZcVOgZyWo4mxpNp65EUwTfttRlpVqSItwDPsffuS
	 3p+AhczPG5ujC5bLLYXb+kbeqtJGihBOzzCqII5TQgyYZzuOnNDrb2qIcgH9Q0vWek
	 1ZJbWDF99K8JN//I+G310oy4r3Loii2uw9pexRic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1849/2151] ksmbd: return requested create allocation size
Date: Wed, 18 Nov 2026 15:59:44 +0100
Message-ID: <20261118150229.154139117@linuxfoundation.org>
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

[ Upstream commit 3b41d8b05dc89b1f3c53ca7f1a084c7c93712ebf ]

smb2.create.blob sends an SMB2_CREATE_ALLOCATION_SIZE create context with
a 1MiB allocation size and expects the create response AllocationSize field
to match the requested size.  smb2.create.open additionally compares the
AllocationSize returned in the CREATE response with the AllocationSize
returned by FILE_ALL_INFORMATION on the same handle.

ksmbd applies the allocation with fallocate(), but then fills both the
create response and handle-based information from stat.blocks << 9.  On
filesystems such as ext4 this can include filesystem allocation rounding
and metadata effects, causing a response larger than the SMB2 allocation
size context and a disagreement between the two queries.

Remember the requested allocation size while processing the create context,
store the reported allocation size in struct ksmbd_file, and use it for
both the create response and handle-based allocation size responses. Update
the stored value when FILE_ALLOCATION_INFORMATION changes it, and fall back
to stat.blocks << 9 when no allocation size context was provided.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: aad7d86a6651 ("ksmbd: round SetAllocation to the advertised allocation unit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c   | 34 +++++++++++++++++++++++-----------
 fs/smb/server/vfs_cache.h |  1 +
 2 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 0b8fc36bd559c..9a63dd0df84d5 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2999,7 +2999,7 @@ int smb2_open(struct ksmbd_work *work)
 	char *stream_name = NULL;
 	bool file_present = false, created = false, already_permitted = false;
 	int share_ret, need_truncate = 0;
-	u64 time;
+	u64 time, alloc_size = 0;
 	umode_t posix_mode = 0;
 	__le32 daccess, maximal_access = 0;
 	int iov_len = 0;
@@ -3679,7 +3679,6 @@ int smb2_open(struct ksmbd_work *work)
 			rc = PTR_ERR(az_req);
 			goto err_out1;
 		} else if (az_req) {
-			loff_t alloc_size;
 			int err;
 
 			if (le16_to_cpu(az_req->ccontext.DataOffset) +
@@ -3738,6 +3737,8 @@ int smb2_open(struct ksmbd_work *work)
 	else
 		fp->create_time = ksmbd_UnixTimeToNT(stat.ctime);
 	fp->change_time = ksmbd_UnixTimeToNT(stat.ctime);
+	fp->allocation_size = S_ISDIR(stat.mode) ? 0 :
+		(alloc_size ?: stat.blocks << 9);
 	if (req->FileAttributes || fp->f_ci->m_fattr == 0)
 		fp->f_ci->m_fattr =
 			cpu_to_le32(smb2_get_dos_mode(&stat, le32_to_cpu(req->FileAttributes)));
@@ -3788,8 +3789,19 @@ int smb2_open(struct ksmbd_work *work)
 	time = ksmbd_UnixTimeToNT(stat.mtime);
 	rsp->LastWriteTime = cpu_to_le64(time);
 	rsp->ChangeTime = cpu_to_le64(fp->change_time);
-	rsp->AllocationSize = S_ISDIR(stat.mode) ? 0 :
-		cpu_to_le64(stat.blocks << 9);
+	/*
+	 * The cached allocation size hides filesystem rounding for the
+	 * requested allocation, but it can go stale when the file grows past
+	 * it via writes (e.g. across a durable reconnect). Refresh it once the
+	 * file exceeds the cached value, rounding the end of file up to the
+	 * volume allocation unit (the filesystem block size, matching the
+	 * SectorsPerAllocationUnit/BytesPerSector ksmbd advertises) rather than
+	 * using the raw on-disk block count, which can include filesystem
+	 * preallocation and metadata rounding.
+	 */
+	if (!S_ISDIR(stat.mode) && stat.size > fp->allocation_size)
+		fp->allocation_size = round_up(stat.size, stat.blksize);
+	rsp->AllocationSize = cpu_to_le64(fp->allocation_size);
 	rsp->EndofFile = S_ISDIR(stat.mode) ? 0 : cpu_to_le64(stat.size);
 	rsp->FileAttributes = fp->f_ci->m_fattr;
 
@@ -5082,7 +5094,7 @@ static int get_file_standard_info(struct smb2_query_info_rsp *rsp,
 	delete_pending = ksmbd_inode_pending_delete(fp);
 
 	if (ksmbd_stream_fd(fp) == false) {
-		sinfo->AllocationSize = cpu_to_le64(stat.blocks << 9);
+		sinfo->AllocationSize = cpu_to_le64(fp->allocation_size);
 		sinfo->EndOfFile = S_ISDIR(stat.mode) ? 0 : cpu_to_le64(stat.size);
 	} else {
 		sinfo->AllocationSize = cpu_to_le64(fp->stream.size);
@@ -5161,8 +5173,7 @@ static int get_file_all_info(struct ksmbd_work *work,
 	file_info->Attributes = fp->f_ci->m_fattr;
 	file_info->Pad1 = 0;
 	if (ksmbd_stream_fd(fp) == false) {
-		file_info->AllocationSize =
-			cpu_to_le64(stat.blocks << 9);
+		file_info->AllocationSize = cpu_to_le64(fp->allocation_size);
 		file_info->EndOfFile = S_ISDIR(stat.mode) ? 0 : cpu_to_le64(stat.size);
 	} else {
 		file_info->AllocationSize = cpu_to_le64(fp->stream.size);
@@ -5372,7 +5383,7 @@ static int get_file_network_open_info(struct smb2_query_info_rsp *rsp,
 	file_info->ChangeTime = cpu_to_le64(fp->change_time);
 	file_info->Attributes = fp->f_ci->m_fattr;
 	if (ksmbd_stream_fd(fp) == false) {
-		file_info->AllocationSize = cpu_to_le64(stat.blocks << 9);
+		file_info->AllocationSize = cpu_to_le64(fp->allocation_size);
 		file_info->EndOfFile = S_ISDIR(stat.mode) ? 0 : cpu_to_le64(stat.size);
 	} else {
 		file_info->AllocationSize = cpu_to_le64(fp->stream.size);
@@ -5500,7 +5511,7 @@ static int find_file_posix_info(struct smb2_query_info_rsp *rsp,
 	file_info->Inode = cpu_to_le64(stat.ino);
 	if (ksmbd_stream_fd(fp) == false) {
 		file_info->EndOfFile = cpu_to_le64(stat.size);
-		file_info->AllocationSize = cpu_to_le64(stat.blocks << 9);
+		file_info->AllocationSize = cpu_to_le64(fp->allocation_size);
 	} else {
 		file_info->EndOfFile = cpu_to_le64(fp->stream.size);
 		file_info->AllocationSize = cpu_to_le64(fp->stream.size);
@@ -6241,8 +6252,7 @@ int smb2_close(struct ksmbd_work *work)
 		}
 
 		rsp->Flags = SMB2_CLOSE_FLAG_POSTQUERY_ATTRIB;
-		rsp->AllocationSize = S_ISDIR(stat.mode) ? 0 :
-			cpu_to_le64(stat.blocks << 9);
+		rsp->AllocationSize = cpu_to_le64(fp->allocation_size);
 		rsp->EndOfFile = cpu_to_le64(stat.size);
 		rsp->Attributes = fp->f_ci->m_fattr;
 		rsp->CreationTime = cpu_to_le64(fp->create_time);
@@ -6581,6 +6591,8 @@ static int set_file_allocation_info(struct ksmbd_work *work,
 			return rc;
 		}
 	}
+
+	fp->allocation_size = le64_to_cpu(file_alloc_info->AllocationSize);
 	return 0;
 }
 
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index 1530df617415e..7cfdc1140560c 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -102,6 +102,7 @@ struct ksmbd_file {
 	__le32				cdoption;
 	__u64				create_time;
 	__u64				change_time;
+	__u64				allocation_size;
 	__u64				itime;
 
 	bool				is_nt_open;
-- 
2.53.0



