Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8824EBAE3;
	Fri,  9 Oct 2026 14:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557143; cv=none; b=aF1NhTbesQKgKWgrWXvKXg91e5SA7I505w/AD4I9CXaND1xVHFvAsEzTquv+aJFlJ2ZuSZ24TkU3ztmbTFsUy9XC4aK6adml10OI/zaYkY7dN0ESTDbmrvCiXI+3XiAKITFetOQk4696z7cbATm1p1/8U9BazBWVoJdnS4OeAkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557143; c=relaxed/simple;
	bh=naSevYPWQwT8zBJv7D04eTbrcG1+UNH9xgMPvHsLnhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=asirhCKegfFpgj4zww1MVIZKKegU2ClrG4olv0Fcf0CaEBKnmeYB/ffj7mKFBpxajD2ysvqjVvjncAFMcgOuDRjnmRNhGJar8goOYJxDSuWpAmXkyRl+L83ZH5OBN2jn03AgsRR1xsHGlSG/jGJLFckcn17ldZsr7ECVv0Z81DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vP1Iu3AA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vP1Iu3AA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284CF1F000FF;
	Fri,  9 Oct 2026 14:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557141;
	bh=CmqaoMG1bJy2SEY++SPUgfTgLgoELiUF8c7r2pWAIZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vP1Iu3AAH5XFR4cya7601MmOt1ZpZAbqUmhvAIiJ4KdkDU/tblAk0mm0i9i6ZfhlK
	 QwgHPiKIeqc3XhYFcePXebREJQuYa9EweXI26Fq71REQSTXXUMwWNxWaGxQfOZI+gw
	 75JZ6sQTwn8a+E7V38GOtGdrAnKi6wRmL2y7L580=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.18 353/403] fs,fsverity: remove check for fsverity being enabled in setattr_prepare()
Date: Fri,  9 Oct 2026 16:11:54 +0200
Message-ID: <20261009141000.533386508@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Andrey Albershteyn <aalbersh@kernel.org>

commit d2f96bcb89d36d488a10e3bcf819b98536968286 upstream.

The check that fs-verity is available in the kernel is not necessary
here. Filesystems could have fsverity files even without fs-verity
enabled. In that case, truncate on fsverity file will succeed, what this
check is trying to prevent.

Fixes: e9734653c523 ("fs,fsverity: reject size changes on fsverity files in setattr_prepare")
Cc: stable@vger.kernel.org
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260727094352.1734826-1-aalbersh@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/attr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/attr.c
+++ b/fs/attr.c
@@ -176,7 +176,7 @@ int setattr_prepare(struct mnt_idmap *id
 		 * covered by the open-time check because sys_truncate() takes a
 		 * path, not an open file.
 		 */
-		if (IS_ENABLED(CONFIG_FS_VERITY) && IS_VERITY(inode))
+		if (IS_VERITY(inode))
 			return -EPERM;
 
 		error = inode_newsize_ok(inode, attr->ia_size);


