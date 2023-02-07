Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 910B83212
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:03:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07BFCC433D2;
	Tue,  7 Feb 2023 13:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675774995;
	bh=KgPu11W9K9teAZpNvLupPUTrxwKuy9OLtdD/HC0mjhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eBcBoj4BW5SVL08IVmzLGWvh+R32+ZfgR82mYbn0PbgZY1iG170qHivsdV05/O94n
	 x9hCq4S4pmyCYFu3LV8zv1wtikC8w19/VRjo1U2eOmCiWcizzn2g1hTI2Gy13yKV0s
	 HxURmjhcYCMXYBn+Dq6rYiEcz/pfO+hPmj3JHGWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 102/208] Revert "gfs2: stop using generic_writepages in gfs2_ail1_start_one"
Date: Tue,  7 Feb 2023 13:55:56 +0100
Message-Id: <20230207125638.969726723@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
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

[ Upstream commit 95ecbd0f162fc06ef4c4045a66f653f47b62a2d3 ]

Commit b2b0a5e97855 switched from generic_writepages() to
filemap_fdatawrite_wbc() in gfs2_ail1_start_one() on the path to
replacing ->writepage() with ->writepages() and eventually eliminating
the former.  Function gfs2_ail1_start_one() is called from
gfs2_log_flush(), our main function for flushing the filesystem log.

Unfortunately, at least as implemented today, ->writepage() and
->writepages() are entirely different operations for journaled data
inodes: while the former creates and submits transactions covering the
data to be written, the latter flushes dirty buffers out to disk.

With gfs2_ail1_start_one() now calling ->writepages(), we end up
creating filesystem transactions while we are in the course of a log
flush, which immediately deadlocks on the sdp->sd_log_flush_lock
semaphore.

Work around that by going back to how things used to work before commit
b2b0a5e97855 for now; figuring out a superior solution will take time we
don't have available right now.  However ...

Since the removal of generic_writepages() is imminent, open-code it
here.  We're already inside a blk_start_plug() ...  blk_finish_plug()
section here, so skip that part of the original generic_writepages().

This reverts commit b2b0a5e978552e348f85ad9c7568b630a5ede659.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/log.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 723639376ae2..61323deb80bc 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -80,6 +80,15 @@ void gfs2_remove_from_ail(struct gfs2_bufdata *bd)
 	brelse(bd->bd_bh);
 }
 
+static int __gfs2_writepage(struct page *page, struct writeback_control *wbc,
+		       void *data)
+{
+	struct address_space *mapping = data;
+	int ret = mapping->a_ops->writepage(page, wbc);
+	mapping_set_error(mapping, ret);
+	return ret;
+}
+
 /**
  * gfs2_ail1_start_one - Start I/O on a transaction
  * @sdp: The superblock
@@ -131,7 +140,7 @@ __acquires(&sdp->sd_ail_lock)
 		if (!mapping)
 			continue;
 		spin_unlock(&sdp->sd_ail_lock);
-		ret = filemap_fdatawrite_wbc(mapping, wbc);
+		ret = write_cache_pages(mapping, wbc, __gfs2_writepage, mapping);
 		if (need_resched()) {
 			blk_finish_plug(plug);
 			cond_resched();
-- 
2.39.0



