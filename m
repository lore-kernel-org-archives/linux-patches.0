Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E63AB847F
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 13:57:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57813C4339B;
	Fri, 10 Mar 2023 13:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456652;
	bh=RArpjnMwBEs2DGsdQt7WJGIw0o6vGKWNLAO1rlw9TuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VUOn7OuZ0StgItS7ldvDFidrbfaI4pK7rZUtFrRENQbWyCfe7DItJgkdKcBOvEBsX
	 Uqs3GYhk9Pu6ZXY7ZEzUxdARa/myKT5+B9Up15X1GPXChZoUuY/6U6yFKD2dXQeGAZ
	 Mf2feSVzqPsQWGRPSvzJddQQFpg4GGtE1PNWqzdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 046/211] f2fs: fix to update age extent correctly during truncation
Date: Fri, 10 Mar 2023 14:37:06 +0100
Message-Id: <20230310133720.139568610@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chao Yu <chao@kernel.org>

[ Upstream commit 8c0ed062ce27f6b7f0a568cb241e2b4dd2d9e6a6 ]

nr_free may be less than len, we should update age extent cache
w/ range [fofs, len] rather than [fofs, nr_free].

Fixes: 71644dff4811 ("f2fs: add block_age-based extent cache")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 63d468b1a9b82..cd1c6ed89d5ef 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -619,7 +619,7 @@ void f2fs_truncate_data_blocks_range(struct dnode_of_data *dn, int count)
 		fofs = f2fs_start_bidx_of_node(ofs_of_node(dn->node_page),
 							dn->inode) + ofs;
 		f2fs_update_read_extent_cache_range(dn, fofs, 0, len);
-		f2fs_update_age_extent_cache_range(dn, fofs, nr_free);
+		f2fs_update_age_extent_cache_range(dn, fofs, len);
 		dec_valid_block_count(sbi, dn->inode, nr_free);
 	}
 	dn->ofs_in_node = ofs;
-- 
2.39.2



