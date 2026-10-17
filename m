Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDDBC3B19BA;
	Sat, 17 Oct 2026 17:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258961; cv=none; b=Mc/opPMQcCcAddzqLfRhNTIL5TKhnwPXzHDabKersndtQvcvRUFznwXxjEovWWomzZjM9+6hhz0JTGnRfY/C/qUp9TKFn3AdKqKb+F1omHWZ461PqxW5BSkI7+t9dxP1zrfHHzKbKZwsTx/45c21GMzYROIMrwOdt9kFXA/IGeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258961; c=relaxed/simple;
	bh=XohB5shD6BbJy9MD29l5hN47DeHxNFfx5nz/Gf60U2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s1cgblXMYtVBrGq3NGfRo7zD8sKex/GrU//RNMHjZar6P+VQ/nEBR6WNAB9Vy/1UwQbnbUv5vYP3qvqUjeqh0LpkOibxdkY8qVexvEVyLtcufA/L2gJTc+13TmWX0lgc/JZIIwJHYJFhEf0zylP9IQ3tRA5khFXSXH7QvH+i0lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IG/vCP/w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IG/vCP/w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21CF11F000C4;
	Sat, 17 Oct 2026 17:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258960;
	bh=GUvj0N6/md4B6D49tToDJv4cayxlKmZBxzAFVJfkwMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IG/vCP/whLTb+CbwFjND2FNvHAZ4QrA9STjtuJBhGIPx0j0qqNpfKDUNHjGd4K90t
	 Lnv5olp6TNdP0eOi6Apto0db//AYt9Xmegw9qpuD+BnyydePi1OAeluluB54ZwhpVr
	 e+iGriTytiWwH52BEHbvCWnr+Q4RLkoPA7nSqc+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Zhu <zhujia.zj@bytedance.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1054/1674] erofs: fix metabuf leak in inode xattr initialization
Date: Sat, 17 Oct 2026 17:55:26 +0200
Message-ID: <20261017160458.180714624@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Jia Zhu <zhujia.zj@bytedance.com>

[ Upstream commit 79b09c54c6563df9846ca3094bcfd72082c3e1d7 ]

commit bb88e8da0025 ("erofs: use meta buffers for xattr operations")
converted xattr operations to use on-stack erofs_buf instances.
erofs_init_inode_xattrs() uses such a metabuf while reading the inline
xattr header and shared xattr id array.

Some error paths after erofs_read_metabuf() leave through out_unlock
without dropping the metabuf, so the folio reference can leak.

Consolidate the cleanup at out_unlock. erofs_put_metabuf() is a
no-op if no folio has been acquired, and this keeps all paths after
taking EROFS_I_BL_XATTR_BIT covered by a single cleanup site.

Fixes: bb88e8da0025 ("erofs: use meta buffers for xattr operations")
Signed-off-by: Jia Zhu <zhujia.zj@bytedance.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Fixes: bb88e8da0025 ("erofs: use meta buffers for xattr operations")
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/xattr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/erofs/xattr.c b/fs/erofs/xattr.c
index 09d341675e890..411f5f3edeb01 100644
--- a/fs/erofs/xattr.c
+++ b/fs/erofs/xattr.c
@@ -105,6 +105,7 @@ static int erofs_init_inode_xattrs(struct inode *inode)
 		it.kaddr = erofs_bread(&it.buf, erofs_blknr(sb, it.pos),
 				       EROFS_KMAP);
 		if (IS_ERR(it.kaddr)) {
+			erofs_put_metabuf(&it.buf);
 			kfree(vi->xattr_shared_xattrs);
 			vi->xattr_shared_xattrs = NULL;
 			ret = PTR_ERR(it.kaddr);
-- 
2.53.0



