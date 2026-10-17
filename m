Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964372E5B2A;
	Sat, 17 Oct 2026 17:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259116; cv=none; b=Xd7HB2Q78ntK1Le76nBbZZx7gKdwsoyNbEXKnvEss6C4pCTVHULhWkhciP2v8Mgup11SBiBgg15RZ4cNXng/UnhguBQrqSwE6mQI6WvELZfXbw/rIPsfPPNzY/Tk0u4LLO/vraDzeM2JcJ70FQlmsj22ob4jvQ9RZYwE5vtiUuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259116; c=relaxed/simple;
	bh=F0BIibBnbRnPwh86eGTJ6MYjGqo/faKfdMZUTqlOJBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sxySZilYx4SO8cXVIS/9FFTsl4FgFvLo1IlxqdHVhqSnndqI4KiW6owmgJ+UfmjeVZYDi4+CCUULM15MXiy7usMAB63aY1oG9CQ7BltOPwSN8ZbE0gidN/4N/+gO0Fw3ZEgf9DCkJUITVkJWXPaIqpdISWjRD95TiZw+ip+v0nE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=15F+1/bw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="15F+1/bw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65DE71F000C4;
	Sat, 17 Oct 2026 17:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259115;
	bh=ngxTkuaB4MnrmLpsbQpdzkVYqcYTqp68Pot5xsAifwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=15F+1/bwquz/tCaEPiGZ4YPsCsYsO0J2aD5AeWFBbQTQiUM19NhsPYo+KDMuhDY4O
	 Fai4uqjPcbD4RfJN9sUIG92x+T9xhQPrtmyV5uHWs5N9osFaJHuCFx/sO2oQS5tZQZ
	 4NdYnzU/zo0TVZKC8JxDRCqyonrh+Fq0XTrDyl7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Y s65 <yu4ys@outlook.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1066/1674] ksmbd: prevent path traversal bypass by restricting caseless retry
Date: Sat, 17 Oct 2026 17:55:38 +0200
Message-ID: <20261017160458.488667370@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 54bab9ba5a9f156ffa9324fcbe5a356fd0242f95 ]

ksmbd_vfs_path_lookup() enforces LOOKUP_BENEATH to restrict path
resolution within the share root. When a crafted path attempts to
escape the share boundary using parent-directory components ('..'),
vfs_path_parent_lookup() detects this and immediately fails,
returning -EXDEV.

However, a bug exists in __ksmbd_vfs_kern_path() under caseless mode.
The function fails to intercept the -EXDEV error and erroneously
falls through to the caseless retry logic, which is intended only
for genuinely missing files. During this retry process, the path
is reconstructed, leading to an unintended LOOKUP_BENEATH bypass
that allows write-capable users to create zero-length files or
directories outside the exported share.

Fix this by ensuring that the execution only proceeds to the caseless
lookup retry when the error is specifically -ENOENT. Any other errors,
such as -EXDEV from a path traversal attempt, must be returned immediately.

Cc: stable@vger.kernel.org
Reported-by: Y s65 <yu4ys@outlook.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 583ee58753838..43dc18192d058 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1255,7 +1255,7 @@ int ksmbd_vfs_kern_path_locked(struct ksmbd_work *work, char *name,
 	if (!err)
 		return 0;
 
-	if (caseless) {
+	if (caseless && err == -ENOENT) {
 		char *filepath;
 		size_t path_len, remain_len;
 
@@ -1286,7 +1286,7 @@ int ksmbd_vfs_kern_path_locked(struct ksmbd_work *work, char *name,
 			err = vfs_path_lookup(share_conf->vfs_path.dentry,
 					      share_conf->vfs_path.mnt,
 					      filepath,
-					      flags,
+					      flags | LOOKUP_BENEATH,
 					      path);
 			if (!is_last)
 				next[0] = '/';
-- 
2.53.0



