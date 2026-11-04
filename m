Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829234;
	b=qwN3gTTSpjRAt+WvtEszT4kC/C9i+dNWStfOh1siLErixXzcbtOsf8NikctKfB2IWAOj
	 1p2hezhtk+KO0OaULNj5KwN1JtMW/ggMApkLmSVVXfUoVTfUaQNnLqwdmBPv0Tpmysj/F
	 GO7hlVCPSfzSvcLVe9SvzxuCjyNtCvcNTSP8bAkNZdrIuzp3h7rVgE4Nxt0XK6Tb4TaVT
	 +nK/vRUGOzASqlnbJv3AMZa7L3ZLDDuWB2xcpa/oopplQ9i5ZhXvvZ/hSuMZl/irpt4WL
	 JA5L32kAX0B0E3cSYUS/dFkZ9gyahcssvt6d51dlv6IMU/Q1bcuQV6M+vkY2hzt0dbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829234;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nkdU8LPsyafq4Cm/yPWK8HWwlVDu68K4h2ERNEAVt5c=;
	b=ah6CjlXuk2KE2kJnbO6PSkjGcvO2GhawTQpeVyzADyD4UnUxWaMACQjF79inFEhVPcqN
	 BVAPHK5zfOirHH3gHF7vHgPw0qj3vUjqMZnxPpP0fizrstp5krq7glEh3hGIeKO5383uC
	 DTlLxS+/q4xlZWkbHAbmM7geSFL4NQeNNwpfvAI7OUt8IA7Wni1i/zYPfXes+flGqyRu9
	 JIve2TD+DLrve+zLg9j/xxfNQMSYrHjCZAXaDbt9BEhjPBfKGii0/v2/Z7hcXKUZimePl
	 Y0a0SGNyBPZxox1UllqxKXZbjlEOdxMCIDbjV+sVMp2iybJtTjjrLFOOqQyM4SoUwjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aGp6ILYc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A50F606D80D;
	Wed,  4 Nov 2026 21:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aGp6ILYc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 872A81F00919;
	Wed,  4 Nov 2026 21:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829233;
	bh=nkdU8LPsyafq4Cm/yPWK8HWwlVDu68K4h2ERNEAVt5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aGp6ILYcf8PYhWoibpWrDXA+HyAMSQWdFhtaQTzNBX5JQ5Ap2FUic9Rbfz88C1POX
	 yw3SNKeJNoa1iotbsY4GWn+N921/YFOGBliEjaGksSefEcd+5Ryy3cfGLG5ojKZTCR
	 It8zzRHmeDyh1YBFUWpCESTTyRjllQT7/8vV5fBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Yongkang <teel4res@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.3 533/547] io_uring/net: fix multishot recv length limit accounting
Date: Wed,  4 Nov 2026 16:11:57 -0500
Message-ID: <20261104211053.536775725@linuxfoundation.org>
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

From: Cheng Yongkang <teel4res@gmail.com>

Commit 3e3aebb7570ccdde5cc49c9bfc8fd3a436b71b0c upstream.

io_recv_finish() debits sr->mshot_total_len with min_t(int, sel->val,
sr->mshot_total_len).  sel->val is the cumulative byte count of the
request: on a bundle retry the receive path adds sr->done_io back to the
return value, and the bundle branch in io_recv_finish() recovers the new
bytes with this_ret = sel->val - sr->done_io.  The debit therefore uses
the wrong value after a bundle retry, and the int cast truncates a limit
above INT_MAX.

For an IORING_OP_RECV multishot request with optlen above INT_MAX, the
limit becomes negative when cast to int, so the first completion debits
the entire limit and ends the multishot with IORING_RECV_MSHOT_DONE
while the socket still holds data that covers the limit.  With 120 bytes
queued, a 64-byte buffer and optlen 0x80000000, the first 64-byte CQE
lacks IORING_CQE_F_MORE and 56 bytes remain unread; the same setup with
optlen 0x7fffffff posts 64 and 56 bytes with F_MORE.

After a bundle retry, the bytes already debited for the previous
attempts are debited again, so the limit is exhausted early.  With 1400
bytes queued, optlen 1000 and buffers of 600, 100, 100, 50, 50 and 200
bytes, the first attempt delivers 700 bytes and retries; the second
delivers 200 more, but the debit accounts for 900 and finishes the
request with a terminal 900-byte CQE while 500 bytes remain unread.  The
limit could have been reached.

Debit only the bytes received by this invocation, sel->val -
sr->done_io, and compare as unsigned so a limit above INT_MAX is
accounted correctly. Non-bundle multishot requests keep sr->done_io at
zero, so their accounting is unchanged.

Fixes: 0ebc9a7ecf6a ("io_uring/net: Support multishot receive len cap")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Cheng Yongkang <teel4res@gmail.com>
Link: https://patch.msgid.link/179328314078.648427.10086632105828535293@gmail.com
[axboe: fix-up near-by incorrect comment while in there]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -881,12 +881,15 @@ static inline bool io_recv_finish(struct
 		cflags |= IORING_CQE_F_SOCK_NONEMPTY;
 
 	if (sel->val > 0 && sr->flags & IORING_RECV_MSHOT_LIM) {
+		unsigned int this_len = sel->val - sr->done_io;
+
 		/*
-		 * If sr->len hits zero, the limit has been reached. Mark
-		 * mshot as finished, and flag MSHOT_DONE as well to prevent
-		 * a potential bundle from being retried.
+		 * If sr->mshot_total_len hits zero, the limit has been reached.
+		 * Mark mshot as finished, and flag MSHOT_DONE as well to
+		 * prevent a potential bundle from being retried.
 		 */
-		sr->mshot_total_len -= min_t(int, sel->val, sr->mshot_total_len);
+		sr->mshot_total_len -= min_t(unsigned int, this_len,
+					     sr->mshot_total_len);
 		if (!sr->mshot_total_len) {
 			sr->flags |= IORING_RECV_MSHOT_DONE;
 			mshot_finished = true;


