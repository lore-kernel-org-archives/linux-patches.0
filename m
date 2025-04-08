Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B501B87CF;
	Tue,  8 Apr 2025 12:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114102; cv=none; b=DLMDdGEbTDzFFVBaZHdeAanntqNII6zatOa9zqEnMFOwua6tZMEDbn1ev506ZAajQZBtbUDDi2Cj+tScH0liW+9buYxsND9afap4ezGwgFNIoRRkKt5ICtBZgDn3yXEkaHsc0WKawlfP9VLqjFKyB55lFVHnyvRawnwMW0xTyjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114102; c=relaxed/simple;
	bh=5emjh1+X5ghxh3j/kqPwKxP9cQ2rC5qeD/KdUlJQH84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o/A+czuERATuNYOFPf9Do+oP/VlH3hNLfH6jy9xywSdCjsbBk5Qq7L9rr+I2JRlGdjREM3Qu3AZBKJ8C5Nle/oCc0sN7Of/nlMv3XAhqxNMoclWWiTAwjQLA6f7HVfHAsZuojIEtVTWq2x3uBORPbyPwljDUxgBVLoNT+YPI1v4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b8wU1i5Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b8wU1i5Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45546C4CEE5;
	Tue,  8 Apr 2025 12:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114102;
	bh=5emjh1+X5ghxh3j/kqPwKxP9cQ2rC5qeD/KdUlJQH84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b8wU1i5QYS+X+SUBhgLR2yP+vcc5MaczuZzf32QMoZz5q0HplqMZ4dNFrV5PoDI/L
	 rd6yXAkXJPpfyFOnfKJeexX5RI6zY6rU9wVxu4rhWIk8Q29t4QrqJqz/+yauNWbd9G
	 1ysvNI/eGUrrrkAVKMf6FRKiQeCKYZveYO5i5FxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 137/154] spufs: fix a leak in spufs_create_context()
Date: Tue,  8 Apr 2025 12:51:18 +0200
Message-ID: <20250408104819.705415933@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 1183e264ff421..93214d52ae82a 100644
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -440,8 +440,11 @@ spufs_create_context(struct inode *inode, struct dentry *dentry,
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



