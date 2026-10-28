Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215279;
	b=GEp0hq/56Iqodey4awpq1DfY9ehJf3OjfnmzUmqILyYCwXkctj7tndAVC2kDNCBW9IDM
	 15p7GshzX4Cj+k0hd1e0+j0geWr1hZxWBD2jz8/qMfMv2U49j7/TcnvWapyl3KvaZAQGn
	 NNv6JTZyfVizFae4Pk6ug63U4bXyz2vd1Mw8E6S2JHfrdZgEhxAbQ0nKVGSd730hwm+N/
	 vtxnoDorDpjTqP9RPJ7dCiMtE9fegLPW+zfQ1LRAfu3RakPphuE2eI11wEV54nsWcN96B
	 /12Hul5PTwLHcnJBUVSjWxn3XFgOoq8eOuRjwlKGDTfpX7ADg5u6/1CSK+pJwDT29BQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215279;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wu6LBbTYPbTmGz+mYAjGbgihchzCRu8GBJAGlgZBy0I=;
	b=dLUxpaxK7pY6SAbi8+vPNObYWwtMwZgRO55vBifoqROSoRpssPNhA7GzLNm8YKsYF2+d
	 2w+ATrmLjWcP/7jupj6HwUPH2HBR3kCVqQ4wwWj3b3PriIBbEtsltDYHQkvcbYbO9sC2W
	 xJDcHN7ceKSCrkxumZO9WwOacyWzfbmDYp4QaULT6quEsl5vW6tNLqd0VML92C0lm+Tpw
	 iUCHOqta33DjSWOUsu1dSxt0aZEDQ8xS27YVW+aMvBjQ97XinMLql5MH6BqjDQ5TKGn/M
	 dkOGf4M1TioE45pSCBFxrbSEsDU0CprBExeFJoH6DHXqqBuQkIGe6Hpi9/voM1YY2qQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lm0yJkmS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B4B606A31C;
	Wed, 28 Oct 2026 19:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lm0yJkmS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C87591F01825;
	Wed, 28 Oct 2026 19:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215278;
	bh=wu6LBbTYPbTmGz+mYAjGbgihchzCRu8GBJAGlgZBy0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lm0yJkmSluy+nTPLobTHEh/px5sWinlGkrJ3m2cyNJ4sjgEt9YqqWA0DbtMdyzaat
	 xyZOnlyDGyCDKrbLU2orac6UpFdReO6vgnPdqyei36FaRjBwLL3ysp0ZarqaYpqSFu
	 EpRSyYaAbF9MwWRPcne2+6CPHVOqRZB1jtw1L2GM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Y s65 <yu4ys@outlook.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1155/1887] ksmbd: prevent path traversal bypass by restricting caseless retry
Date: Wed, 28 Oct 2026 17:54:11 +0100
Message-ID: <20261028170525.691028560@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 992ead0759f7a..29247726d9d27 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1239,7 +1239,7 @@ int ksmbd_vfs_kern_path_locked(struct ksmbd_work *work, char *name,
 	if (!err)
 		return 0;
 
-	if (caseless) {
+	if (caseless && err == -ENOENT) {
 		char *filepath;
 		size_t path_len, remain_len;
 
@@ -1270,7 +1270,7 @@ int ksmbd_vfs_kern_path_locked(struct ksmbd_work *work, char *name,
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



