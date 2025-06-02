Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51349223DF6;
	Mon,  2 Jun 2025 14:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874163; cv=none; b=K/raqyqxc6Y4XRz2HK3AuJlIIBOS9KKJmft5SX+Ua/Scxn/RbjBnoZn9W6ZrvN4ShZoQDzQMks+YMgljlOzM12l6nxPiVWPMHQhqmsGTVegrrvmysIzFvMIOmkriW/Qayq+9nhfXP2Vp6mS4yku/MpbWDiI2y1TjB7aHtbKJ7uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874163; c=relaxed/simple;
	bh=W3jKQK6XwfYRSve7GU9aqYQnLIqRrIpfE0xoE7l4vUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NZ37SnO8ZN7ZtWAAOfXfsvSi+ZJP8uGFrI/xEf8dJmHIM+67b0imWFdH4fh965qpCHvSD8n/z/Ccrzhv/jStJ/wdILJlE3NTmmocLZT1G2fcETF4DdJLysUKWszRoKFaOGIm88rLycwXrolGMyvA1iv9GDh4t9i1Dd2xWr1n+0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JnGDcXtM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JnGDcXtM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EDF5C4CEEE;
	Mon,  2 Jun 2025 14:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874163;
	bh=W3jKQK6XwfYRSve7GU9aqYQnLIqRrIpfE0xoE7l4vUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JnGDcXtMOsp6EdydrGZoazzgKyK0ge/MTNnRdMdPNdFwLU7km47sKmeKMAde1I4/k
	 VyjUVWUjEboEFLomIewUh9O1jbf0Rf7WNWpOgoKrOy4udRXBO7lc7mmWg7uFBABSL8
	 WVA/vpPGw9FT2lKnPAOZiavhjg3OUX7eJM51iMYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 379/444] ksmbd: fix stream write failure
Date: Mon,  2 Jun 2025 15:47:23 +0200
Message-ID: <20250602134356.298053079@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 1f4bbedd4e5a69b01cde2cc21d01151ab2d0884f ]

If there is no stream data in file, v_len is zero.
So, If position(*pos) is zero, stream write will fail
due to stream write position validation check.
This patch reorganize stream write position validation.

Fixes: 0ca6df4f40cf ("ksmbd: prevent out-of-bounds stream writes by validating *pos")
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index f6616d687365a..3bbf238270605 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -426,10 +426,15 @@ static int ksmbd_vfs_stream_write(struct ksmbd_file *fp, char *buf, loff_t *pos,
 	ksmbd_debug(VFS, "write stream data pos : %llu, count : %zd\n",
 		    *pos, count);
 
+	if (*pos >= XATTR_SIZE_MAX) {
+		pr_err("stream write position %lld is out of bounds\n",	*pos);
+		return -EINVAL;
+	}
+
 	size = *pos + count;
 	if (size > XATTR_SIZE_MAX) {
 		size = XATTR_SIZE_MAX;
-		count = (*pos + count) - XATTR_SIZE_MAX;
+		count = XATTR_SIZE_MAX - *pos;
 	}
 
 	v_len = ksmbd_vfs_getcasexattr(idmap,
@@ -443,13 +448,6 @@ static int ksmbd_vfs_stream_write(struct ksmbd_file *fp, char *buf, loff_t *pos,
 		goto out;
 	}
 
-	if (v_len <= *pos) {
-		pr_err("stream write position %lld is out of bounds (stream length: %zd)\n",
-				*pos, v_len);
-		err = -EINVAL;
-		goto out;
-	}
-
 	if (v_len < size) {
 		wbuf = kvzalloc(size, GFP_KERNEL);
 		if (!wbuf) {
-- 
2.39.5



