Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42FFA1D7E5C;
	Sat, 12 Sep 2026 14:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224962; cv=none; b=fsbaO8aHkK9eXRMRxpVNRHXkbgcqu6ZKgE/RyO0y1M6+01Vo/BfCtskkoWeeNaafK758GXPknVHHSN2M0JaMWvjLHSOJZ4SNJOh/yUjHNpJJ8vMNX2hOTUKVAx4z0gTyIzPqT1VMJOAThwF36Si3k2PyGJrQj4xSZeSxJaCW5Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224962; c=relaxed/simple;
	bh=KoiMeLV13xicvlUtb7NAnQiwLoEEiY+af8hHtfHE0iI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CH7//RXY0wKzof3USBq3uMBIdwsjTVbQiEnV59h8CnczQYceMmeBmI2D2j/L10eYc/41Ye7n4iqlYcpTYzm8WZ7ezlvBw+Bg5Dl5QlGvG87E/yKxGqqXTMhiKQue1o9RaIMyVn4SUTzYwiW1rwlEg/r/rO2EX7fMps3NCglUXow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uKe2uCzM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uKe2uCzM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89DBC1F000FF;
	Sat, 12 Sep 2026 14:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224958;
	bh=mVKRwu8foB7R+kY504VNhUnfY5kfypNTW5+pMddSHVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uKe2uCzMqNFoGlHHQXqOqTBR8bJSpgwr+CZQWYRRLXp9M7K8Q0NfyILGUqLSm/SlQ
	 Ta4bC/Zt84nQWihQRAUTaKcsUqoNehtSue/uK/uQjBN1Oz+LuQCiIR9r39jUKzvAVx
	 FxZK+F0z7xHVq5HkHLgwZ7qK84ID/YWCt69UXtYg=
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
Subject: [PATCH 6.6 1101/1424] hugetlbfs: release subpool on fill_super failure
Date: Sat, 12 Sep 2026 08:58:53 +0200
Message-ID: <20260912065631.961324512@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 914e850b9cbb7..9bc9f04e4b7a6 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -1553,7 +1553,8 @@ hugetlbfs_fill_super(struct super_block *sb, struct fs_context *fc)
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



