Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0302B25FA29;
	Tue,  8 Apr 2025 11:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110172; cv=none; b=QQVSTRYFa1waMZm4+8egrMXJwjvGEt+bx6VDrbicXnSYpNQkha/p7cGLglS6/6CKtHjlI7E4abkXKFyJy5oQmE8HPKh1fCITG+D3OePl6fRa2V3A9tW6PtkG/J7b+UZ8vb3kRWB4G/LHHGhVbZYYf6aRaqr04xVLbUATRYzEMIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110172; c=relaxed/simple;
	bh=UAD8o8pkAgtv84PCh+Wy61sb0IvoChXw+EfiQvNaeZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PsOQY7Xojse0HlocmunVVL+oiU/0xiTxCsRnYck3Y3t/5pToHg5Aj+tGcwL7wEZXdlu8sO0GKq9G35MJXkEhzIJIXxz7BmGJijBzvOl1EebDr7WbE88B8DIOisDrrhnmjwvqIZU52J+NqijDHHZ/cQdCXmMA1YyoKmu24SpSZ74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dGEbugP1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dGEbugP1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86614C4CEE5;
	Tue,  8 Apr 2025 11:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110171;
	bh=UAD8o8pkAgtv84PCh+Wy61sb0IvoChXw+EfiQvNaeZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dGEbugP1XGdq15VgtWImn36+/qPe/zaW4bPtN/lWMc+eE9EFnWzD8zF4lsHEDWNhs
	 HWoGO4kqLnGm/bN6WTpdOBqCZOT5Ago0sM7mTO6czOxKzwLQHg9S+ASSIMqkBuSdk/
	 lBG7d+fGaW06GpmIVf97S6b3OrHKSszEfpiVSUQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 194/227] spufs: fix a leak in spufs_create_context()
Date: Tue,  8 Apr 2025 12:49:32 +0200
Message-ID: <20250408104826.117757843@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0159bd9231ef8..373814bbc43d7 100644
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -438,8 +438,11 @@ spufs_create_context(struct inode *inode, struct dentry *dentry,
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



