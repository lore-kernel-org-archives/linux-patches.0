Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F6A1EEE0;
	Thu, 13 Jun 2024 12:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282307; cv=none; b=igM2LNZiKiSy02lV3YlhZZa6I5CRqM0wkuS5VuUel0PDe7xOA8M7+k6fO+3rBskDwvRTa8YggiG5q2m4X6tnLCOXTfavsvL/SHGg736LGdMFfT0KqKNd/05iW0jF+IlZh/fsAZO0A04jz2XmUTTJcDF/NJwiMUzccV7zzsZRX8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282307; c=relaxed/simple;
	bh=avFnPYkHbMQkItqg/BsckRiDPorwVNBg2FvR/Ie/K14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fg0LkcdzKpCJY1wfAto6+3G8qqKn2RQsFoEHvz51YY5CniZvpwYVN4IDS/CpwYcfFOirUmrsqRcKbOT0OF6cFtqwo+vqF3kNKtGRwx/xh9plN3jBpQ179bFmu22kt9IE4iII8A+SP1RqHeFqb0EXFTAwcFrxv1c8ota3ukRNmuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J5og/RFJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J5og/RFJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0BF6C2BBFC;
	Thu, 13 Jun 2024 12:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282307;
	bh=avFnPYkHbMQkItqg/BsckRiDPorwVNBg2FvR/Ie/K14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J5og/RFJN/N+2OupkmMGwNp0VBYPNNoLNVhaVqnWn3w7BbwvvfMUN0PbhbzQ9mN74
	 ogaeGTRKmmfLJn96pTd3LJebFG7H5BJrsRObXukqPJiSMaDYawjMZnkisyZn06+bXa
	 TM6GkMM643tlfmukk5wNkUUj/8T1ExwB1PbS29XU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 233/402] f2fs: fix to release node block count in error path of f2fs_new_node_page()
Date: Thu, 13 Jun 2024 13:33:10 +0200
Message-ID: <20240613113311.232925663@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index dc85dd55314cc..b6758887540f2 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1300,6 +1300,7 @@ struct page *f2fs_new_node_page(struct dnode_of_data *dn, unsigned int ofs)
 	}
 	if (unlikely(new_ni.blk_addr != NULL_ADDR)) {
 		err = -EFSCORRUPTED;
+		dec_valid_node_count(sbi, dn->inode, !ofs);
 		set_sbi_flag(sbi, SBI_NEED_FSCK);
 		goto fail;
 	}
@@ -1325,7 +1326,6 @@ struct page *f2fs_new_node_page(struct dnode_of_data *dn, unsigned int ofs)
 	if (ofs == 0)
 		inc_valid_inode_count(sbi);
 	return page;
-
 fail:
 	clear_node_page_dirty(page);
 	f2fs_put_page(page, 1);
-- 
2.43.0



