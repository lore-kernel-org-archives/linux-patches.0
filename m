Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3209D26988E;
	Tue,  8 Apr 2025 12:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115914; cv=none; b=SHD/2W9U4xPrGaT62zBbj/Lym5TeiZXFwyjyVlrY3cb0aSrS7h0DODJKtFE0IW7mMfDbtJEtGDRxwtSXYXt+i2ZwN1yik/0TKFdPYPjrUib/shuy4yAgR9JhZ2FSMjRcD8zxQJ/g/G4fB38apUMIiwjcdbX/kVPanCnafs1IlSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115914; c=relaxed/simple;
	bh=QvApcgbBH6rV17OYrLTL7TqVl1ORpIrsbIrN6EjnryQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dqED2YQe2X8Mzjl1lEw47pq92acWph4vpv+aqQ7cZP98Vtzibt55K8MkY7/e37sExVUF4KhuD+vuePmcFRJYA2ZtP6UvbnGDEuZ/sPT17rAa5l10VSuIvboxFrd44cvA6bsWSUxIi1isV1Th2mqdpl4HMrhDY/WnLcARYvFcFUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QB1uzGMb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QB1uzGMb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B421AC4CEE5;
	Tue,  8 Apr 2025 12:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115914;
	bh=QvApcgbBH6rV17OYrLTL7TqVl1ORpIrsbIrN6EjnryQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QB1uzGMbSHVk/aG5jLukZ3UfXXbEu3VIKkObAnbnK9aegoWK0eeGwm5AVBvH+r2tI
	 ot5xB213gcIFKVVm4qFpZuGIe2SZu6/vlu+sZLkMww8eeEId5EP0qwU24uspjWfRpr
	 bgdQzNtL3WfD+QcB6entVG7y5tCOtc3acy00dgV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 150/204] spufs: fix a leak in spufs_create_context()
Date: Tue,  8 Apr 2025 12:51:20 +0200
Message-ID: <20250408104824.702899884@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 79d45fa599002..d11951586e1f8 100644
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



