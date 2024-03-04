Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D497A706;
	Mon,  4 Mar 2024 21:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588646; cv=none; b=UqGvwEpNZdwRhskqwqpHj81wO5ehtVQPvDJc82Ubv/8bARPsN394sxd6660cl9FGjDw4R6FhG49htPj66lUJJ4RA54RcCNDydvs/XTiv4QzbaT+Xm574+//TDqE+jI0TuGyJ8WGYokeKKTwSftI4qzqECxZbJ/+gyhh1LBtZ9s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588646; c=relaxed/simple;
	bh=cZErp8feoudr9ZXJw1B7wnRbjMBU72DcdbLHXYqJ6Q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K5Lh3t4SfWHO6lCW2hEcKH2keMUFQltPGWNQ3b4/dH5gWejR7pAQhu8f+p5X9/z4jvJcSyUsAaWTR+TAdJ0YWlk1JwrJb3JHorgv+IYVeTQFKmpDa8bSqfouWITjdu1WuSJNNbq+TYg/zAB/4Qn1pMgWdjEoAZF5/+5GEaKNhkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mmJarOr0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mmJarOr0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BBE4C433C7;
	Mon,  4 Mar 2024 21:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588646;
	bh=cZErp8feoudr9ZXJw1B7wnRbjMBU72DcdbLHXYqJ6Q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mmJarOr0lIdpSSnFOyn4YF0ETte0jleXPRGQ6rX2+7JkYxiy4Xv99n6zKfmSiE7jH
	 hw3/k46tFmgCVGpOYJEHGt9TrJJMz0u+iFfYAArq8w2FiLU+qy1isIHf0kjAgXlwHO
	 O/a+0+0GLkWAY30pC5873bFeWCjmsfT0Fh/zZ+ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia-Ju Bai <baijiaju1990@gmail.com>,
	TOTE Robot <oslab@tsinghua.edu.cn>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 019/215] fs/ntfs3: Fix a possible null-pointer dereference in ni_clear()
Date: Mon,  4 Mar 2024 21:21:22 +0000
Message-ID: <20240304211557.610324346@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit ec275bf9693d19cc0fdce8436f4c425ced86f6e7 ]

In a previous commit c1006bd13146, ni->mi.mrec in ni_write_inode()
could be NULL, and thus a NULL check is added for this variable.

However, in the same call stack, ni->mi.mrec can be also dereferenced
in ni_clear():

ntfs_evict_inode(inode)
  ni_write_inode(inode, ...)
    ni = ntfs_i(inode);
    is_rec_inuse(ni->mi.mrec) -> Add a NULL check by previous commit
  ni_clear(ntfs_i(inode))
    is_rec_inuse(ni->mi.mrec) -> No check

Thus, a possible null-pointer dereference may exist in ni_clear().
To fix it, a NULL check is added in this function.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/frecord.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index bb7e33c240737..1f0e230ec9e2c 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -102,7 +102,7 @@ void ni_clear(struct ntfs_inode *ni)
 {
 	struct rb_node *node;
 
-	if (!ni->vfs_inode.i_nlink && is_rec_inuse(ni->mi.mrec))
+	if (!ni->vfs_inode.i_nlink && ni->mi.mrec && is_rec_inuse(ni->mi.mrec))
 		ni_delete_all(ni);
 
 	al_destroy(ni);
-- 
2.43.0



