Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DBA833C1B6;
	Fri,  9 Jan 2026 12:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960911; cv=none; b=qDk3QGW/HQ5d3Fgz66ZvZpAm/UbFYf+eq+cspCmzfpVWzPLQqT6z76n7u3D8YboCoqtYhj/WTMhB9c+xg7jUPDJhC9C8fVAGF9TFSNZ5s2JICS/lECbBTRlMrpjkt9t2/c1z78YWnumwPipQiN3kFrMBqIGjjCCqEy4aV+jUqxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960911; c=relaxed/simple;
	bh=A5awVj2CMJ9suDOlpH5vsr9+HG/GTcK2CGdzvtlRelU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vDB80H0D8KEcNinmAcJEdySoFa8a3UZnyH/Pasg7TE9Wx29FY56JpHcSlOuc1YQjn4hMCERHmqNXoYeNa+KWeFfA5bLGiqWrqRGSE3M75YE/puRFJYSRIyGaL4Gy4Mru8Fhrzhp+z1jgEPegsnajBvaoUWjLzm9M2/giW+HhHXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q523LtGT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q523LtGT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D993C4CEF1;
	Fri,  9 Jan 2026 12:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960911;
	bh=A5awVj2CMJ9suDOlpH5vsr9+HG/GTcK2CGdzvtlRelU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q523LtGT5ovkKT9uZ6DOOj1FD0KA3HdG3W6YtOH063jzD/nfY64LK/7FA3uza9/XM
	 xetS1OtqG9/VVC7PkQnIIFepcUs2VOV6HrOjIsS3NZlkvgCky/zDCtD0GIuXn3SmIS
	 sk1K+4b6YeyfmwSk6D/Ln7hCvgkRh6vsNw5SzE4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 535/737] ksmbd: Fix memory leak in get_file_all_info()
Date: Fri,  9 Jan 2026 12:41:14 +0100
Message-ID: <20260109112154.121369458@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 0c56693b06a68476ba113db6347e7897475f9e4c ]

In get_file_all_info(), if vfs_getattr() fails, the function returns
immediately without freeing the allocated filename, leading to a memory
leak.

Fix this by freeing the filename before returning in this error case.

Fixes: 5614c8c487f6a ("ksmbd: replace generic_fillattr with vfs_getattr")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 3ed78decdca4..f4b3798279d9 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4912,8 +4912,10 @@ static int get_file_all_info(struct ksmbd_work *work,
 
 	ret = vfs_getattr(&fp->filp->f_path, &stat, STATX_BASIC_STATS,
 			  AT_STATX_SYNC_AS_STAT);
-	if (ret)
+	if (ret) {
+		kfree(filename);
 		return ret;
+	}
 
 	ksmbd_debug(SMB, "filename = %s\n", filename);
 	delete_pending = ksmbd_inode_pending_delete(fp);
-- 
2.51.0



