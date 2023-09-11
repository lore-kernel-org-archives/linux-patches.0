Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F091170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:23:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D513EC433C7;
	Mon, 11 Sep 2023 14:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442232;
	bh=V5raUm+Y2RlbgNj8FgDk8KNQeFbvgQ17mZJq0imrvfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zo+i0V72TruIZjp5ZpfosgHsAuDy4wDSkorMypvB+TkUxp3CmTvXtw9z9BgzNkpXe
	 fh0bV+1V0gUeiE/Dya/JGRS4HJ2vx1gEGxGHaaLhUSw6xVf0hHyY0anRoxmdYju5LX
	 UU+YOU46gKbebPfN/6IPcLvYIEjJBlzzIOKfdV3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.5 692/739] block: fix pin count management when merging same-page segments
Date: Mon, 11 Sep 2023 15:48:11 +0200
Message-ID: <20230911134710.426463256@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

commit 5905afc2c7bb713d52c7c7585565feecbb686b44 upstream.

There is no need to unpin the added page when adding it to the bio fails
as that is done by the loop below.  Instead we want to unpin it when adding
a single page to the bio more than once as bio_release_pages will only
unpin it once.

Fixes: d1916c86ccdc ("block: move same page handling from __bio_add_pc_page to the callers")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20230905124731.328255-1-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-map.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -315,12 +315,11 @@ static int bio_map_user_iov(struct reque
 					n = bytes;
 
 				if (!bio_add_hw_page(rq->q, bio, page, n, offs,
-						     max_sectors, &same_page)) {
-					if (same_page)
-						bio_release_page(bio, page);
+						     max_sectors, &same_page))
 					break;
-				}
 
+				if (same_page)
+					bio_release_page(bio, page);
 				bytes -= n;
 				offs = 0;
 			}


