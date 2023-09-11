Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1863D11706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:46:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 901A9C433C7;
	Mon, 11 Sep 2023 14:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443570;
	bh=4iWla1tvlViRHH/dQeCQJS+IUdK6uw/MBQj4edbr8uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y71zJ5wRyiBKOVjqaPYdV8w2kFGGEIFgtkBS0VGDgoBVhKfC0tqhHLU7PZX5twOav
	 YA0ZtXByYvLGFeHjYE6fKyUdTF2aMrj/PX7WqiGNBc2fQzJ09oVh6WUSk2kv42/EDM
	 z6gGjmhAfatmCIWSDAXwNctlEjtfBa/A5q4w5Zu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Corey Hickey <bugfood-ml@fatooh.org>
Subject: [PATCH 6.4 395/737] md/raid5-cache: fix null-ptr-deref for r5l_flush_stripe_to_raid()
Date: Mon, 11 Sep 2023 15:44:14 +0200
Message-ID: <20230911134701.630589094@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 0d0bd28c500173bfca78aa840f8f36d261ef1765 ]

r5l_flush_stripe_to_raid() will check if the list 'flushing_ios' is
empty, and then submit 'flush_bio', however, r5l_log_flush_endio()
is clearing the list first and then clear the bio, which will cause
null-ptr-deref:

T1: submit flush io
raid5d
 handle_active_stripes
  r5l_flush_stripe_to_raid
   // list is empty
   // add 'io_end_ios' to the list
   bio_init
   submit_bio
   // io1

T2: io1 is done
r5l_log_flush_endio
 list_splice_tail_init
 // clear the list
			T3: submit new flush io
			...
			r5l_flush_stripe_to_raid
			 // list is empty
			 // add 'io_end_ios' to the list
			 bio_init
 bio_uninit
 // clear bio->bi_blkg
			 submit_bio
			 // null-ptr-deref

Fix this problem by clearing bio before clearing the list in
r5l_log_flush_endio().

Fixes: 0dd00cba99c3 ("raid5-cache: fully initialize flush_bio when needed")
Reported-and-tested-by: Corey Hickey <bugfood-ml@fatooh.org>
Closes: https://lore.kernel.org/all/cddd7213-3dfd-4ab7-a3ac-edd54d74a626@fatooh.org/
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5-cache.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 5c246b2697e0b..21653e1ed9384 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -1260,14 +1260,13 @@ static void r5l_log_flush_endio(struct bio *bio)
 
 	if (bio->bi_status)
 		md_error(log->rdev->mddev, log->rdev);
+	bio_uninit(bio);
 
 	spin_lock_irqsave(&log->io_list_lock, flags);
 	list_for_each_entry(io, &log->flushing_ios, log_sibling)
 		r5l_io_run_stripes(io);
 	list_splice_tail_init(&log->flushing_ios, &log->finished_ios);
 	spin_unlock_irqrestore(&log->io_list_lock, flags);
-
-	bio_uninit(bio);
 }
 
 /*
-- 
2.40.1



