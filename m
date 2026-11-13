Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591039;
	b=pv5CfVuVGJ1XKGbK0CnSjXq9gBOkWJKZKmxAAbBw0zqaYfqzGltCV3EV80PTmvqk0W5W
	 o62mATtgyogFU6w/hvgjw1J0/YNImucxm8vlnB5YYO026qBrCJDJw+CRHr5emeijHZXAp
	 jrM/+TxEUUtEeKXAFNVAw9kbW27Vb64DfEKfLdHo7Uuk5TRlGr6HACRv7+lX2AeWH4Jos
	 rdRxkB6usKLlxBpHU9FvcObLcLudorub1JvpajMoJBAgg9kgIjNmRSA7RmoUA9McPa1y7
	 awxEjT+FLFy3cBQKuNkEQQUfyxBIqFD1d1IL6E91uIiunEQJGsMJZu+KhPiJEstt1QA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591039;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U+VNO65F85KSJplptdEXIaFvXcIWyWkGpQldrm8z0Vc=;
	b=u2vNIfxzWQ4C59vmSycGxCSA1i37VUWsmh1b94XJ6iFt8Hvb2GPWZrkJ6Sqcy0t3kkyB
	 RKD4i/ah1mS5OUVkEXkOUvEU0huJA5ppVUa6pW78/zrWtT+tYWKlGL5+fLa3Hw6LrC7P6
	 ExM9iRi/3yPc7xDkWGQfBzYdIcjIeZpWst2b5dXx8+0DUikHA+pYw2WaoBCnOX5BHXMmh
	 CVMyTrXPYtzkaCVfhYeMN81LmHH1ED4KGWfEcqWhyOi1IA8tL7YjGILlE65RnFNGZifXu
	 zx3wyQw/irruYfu/2d7PBz1WUCv4hJXgOS1dFYGiiF6+MFhhVJQrc/x7pDZ83TzO7jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IzNUO82b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99169606B80D;
	Fri, 13 Nov 2026 17:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IzNUO82b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45A531F000C7;
	Fri, 13 Nov 2026 17:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591039;
	bh=U+VNO65F85KSJplptdEXIaFvXcIWyWkGpQldrm8z0Vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IzNUO82bph42MXuuoSBoz6Z3ndZlNu1h+z1TGX806HsfqB5sG5+hm+Ll9fPw0S2DT
	 UMC6ojnsxQWF+dNwqv4zqB5veghZZYxEc9fy2ujqLdII1G6WU3H4doIXvDvNSu1Gu1
	 9PZdGfmNEWOEf2SztQw0qvKdwzM/gwEMxOxTaVQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Zhang <yuz08559@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 205/670] ptp: fix use-after-free in extts_fifo_show() reading tsevqs unlocked
Date: Fri, 13 Nov 2026 10:46:09 -0500
Message-ID: <20261113153818.898141907@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



