Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207895;
	b=j6/6u3ivBfV/IrTP8CCEuiWOKDh0XYH+XikhKHdDr+XJxstvqfglzT9ixawub61jGw0M
	 HrHQz23xtcsTNdd8KOKdlqhKbv4EWYizu7AKXBosCbWajzZ2FNJ4HSKDHvgLWjAuHmn5w
	 Ty47ieD3tBsXMKjjiKoSfiVp5EYyUOHfBWkBYgJ+6x9rQzscgsYReExverKwLfSj12zTI
	 dxyAkuStEf0/U3iqLbJ53bt1xbWt90HoLoWhNGT+qTxh+WXgtlX2lFBdOe8Px0Z8LA6+K
	 P8CR4xCII5hutQ5AmOdM44ZfL3JBDOgKoAZ4wBCbvVSSLNqdBLbhappJ9x14YRngFng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207895;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NE0Cx1P7NOEerEcTCQ3AJg/URrjYOXNsGCQbu/RB4sQ=;
	b=bC6MU7yuiZLgVdO1neY5JopfXgEGB3ZOKjYiE/WLvdMtTTK4LTZBL+cClk61LHVFaLD2
	 hB4laGAahU4PRDGrgBOnu1lZmNctCLoTX3DUbKTIBWrIRjieWm4xFcPl5/YrjE2m+J9ii
	 4d3mCSuPRKkqpayXrkGJ9ZlcCKZSkM+sbuPY4t9ZyPavILk0Cm5yw0sZm3T0neYsHP1++
	 adI1ItRavBg1DgacSwWyKrBpTIQu3PE2/zbHkOf4EMfC338khQg5te9p9hXUdkMzdUMEA
	 J5bVRJ/uN+IxCCuRLE6/E13nDWC4wy2WFymC0zXNs5sFK0EfgWFrWOTshgsUSbnsxTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1NmWzmH5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4841C606A336;
	Wed, 28 Oct 2026 17:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1NmWzmH5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64ED51F01829;
	Wed, 28 Oct 2026 17:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207894;
	bh=NE0Cx1P7NOEerEcTCQ3AJg/URrjYOXNsGCQbu/RB4sQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1NmWzmH5eihHXv5hWzMdMXK+inTpbiBqIm2nGmF4JSEk+g5YvG6w7JRK1NCQWvRI+
	 seNigsi9tYwaXg9scGKxI3u0M00ZnLrmSKKsBLtoJsak5d6M+dBhi78TuygSJABiZy
	 9GQIavyvV2GQnHEZrTE1QSvoeFE4Z45upC7VcvC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 134/247] kernel/watch_queue: Use pipe_buf() to retrieve the pipe buffer
Date: Wed, 28 Oct 2026 17:58:57 +0100
Message-ID: <20261028165950.580510185@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

From: K Prateek Nayak <kprateek.nayak@amd.com>

[ Upstream commit 547476063e123e73fc3aea8432104ab092ffea84 ]

Use pipe_buf() helper to retrieve the pipe buffer in
post_one_notification() replacing the open-coded the logic.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
Link: https://lore.kernel.org/r/20250307052919.34542-3-kprateek.nayak@amd.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 5e531d62f1f8 ("watch_queue: Fix note pool publication race in watch_queue_set_size()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/watch_queue.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/watch_queue.c b/kernel/watch_queue.c
index 6d1936fb8ff02..5da67a1047d00 100644
--- a/kernel/watch_queue.c
+++ b/kernel/watch_queue.c
@@ -101,12 +101,11 @@ static bool post_one_notification(struct watch_queue *wqueue,
 	struct pipe_inode_info *pipe = wqueue->pipe;
 	struct pipe_buffer *buf;
 	struct page *page;
-	unsigned int head, tail, mask, note, offset, len;
+	unsigned int head, tail, note, offset, len;
 	bool done = false;
 
 	spin_lock_irq(&pipe->rd_wait.lock);
 
-	mask = pipe->ring_size - 1;
 	head = pipe->head;
 	tail = pipe->tail;
 	if (pipe_full(head, tail, pipe->ring_size))
@@ -124,7 +123,7 @@ static bool post_one_notification(struct watch_queue *wqueue,
 	memcpy(p + offset, n, len);
 	kunmap_atomic(p);
 
-	buf = &pipe->bufs[head & mask];
+	buf = pipe_buf(pipe, head);
 	buf->page = page;
 	buf->private = (unsigned long)wqueue;
 	buf->ops = &watch_queue_pipe_buf_ops;
@@ -147,7 +146,7 @@ static bool post_one_notification(struct watch_queue *wqueue,
 	return done;
 
 lost:
-	buf = &pipe->bufs[(head - 1) & mask];
+	buf = pipe_buf(pipe, head - 1);
 	buf->flags |= PIPE_BUF_FLAG_LOSS;
 	goto out;
 }
-- 
2.53.0



