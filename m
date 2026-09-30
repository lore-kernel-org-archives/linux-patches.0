Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5316923ABBE;
	Wed, 30 Sep 2026 18:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794579; cv=none; b=qcKLzzke9CJcZsm/VhIob0nO27a1lUeyzkveEVTLB2E8+zJf/h1GdR2lAFEetIpPC7l4f1qhbiIkGa/zM2yIjmBjzPQzFZHNdzrv2GErmOyH/viunm7nfWDk8tIKzi7lQNnjfB4UQ5UKiWPwVH4UuTO8URYSHwoA5EMx0PH0VXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794579; c=relaxed/simple;
	bh=dobWjlnusleMYu6IFLdLJQZjRaONUwSxkazjdbLdJCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c1qIqNVflHDW5t6r+YJxj9Wbuv0aG37Tlmg3YYvH5iaeiJnCvHT2j7lDNMYIXW5uC56QUBGUTqXuZKqWqOK3c/KH3bgcbOtTDHkXvK39Ye/XUdy9t66md/RiNLQoBnyQSaMDjGehmUwNJ2MCYEvsHljyDPI2DgzWgkTL0CUFTcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=11lYlvPw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="11lYlvPw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 446CE1F000FF;
	Wed, 30 Sep 2026 18:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794577;
	bh=G70VphFTPA75cxefNQdC7ZSF2p+Q1cYoL2w4GtxxGLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=11lYlvPw7ItVhpbjGV0ne5KTb1orCXPCC29jjs118KTFpZ/Atj6brhKyzrET8qNIO
	 mp9eS57JoE7gvXzOQ0vDp1+MxjgyNIBA+jDID+fQ5HRGIByVSaM2J9yW2OQYWNv6hM
	 5kQVxy3oyF4v8B+pae3FkUKTIHKrk+K/Ed8Q5B60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0259/1193] ksmbd: start file id allocation at 1
Date: Wed, 30 Sep 2026 17:15:43 +0200
Message-ID: <20260930152439.926170835@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index e1f2a9135684d..287858f6304ef 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -698,7 +698,8 @@ static int __open_id(struct ksmbd_file_table *ft, struct ksmbd_file *fp,
 
 	idr_preload(GFP_KERNEL);
 	write_lock(&ft->lock);
-	ret = idr_alloc_cyclic(ft->idr, fp, 0, INT_MAX - 1, GFP_NOWAIT);
+	ret = idr_alloc_cyclic(ft->idr, fp, KSMBD_START_FID, INT_MAX - 1,
+			       GFP_NOWAIT);
 	if (ret >= 0) {
 		id = ret;
 		ret = 0;
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index c83d2f96e8636..e39d6e9023504 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -23,7 +23,12 @@
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



