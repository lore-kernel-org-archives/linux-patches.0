Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74B231748;
	Fri, 24 Nov 2023 19:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CZ1puY1/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C19A7C433C8;
	Fri, 24 Nov 2023 19:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852666;
	bh=m5a/meUkL75YEI1xbfGvc63PUGUFfCG09qvEuE+tIXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CZ1puY1/FwiFDER7isU7mSOFVRGoec5f76bo7x40K9S9yodFdtQmNSnZoUInYnlMt
	 1VMeyleP1Y89Vd835tlxdg5Q2gYpETf5cocjFSo3T+6C5UrQXUsUlnClet6HDcqcvn
	 PLhqBQ5EHam2Xr/pi7vNXfiuYWBPhMqej2BKZK8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 075/193] ptp: annotate data-race around q->head and q->tail
Date: Fri, 24 Nov 2023 17:53:22 +0000
Message-ID: <20231124171950.235012028@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171947.127438872@linuxfoundation.org>
References: <20231124171947.127438872@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 73bde5a3294853947252cd9092a3517c7cb0cd2d ]

As I was working on a syzbot report, I found that KCSAN would
probably complain that reading q->head or q->tail without
barriers could lead to invalid results.

Add corresponding READ_ONCE() and WRITE_ONCE() to avoid
load-store tearing.

Fixes: d94ba80ebbea ("ptp: Added a brand new class driver for ptp clocks.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Link: https://lore.kernel.org/r/20231109174859.3995880-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_chardev.c | 3 ++-
 drivers/ptp/ptp_clock.c   | 5 +++--
 drivers/ptp/ptp_private.h | 8 ++++++--
 drivers/ptp/ptp_sysfs.c   | 3 ++-
 4 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
index af3bc65c4595d..9311f3d09c8fc 100644
--- a/drivers/ptp/ptp_chardev.c
+++ b/drivers/ptp/ptp_chardev.c
@@ -487,7 +487,8 @@ ssize_t ptp_read(struct posix_clock *pc,
 
 	for (i = 0; i < cnt; i++) {
 		event[i] = queue->buf[queue->head];
-		queue->head = (queue->head + 1) % PTP_MAX_TIMESTAMPS;
+		/* Paired with READ_ONCE() in queue_cnt() */
+		WRITE_ONCE(queue->head, (queue->head + 1) % PTP_MAX_TIMESTAMPS);
 	}
 
 	spin_unlock_irqrestore(&queue->lock, flags);
diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index 21c4c34c52d8d..ed766943a3563 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -55,10 +55,11 @@ static void enqueue_external_timestamp(struct timestamp_event_queue *queue,
 	dst->t.sec = seconds;
 	dst->t.nsec = remainder;
 
+	/* Both WRITE_ONCE() are paired with READ_ONCE() in queue_cnt() */
 	if (!queue_free(queue))
-		queue->head = (queue->head + 1) % PTP_MAX_TIMESTAMPS;
+		WRITE_ONCE(queue->head, (queue->head + 1) % PTP_MAX_TIMESTAMPS);
 
-	queue->tail = (queue->tail + 1) % PTP_MAX_TIMESTAMPS;
+	WRITE_ONCE(queue->tail, (queue->tail + 1) % PTP_MAX_TIMESTAMPS);
 
 	spin_unlock_irqrestore(&queue->lock, flags);
 }
diff --git a/drivers/ptp/ptp_private.h b/drivers/ptp/ptp_private.h
index 6b97155148f11..d2cb956706763 100644
--- a/drivers/ptp/ptp_private.h
+++ b/drivers/ptp/ptp_private.h
@@ -55,9 +55,13 @@ struct ptp_clock {
  * that a writer might concurrently increment the tail does not
  * matter, since the queue remains nonempty nonetheless.
  */
-static inline int queue_cnt(struct timestamp_event_queue *q)
+static inline int queue_cnt(const struct timestamp_event_queue *q)
 {
-	int cnt = q->tail - q->head;
+	/*
+	 * Paired with WRITE_ONCE() in enqueue_external_timestamp(),
+	 * ptp_read(), extts_fifo_show().
+	 */
+	int cnt = READ_ONCE(q->tail) - READ_ONCE(q->head);
 	return cnt < 0 ? PTP_MAX_TIMESTAMPS + cnt : cnt;
 }
 
diff --git a/drivers/ptp/ptp_sysfs.c b/drivers/ptp/ptp_sysfs.c
index 8cd59e8481631..8d52815e05b31 100644
--- a/drivers/ptp/ptp_sysfs.c
+++ b/drivers/ptp/ptp_sysfs.c
@@ -78,7 +78,8 @@ static ssize_t extts_fifo_show(struct device *dev,
 	qcnt = queue_cnt(queue);
 	if (qcnt) {
 		event = queue->buf[queue->head];
-		queue->head = (queue->head + 1) % PTP_MAX_TIMESTAMPS;
+		/* Paired with READ_ONCE() in queue_cnt() */
+		WRITE_ONCE(queue->head, (queue->head + 1) % PTP_MAX_TIMESTAMPS);
 	}
 	spin_unlock_irqrestore(&queue->lock, flags);
 
-- 
2.42.0



