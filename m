Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8194139FE1;
	Fri, 24 Nov 2023 17:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zIFf1xnh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9145C433C8;
	Fri, 24 Nov 2023 17:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700848733;
	bh=FjjdDm14ozEdMXMl0ZnQYUWAR2A0lGZX7X4eVi6s+2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zIFf1xnh7rkIS+Irzo7gSwf7kqe8VZvGok1KEgpgvkOyktjNpwg43lV1OqPneGStT
	 2a/UeMrcSsAXw06i5jn6gTg34Oz2h+Dxwud+knMItdV2txwDfuZQYtfnLRf9LN4msm
	 emXnQ6cLP5wtBJGpAC726IIFcWnxoEIM3k+sKljc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 42/97] ptp: annotate data-race around q->head and q->tail
Date: Fri, 24 Nov 2023 17:50:15 +0000
Message-ID: <20231124171935.718234728@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171934.122298957@linuxfoundation.org>
References: <20231124171934.122298957@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 796eeffdf93b1..8ff2dd5c52e64 100644
--- a/drivers/ptp/ptp_chardev.c
+++ b/drivers/ptp/ptp_chardev.c
@@ -346,7 +346,8 @@ ssize_t ptp_read(struct posix_clock *pc,
 
 	for (i = 0; i < cnt; i++) {
 		event[i] = queue->buf[queue->head];
-		queue->head = (queue->head + 1) % PTP_MAX_TIMESTAMPS;
+		/* Paired with READ_ONCE() in queue_cnt() */
+		WRITE_ONCE(queue->head, (queue->head + 1) % PTP_MAX_TIMESTAMPS);
 	}
 
 	spin_unlock_irqrestore(&queue->lock, flags);
diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index 89632cc9c28fc..1e92bd897aa45 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -68,10 +68,11 @@ static void enqueue_external_timestamp(struct timestamp_event_queue *queue,
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
index 05f6b6a9bbd58..1e02b5ae6127b 100644
--- a/drivers/ptp/ptp_private.h
+++ b/drivers/ptp/ptp_private.h
@@ -68,9 +68,13 @@ struct ptp_clock {
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
index f97a5eefa2e23..b9e2f08960688 100644
--- a/drivers/ptp/ptp_sysfs.c
+++ b/drivers/ptp/ptp_sysfs.c
@@ -91,7 +91,8 @@ static ssize_t extts_fifo_show(struct device *dev,
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



