Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401C1267F6E;
	Tue,  8 Apr 2025 11:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113548; cv=none; b=JqyXQYlq6ukJfTjkWuKOusuG1jiBd0YQ2VjIQ9b0SndYaMiUAe+OTcnAYzQWpc/T/OdrG0g/4SBuAYEsBH6SNZfXrFqb1nbKtgfD2IUmqDt/p6ffsW2KZz8h6XfupgSIJLhn8Hu8UTlG2BtWQSgkYsNV76WkapvqlfBMWypQc5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113548; c=relaxed/simple;
	bh=r69GEiJZHxXjeNY90hUv7aE7fsQcqdjFH/MX9Jbnams=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kARUyANNkjcw1ZQFNWE2xuLNXBR8+retz/lwY3FKNoTeowL0DCY6AfXCTL6/8++7rp7y/hSrGyOrKDWgGaGmUIlWFHz4ztTpI8ubQ9Wfy4Bm1jGNfI4ub9BpIvBC2naANyesbnEJm+pP5pjq47AHGAtYvpw7EMqE5ydlXMyt5c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sCu/CXUa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sCu/CXUa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2FF8C4CEE7;
	Tue,  8 Apr 2025 11:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113548;
	bh=r69GEiJZHxXjeNY90hUv7aE7fsQcqdjFH/MX9Jbnams=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sCu/CXUaqSgIzo7QczjRLFpk3TXI8sj2cX9fjjPKmXykPcdfim1i8K9ltidF/AAgA
	 3mMP5yVTTgjbDeb6ZAQr5KmwXkHCtKX6V6fxlLVtQUsCcXzejrgPDbgs9U5Kh0c3jQ
	 X0pE54mvVRg/ZH5oLBGJ1eKA+MPxp+CPrcfG8hQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 193/268] spufs: fix a leak in spufs_create_context()
Date: Tue,  8 Apr 2025 12:50:04 +0200
Message-ID: <20250408104833.762376891@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 0f5cce3fc55b08ee4da3372baccf4bcd36a98396 ]

Leak fixes back in 2008 missed one case - if we are trying to set affinity
and spufs_mkdir() fails, we need to drop the reference to neighbor.

Fixes: 58119068cb27 "[POWERPC] spufs: Fix memory leak on SPU affinity"
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/cell/spufs/inode.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/cell/spufs/inode.c b/arch/powerpc/platforms/cell/spufs/inode.c
index a0f297581a66c..3216245a648ae 100644
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -459,8 +459,11 @@ spufs_create_context(struct inode *inode, struct dentry *dentry,
 	}
 
 	ret = spufs_mkdir(inode, dentry, flags, mode & 0777);
-	if (ret)
+	if (ret) {
+		if (neighbor)
+			put_spu_context(neighbor);
 		goto out_aff_unlock;
+	}
 
 	if (affinity) {
 		spufs_set_affinity(flags, SPUFS_I(d_inode(dentry))->i_ctx,
-- 
2.39.5



