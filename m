Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA104F054D;
	Tue, 13 Oct 2026 12:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893658; cv=none; b=RCbnIsgBgP/7AL8aw1xa3Gw7gljg8WXF7HZqV+VRxRN3XaG65R+pyQ+FbmqJgfl04PP9h27n7o1uJ6vZdAxTOsHvvFx2NsTTRXkj1iC+baH9+A3wckKxUlSNvqTnzSAMqRPjtLtfU5gUpp3NVcAG147K9s6WZw1upjBCy1pDoys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893658; c=relaxed/simple;
	bh=GS3ddjV9kYpsr16XsZUHAsFZRc6eFdTxCPc51+r9k5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eE5k4YjAOZVXK2QgN3pV9dj69ZcsugWjeuqxajG0/XWtAA8G6preLmQUFfB9rrBZVzK3iItQCMP8RE9Trc/uBrJchRCORhKzT/6J81SRlZadS5lMd5GXmFQ7idOMMAcXKoMMo84wT3CdUGBSynkvhtA9PCms1Tg7HfdMMeX2qyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OP8QEtCk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OP8QEtCk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A35E91F000FF;
	Tue, 13 Oct 2026 12:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893657;
	bh=2pPf3WMC9S/KyCM8Cj7/wljzpiEzhqL98ls9Vzanxgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OP8QEtCkHN53CYUQmokNiShDWOH1VcWEg/1jJDbFhRzPKWUu3AL15lYJqYDQ15YqZ
	 Gyxyxc3LAa/KlyGrPUztDWKMCsLEXAEW27MPi5c8q465VnTa/Sra721RHOO1bBjamu
	 wn+2+qiwn5h1NmX/NYm88uTQ3T1X0yqbn9nIm0z4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Y s65 <yu4ys@outlook.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 255/621] ksmbd: prevent path traversal bypass by restricting caseless retry
Date: Tue, 13 Oct 2026 13:34:10 +0200
Message-ID: <20261013112926.912721689@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 fs/smb/server/vfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index ec9d04e4de416..3ac5f3f48121d 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1238,7 +1238,7 @@ int __ksmbd_vfs_kern_path(struct ksmbd_work *work, char *filepath,
 
 retry:
 	err = ksmbd_vfs_path_lookup(share_conf, filepath, flags, path, do_lock);
-	if (!err || !caseless)
+	if (!err || err != -ENOENT || !caseless)
 		return err;
 
 	path_len = strlen(filepath);
-- 
2.53.0



