Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7A126B2B3;
	Tue,  8 Apr 2025 12:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116926; cv=none; b=pFX6mS7XL4+qg7DoOIrHp/BQLWb1pkN8SzQxihmayuyr445mIi/nj+kNGPgzlOxlaayyOrKSZOYZYwpVacwWbO2LxkZAvL4zuGWS0eTk//I9y3d9ZjRDVSvI/H4/rDWgJ8NgNl+sHiDRJpXezUSRxiJTwV7vFZVA+s7OkrUHgXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116926; c=relaxed/simple;
	bh=aRpjt59Eevt3/eyYEoWuVyvtqFBqrnyTvsyXkBR9k/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fWBjyrq8+H8jhVGKMUOVRvvXGXKmqUDdeovERb20fOCcwkrnjNHWSvVly2E1JiGcZTQ2LEuqdhkhcfWZqrs+/L0wH2sT0k94uQWbNJrTqVCTkCMxtUwvRWIsWYzgCCFTkcFFp/LmNkYYNFFWFBetoKoIP1sH/c2TEkekUpI3Yqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v5XhsnS8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v5XhsnS8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 504B9C4CEE5;
	Tue,  8 Apr 2025 12:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116926;
	bh=aRpjt59Eevt3/eyYEoWuVyvtqFBqrnyTvsyXkBR9k/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v5XhsnS8T7iUgR3+sqG04uFDVitEWgxKTLmDy4VJdjFG/5flMmv6pcMwlJQ8pViDI
	 IJLs/tlzA6D+1wUQ4otVcMnUiBEfz7vJF5Wutei4nYwS8XtAGIvLPSuuu5fGYVZFfO
	 B6FIhkggGgZp/CLYwwwSDwzYnKaanlALVtn2z3zQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 303/423] spufs: fix a leak in spufs_create_context()
Date: Tue,  8 Apr 2025 12:50:29 +0200
Message-ID: <20250408104852.852394513@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



