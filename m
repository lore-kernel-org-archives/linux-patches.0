Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932C326B2B5;
	Tue,  8 Apr 2025 12:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115118; cv=none; b=vC9eQRqcAXpEvY6zMY1yoWXJPI5jFUQ0SH0p69LlREDyv0dmaYMD7TX/RjEFSbqHEKvrXkPJW5HF3pDxazpu4Hloy/J8fQ7ASwYmDBD0BmEFSs5qWhJPULFmDgzTbfqLzU54DRLKz2Ez4xVOFcDX1mwX7MD7ZhgKMsRE5g6QJnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115118; c=relaxed/simple;
	bh=Nl+uBCnhE/AVymn+Amq+GJFVtbruHblMuhPsX0K7XbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mzuVtKCosO6viswcQMQ5Raon4iPKn1cLnxxZwSzk8pPKjH9+kzbN9uPliJv5Qt1g+bwuMd9qsss0C4/8PsPd5x7uWebaF8EOgGWg1MkunhBtl7KRREi30h/si55nJQkFPVljIjnwG98EgFncO3FMmYRcvGSlzPDnaos+srItcwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vt7M9+GM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vt7M9+GM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26552C4CEE5;
	Tue,  8 Apr 2025 12:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115118;
	bh=Nl+uBCnhE/AVymn+Amq+GJFVtbruHblMuhPsX0K7XbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vt7M9+GMvmbHFJwHkzWgcsFf+aRTOXUwTc/t3TM/J8/DeBJg56dFtlksktz/G7Z2E
	 DSWoJ+TY2TXeSH4XsetCrieZ3DY5ajgqFPkWnNcQ4B7yL8pGgvybK0buNiIHFKWzBA
	 FOuv4RRj7pi3HQqs/NqpsBRBkOxqNKJfFNmQsMik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 356/499] spufs: fix a leak in spufs_create_context()
Date: Tue,  8 Apr 2025 12:49:28 +0200
Message-ID: <20250408104900.112026996@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index c566e7997f2c1..9f9e4b8716278 100644
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -460,8 +460,11 @@ spufs_create_context(struct inode *inode, struct dentry *dentry,
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



