Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F10215041;
	Thu, 12 Dec 2024 17:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025637; cv=none; b=SL53rQv48AkE7yjrJ6LqwGy9OM8g8XWWfJmif09bnLUE0Ov8k2PsEf8stHdvRamKgIEw4/FKagmUOPCtADwxiBbXMVfIEmpVg+Uq3tuj6lLqemnQDDqJ/DetoV/SU/qhgkHzQVHlk0SmZUDp3Y+iQAWwK8+uUWcx/WMrYR9orx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025637; c=relaxed/simple;
	bh=bAD5VegBRXsIVOrrRsohWdFEDds97YqqFunpKWNqfc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cJOGshtAGaf4fAzcurYHbGLis5O+6KX7a5bHJyfxbsqluSHMrMlWZeRTrAThRaLPQVY9JjMEN/iORRu6IjrEeE30+sL6egQ2zkRtLZH62yLDuw8EXDJjpx0x8C8WyUmUDUAGoAXyhPT3gVkVFzTFd231ezFUv+muzmbepgD0X6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JHHwxuM0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JHHwxuM0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD743C4CECE;
	Thu, 12 Dec 2024 17:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025637;
	bh=bAD5VegBRXsIVOrrRsohWdFEDds97YqqFunpKWNqfc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JHHwxuM09mFwOct0K8QPw2WsczfZy7N03AsbEnlZ1Ey8u5ylsfU+jNoHQRSwuFt/H
	 XHJd6wR+WA+7fnusTmrl8Enjj/A+BqEckrlxukiFd6t+KyZCoAl8TSRnKQLgKzmzbv
	 uozmWbZKfj2RBjT4nXOuL0GeelJ2f03ifgKWQwdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a8c9d476508bd14a90e5@syzkaller.appspotmail.com,
	Miklos Szeredi <miklos@szeredi.hu>,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5.4 209/321] ovl: Filter invalid inodes with missing lookup function
Date: Thu, 12 Dec 2024 16:02:07 +0100
Message-ID: <20241212144238.238473326@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasiliy Kovalev <kovalev@altlinux.org>

commit c8b359dddb418c60df1a69beea01d1b3322bfe83 upstream.

Add a check to the ovl_dentry_weird() function to prevent the
processing of directory inodes that lack the lookup function.
This is important because such inodes can cause errors in overlayfs
when passed to the lowerstack.

Reported-by: syzbot+a8c9d476508bd14a90e5@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=a8c9d476508bd14a90e5
Suggested-by: Miklos Szeredi <miklos@szeredi.hu>
Link: https://lore.kernel.org/linux-unionfs/CAJfpegvx-oS9XGuwpJx=Xe28_jzWx5eRo1y900_ZzWY+=gGzUg@mail.gmail.com/
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/util.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -111,6 +111,9 @@ bool ovl_dentry_remote(struct dentry *de
 
 bool ovl_dentry_weird(struct dentry *dentry)
 {
+	if (!d_can_lookup(dentry) && !d_is_file(dentry) && !d_is_symlink(dentry))
+		return true;
+
 	return dentry->d_flags & (DCACHE_NEED_AUTOMOUNT |
 				  DCACHE_MANAGE_TRANSIT |
 				  DCACHE_OP_HASH |


