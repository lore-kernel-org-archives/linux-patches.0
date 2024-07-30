Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED431B5831;
	Tue, 30 Jul 2024 15:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722354815; cv=none; b=i9acevf34XfpATB5YDfToJTHPh4xSPHk80+sEWBImO8rbyBDd/bKhbHABXzqUi/25jT2oWbe3lT0voc9vnfwD05UbvBm5dkdzL6YlVpisR73e5LQ7Oe06VBkkeu7pxVLTb5AX1JpWD7u305fFbVAoBzRDj03JWVNl8Is/U08RXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722354815; c=relaxed/simple;
	bh=01jojIx2AnvQEPlSOtnMgoMi27hQsVse/zCf3pEwmsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PNynUPQWKzYvpevBVRyxgfgEtA/jc28n/PS35RrixQroUy3YuJqCFLCOp2OGy6J/5mfMrIlRuwRMmkT1Icdc09bxn9C0T2SnKo35i8awytq/t8pphqSY2vi66KhLBfUrQrx28lsdpHfzeW8cWO2Efa346L0V1ft6P7AziSJEtQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hy8u8JMg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hy8u8JMg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF7D1C4AF0A;
	Tue, 30 Jul 2024 15:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722354814;
	bh=01jojIx2AnvQEPlSOtnMgoMi27hQsVse/zCf3pEwmsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hy8u8JMgPmtRdP9glH2w0HMqhTdaJsBJQGAaUETYeRC0cUXvW+B4LWRn+qPvYtWv+
	 czwHdJ/DZI/oK+dM9T2e9bHAKy1VI7eGOT4Hf2GnglnkZqVlMOTD2gLDH2vzW0UbHL
	 YstyrIWAZh9Q2l6iL0RXpOBgkbUv5nE4UArMnBDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 005/440] md: fix deadlock between mddev_suspend and flush bio
Date: Tue, 30 Jul 2024 17:43:58 +0200
Message-ID: <20240730151615.971212510@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

From: Li Nan <linan122@huawei.com>

[ Upstream commit 611d5cbc0b35a752e657a83eebadf40d814d006b ]

Deadlock occurs when mddev is being suspended while some flush bio is in
progress. It is a complex issue.

T1. the first flush is at the ending stage, it clears 'mddev->flush_bio'
    and tries to submit data, but is blocked because mddev is suspended
    by T4.
T2. the second flush sets 'mddev->flush_bio', and attempts to queue
    md_submit_flush_data(), which is already running (T1) and won't
    execute again if on the same CPU as T1.
T3. the third flush inc active_io and tries to flush, but is blocked because
    'mddev->flush_bio' is not NULL (set by T2).
T4. mddev_suspend() is called and waits for active_io dec to 0 which is inc
    by T3.

  T1		T2		T3		T4
  (flush 1)	(flush 2)	(third 3)	(suspend)
  md_submit_flush_data
   mddev->flush_bio = NULL;
   .
   .	 	md_flush_request
   .	  	 mddev->flush_bio = bio
   .	  	 queue submit_flushes
   .		 .
   .		 .		md_handle_request
   .		 .		 active_io + 1
   .		 .		 md_flush_request
   .		 .		  wait !mddev->flush_bio
   .		 .
   .		 .				mddev_suspend
   .		 .				 wait !active_io
   .		 .
   .		 submit_flushes
   .		 queue_work md_submit_flush_data
   .		 //md_submit_flush_data is already running (T1)
   .
   md_handle_request
    wait resume

The root issue is non-atomic inc/dec of active_io during flush process.
active_io is dec before md_submit_flush_data is queued, and inc soon
after md_submit_flush_data() run.
  md_flush_request
    active_io + 1
    submit_flushes
      active_io - 1
      md_submit_flush_data
        md_handle_request
        active_io + 1
          make_request
        active_io - 1

If active_io is dec after md_handle_request() instead of within
submit_flushes(), make_request() can be called directly intead of
md_handle_request() in md_submit_flush_data(), and active_io will
only inc and dec once in the whole flush process. Deadlock will be
fixed.

Additionally, the only difference between fixing the issue and before is
that there is no return error handling of make_request(). But after
previous patch cleaned md_write_start(), make_requst() only return error
in raid5_make_request() by dm-raid, see commit 41425f96d7aa ("dm-raid456,
md/raid456: fix a deadlock for dm-raid456 while io concurrent with
reshape)". Since dm always splits data and flush operation into two
separate io, io size of flush submitted by dm always is 0, make_request()
will not be called in md_submit_flush_data(). To prevent future
modifications from introducing issues, add WARN_ON to ensure
make_request() no error is returned in this context.

Fixes: fa2bbff7b0b4 ("md: synchronize flush io with array reconfiguration")
Signed-off-by: Li Nan <linan122@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20240525185257.3896201-3-linan666@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 506c998c0ca59..7dc1c42accccd 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -527,13 +527,9 @@ static void md_end_flush(struct bio *bio)
 
 	rdev_dec_pending(rdev, mddev);
 
-	if (atomic_dec_and_test(&mddev->flush_pending)) {
-		/* The pair is percpu_ref_get() from md_flush_request() */
-		percpu_ref_put(&mddev->active_io);
-
+	if (atomic_dec_and_test(&mddev->flush_pending))
 		/* The pre-request flush has finished */
 		queue_work(md_wq, &mddev->flush_work);
-	}
 }
 
 static void md_submit_flush_data(struct work_struct *ws);
@@ -564,12 +560,8 @@ static void submit_flushes(struct work_struct *ws)
 			rcu_read_lock();
 		}
 	rcu_read_unlock();
-	if (atomic_dec_and_test(&mddev->flush_pending)) {
-		/* The pair is percpu_ref_get() from md_flush_request() */
-		percpu_ref_put(&mddev->active_io);
-
+	if (atomic_dec_and_test(&mddev->flush_pending))
 		queue_work(md_wq, &mddev->flush_work);
-	}
 }
 
 static void md_submit_flush_data(struct work_struct *ws)
@@ -594,8 +586,20 @@ static void md_submit_flush_data(struct work_struct *ws)
 		bio_endio(bio);
 	} else {
 		bio->bi_opf &= ~REQ_PREFLUSH;
-		md_handle_request(mddev, bio);
+
+		/*
+		 * make_requst() will never return error here, it only
+		 * returns error in raid5_make_request() by dm-raid.
+		 * Since dm always splits data and flush operation into
+		 * two separate io, io size of flush submitted by dm
+		 * always is 0, make_request() will not be called here.
+		 */
+		if (WARN_ON_ONCE(!mddev->pers->make_request(mddev, bio)))
+			bio_io_error(bio);;
 	}
+
+	/* The pair is percpu_ref_get() from md_flush_request() */
+	percpu_ref_put(&mddev->active_io);
 }
 
 /*
-- 
2.43.0



