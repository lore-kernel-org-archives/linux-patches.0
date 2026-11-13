Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590222;
	b=yIUkcFOh3fyVcECvfq0KXh8/nk9MeSEIM5swD+kXL62FFsIWg4B9XLjIR91TMt0uzmnS
	 prqTMI/vDUSOFymyIKMRIPZsXZpWxW+ZWmnNPmxWwofmKOp3TWqORW18uRAJAsI++4jxG
	 YuLKcD5/943G7KI7c7fKBb//tRcAZ9ABXBD/pAUJjN1YnkLRxxIS2m44YHxPZSspP8s12
	 WgB7w9Z0UvKS84ka4X5o8ycDKUJjXu3Kl5IGb7rw6BU+OK+FQ2vRbl4EAd8iyVxcjTyjE
	 PwYspXMowdMPwevzRA+wmBzPcvhQrZAN/IuouoaPNpplBAfoh9jpyIkPjLG+OdQy7oQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590222;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V3Tge/BnRO758fTYQlL9dALxrYuDUBnTmqGyx7tqavA=;
	b=jYaRr66hcm4ItzQEVzXcUozlWP6pvvcxqMKFiurfnuVp9m9CjWSqGm7g7uofKVODcBvi
	 4H64HZC7eO6xh1iuRAD1UeMm2acngECQDuIw00Y0e/vTuoiJCk6Dk4ybVlS4bKOoR0FIu
	 rHvOZSuvMnKUntX1f7Y4tgoAI9h47gc1ZLetUvDGV+coQ4B4AjyWFL4GAt3rjdwnzz6AJ
	 Gxx+WAM1xyjM8KNfsEo+qsTDvecH8pO/Wtj12D65HTfwLIiUuRTMN4L3XWK71ldvDuxqa
	 /qbuIUFNnC3AyWt8tvu0XRPfI1o+wHI0bPSBOpkQkHBM9VvTeqdvJ3Hk4sM5W3vhqVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EzY9IGnl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213BD606C08A;
	Fri, 13 Nov 2026 17:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EzY9IGnl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B174C1F000C4;
	Fri, 13 Nov 2026 17:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590222;
	bh=V3Tge/BnRO758fTYQlL9dALxrYuDUBnTmqGyx7tqavA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EzY9IGnlTDUloUoEQDTRYiZAMNlqqFP9six26V6n4OOUnMznxgCY3jTpKd4IlCie0
	 Gmaeh0/+368z/isucgM6nMSGwAY+7YsUH7tCxj6FnlOx3AwGfviQuPqXvABx751GRq
	 ehMB078pT4UkpKplQ3yNxQk/aEoBvofNT9m8Y1QE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Zhang <yuz08559@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 222/686] ptp: fix use-after-free in extts_fifo_show() reading tsevqs unlocked
Date: Fri, 13 Nov 2026 10:45:55 -0500
Message-ID: <20261113153828.552851594@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Zhang <yuz08559@gmail.com>

[ Upstream commit 603a0c40d414ea12509fc45f2b930449a8d4aad2 ]

extts_fifo_show() walks ptp->tsevqs with list_count_nodes() and then
list_first_entry() without holding ptp->tsevqs_lock, the spinlock that
"protects tsevqs from concurrent access". Every other accessor of the
list honours it: ptp_open() (list_add_tail), ptp_release() (list_del
followed by kfree of the per-fd queue), ptp_clock_release() and
ptp_clock_event() all take tsevqs_lock. extts_fifo_show() is the only
one that does not.

A per-fd timestamp queue is appended to tsevqs on open("/dev/ptpN") and
removed and freed on close(), both under tsevqs_lock:

	scoped_guard(spinlock_irq, &ptp->tsevqs_lock)
		list_del(&queue->qlist);
	bitmap_free(queue->mask);
	kfree(queue);

So a read of /sys/class/ptp/ptpN/fifo running concurrently with a
close() of a /dev/ptpN fd can have list_count_nodes() walk into the
queue that close() is removing and freeing, dereferencing freed memory
(use-after-free) or a poisoned list pointer.

Take tsevqs_lock around the list walk. The fifo only ever draws from the
first queue, which is the registration-time queue created in
ptp_clock_register() and freed only in ptp_clock_release(); that cannot
run while the sysfs attribute is being read, so the dequeue from
queue->buf under queue->lock may stay outside tsevqs_lock and the lock
order is unchanged.

Fixes: d26ab5a35ad9 ("ptp: Replace timestamp event queue with linked list")
Cc: stable@vger.kernel.org
Signed-off-by: Yu Zhang <yuz08559@gmail.com>
Link: https://patch.msgid.link/20261026100535.68114-1-yuz08559@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_sysfs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_sysfs.c b/drivers/ptp/ptp_sysfs.c
index 200eaf5006968..0d4b081daf639 100644
--- a/drivers/ptp/ptp_sysfs.c
+++ b/drivers/ptp/ptp_sysfs.c
@@ -80,13 +80,17 @@ static ssize_t extts_fifo_show(struct device *dev,
 	size_t qcnt;
 	int cnt = 0;
 
+	spin_lock_irqsave(&ptp->tsevqs_lock, flags);
 	cnt = list_count_nodes(&ptp->tsevqs);
-	if (cnt <= 0)
+	if (cnt <= 0) {
+		spin_unlock_irqrestore(&ptp->tsevqs_lock, flags);
 		goto out;
+	}
 
 	/* The sysfs fifo will always draw from the fist queue */
 	queue = list_first_entry(&ptp->tsevqs, struct timestamp_event_queue,
 				 qlist);
+	spin_unlock_irqrestore(&ptp->tsevqs_lock, flags);
 
 	memset(&event, 0, sizeof(event));
 	spin_lock_irqsave(&queue->lock, flags);
-- 
2.53.0



