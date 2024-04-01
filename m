Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588EBC129;
	Mon,  1 Apr 2024 16:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988424; cv=none; b=VXID8sOTJV1SgZqw6G69KXcW5fmx9nRsf7I3NHEiqYG9svn+E1BDW5kJ/QJ/bKcJuU0NTeR30iobdhhUAdSwRyd1V8CwCtE/TOdYuLs6PqawFoUJMhNbG3BfAycmVenMHQL7eaud9lV0Hu0a+NgFbU2r22SQxBLNVg510U6P4hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988424; c=relaxed/simple;
	bh=5z1fErpRDQUcKd6+bsBslOG/wKP3ZoOokV7DR6fIhiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NPxGHcwnIRLvZmB7bHxssjuCBArDPmnxJ211Ono94uBjrrP2534cvFPOwFLlQmgoI1fDGXBttGXs6l0IvBC8qWD1lqtfl/nkoDBLvib1gWgeqGfXhX9iQFK9+oDEu5x1lb/a3gHrY0ddUqCUH11YPjUwPffSIqHRrLK+CYuweDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WPkWTPFX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WPkWTPFX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA643C433C7;
	Mon,  1 Apr 2024 16:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988424;
	bh=5z1fErpRDQUcKd6+bsBslOG/wKP3ZoOokV7DR6fIhiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WPkWTPFX2Lo7Xif5JKAB29wRXU9uAWvSFRnUjFUfcFhZFyFJmhK1I4iGmI736U3yP
	 HEdg8zO8w+N7ScU5XbX7L6H33FzIMpCqvkmEkAcei/PPviDbl7LN4xpS+Ope43nfH+
	 5QDkWdWAYwpxc7WSdhex7G5M94PD3qyytZiTSS6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugene Korenevsky <ekorenevsky@astralinux.ru>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 181/432] cifs: open_cached_dir(): add FILE_READ_EA to desired access
Date: Mon,  1 Apr 2024 17:42:48 +0200
Message-ID: <20240401152558.542729979@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



