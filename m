Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909CA51B165;
	Wed, 30 Sep 2026 16:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784678; cv=none; b=AnPmPbBkuZcADxQ7fVQ1LnpkfjXFGMdMXZo0hfMB739Uzb17QLyKHXMi6sRO9+5VhWwylhIeGm3YEwz8u12Dtc+vBQEMjnMAkI0InHkOHEq81kNWxeoZYRL4bsqxo4Gti3pnhsFYENWNFl4NTENxKBDczp7BYcsCnkbTqPUMQfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784678; c=relaxed/simple;
	bh=qU0+Xr6miFNn66DydSQxHMRBPywzQIf0ukPVbzXyxpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aH8D95N8Krl0qeEiZkWHSzB4LBDhNh7dSccizXkmsIqUTWUTYBvIlP9kb09xVUGlbk7R8U0KeMa3/UWokhxyvy+YJeqlVttQ8k0y6jSW/Qvz16ijJFlfJgm+FF7QtM8vSRrNsgGVK2838RFoOISqEpQLCMBSosLRSvB5K3YrAjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X6/x7QZW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X6/x7QZW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 880471F00893;
	Wed, 30 Sep 2026 16:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784672;
	bh=Qsku0qYmxIc6n6rH04WfpotKSfxkCP5TB+hXJ2Eczys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X6/x7QZWyijQ8CGnAO+9uoNoWpi/xPPlXVVl4CQrWfw87/hzVsU8VWJKfhZrUWnUs
	 0JeyQnAiucXBf6Q2PQoLL/YJIbY3X5ZnIFaH62W0svFucVOOdcEJ7KeQm9Fq7Hb0A9
	 P2QID2m5zxRT7pOYqVDY/29NBEZ25XU9AnuwlVQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Liu <liuqiang@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 237/982] ksmbd: fix n.data memory leak in ksmbd_vfs_set_dos_attrib_xattr
Date: Wed, 30 Sep 2026 17:16:13 +0200
Message-ID: <20260930152421.887213698@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiang Liu <liuqiang@kylinos.cn>

[ Upstream commit 7ac657bb9c5c1b0f7bdf1fa6d3ad532f969be5cf ]

Free ndr buffer data when ndr_encode_dos_attr() returns error
to avoid memory leak.

Signed-off-by: Qiang Liu <liuqiang@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 413071ce9633f..27a15c9d3cc22 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1613,14 +1613,15 @@ int ksmbd_vfs_set_dos_attrib_xattr(struct user_namespace *user_ns,
 
 	err = ndr_encode_dos_attr(&n, da);
 	if (err)
-		return err;
+		goto out;
 
 	err = ksmbd_vfs_setxattr(user_ns, path, XATTR_NAME_DOS_ATTRIBUTE,
 				 (void *)n.data, n.offset, 0, get_write);
 	if (err)
 		ksmbd_debug(SMB, "failed to store dos attribute in xattr\n");
-	kfree(n.data);
 
+out:
+	kfree(n.data);
 	return err;
 }
 
-- 
2.53.0



