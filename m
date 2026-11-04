Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831880;
	b=N0MhYGj7KtYY+tG9ZYKKB4mIMy8UZYkM8p+UoOZMOobV8E5bH4bsEfAndBS7JlblaQa9
	 AwqCNYo+Lku/c4bWcGj7/GzeI6PdEbCnRdxJ4PIfEfdhyisJRQvpIe2L1y8hYSRdPemis
	 bfdDL/3rI9Biy9qTMZQu2qehoNvSJGcaqqsiT/0MS5SqjgcWFMJWbjR+bOac50n4U0elp
	 OZQA3RBHhM6mNudMXNSG0Lly6w5vDWMdiuKHBThm/KIFG7ggV3t2b7qJqEQhmkFY96LvB
	 0Xpmy+wTQczPaAVxEAzUjJFkfzoXMf7M5McT22fZmAagdFpFa5gpYnRX7eZcdvDn0tQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831880;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bZY+i01/mE00EYUFAx4x3wQ3Uu8a5ppTT6x1jzB8hM0=;
	b=xfLCoZdLRnaEhsM5Py3u99ABAHGgV5kFg7tSjstxlVR3E7axKaZOjBlzconx/JhAknGA
	 CpWIMvIDSYTf1aWekkOHQhksdspiF1q2RL53+vk4PKvm6LocAmw8199MQUuB+QNm5COfv
	 irt2QwCnNMV0sip/zKboKRPepvqILEDt0cm6sS2mhGZI11yZ5CnWLzWRAB6LzGn7rpD7X
	 5ZM11RBMtwJbF8nqpC2z3yRjVJeDA6oU20Hcpatz43sp2imTTBMHFAah72dDlflYPOGJa
	 rPKHzBMmcE45Yzg1bXYkMRh4gUNmNSzGrB+32wau+OvS/n0x4fpCe9T9BZR/pHV6C5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mY+wv9S5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6F6606A841;
	Wed,  4 Nov 2026 22:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mY+wv9S5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E58CD1F000C1;
	Wed,  4 Nov 2026 22:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831880;
	bh=bZY+i01/mE00EYUFAx4x3wQ3Uu8a5ppTT6x1jzB8hM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mY+wv9S5WjUWHiHZ3iAGTxZZn/YtEPZsgP/4HbxfmCMuz6T/MWkf2nE8/GoYgSnGF
	 CusbkWNCx/zrhb+ipi+p5o+6A9BJa2sz1InsvImXIYpIE1YKo3DMzIX2fpdklGxj5J
	 pllq51tHtTND1lgGQLhTRnQeeNo0XnJNxxfisqJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 0971/1005] io_uring/kbuf: advance head when a pickup empties the buffer ring
Date: Wed,  4 Nov 2026 16:11:44 -0500
Message-ID: <20261104211110.265033132@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
@@ -314,8 +314,10 @@ static int io_ring_buffers_peek(struct i
 
 		arg->out_len += len;
 		arg->max_len -= len;
-		if (!arg->max_len)
+		if (!arg->max_len) {
+			head++;
 			break;
+		}
 
 		buf = io_ring_head_to_buf(br, ++head, bl->mask);
 	} while (--nr_iovs);


