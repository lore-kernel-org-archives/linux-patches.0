Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061847;
	b=IWRB1P+M6vfzLOWyGmIc+0Hm37vOv5tGWeXV2EFlogVpdQ3FNXpFTKcO/8lvlPoFsi6h
	 +BIReM0VN4wU3fxbopzJA3Pdb7yDen7+lBwk0j1WFlNaDEdWaqkiIc71yVQZo2934zuyn
	 S+CFyqIyLuefXpPiSeYeVrBqLaX4R6PRhlNbKBkANmc2NVYiqVlepAzJPGKixaapJ2iko
	 Osoi+HS1dEmM1eEUMA4h4qIXKgs7H14EzhJBdEO7IB3Z0mxklGUquQn0QWAMor4rftQzT
	 Fq+N7EvMyHbxmZo8JnUVcBIVFT99mP1x77CadmpQ+SepniR4DgwsrbVb2iqPSwz/eqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061847;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ST0p6GGsAef8MYuTQKFhua93lciTCtxoK/gIeIzQyk0=;
	b=SQQRkGnRSaFHhGGP1P2pNgWh1QsbKGgvgWl3CmG1J2BneD1owwAbZaBr/vpmSSA2Ga5K
	 BuXGUv+tUzxgTUN+/TgWYgEvA0RGc2VCRpIBf0Sx4e1pufyArdZd/zINyMxO9YDqatIHk
	 Tu1pWMyzRFWwHt6ZVVtduhLg20yUqXyb5pL/Os1ftAbEruZYQjPwFU3ufVZ255sd23yhn
	 awSpjbEe/d1LBza3EOXTPLcFJLC3n5OjGF9kWEk8v6k1rGHTp/bMW2TKqyx8sgpYnEjqe
	 vPVNoMzjrAQ4C2dUC6S6VtP3dziRBntDvHncpuU/CtpDJ0A1xaR40i0IQWEh/OwkzMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AiY4z+UG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB191606A326;
	Sat,  7 Nov 2026 14:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AiY4z+UG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55ECC1F0089F;
	Sat,  7 Nov 2026 14:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061846;
	bh=ST0p6GGsAef8MYuTQKFhua93lciTCtxoK/gIeIzQyk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AiY4z+UGCky4J6oap4Nym17YqOfh5129/cQTf7qzczaNGgzdkZ2hBq8Grkwgj9zAc
	 ejCYvLih7C5o4YV9nLiy2dy2QbYGyoZevnd8K2Zp2o5wbL+eI6aypTOzHIB0dqNpdP
	 xCL5b+ky3pzjllH4qxsd1d1RlerunLWMyGijkNQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 0828/1536] io_uring/kbuf: advance head when a pickup empties the buffer ring
Date: Sat,  7 Nov 2026 08:47:24 -0500
Message-ID: <20261107135020.800714844@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Yichong Chen <chenyichong@uniontech.com>

Commit 8742f4b5a472c347fe568a73468a2d9e4d630b33 upstream.

io_ring_buffers_peek() flags the request with REQ_F_BL_EMPTY if the
buffers it picked were the last ones available, comparing head to tail.
When the loop breaks because max_len was exhausted the buffer was picked,
but head is left pointing at it, so the flag isn't set if it was the last
buffer. A bundle receive then retries, finds no buffer, and the request,
which has received data, is marked as failed on account of the -ENOBUFS.
That severs a link, and ends a multishot.

Fixes: 35c8711c8fc4 ("io_uring/kbuf: add helpers for getting/peeking multiple buffers")
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Link: https://patch.msgid.link/20261023091711.83481-1-chenyichong@uniontech.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/kbuf.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -302,8 +302,10 @@ static int io_ring_buffers_peek(struct i
 
 		arg->out_len += len;
 		arg->max_len -= len;
-		if (!arg->max_len)
+		if (!arg->max_len) {
+			head++;
 			break;
+		}
 
 		buf = io_ring_head_to_buf(br, ++head, bl->mask);
 	} while (--nr_iovs);


