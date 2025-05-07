Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDA71482F5;
	Wed,  7 May 2025 18:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644220; cv=none; b=jhptmSEVXKiK/U3GGgxu5ZeuXdo6B/2wcg7HYf61WM1vKbXAE31eIs/qimYLoWozyQALllDEKTzjMqDiIzTORcGIynPXr2Wwp4gnQe1oHpswfHKnqZXqCzImc9JyQTauJqC5eQbUBN5tzoB/gnuFzymqDJMZxXWi5+TV+3MKedk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644220; c=relaxed/simple;
	bh=V6uwmLLcmui3IWUTgvzwqs33c1UlCmqr743u0DlbhKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=We4aEd4CrbZ5+yuwgScGTM+/y57LQ2D7kcV0qo9JYHwjRIpAeA3a/6/+rfqdDPTPN8l2y8lX3/I/M3gGh/ZNQcYSlkFeASrO376+Hx4Us2tEhAsMUrVS4p8ELTju+0V76zJB5LMg3VjXncia4/axG6qSBnX5UGh2QkpGtD7tXB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=abW/wfnV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="abW/wfnV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA460C4CEE2;
	Wed,  7 May 2025 18:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644220;
	bh=V6uwmLLcmui3IWUTgvzwqs33c1UlCmqr743u0DlbhKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=abW/wfnVV1OeYD1to4MMV8+UL1uFiPKOSb9Q3+7t569G3bQRpZaD5frhJQVG+ZMr7
	 jWNyJVke3n2VrGFMitK/LMVZH4hkOHblew1OzGZFAzGcOb4p+WpeixFL7zr09kdABp
	 TDsGLiQsPbqyJIpGnsIIzUFmUOQ3Oaw09X/pkoUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uday Shankar <ushankar@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.14 158/183] ublk: remove __ublk_quiesce_dev()
Date: Wed,  7 May 2025 20:40:03 +0200
Message-ID: <20250507183831.269414049@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 736b005b413a172670711ee17cab3c8ccab83223 ]

Remove __ublk_quiesce_dev() and open code for updating device state as
QUIESCED.

We needn't to drain inflight requests in __ublk_quiesce_dev() any more,
because all inflight requests are aborted in ublk char device release
handler.

Also we needn't to set ->canceling in __ublk_quiesce_dev() any more
because it is done unconditionally now in ublk_ch_release().

Reviewed-by: Uday Shankar <ushankar@purestorage.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20250416035444.99569-7-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/ublk_drv.c |   19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -205,7 +205,6 @@ struct ublk_params_header {
 
 static void ublk_stop_dev_unlocked(struct ublk_device *ub);
 static void ublk_abort_queue(struct ublk_device *ub, struct ublk_queue *ubq);
-static void __ublk_quiesce_dev(struct ublk_device *ub);
 
 static inline unsigned int ublk_req_build_flags(struct request *req);
 static inline struct ublksrv_io_desc *ublk_get_iod(struct ublk_queue *ubq,
@@ -1558,7 +1557,8 @@ static int ublk_ch_release(struct inode
 		ublk_stop_dev_unlocked(ub);
 	} else {
 		if (ublk_nosrv_dev_should_queue_io(ub)) {
-			__ublk_quiesce_dev(ub);
+			/* ->canceling is set and all requests are aborted */
+			ub->dev_info.state = UBLK_S_DEV_QUIESCED;
 		} else {
 			ub->dev_info.state = UBLK_S_DEV_FAIL_IO;
 			for (i = 0; i < ub->dev_info.nr_hw_queues; i++)
@@ -1804,21 +1804,6 @@ static void ublk_wait_tagset_rqs_idle(st
 	}
 }
 
-static void __ublk_quiesce_dev(struct ublk_device *ub)
-{
-	int i;
-
-	pr_devel("%s: quiesce ub: dev_id %d state %s\n",
-			__func__, ub->dev_info.dev_id,
-			ub->dev_info.state == UBLK_S_DEV_LIVE ?
-			"LIVE" : "QUIESCED");
-	/* mark every queue as canceling */
-	for (i = 0; i < ub->dev_info.nr_hw_queues; i++)
-		ublk_get_queue(ub, i)->canceling = true;
-	ublk_wait_tagset_rqs_idle(ub);
-	ub->dev_info.state = UBLK_S_DEV_QUIESCED;
-}
-
 static void ublk_force_abort_dev(struct ublk_device *ub)
 {
 	int i;


