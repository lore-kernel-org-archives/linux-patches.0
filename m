Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49A23A8753;
	Sat, 17 Oct 2026 18:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260366; cv=none; b=iOnkEWRtTmOe6/9hpkZi/ls/RkEo3aKt2tuhONBxYw+hJyPUeJ8Qhl4DWgJMzr8ovbP0jLbmTTpoEvHkdKxcHaE13VckUyubfmhxrHuGRV9j6tkX4lKj2kMWjQqkzNTZyxBN4eOWt05UYM5LkVjWvDjR00u0Xvc9Cz94+SirdtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260366; c=relaxed/simple;
	bh=K8AVZCL62dz+CG3ARirhbK0BN38MOVzPX6pR74ZrC/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=seby9jxCAEU2UlGGtOorj0Sw9vR428NLaHv69WnfimrfIksL9FHFnAH1+9GcT7WJRamx2IL6c8m1nXXQFzs8GAymwIlRkeHNFNXqLXvcQK1zF4cHUXQBHYYkqa080XX095nbDYhegSvslzU6TM6hPU+M1vtlF4qHMQnt93s7gls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V6du9LR5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V6du9LR5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 534181F000C4;
	Sat, 17 Oct 2026 18:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260365;
	bh=Sy2UAVwmnUhCl1hxxGwVfsUGkhNq2diiPiSE6kfFK1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V6du9LR5z5O4371YxVfmISsAygVqEMDYYcMbubaMtE3w/hreaUQ0LlgF67Vi3RPDW
	 +Mhd26udSR5vyo4HS3K1h97MKv6tk9e+uqgQ4n6igwzKTGWL1BFFBJCiEX75rMcsKc
	 0xiZufMgzb5zLP8IJbKt3oMvyQHc9a2uhIBf7Bio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1521/1674] smb/client: zero-initialize stack-allocated cifs_open_info_data
Date: Sat, 17 Oct 2026 18:03:13 +0200
Message-ID: <20261017160510.161143636@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

[ Upstream commit 8fce4cf4369c766a3293a05419500cbfde72e60d ]

Stack-allocated cifs_open_info_data may contain random data.
This can make some fields have wrong value if they are not set later.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/link.c    | 2 +-
 fs/smb/client/smb1ops.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/link.c b/fs/smb/client/link.c
index 221585e846c1f..a8664328701e8 100644
--- a/fs/smb/client/link.c
+++ b/fs/smb/client/link.c
@@ -257,7 +257,7 @@ cifs_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 	struct cifs_open_parms oparms;
 	struct cifs_io_parms io_parms = {0};
 	int buf_type = CIFS_NO_BUFFER;
-	struct cifs_open_info_data query_data;
+	struct cifs_open_info_data query_data = {};
 
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index ef71c0eb8704a..c43b75128e0c8 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -990,7 +990,7 @@ smb_set_file_info(struct inode *inode, const char *full_path,
 	struct cifs_open_parms oparms;
 	struct cifsFileInfo *open_file;
 	FILE_BASIC_INFO new_buf;
-	struct cifs_open_info_data query_data;
+	struct cifs_open_info_data query_data = {};
 	__le64 write_time = buf->LastWriteTime;
 	struct cifsInodeInfo *cinode = CIFS_I(inode);
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
-- 
2.53.0



