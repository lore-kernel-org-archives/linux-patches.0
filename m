Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CBA9350A16;
	Tue, 16 Dec 2025 11:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886197; cv=none; b=FvIhtjzFaicT/Wbv3F3btWslVZa328Aox255eKDJnWDNzz9117nLVW78ztO9ICzIf3g4w8cQVOg6FZ7SOOzzO9sflpOg+vK9W4+Mg9lc+SU2WXnXGUV0y57SPpN/qc7/YHN7cUIo3Q2kTK8Z6rsimd1KoLaGjPWfw7hQ8EU7bHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886197; c=relaxed/simple;
	bh=/emM/ADLYByNQ/++KkY5p8U6a8prWyOU2glwlZvHMog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s7pJr+rU/bx5MTzG7HDOjFrhtWv26zGr+v9ZzhM2JLPDf6Uz3sAPcqaIkM1RwqLRppSOkzUQEQigoOjJurPflrXNtA9k0p/FiCDmfdX/gb3lJx45UoQ11JwiZBW3u4v3UZNfRE7LoueqhVkJ6Mugdbqf3UKizWfbWNzyGADA5to=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NLsJ5x5Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NLsJ5x5Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F24EBC4CEF1;
	Tue, 16 Dec 2025 11:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886197;
	bh=/emM/ADLYByNQ/++KkY5p8U6a8prWyOU2glwlZvHMog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NLsJ5x5YItRelwcvqV3JdSk3EP4YYydeBbjXUajAXbDm60/oZorg1XaUcfKAm56rA
	 mMTCE6zFQ2Lcc0oeoZlPXhPlQ/io4GfiPiIV5D8zjBHDoYMMk11rAm1zRzdVKOe8Rf
	 VWmXVjNz/mtc4g3fMFv012bv2uKo/MPZReq3LnJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Rosenberg <olrose55@gmail.com>,
	Will Rosenberg <whrosenb@asu.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 367/507] kernfs: fix memory leak of kernfs_iattrs in __kernfs_new_node
Date: Tue, 16 Dec 2025 12:13:28 +0100
Message-ID: <20251216111358.754182559@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Rosenberg <whrosenb@asu.edu>

[ Upstream commit 382b1e8f30f779af8d6d33268e53df7de579ef3c ]

There exists a memory leak of kernfs_iattrs contained as an element
of kernfs_node allocated in __kernfs_new_node(). __kernfs_setattr()
allocates kernfs_iattrs as a sub-object, and the LSM security check
incorrectly errors out and does not free the kernfs_iattrs sub-object.

Make an additional error out case that properly frees kernfs_iattrs if
security_kernfs_init_security() fails.

Fixes: e19dfdc83b60 ("kernfs: initialize security of newly created nodes")
Co-developed-by: Oliver Rosenberg <olrose55@gmail.com>
Signed-off-by: Oliver Rosenberg <olrose55@gmail.com>
Signed-off-by: Will Rosenberg <whrosenb@asu.edu>
Link: https://patch.msgid.link/20251125151332.2010687-1-whrosenb@asu.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/kernfs/dir.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index a670ba3e565e0..5c0efd6b239f6 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -675,11 +675,14 @@ static struct kernfs_node *__kernfs_new_node(struct kernfs_root *root,
 	if (parent) {
 		ret = security_kernfs_init_security(parent, kn);
 		if (ret)
-			goto err_out3;
+			goto err_out4;
 	}
 
 	return kn;
 
+ err_out4:
+	simple_xattrs_free(&kn->iattr->xattrs, NULL);
+	kmem_cache_free(kernfs_iattrs_cache, kn->iattr);
  err_out3:
 	spin_lock(&root->kernfs_idr_lock);
 	idr_remove(&root->ino_idr, (u32)kernfs_ino(kn));
-- 
2.51.0



