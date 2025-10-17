Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C693332C92B;
	Fri, 17 Oct 2025 15:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713993; cv=none; b=NiYT2/ETmMaiMETECZ2/0Sf0I5MJWnBKeD84gzPrU8hgKRZcHzKz72ZOcprBVt0zoXNCeqdPvNYUn+pKvRx3Q5EOrRoUR4e+u87Xjq4T1FO7ffKKReMeD8S/VSoeNqFQ1Uq6xthg2Wrh/Y3nHHhUnjEOl+jhUx0FBaRM2HcYbZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713993; c=relaxed/simple;
	bh=shAYL50+/CDPTAWYy3jHTWWe0wzxMYxpGXY4HlWerIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QcnEZJFnquh4OIdncK7LhfJtV8wypxp9fijp+9zRrZs+08yS0ewTLrukVX8XuxCP0pFfm0sC3EhGS1oppMckRTYak9vUt/ty5qDpYBHgpBKUdjfvEP682mDvv7bw+dvvGyv+Z/MeR06BYvVLy7aeST3XhNRBdI6gaallH4A1NbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vRtCCDoJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vRtCCDoJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6634C4CEE7;
	Fri, 17 Oct 2025 15:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713991;
	bh=shAYL50+/CDPTAWYy3jHTWWe0wzxMYxpGXY4HlWerIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vRtCCDoJXnC16KqCAmNIA4tjnQO+sNcyAdao7AXB83BjN6+vsV/bMVsxp9HA5kNQn
	 +egbPEUQKw0qsMXHfoo2yzTZud5EZk+Jcgx+zh6/g1Ol+Yf/DNl3rL6SEodAYe1IDV
	 fXEKVQ/e8COYE0+sPPl5tSk3uR+ZI8PRgFu3C8P0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phillip Lougher <phillip@squashfs.org.uk>,
	syzbot+f754e01116421e9754b9@syzkaller.appspotmail.com,
	Amir Goldstein <amir73il@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 158/201] Squashfs: reject negative file sizes in squashfs_read_inode()
Date: Fri, 17 Oct 2025 16:53:39 +0200
Message-ID: <20251017145140.535634484@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

From: Phillip Lougher <phillip@squashfs.org.uk>

[ Upstream commit 9f1c14c1de1bdde395f6cc893efa4f80a2ae3b2b ]

Syskaller reports a "WARNING in ovl_copy_up_file" in overlayfs.

This warning is ultimately caused because the underlying Squashfs file
system returns a file with a negative file size.

This commit checks for a negative file size and returns EINVAL.

[phillip@squashfs.org.uk: only need to check 64 bit quantity]
  Link: https://lkml.kernel.org/r/20250926222305.110103-1-phillip@squashfs.org.uk
Link: https://lkml.kernel.org/r/20250926215935.107233-1-phillip@squashfs.org.uk
Fixes: 6545b246a2c8 ("Squashfs: inode operations")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Reported-by: syzbot+f754e01116421e9754b9@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68d580e5.a00a0220.303701.0019.GAE@google.com/
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/squashfs/inode.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/squashfs/inode.c
+++ b/fs/squashfs/inode.c
@@ -193,6 +193,10 @@ int squashfs_read_inode(struct inode *in
 			goto failed_read;
 
 		inode->i_size = le64_to_cpu(sqsh_ino->file_size);
+		if (inode->i_size < 0) {
+			err = -EINVAL;
+			goto failed_read;
+		}
 		frag = le32_to_cpu(sqsh_ino->fragment);
 		if (frag != SQUASHFS_INVALID_FRAG) {
 			/*


