Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE9E1C0DE7;
	Mon,  1 Apr 2024 17:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990979; cv=none; b=lziSaMwJRJivkjDmRh/aC/FG/FaPBwVhdx6JG6RMjw/VhB9XrmoiEbwAjI5GHCg69JTKyuVn9cfeJoG2SF6n/mCMjsRZY1/cqbEKYJC6RKCEO6I/+7nWbAs7KVbUF+atcGX3d9CDZMaIYOSpkeBAJXKOWYrPOrXu8EPAT0B3isg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990979; c=relaxed/simple;
	bh=Xtb1VkE4yl2EzPYOu4VhdxBdX+liwBXGdzgMeX8w8c4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pbCI/NmOgdnuXtwQbKXKwPwRhQwAc9rrMlKm4fER093jz1kV6i7mNQ0WV5Sk4b9tqLWCbdUplsIdbMNiVIZMhGsSbGY3ejrE7dLiqq5ZwZ/RcIYhiMeRsnErIkqN6tibDpLoJsaKR4hSHbfcDlmryViqf0xxV2C9pHL1DkIl7sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m3/na0AR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m3/na0AR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C98C43390;
	Mon,  1 Apr 2024 17:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990978;
	bh=Xtb1VkE4yl2EzPYOu4VhdxBdX+liwBXGdzgMeX8w8c4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m3/na0ARJ6PHqgGXTmO0CJfZ5QLM9wy4QkhyccZXJ2itcPfC16oRb/HizweCIrpu5
	 NhWyA6z5hrSrBb9y7ZcrTrMbCyOOrEoQwUzY4DeNXXN/9uHzz6HcYdfWi6iHh0bIiT
	 IHaTjPvgFGVKNDGLA7NZ7arKusbxbgm/HukuTMqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugene Korenevsky <ekorenevsky@astralinux.ru>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 126/272] cifs: open_cached_dir(): add FILE_READ_EA to desired access
Date: Mon,  1 Apr 2024 17:45:16 +0200
Message-ID: <20240401152534.598554802@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eugene Korenevsky <ekorenevsky@astralinux.ru>

[ Upstream commit f1b8224b4e6ed59e7e6f5c548673c67410098d8d ]

Since smb2_query_eas() reads EA and uses cached directory,
open_cached_dir() should request FILE_READ_EA access.

Otherwise listxattr() and getxattr() will fail with EACCES
(0xc0000022 STATUS_ACCESS_DENIED SMB status).

Link: https://bugzilla.kernel.org/show_bug.cgi?id=218543
Cc: stable@vger.kernel.org
Signed-off-by: Eugene Korenevsky <ekorenevsky@astralinux.ru>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cached_dir.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index fd082151c5f9b..86fe433b1d324 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -218,7 +218,8 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		.tcon = tcon,
 		.path = path,
 		.create_options = cifs_create_options(cifs_sb, CREATE_NOT_FILE),
-		.desired_access =  FILE_READ_DATA | FILE_READ_ATTRIBUTES,
+		.desired_access =  FILE_READ_DATA | FILE_READ_ATTRIBUTES |
+				   FILE_READ_EA,
 		.disposition = FILE_OPEN,
 		.fid = pfid,
 	};
-- 
2.43.0



