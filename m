Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A848489
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:19:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FBD2C433EF;
	Fri, 10 Mar 2023 14:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457979;
	bh=ka/l1E7Xb5eepuaRspzFHO4Koi0TqXwHvIGE4Ytu3/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EUuDOna21bk0icGKRip0pm5wjR/rZHSlEd4BckCvygA0q9BkIz/8UG7SadRNJ+4/U
	 i1rMI89lG8TK6gJNQ66mYN9F/dMJjJQkuQzjeyB+TCCNjYu7sIMl1JKOEvmXBKMGgr
	 3fN90o6rk8/ABFC9+7U8PkJs9RGPSHKWmpnYTntE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 093/252] gfs2: jdata writepage fix
Date: Fri, 10 Mar 2023 14:37:43 +0100
Message-Id: <20230310133721.635984421@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit cbb60951ce18c9b6e91d2eb97deb41d8ff616622 ]

The ->writepage() and ->writepages() operations are supposed to write
entire pages.  However, on filesystems with a block size smaller than
PAGE_SIZE, __gfs2_jdata_writepage() only adds the first block to the
current transaction instead of adding the entire page.  Fix that.

Fixes: 18ec7d5c3f43 ("[GFS2] Make journaled data files identical to normal files on disk")
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/aops.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 31e8270d0b266..c5390421cca29 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -179,7 +179,6 @@ static int __gfs2_jdata_writepage(struct page *page, struct writeback_control *w
 {
 	struct inode *inode = page->mapping->host;
 	struct gfs2_inode *ip = GFS2_I(inode);
-	struct gfs2_sbd *sdp = GFS2_SB(inode);
 
 	if (PageChecked(page)) {
 		ClearPageChecked(page);
@@ -187,7 +186,7 @@ static int __gfs2_jdata_writepage(struct page *page, struct writeback_control *w
 			create_empty_buffers(page, inode->i_sb->s_blocksize,
 					     BIT(BH_Dirty)|BIT(BH_Uptodate));
 		}
-		gfs2_page_add_databufs(ip, page, 0, sdp->sd_vfs->s_blocksize);
+		gfs2_page_add_databufs(ip, page, 0, PAGE_SIZE);
 	}
 	return gfs2_write_full_page(page, gfs2_get_block_noalloc, wbc);
 }
-- 
2.39.2



