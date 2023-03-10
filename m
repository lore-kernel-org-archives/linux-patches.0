Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E260846C
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:33:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C62EC433EF;
	Fri, 10 Mar 2023 14:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458780;
	bh=yf1V2yYku1Tb2D38hbQzvy58pR0jhpqtt7MShKtSbEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HlicrhXUuC/nxKDNSvV8hjAQXNRS4LR6QDh7qRk/PnwF+YKlavtwOejQEj/2uOJAP
	 KLfi73WJFEuEVqr1mk4T0y498xS9tu6b0qCi2OlDmy7BubGwaah/J2WwFndg03xZ3I
	 jJ4WNxUvMB/5EQqui4DPFLN7KWYijh8bGIoEEiGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 142/357] gfs2: jdata writepage fix
Date: Fri, 10 Mar 2023 14:37:11 +0100
Message-Id: <20230310133740.959202477@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
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
index b9fe975d7625a..c21383fab33b7 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -156,7 +156,6 @@ static int __gfs2_jdata_writepage(struct page *page, struct writeback_control *w
 {
 	struct inode *inode = page->mapping->host;
 	struct gfs2_inode *ip = GFS2_I(inode);
-	struct gfs2_sbd *sdp = GFS2_SB(inode);
 
 	if (PageChecked(page)) {
 		ClearPageChecked(page);
@@ -164,7 +163,7 @@ static int __gfs2_jdata_writepage(struct page *page, struct writeback_control *w
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



