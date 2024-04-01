Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5544917552;
	Mon,  1 Apr 2024 15:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987089; cv=none; b=XVvPSieOZO2LyzT/M3Mf2BXPqQz8DyDjFJ3n8fXXo6+1h6WcmZzRR/a+wra+mwcszlcRmGAiDdjZGLSLkyiVZjc7J/xvVlQnumYh23LloL20wLnEdJAYs4e+ZDsccCxzOQyDhuSpw5kb1pX/0XxfZBJNGv2Sm+Yuf3/nXVaVV4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987089; c=relaxed/simple;
	bh=T5xnnFzgMmSBg91T4rP3cUOJq9xvHC5ospe1mzSe9co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A8373TgVhudLl9pewE9ONVPq+4dUDfTbud2hIuwir2egR2obCGNscqFOjrpTHtycO+tKPOLCXywZ7xfWKGGgYSnkEdnIWMRcy/U+cD7sUU1PCWMbSEd4CVdymKPfyZGf7gnNSSeNtlRgT3WrxwKkbDDyBnNrFLWP5yhkbvfSrK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=leWdBg94; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="leWdBg94"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D59C433C7;
	Mon,  1 Apr 2024 15:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987089;
	bh=T5xnnFzgMmSBg91T4rP3cUOJq9xvHC5ospe1mzSe9co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=leWdBg94/8xPOs0ouPB89K1A+fd0k0Zo5CZ7mvHxfccp6LZ5ibptlZWOmUDaLCyXa
	 q3pHVvSROq3nYjku0XVjqCKh1Y7VbFu/qAylIixjLhu+b81G6w+PyzuEg3DWGUbxgN
	 3RmPF1wwZXpJjTEGXufpprNkG2l18eTzISLlzyC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugene Korenevsky <ekorenevsky@astralinux.ru>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 181/399] cifs: open_cached_dir(): add FILE_READ_EA to desired access
Date: Mon,  1 Apr 2024 17:42:27 +0200
Message-ID: <20240401152554.578225811@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 3de5047a7ff98..a0017724d5239 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -239,7 +239,8 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		.tcon = tcon,
 		.path = path,
 		.create_options = cifs_create_options(cifs_sb, CREATE_NOT_FILE),
-		.desired_access =  FILE_READ_DATA | FILE_READ_ATTRIBUTES,
+		.desired_access =  FILE_READ_DATA | FILE_READ_ATTRIBUTES |
+				   FILE_READ_EA,
 		.disposition = FILE_OPEN,
 		.fid = pfid,
 		.replay = !!(retries),
-- 
2.43.0



