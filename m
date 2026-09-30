Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4CF518133;
	Wed, 30 Sep 2026 16:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784629; cv=none; b=TROmymomewcl09FwEbpcKzC+iKPtvKMPUOJqL23oH8gTdzVKgVPGTAdwloufMSSfUPWZVD7Do+vEFE6kl3BkO5ZDnIBbcj2XKRcIBf/AJQVWPATq5nLZRMqhJQ/rtXI9AEq7HK3l+eiVGkFyMOeZJN6sYCkPtOsVOMoe36TcwRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784629; c=relaxed/simple;
	bh=tHNFcKB1cyDrYPmInQkcME2Do94EEDBi+3CFseC/SJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MlQAFOtXgz19g/cX5AFZY1g9cp9ItQN3zeynNgnvGZtZ7gR4LuS73NoNdhdgYSvaAkpY76pQKva8Jlv0IS6Jz/ack/yHYx8tCJ90JNlu88mMB9n0XDEskfC1F94IrcCkb7azCvDlUj32FNMmS6kDNPenFBfNk+5/zJscbhyKalU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b8HnyqxW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b8HnyqxW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A8C61F000FF;
	Wed, 30 Sep 2026 16:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784620;
	bh=9okC6m329XxuN89Kvy2oQ+672yoEPcBNUDT+u9ITVB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b8HnyqxWXelMoDJnJ1B2syt2yz5MiVUenSa4VrkjNpmnRAQKXyxXHSOS8IE6WI3gZ
	 eT/8Kp4poWFUZYtj0VRMvyHQk5WUnhIkoHDz3ylGBsahLsZRb7RUx8p+BkitmQQ/Wn
	 YnOvugXyFdN1bJVS1OZQxIcIw2oMekghGNwIIcn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 221/982] ksmbd: start file id allocation at 1
Date: Wed, 30 Sep 2026 17:15:57 +0200
Message-ID: <20260930152421.548984019@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 6b375be0b4e1be89e9a817880515311503a19114 ]

ksmbd allocates both the volatile id (per-session file table) and the
persistent id (global file table) with idr_alloc_cyclic() starting at 0.
The first open after the module loads therefore gets volatile id 0 and
persistent id 0, and ksmbd returns an SMB2 FileId of {0, 0} in the create
response.

Clients treat an all-zero FileId as a null handle. smbtorture's
smb2_util_handle_empty() considers {0, 0} empty, so tests that guard the
close with it (e.g. smb2.oplock.statopen1, smb2.lease.statopen*) never
close that first handle. The leaked open keeps the inode's oplock count
non-zero, so a later batch oplock request on the same file is downgraded
to level II and the test fails.

Start the id allocation at 1 (KSMBD_START_FID) so no handle is ever
assigned a {0, 0} FileId, matching the behaviour of other SMB servers.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs_cache.c | 3 ++-
 fs/smb/server/vfs_cache.h | 7 ++++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 5b3a55bd700dc..9eb9f892ac2b5 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -556,7 +556,8 @@ static int __open_id(struct ksmbd_file_table *ft, struct ksmbd_file *fp,
 
 	idr_preload(GFP_KERNEL);
 	write_lock(&ft->lock);
-	ret = idr_alloc_cyclic(ft->idr, fp, 0, INT_MAX - 1, GFP_NOWAIT);
+	ret = idr_alloc_cyclic(ft->idr, fp, KSMBD_START_FID, INT_MAX - 1,
+			       GFP_NOWAIT);
 	if (ret >= 0) {
 		id = ret;
 		ret = 0;
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index 8d1bf34eb4a18..ffa2737e279af 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -22,7 +22,12 @@
 #define	FILE_GENERIC_WRITE	0x120116
 #define	FILE_GENERIC_EXECUTE	0X1200a0
 
-#define KSMBD_START_FID		0
+/*
+ * Start volatile/persistent file id allocation at 1. A file id of 0 yields an
+ * SMB2 FileId of {0, 0}, which clients (e.g. Windows, Samba) treat as a null
+ * handle and never close, leaking the open on the server.
+ */
+#define KSMBD_START_FID		1
 #define KSMBD_NO_FID		(INT_MAX)
 #define SMB2_NO_FID		(0xFFFFFFFFFFFFFFFFULL)
 
-- 
2.53.0



