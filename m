Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8610978C9C;
	Sat, 12 Sep 2026 12:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217474; cv=none; b=Wakt3e8pug/vN1/ZFBl2KDu4mFZSUYj3Wz/GldPP4H4TuEU1Af4g2lcOFd1iRbfrikUmX2GY2j9cATjJLx9AJ8d0RUCNlFGv6g8EU3LZ3HLXRHYqMK3A3yyj7aXFMCyJZl0aOuQk2BNx+r4i15OgUeeF+SJAhCNcQAExzv1gevg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217474; c=relaxed/simple;
	bh=kRzCssO6+QyhdOTs63A2QTYAoyDyoS3vk4QBRYAwlFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RX7WTOMGnzQxaReoudykm3s64YhlqCErdoRrcpM6M782NPGrKAfw+qCv5LeMFXKufGLUSUNO/7CrWfuxtVynIBk+H6axHnKwLtg4TQdBHlX96fmgwsuCQnsYumku5z4kN9PtIOL38Z3NWdY9T5A39TPFmOH4OJze88Z859z3q0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=heAariq8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="heAariq8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E58D1F000FF;
	Sat, 12 Sep 2026 12:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217473;
	bh=xM2ewyCKdXejgN1ghYNEeqPYxQrbGa6n4HmrsZUnEZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=heAariq8sg+DyjEjMAstILB7+tky7H0DAcO/l69eqTJZixOTj3tynU1KF7zAZ5Xt0
	 Fx1B+75/ZYgQ+//f9J4wgGzfTskVdGuVPfvo4Llt/Xl94HWfJ5AP3wdlC/KMFfygrX
	 SDlbN+hrsTBhzP2SXhVKTYLvZ8SDCNXz2FNyGIPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0948/1376] hugetlbfs: release subpool on fill_super failure
Date: Sat, 12 Sep 2026 08:56:14 +0200
Message-ID: <20260912065628.689028755@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yichong Chen <chenyichong@uniontech.com>

[ Upstream commit 308ab73e97c87bd0e142b11758faab7f88d82854 ]

hugetlbfs_fill_super() allocates a hugepage subpool when size or min_size
mount options are specified.  hugepage_new_subpool() may also reserve huge
pages for min_size.

If root dentry creation fails after the subpool is created, the failure
path frees the subpool with kfree().  This bypasses hugepage_put_subpool()
and can leave min_size reservations charged.

Use hugepage_put_subpool() on the failure path, matching the normal
put_super path.

Link: https://lore.kernel.org/20260720021900.1376309-1-chenyichong@uniontech.com
Fixes: 7ca02d0ae586 ("hugetlbfs: accept subpool min_size mount option and setup accordingly")
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hugetlbfs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index b0c3b4399a793..734eb08bafc92 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -1506,7 +1506,8 @@ hugetlbfs_fill_super(struct super_block *sb, struct fs_context *fc)
 		goto out_free;
 	return 0;
 out_free:
-	kfree(sbinfo->spool);
+	if (sbinfo->spool)
+		hugepage_put_subpool(sbinfo->spool);
 	kfree(sbinfo);
 	return -ENOMEM;
 }
-- 
2.53.0



