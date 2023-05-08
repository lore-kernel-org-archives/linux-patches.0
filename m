Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62DEA171A8
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:39:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B903BC433D2;
	Mon,  8 May 2023 11:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545944;
	bh=KJ0IC0PncwL+PAkObK0Z38OkBdsCIxLXCcd4aSjOX2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KY82o0V5wF+W6GBpOUDwfzZgpiOrTrAp5jJY0Y4PNg3/Mx33Od9Qe2tssQc5uf3Ut
	 ZNf+86J7lhKpZuVcUVjQx41MsbAhNLugcKLAQ1+NE9J5GNz6FY2d3v5SrDFGw8Ktrx
	 xWUSW/tx3cT4sNLzAzqT4+giJyCNnDwd/bPh8QEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 206/371] md/raid10: fix task hung in raid10d
Date: Mon,  8 May 2023 11:46:47 +0200
Message-Id: <20230508094820.255592567@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Li Nan <linan122@huawei.com>

[ Upstream commit 72c215ed8731c88b2d7e09afc51fffc207ae47b8 ]

commit fe630de009d0 ("md/raid10: avoid deadlock on recovery.") allowed
normal io and sync io to exist at the same time. Task hung will occur as
below:

T1                      T2		T3		T4
raid10d
 handle_read_error
  allow_barrier
   conf->nr_pending--
    -> 0
                        //submit sync io
                        raid10_sync_request
                         raise_barrier
			  ->will not be blocked
			  ...
			//submit to drivers
  raid10_read_request
   wait_barrier
    conf->nr_pending++
     -> 1
					//retry read fail
					raid10_end_read_request
					 reschedule_retry
					  add to retry_list
					  conf->nr_queued++
					   -> 1
							//sync io fail
							end_sync_read
							 __end_sync_read
							  reschedule_retry
							   add to retry_list
					                    conf->nr_queued++
							     -> 2
 ...
 handle_read_error
 get form retry_list
 conf->nr_queued--
  freeze_array
   wait nr_pending == nr_queued+1
        ->1	      ->2
   //task hung

retry read and sync io will be added to retry_list(nr_queued->2) if they
fails. raid10d() called handle_read_error() and hung in freeze_array().
nr_queued will not decrease because raid10d is blocked, nr_pending will
not increase because conf->barrier is not released.

Fix it by moving allow_barrier() after raid10_read_request().
raise_barrier() will wait for nr_waiting to become 0. Therefore, sync io
and regular io will not be issued at the same time.

Also remove the check of nr_queued in stop_waiting_barrier. It can be 0
but don't need to be blocking. Remove the check for MD_RECOVERY_RUNNING as
the check is redundent.

Fixes: fe630de009d0 ("md/raid10: avoid deadlock on recovery.")
Signed-off-by: Li Nan <linan122@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20230222041000.3341651-2-linan666@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid10.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 31ecb080851ac..4bf09ecedec14 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -970,11 +970,15 @@ static bool stop_waiting_barrier(struct r10conf *conf)
 	    (!bio_list_empty(&bio_list[0]) || !bio_list_empty(&bio_list[1])))
 		return true;
 
-	/* move on if recovery thread is blocked by us */
-	if (conf->mddev->thread->tsk == current &&
-	    test_bit(MD_RECOVERY_RUNNING, &conf->mddev->recovery) &&
-	    conf->nr_queued > 0)
+	/*
+	 * move on if io is issued from raid10d(), nr_pending is not released
+	 * from original io(see handle_read_error()). All raise barrier is
+	 * blocked until this io is done.
+	 */
+	if (conf->mddev->thread->tsk == current) {
+		WARN_ON_ONCE(atomic_read(&conf->nr_pending) == 0);
 		return true;
+	}
 
 	return false;
 }
@@ -2954,9 +2958,13 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
 		md_error(mddev, rdev);
 
 	rdev_dec_pending(rdev, mddev);
-	allow_barrier(conf);
 	r10_bio->state = 0;
 	raid10_read_request(mddev, r10_bio->master_bio, r10_bio);
+	/*
+	 * allow_barrier after re-submit to ensure no sync io
+	 * can be issued while regular io pending.
+	 */
+	allow_barrier(conf);
 }
 
 static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
-- 
2.39.2



