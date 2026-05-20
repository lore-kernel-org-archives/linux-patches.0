Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DEC535AC18;
	Wed, 20 May 2026 17:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297382; cv=none; b=hKBXvj0+in7b4gKLM6oSL2C916E1hfObWOjQIn7F2E5F/rrcscOQ6g0IQ1vljWNGr4/Ou5uLT6ssTpa/61fLkI5JChg+1XCJ6z4X4OHxCxh1xGS8mbELVZSD8QnKGGYozf9dVVmnMwQPouCrWU9Ly62VEZa826ViWPf0ahQzcTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297382; c=relaxed/simple;
	bh=m2bHRdz1Mlxdv9UKDZ4ew1C86N52hvHE31zhaZ/8TXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FpqHJfZV1ASCLrgcIk7PCctLXyJ84h1VIiLpCGKxoBoyZidn/bqpUjT5nfpiVu7B5zW2B6WmyqqPzWq8quM6RandVSQfMQ5aLVF52aIy3XMYsVJG1ODad+8yqDLSI5ZWcwI+vpUoyKx77s5BQ/IjU+RFclWyS9u9llN8LHOaaZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kf10fPMY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kf10fPMY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E7CD1F000E9;
	Wed, 20 May 2026 17:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297380;
	bh=nkxrS763cj0dxM/8qC2fuxwz46Qpav0VjVX5mMtbFTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kf10fPMY5A0uDbLOtdcTJhStNAnYtMy0BNUrXbsgL7bi41vV0rJxG5frlGgr6jZqp
	 Ig1s4eSdYdX+6YNPZOBhK3NKXFt/pR3rdPTmaLmjsUoKcpmDSv+D0T6I2DR1n9r6vh
	 BZpUbpAjEMKbeQ7mDnqLo/W4gOgceQdn1Uk/GJms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Chunhai Guo <guochunhai@vivo.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 011/957] erofs: include the trailing NUL in FS_IOC_GETFSLABEL
Date: Wed, 20 May 2026 18:08:14 +0200
Message-ID: <20260520162134.806234165@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Zhan Xusheng <zhanxusheng1024@gmail.com>

[ Upstream commit d6250d49da4d8f11afc0d8991c84e0307949f92e ]

erofs_ioctl_get_volume_label() passes strlen(sbi->volume_name) as
the length to copy_to_user(), which copies the label string without
the trailing NUL byte.  Since FS_IOC_GETFSLABEL callers expect a
NUL-terminated string in the FSLABEL_MAX-sized buffer and may not
pre-zero the buffer, this can cause userspace to read past the label
into uninitialised stack memory.

Fix this by using strlen() + 1 to include the NUL terminator,
consistent with how ext4 and xfs implement FS_IOC_GETFSLABEL.

Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Fixes: 1cf12c717741 ("erofs: Add support for FS_IOC_GETFSLABEL")
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Chunhai Guo <guochunhai@vivo.com>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/erofs/inode.c b/fs/erofs/inode.c
index cb780c095d282..218ab22589228 100644
--- a/fs/erofs/inode.c
+++ b/fs/erofs/inode.c
@@ -348,7 +348,7 @@ static int erofs_ioctl_get_volume_label(struct inode *inode, void __user *arg)
 		ret = clear_user(arg, 1);
 	else
 		ret = copy_to_user(arg, sbi->volume_name,
-				   strlen(sbi->volume_name));
+				   strlen(sbi->volume_name) + 1);
 	return ret ? -EFAULT : 0;
 }
 
-- 
2.53.0



