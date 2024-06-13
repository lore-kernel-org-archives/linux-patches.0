Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F23144312;
	Thu, 13 Jun 2024 11:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278894; cv=none; b=NgJC760fg2ZjYQDfDhwGq16IPt3aqkAbLqZv04sUiJuNtjZiHYJsJpKEHkvvuASPLpHnJKus0mIM/zKbN5WVYTXLFIRbaTESDhTV2irH2Muv93MChWnKfWSdzXIBpdRLjidOecLUuR9dqDiISTlmWnfzbes9gBEHsh3MUsJfDb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278894; c=relaxed/simple;
	bh=HLXXSP1EqwXk6QWvvalUoLzfRD++Pkxo0+36aD/lDuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jKwdOPQUC3SMlzAEZGjAAaw+/2VdLziHrdjKsoC9zi7DE3XS0OJ73AocbOxoRdJSZg50v3RAUJxlHQrow/8GqduA/T7bbMeqzDmaEUQFHkRy5J7Ejwlu7eMAV4LBtK/ycD1OxbXTi0DzfR7W3vPgj9UVrcBd9QIvmYQhmWoSlKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VdkdAD9c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VdkdAD9c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87628C2BBFC;
	Thu, 13 Jun 2024 11:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278893;
	bh=HLXXSP1EqwXk6QWvvalUoLzfRD++Pkxo0+36aD/lDuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VdkdAD9c6PJHcO9X+lAOLrv1FmotWFMrkPcCbCeQiA4xjlBQxnTIy+Xdk/P/qGX7D
	 9UpJonHJSqkM9HhSpaFjA++TiDlZTBqXyB9fVw1sR1SJbrSyD7NVprvo0hvCPT4gYW
	 aN2T5dpzRFd740usiGtw/AEcnRKVFYuXtsrxs2dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 105/213] f2fs: fix to release node block count in error path of f2fs_new_node_page()
Date: Thu, 13 Jun 2024 13:32:33 +0200
Message-ID: <20240613113232.054903502@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 9911f780e0136..38a937bdcf8ba 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1236,6 +1236,7 @@ struct page *f2fs_new_node_page(struct dnode_of_data *dn, unsigned int ofs)
 	}
 	if (unlikely(new_ni.blk_addr != NULL_ADDR)) {
 		err = -EFSCORRUPTED;
+		dec_valid_node_count(sbi, dn->inode, !ofs);
 		set_sbi_flag(sbi, SBI_NEED_FSCK);
 		goto fail;
 	}
@@ -1261,7 +1262,6 @@ struct page *f2fs_new_node_page(struct dnode_of_data *dn, unsigned int ofs)
 	if (ofs == 0)
 		inc_valid_inode_count(sbi);
 	return page;
-
 fail:
 	clear_node_page_dirty(page);
 	f2fs_put_page(page, 1);
-- 
2.43.0



