Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A41F5334C24;
	Fri,  9 Jan 2026 12:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960502; cv=none; b=BdyLfxIxv/gEvCkExGi8esrCNPY1pnRuBxe/KqsRIzPFv/hABwIbWOb/AqUMRaZR3qYCj/1g+RaJbvCqFWVYPtdC3Rtyo8U2CYydd2o+dKi5koub1+6Eglch97yLqXAp+a7W/xYfGJwmsc9kzN3ReAXj7cw4LVQDVzmP+2JrAjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960502; c=relaxed/simple;
	bh=fz8g8w8DQYURkMjCsnrH0eGKdzGlupbaYonBMhlZLFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cOm1RHNE/zcD7mbaADbuyiTRILZH7kp8YF7hHnBr07MvYXSwF2pNgURdcmUTulO5UUNMtz3ExskVNmp/F03cJnvcW65rM9T+a5EQL+vGmUjOF8+lWD5KpATy7yFbKY0kCEWzJN7S095BI2RmJODvouheM8a//6w8WHdAax2qGtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UULlKkJc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UULlKkJc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E4C3C16AAE;
	Fri,  9 Jan 2026 12:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960502;
	bh=fz8g8w8DQYURkMjCsnrH0eGKdzGlupbaYonBMhlZLFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UULlKkJcEmE37OuKjRJ+r7qiMRFfeFZzsmuNxu16n8FAB7/dgqteGgxTg6CXsBoXh
	 ZRCeo8T4x+dewd73HCl4PEnpQy1eCtI7mWvOo6qOqSlBIfTdhqS28lTQzQGFr2iNHV
	 sVQgkmG6FAMBpgjCsXThZE/hz56MRnf9Vk7s4VkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernd Schubert <bschubert@ddn.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 394/737] fuse: Always flush the page cache before FOPEN_DIRECT_IO write
Date: Fri,  9 Jan 2026 12:38:53 +0100
Message-ID: <20260109112148.821499648@linuxfoundation.org>
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

From: Bernd Schubert <bschubert@ddn.com>

[ Upstream commit 1ce120dcefc056ce8af2486cebbb77a458aad4c3 ]

This was done as condition on direct_io_allow_mmap, but I believe
this is not right, as a file might be open two times - once with
write-back enabled another time with FOPEN_DIRECT_IO.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 2055af1ffaf3..1dd9ef5398d7 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1463,7 +1463,7 @@ ssize_t fuse_direct_io(struct fuse_io_priv *io, struct iov_iter *iter,
 	if (!ia)
 		return -ENOMEM;
 
-	if (fopen_direct_io && fc->direct_io_allow_mmap) {
+	if (fopen_direct_io) {
 		res = filemap_write_and_wait_range(mapping, pos, pos + count - 1);
 		if (res) {
 			fuse_io_free(ia);
-- 
2.51.0



