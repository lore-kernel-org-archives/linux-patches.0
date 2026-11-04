Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826877;
	b=wW5GoDZFcCVYtaoWa276dhdYo5EkLuUO6VMRkF+NtB+ZGKxBYok9WvLnU7g4GRK6DTr2
	 BM2nnAOEJF6vUPcByFQ/pol4PuM5AaEUWCrNCchX46yfUxspCAFSMq0Y20U88aa09498F
	 ccI4h67u7GgI1RH2BnoWoccsqvbVnItLTdFeJ3WFsCV8C6fWxTJgc8lniV+fdI+N3UxEw
	 AUOeMpyjbCwV1Ypp164BZZyD4ntriP669G3MHBJxADi21gQj1X3hRCu0Ojrrwo0kdADTa
	 DOScOGCbEwVPURUzPcYjZ46Sigd9bWdnM+QPRuvuYc+sql+F8BYi0tMe/MFTegTBsOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826877;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EQdqEJcLyandj3jrk8wDUb3CuQxqjqu7K53AvNJ+w/g=;
	b=QmZMdaVxMostDwxiyY8r3Chh9TjN6VwC/O2ZlbubvdtvNa3pZgjAGYNby7IQgpNUM1vx
	 e3KLhIHvle4ZMWNHJ4hhJCkx1Erx1tkynDcEDxMO6n2fYmKOP8vXoNSG6GR77MOjY1HZW
	 qBONH17b6n5UZiNdm8w9lHAKJS5X0GHGyv5kRUFVkdwvOG6Jn52y2gt5+RLzz3KNzVXgn
	 HqgfdvAYYtdpOeZRdzlkkHgyWOuYJRz49Qc4cgNN86MvK2+mQamgPsjUeN6fTDDC3ZptU
	 BK+UGXHR45YlM/jl8AOuU6YXE6tD3P9hhRxvcY2/0njg1ymiGGXcQPU4Zfmhg7eGXWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oLHJYTHw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E336F60B3338;
	Wed,  4 Nov 2026 21:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oLHJYTHw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 514341F00A15;
	Wed,  4 Nov 2026 21:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826876;
	bh=EQdqEJcLyandj3jrk8wDUb3CuQxqjqu7K53AvNJ+w/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oLHJYTHw92WEed8GlMO7cVrP+4HdKRPkmRtyFtIFOQCccd2XA4PHcSTN7VzAEZpTb
	 cHUumAv15I/y1d9/rSIZCvqwfhZkptsfdlFlmmAbeC+yjiVwak4heqPAYD5a4GD+oL
	 gLUKVw73ALluW7LHtnSwI1LAGO4pc2qX+Z6sex2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 052/547] io_uring/kbuf: handle index wrap in last buffer check
Date: Wed,  4 Nov 2026 16:03:56 -0500
Message-ID: <20261104211039.777317107@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 6e773b5161506a4d0e739eb3aa4667d28f20219c ]

io_ring_buffer_select() flags the request with REQ_F_BL_EMPTY if it takes
the last buffer of the ring. Head and tail are 16-bit counters, but
"head + 1" is computed as an int. If head is 65535 and tail has wrapped
to 0, that compares 65536 to 0 and the flag isn't set.

A bundle receive relies on the flag to tell that there is no point in
trying to get more data. Without it, it goes for another round, finds no
buffer, and the request, which has received data, is marked as failed on
account of the -ENOBUFS. That severs a link, and ends a multishot.

Fixes: c3f9109dbc9e ("io_uring/kbuf: flag request if buffer pool is empty after buffer pick")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-36-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/kbuf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 6e2facf34bfa6..c9641b6ccc8ff 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -204,7 +204,7 @@ static struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 	if (unlikely(tail == head))
 		return sel;
 
-	if (head + 1 == tail)
+	if ((__u16)(head + 1) == tail)
 		req->flags |= REQ_F_BL_EMPTY;
 
 	buf = io_ring_head_to_buf(br, head, bl->mask);
-- 
2.53.0



