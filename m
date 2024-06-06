Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0220198E9C;
	Thu,  6 Jun 2024 14:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682948; cv=none; b=PZoBfFEkIhOfdglXJUtJigiXZuC08ENUNNIK4M1CRFlHv9EPlc9eyavmLl1fxeDnxyDoOothNUGc7sQpso1+eORjSfl2QnS0FAj3btnueXjxWjtATsGr9jfyFohVHjG6Y6uokXTYuU06qWQ+yvE9qq5MQcNi0HF7qjsN2lisOWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682948; c=relaxed/simple;
	bh=J/SMp1S8G4XySj1w5sn9WHnYtZv0vhREu2a+uX44flY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ir+0RbowtksxjmUeco4A1EgiYDOXlFQW0Z6Izc2h/hi4uBN2gEz5R7Vk/hNuF38ZBj7sjhs7QZNNoPyUIbu9tQstb+XBF/2imE+JUtEsafwyG4k+ARwLUgi6GJ1uqCTGm4cDmlSDF0B4f1GvTgMrX8d9pevcYF23a5aeZQ8dfC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rCW6gNa1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rCW6gNa1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C06F2C32781;
	Thu,  6 Jun 2024 14:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682947;
	bh=J/SMp1S8G4XySj1w5sn9WHnYtZv0vhREu2a+uX44flY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rCW6gNa1T0FsuWgOCMd2gEcvi8cqLV/s19gstCM6cT6z7Rllmk/0+U2WuvpKRhpbW
	 +E/LwEEO9yCiSwqYkmGgFLdsHpFNiqvPetUSPc6A4tyuWNZVwsLDcJY1feuE7KsZRf
	 d2LoCdTfquVkS8wI4bFovDx3KGR/Uj9Wy+ItM30A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 110/374] f2fs: fix to release node block count in error path of f2fs_new_node_page()
Date: Thu,  6 Jun 2024 16:01:29 +0200
Message-ID: <20240606131655.605484455@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index b3de6d6cdb021..7df5ad84cb5ea 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1319,6 +1319,7 @@ struct page *f2fs_new_node_page(struct dnode_of_data *dn, unsigned int ofs)
 	}
 	if (unlikely(new_ni.blk_addr != NULL_ADDR)) {
 		err = -EFSCORRUPTED;
+		dec_valid_node_count(sbi, dn->inode, !ofs);
 		set_sbi_flag(sbi, SBI_NEED_FSCK);
 		f2fs_handle_error(sbi, ERROR_INVALID_BLKADDR);
 		goto fail;
@@ -1345,7 +1346,6 @@ struct page *f2fs_new_node_page(struct dnode_of_data *dn, unsigned int ofs)
 	if (ofs == 0)
 		inc_valid_inode_count(sbi);
 	return page;
-
 fail:
 	clear_node_page_dirty(page);
 	f2fs_put_page(page, 1);
-- 
2.43.0



