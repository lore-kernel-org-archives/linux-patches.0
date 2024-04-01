Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC658F5C;
	Mon,  1 Apr 2024 16:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989816; cv=none; b=CYKOliWqVH15kmhdnoXyncPLE9f+PGtL6IGjtLWnEtzlG/jQHUbrrm+smbIYiIAL8eycuFQaqlLq/n1t4kmEcgq9h/4U4VPEhSIxoZZd5tUhZg+dxFRff+HEFNaEepAhoRfbGJC5DGsW2Vzc04hd5Azb9GSJbJKH5NTvCk81GdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989816; c=relaxed/simple;
	bh=BgGQ/XsXvChwN4wottrT5H+Cm0XfOSVbV9XhUo5Jdu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RRtfMFaTfK+OyS42zrTZvdVwBJu0gy292dPpMX1PPRknyf/pfAkwVBpRU1+K3j2Bf4BM4/xdycTOKVDNT0aAM6BsQncTQI7ZpA+IvljV1sc4b23ABCNybCR5lNB3GrVxfuKw17YZDGo6PtQP6Ll80s/eei9KKd3IKzNjLXERU6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=II3AHrX2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="II3AHrX2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDB47C433F1;
	Mon,  1 Apr 2024 16:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989816;
	bh=BgGQ/XsXvChwN4wottrT5H+Cm0XfOSVbV9XhUo5Jdu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=II3AHrX241Sh/XGdfbBMYmpoKpDM9fEUPZjXAIqKLD8XL0qm0Qytaa4xqVleOgA4q
	 dmpBwN+C7HeSvX6k/zJpnDcKJZ6pug+8kQYfo8zx2B2No11Bs0YAu31V7TXkEEvcwS
	 jYo5XGik8xVDnucrBU5AjeL4T3j2Hu18Q6pduDxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugene Korenevsky <ekorenevsky@astralinux.ru>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 162/396] cifs: open_cached_dir(): add FILE_READ_EA to desired access
Date: Mon,  1 Apr 2024 17:43:31 +0200
Message-ID: <20240401152552.771060746@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5730c65ffb40d..15e1215bc4e5a 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -233,7 +233,8 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
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



