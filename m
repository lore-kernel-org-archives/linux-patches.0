Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5765344059;
	Tue, 16 Dec 2025 12:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888152; cv=none; b=IuP2+SJvsiUJA0Yn74Het2PNRM/tWmO79l2Hck0JgNI1i7PlVm+CtSyHwHevrKmXY3h0VUCXry2rWdxR+kZQSbMRTPZPc7c52U/2qmSFBeAuCBtBI/tCJm3mydVkT9xAWkJZ7e6xUz54jR3LUbMmat+aJN+hwG+T7MuHSFKqvNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888152; c=relaxed/simple;
	bh=PfYao538m0sTLRlApZYSz+WQpZO4g/NfaajT3Q9uiOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s8sG+yqYymACCwutwz52dLwDDZ6R+yxug3kAtUXU2hqLS8JT+Ru4XIrDksIUJmsjhdwNAeRCqHHZOuHyQIBtW3BzIgKGm/QhfWVQOB4YgtqOlz+bGZ/L9o/QBIbOizav1JpX7Fli2OIjY+45RP0vS8ETaigAEE8VGNZPjGXEeuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yw9g/vmz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yw9g/vmz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D48D1C4CEF1;
	Tue, 16 Dec 2025 12:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888152;
	bh=PfYao538m0sTLRlApZYSz+WQpZO4g/NfaajT3Q9uiOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yw9g/vmzT8P1ijb7FJdcXGc+tohm3jO91muH4IasQByyR+0lu3C736Lku/BfrZnH1
	 y938TTuH5jnTrb9sSYRYvS8pH49W4FPkk9sGOfnNLOGWppD4ZGix8PclW6bIz1TZM/
	 ItMRM5AwL9GI25Tlc6HD0XYGgCwrlsDx9w/K0eAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Rosenberg <olrose55@gmail.com>,
	Will Rosenberg <whrosenb@asu.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 447/614] kernfs: fix memory leak of kernfs_iattrs in __kernfs_new_node
Date: Tue, 16 Dec 2025 12:13:34 +0100
Message-ID: <20251216111417.567991274@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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



