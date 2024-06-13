Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7096114534A;
	Thu, 13 Jun 2024 12:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281237; cv=none; b=hg6oXpSAZpYafNFXw2iATkf0z/AGlJE8G9YIb38KX6WNRHzNEjyD5S5sX0meVOskCMQCupkyrb9VovYMFtzlbsDHtsaR6pXkbpgD6wOb0FyAFS7pmNxScia8Kb2HcxfDRwOtZZsw5cgvrfDm5x/nb+pgKVeRQcleaiUlpC3PlJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281237; c=relaxed/simple;
	bh=2Jm6dmX6Sk0ekd6vPDtH/ipJ2R35RFC7FzEt2VQFaqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KkPWtP0r+uJltEj5EEWZVwvhYkw7NhyrszlXucVPfY5fuNdgP2nlfOO093hRemwVvACThFBZI5xNwcioqiUgUC6aB/4aV3fZAkEs5eyutlyU2Xehmb/6qb9Mm9WxLf/p3srfiR+oxfFDwcZUzk4wXjUoocJRRdiMr6wpVjxYnsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=buOxKwE+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="buOxKwE+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 834A0C2BBFC;
	Thu, 13 Jun 2024 12:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281236;
	bh=2Jm6dmX6Sk0ekd6vPDtH/ipJ2R35RFC7FzEt2VQFaqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=buOxKwE+ZsKEg4Ns87ZvGRvuxFufmzP8uZN+I6AjFs8thRWMfaWKHDjsrAs7bni34
	 JJhd3FtcFN4VOTDHDBbefkVKHq7sCp/eIbVFUkL02mTX+HAWPABefQHdlotl8wRrcm
	 yckv94Vl/wpHdINNMSsYZlKRt2LWL/lWsoSTJPOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 186/317] f2fs: fix to release node block count in error path of f2fs_new_node_page()
Date: Thu, 13 Jun 2024 13:33:24 +0200
Message-ID: <20240613113254.754116679@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 0fa4e57c1db263effd72d2149d4e21da0055c316 ]

It missed to call dec_valid_node_count() to release node block count
in error path, fix it.

Fixes: 141170b759e0 ("f2fs: fix to avoid use f2fs_bug_on() in f2fs_new_node_page()")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/node.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 02cb1c806c3ed..348ad1d6199ff 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1242,6 +1242,7 @@ struct page *f2fs_new_node_page(struct dnode_of_data *dn, unsigned int ofs)
 	}
 	if (unlikely(new_ni.blk_addr != NULL_ADDR)) {
 		err = -EFSCORRUPTED;
+		dec_valid_node_count(sbi, dn->inode, !ofs);
 		set_sbi_flag(sbi, SBI_NEED_FSCK);
 		goto fail;
 	}
@@ -1267,7 +1268,6 @@ struct page *f2fs_new_node_page(struct dnode_of_data *dn, unsigned int ofs)
 	if (ofs == 0)
 		inc_valid_inode_count(sbi);
 	return page;
-
 fail:
 	clear_node_page_dirty(page);
 	f2fs_put_page(page, 1);
-- 
2.43.0



