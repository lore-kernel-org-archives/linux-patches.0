Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 777B5282F26;
	Mon, 23 Mar 2026 15:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278149; cv=none; b=d2Aaddy0GlUkmWwITiYeX7tDj2VgVHvHQW3URDh4vEfcEpB+I5XXL8hPiGGDSK5RjSDrLBLHEgM1NKF8Iwuf5X7iwBhKJqDuxLuRPYNCuNx5tg3BnFgH97yyiUdts5PMf76HYQLSR2vTUpX9ns95OsMiEcqSDNbnFVeGo7MjHkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278149; c=relaxed/simple;
	bh=Ktfpcqe0fZC9UbwFDqm6Kv+Af0dXDvLl/obvnCc5dso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BKlXYVdOaTMCK9DnLrGWNxPb3tKu2ihltjHxwi1PW37E+8wuC2JqBhfl5HZgdPN+WfxmBnPOKX9z5s3m1+/vbRbpbiChPl95WA/A7jnQf5kmTDv3OFyCpdxtE54Y/fWnr4ELQVNnMsAu5/01lDJ3k+nCOZ4+T8hN2yrOojO1U3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WJh0bKad; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WJh0bKad"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94FEAC2BC9E;
	Mon, 23 Mar 2026 15:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278149;
	bh=Ktfpcqe0fZC9UbwFDqm6Kv+Af0dXDvLl/obvnCc5dso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WJh0bKadbTyHYzSTaoF9t9QML+oPb9XOniEbWeQ0nfgaOl1+XTbfk+LcTwKHYvewo
	 a+/ZL/C65spYsPGsy0ryzvHraFLaf3PyXIJ7eKXYi/fVL08p17S8UANxenJ7nJlXzh
	 G2kwptrSU7kiA7uklLWdBc1cykeZNEWY6hGalHCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 215/567] smb/server: Fix another refcount leak in smb2_open()
Date: Mon, 23 Mar 2026 14:42:15 +0100
Message-ID: <20260323134539.148729402@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit c15e7c62feb3751cbdd458555819df1d70374890 ]

If ksmbd_override_fsids() fails, we jump to err_out2. At that point, fp is
NULL because it hasn't been assigned dh_info.fp yet, so ksmbd_fd_put(work,
fp) will not be called. However, dh_info.fp was already inserted into the
session file table by ksmbd_reopen_durable_fd(), so it will leak in the
session file table until the session is closed.

Move fp = dh_info.fp; ahead of the ksmbd_override_fsids() check to fix the
problem.

Found by an experimental AI code review agent at Google.

Fixes: c8efcc786146a ("ksmbd: add support for durable handles v1/v2")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index da4d914c87ad2..5a112211a7111 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2990,13 +2990,14 @@ int smb2_open(struct ksmbd_work *work)
 				goto err_out2;
 			}
 
+			fp = dh_info.fp;
+
 			if (ksmbd_override_fsids(work)) {
 				rc = -ENOMEM;
 				ksmbd_put_durable_fd(dh_info.fp);
 				goto err_out2;
 			}
 
-			fp = dh_info.fp;
 			file_info = FILE_OPENED;
 
 			rc = ksmbd_vfs_getattr(&fp->filp->f_path, &stat);
-- 
2.51.0



