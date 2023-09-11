Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EEFC11710
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:13:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C461BC433C7;
	Mon, 11 Sep 2023 15:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445193;
	bh=9ST8rcdcm1JAA7jxHTrocRqQDUZebiHSse6nzldbRqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2uBRG89WFhDa3DwQoVe6CpF1WQ8EbVDwqk8jy1IYsLrAKd5HmWnxB2dmvgjWA8JW+
	 6jxMf/xuvAaGpH1BcfoPAi/2Dfo0g2ED+wu7AwVGsuZ4hVtR3I76PpvRKvroDXHaOZ
	 AZbOtr2TiRNc0v4TBUjHjgqS1EFer1OZZ731l6FY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 261/600] block: cleanup queue_wc_store
Date: Mon, 11 Sep 2023 15:44:54 +0200
Message-ID: <20230911134641.311619554@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit c4e21bcd0f9d01f9c5d6c52007f5541871a5b1de ]

Get rid of the local queue_wc_store variable and handling setting and
clearing the QUEUE_FLAG_WC flag diretly instead the if / else if.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20230707094239.107968-2-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 43c9835b144c ("block: don't allow enabling a cache on devices that don't support it")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-sysfs.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index e71b3b43927c0..4f34525bafac7 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -528,21 +528,13 @@ static ssize_t queue_wc_show(struct request_queue *q, char *page)
 static ssize_t queue_wc_store(struct request_queue *q, const char *page,
 			      size_t count)
 {
-	int set = -1;
-
 	if (!strncmp(page, "write back", 10))
-		set = 1;
+		blk_queue_flag_set(QUEUE_FLAG_WC, q);
 	else if (!strncmp(page, "write through", 13) ||
 		 !strncmp(page, "none", 4))
-		set = 0;
-
-	if (set == -1)
-		return -EINVAL;
-
-	if (set)
-		blk_queue_flag_set(QUEUE_FLAG_WC, q);
-	else
 		blk_queue_flag_clear(QUEUE_FLAG_WC, q);
+	else
+		return -EINVAL;
 
 	return count;
 }
-- 
2.40.1



