Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585458;
	b=SgoaVVtymeIaSLgMva493TImX2jrJu9lo95CGBWL0Rxmjku/oTDAGVxAFO2bar9zr/wH
	 cV+DAA4L7ZjjHWGxsSw84X61hvP0udGDRplz2Uz0wr74WxxCjt/avixBpx9fK3C1X7odY
	 R+BFOBc73lPkLWyQBSoraynN85ZCNB+sfRIVnDtURJrA/anLoXu2AwgIxdTkIGvU0i8Y9
	 H0RaAmDSlRgt6B/zLeU6OoOWKocGJ3rbhx2XJcrnm6FGJkroluToBMsLpGSWkQzuLZTj1
	 E4IZV+bxmquyYBMAIbthyndY3wr7vzmLH8R1Abe/JsCbRbJ3R22BCndvnI0XAMBtg0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585458;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WNHoRWdabqPWC0pJnEpZUXhKKxadrF54syBXmqw2Y0s=;
	b=TDaRMJrTvGb75hV7aGD/87sa0aWUmHRcRoJiuIPFG9DpvR7VCv6k2Fzz9V4HYQq3pjBU
	 RnGQkbkLjAkfjUQbP6zk4WcpqqLkYHLRkQU9MlSHITAEGCmRrJWwCzmk0OHyvPROQNVcD
	 RHzQkIyWmZCq3Az0JLaBxpgoxo2VVFwFHqRVJ05EhkBEvUOyPMZmJnfsycO7avZmGmnjx
	 0Irc4OiEyTJNMufnPB62Qr3YWZnY8HAk4+OIcGULognNiv7s4lcUS/oN+KO8C/1khwqHQ
	 q/G2XFOQNyx6YEAoyiDAe9Xjco3w7X8Z1eb6aDGd2IC1Z3SdlNU6tSB0KkcPBQY0uIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GqFrzsVY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA5260A6F43;
	Fri, 13 Nov 2026 15:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GqFrzsVY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD53A1F000C7;
	Fri, 13 Nov 2026 15:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585458;
	bh=WNHoRWdabqPWC0pJnEpZUXhKKxadrF54syBXmqw2Y0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GqFrzsVYBWNIHYYYHmhXunaIxUtiGAAFUMIMRKnaOLTuC/BkscDuZ8yADrG4oLlzM
	 wHsTQWe/JR3939LOZsqCzq+FArVWfNvtBinWOw2WSpNpc3VpwRq8Jmub8iiZQIY5E+
	 r31FVqXZPuNy295SciJtiaUTxAsY7JmfVZohyLgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Zhang <yuz08559@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 098/507] ptp: fix use-after-free in extts_fifo_show() reading tsevqs unlocked
Date: Fri, 13 Nov 2026 10:46:42 -0500
Message-ID: <20261113153757.475466658@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index dc398c6b75284..7d09256aca724 100644
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



