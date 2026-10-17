Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C885038AC99;
	Sat, 17 Oct 2026 16:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254208; cv=none; b=SJDXGPq01wdqvSaX/QvEc0QQU0SZk698Syc1mAQADZSJ28afeYGDQmkn/DhadOHUC5kWPFtPBePgLpmY+hKE1+vDkwlh/xGeJGI9In/kaD0/MehOw8kM4M8lHeta6mYo3vXaG3TElSnaZq449L3sIZ6f0F8ZZb6PrecJRHMHroI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254208; c=relaxed/simple;
	bh=YuhxE0Aml+NaJvPQvoMyocm95vEt+lWkP01uFBQvxSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J5AIVcUk6MHnAsjcRmsS62+NgYlisig22gvsyfvqdEn6qUlwqkbgt/KB71G4Xxq4C98hZ9JScV+86Cg3JjPIZQxgQdVK8ibPehzCwmoSYdVpzpmD8Cdr4CDsvuKt93wRY9qyOlckhJr4L1sbwhot3FCxW7ESSv6cUt0dPshg13g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0D67XZYC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0D67XZYC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D0C81F000C4;
	Sat, 17 Oct 2026 16:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254207;
	bh=OTQs0ooSr4Vxeykg9+ZX+B2GGipWSV5OuxncCuuYQYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0D67XZYCAne1yDo4wDAWpAJiJ79N5V5cPceKqkkQWd6VKhZcysWqDra3AIaduRTrD
	 Cx9Eh+529+MEQ+k7w0NDYvm2NgzDSwNyC0X2g3C8QSHXhaVf+qhGZofDYxqMRvfzKA
	 MU5uWpURpZSusEcscCK7SFji1rCiN28wg8AbgBBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Y s65 <yu4ys@outlook.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 370/869] ksmbd: prevent path traversal bypass by restricting caseless retry
Date: Sat, 17 Oct 2026 17:53:31 +0200
Message-ID: <20261017160046.597748857@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 fs/smb/server/vfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 7785bc10aff11..967f669974861 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1245,6 +1245,8 @@ int ksmbd_vfs_kern_path_locked(struct ksmbd_work *work, char *name,
 					   path);
 	if (!err)
 		return 0;
+	if (err != -ENOENT)
+		return err;
 
 	if (caseless) {
 		char *filepath;
-- 
2.53.0



