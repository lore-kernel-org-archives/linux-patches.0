Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 325A81482F5;
	Thu, 13 Jun 2024 12:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280086; cv=none; b=Hgzv30/d4E034rY8yhMSPPPPpoGHppKbm89EyKDZ/i9TJ2PviDBRaX9qFRRIYNEUwGEtuGJBYMZvubeWTLYqCqa0bT6Z6m2i87pGXyYKXZQmq1bJPTTGxz7uZaXpsMJmMMdCD6Xz2/qlxQXaZWYxF6ICcEjWcb7BC5D74vSCKUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280086; c=relaxed/simple;
	bh=2kEd5YV+PzS2IsUcw+Vv5yK7igNy9PR4vRyXOt7zA8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cb3Y1cten4gGg+F51GB3cg2xm+cx137ptopFBcqCgBhn5Sa9SkogeK9V7K7sVo6zL+eQiVVOSywwPe59nKp1goP7nOQElNGadrg38H3MsN1gTyBwPSxg3VlCH9Noq9ifaaLFbLmukCg/TpNUX9EF5pyh6rfErgxMEItItoXd24U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EirnrXXF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EirnrXXF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9E8FC4AF1A;
	Thu, 13 Jun 2024 12:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280086;
	bh=2kEd5YV+PzS2IsUcw+Vv5yK7igNy9PR4vRyXOt7zA8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EirnrXXFMRhaAI+NauA8o1gYscqbvKgfokrf7+V+knhqIajExggwusEAX8mJzGUWG
	 +0Vk8eZ19f/uyNgqS3TRMk2xSE00rSUarpkosoIdy8birMvzFT621BxiX8xKuWTqFQ
	 ErpxoT0UgFCLkV7n5BycTAKev8V7RoclnWT64CTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 120/202] f2fs: fix to release node block count in error path of f2fs_new_node_page()
Date: Thu, 13 Jun 2024 13:33:38 +0200
Message-ID: <20240613113232.393343882@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 8256a2dedae8c..d629b3c6546c8 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1244,6 +1244,7 @@ struct page *f2fs_new_node_page(struct dnode_of_data *dn, unsigned int ofs)
 	}
 	if (unlikely(new_ni.blk_addr != NULL_ADDR)) {
 		err = -EFSCORRUPTED;
+		dec_valid_node_count(sbi, dn->inode, !ofs);
 		set_sbi_flag(sbi, SBI_NEED_FSCK);
 		goto fail;
 	}
@@ -1269,7 +1270,6 @@ struct page *f2fs_new_node_page(struct dnode_of_data *dn, unsigned int ofs)
 	if (ofs == 0)
 		inc_valid_inode_count(sbi);
 	return page;
-
 fail:
 	clear_node_page_dirty(page);
 	f2fs_put_page(page, 1);
-- 
2.43.0



