Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A7C9443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:21:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D153C433C8;
	Sun, 13 Aug 2023 21:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691961675;
	bh=Fd7KJUSLDtnBgYo5wsJHZ9VQ1IseQeJlbUvTyLRDZkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PBUJ5QwzvwU++thXKK+ykhszmp5zTHerhexkvvmCiu+XjTenB+xcD6IJOXgoBrBbM
	 VrTU6wpGtzQaM7VKmyuybW47YfAbaGbOuXp92rhLh7Ga1xmpbg9wtBMgc/kRQ4OnRa
	 wK+I+88eG7OcGrq47LHzY3M+QNTz8AF5oj23P5m8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 4.14 19/26] btrfs: dont stop integrity writeback too early
Date: Sun, 13 Aug 2023 23:19:12 +0200
Message-ID: <20230813211703.702861030@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211702.980427106@linuxfoundation.org>
References: <20230813211702.980427106@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

commit effa24f689ce0948f68c754991a445a8d697d3a8 upstream.

extent_write_cache_pages stops writing pages as soon as nr_to_write hits
zero.  That is the right thing for opportunistic writeback, but incorrect
for data integrity writeback, which needs to ensure that no dirty pages
are left in the range.  Thus only stop the writeback for WB_SYNC_NONE
if nr_to_write hits 0.

This is a port of write_cache_pages changes in commit 05fe478dd04e
("mm: write_cache_pages integrity fix").

Note that I've only trigger the problem with other changes to the btrfs
writeback code, but this condition seems worthwhile fixing anyway.

CC: stable@vger.kernel.org # 4.14+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Sterba <dsterba@suse.com>
[ updated comment ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent_io.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3884,11 +3884,12 @@ retry:
 			free_extent_buffer(eb);
 
 			/*
-			 * the filesystem may choose to bump up nr_to_write.
+			 * The filesystem may choose to bump up nr_to_write.
 			 * We have to make sure to honor the new nr_to_write
-			 * at any time
+			 * at any time.
 			 */
-			nr_to_write_done = wbc->nr_to_write <= 0;
+			nr_to_write_done = (wbc->sync_mode == WB_SYNC_NONE &&
+					    wbc->nr_to_write <= 0);
 		}
 		pagevec_release(&pvec);
 		cond_resched();


