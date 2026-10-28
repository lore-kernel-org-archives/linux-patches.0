Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207292;
	b=1kMPoQLD5rhYukvnx7xklZ3tfKsHhK0v57vSjjCmUgyOhDQK79+iyDZ2nJhQtcwTo3u/
	 6qTTj/CuKeW3/+Z8Zir/6s8rGBtUQu37iJQrepHik6y5uaiR+HnP0lU9nwnyPqeA9tdet
	 6zS9gIw6Unw8NrHt8fdN7DMP6HzgZr2ydCKjLTElZA9Ll0IDmnySaTBj/A753ibyH9SLy
	 C+6JfmAU6jtlg8WLXv5ipGuoniRI7yndyVjcFhuQ7+NBqZQZqtWn9I7CekxlAuLOpl/Wi
	 i/J63aY8D2FMAMOOLYMLGn3A9H4AUVpUXnQftI2so4IEv8JbLuVK3qdERlUuqIqR2xQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207292;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x2sRPK6b/UWvG3Jm9cdGi+xZJNJ97kptBqlaZ9wiFwE=;
	b=Pj8UbYXWZ6oQ1PH9Qm+A+qO5r5Vh5fngq7WzBvtEcgXZK4kWtecZTGBPOfR0QQHHWEYG
	 Lf5nn8TngwBZ0sHmRTosZdzsj8PEnIcuqT3DKt7bEhaU4AV1CMLerkMNb0tW+BgBagoSS
	 WSWG/BjkALB0wgd+RJd4xlR1UIqecDtMkTcm5BXs+bbVnuFU2QqbmI9Y+ru8ig7Bdj4yC
	 a7CC/dvZ7FSVc52XX4ZYBLQImE0IqbaQEQREeghhQCBT9FlEc17RXtCKaWX0Vh82QEkTX
	 Ir9HeGaudL1ZxIR11I1LNngS/+wlgfpx8gIe6vcAyPAxgPKMH7Khz+X2ZwJRJ+7pZ2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2SZCp2Gl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E3E606A31A;
	Wed, 28 Oct 2026 17:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2SZCp2Gl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83DBC1F01825;
	Wed, 28 Oct 2026 17:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207292;
	bh=x2sRPK6b/UWvG3Jm9cdGi+xZJNJ97kptBqlaZ9wiFwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2SZCp2GlkQjmPh+WPyCnwCW6eg9AknBH7CH1WvZaY/jaV/Nt2WwGVMFAq0Qeee5e6
	 L2BkOuO8vcxe1dgRJW2m8O09yv1V48GJTvn0vaKy3692/d5j6uWSMFf1KEYjLoHm9D
	 ltkVhbT4otEEIs4SY45jtrmoXD277+lnOJbJGl+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 53/88] io_uring/sqpoll: let the thread sleep on disabled rings
Date: Wed, 28 Oct 2026 18:00:01 +0100
Message-ID: <20261028165943.361448763@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.107695352@linuxfoundation.org>
References: <20261028165942.107695352@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

Commit d492dcbb3b81c1c2d0aabef41fa1307093f3a556 upstream.

__io_sq_thread() doesn't submit anything as long as the ring has
IORING_SETUP_R_DISABLED set. The check that keeps the SQPOLL thread from
going to sleep while the SQ ring holds entries doesn't know about that.
If an application fills in SQEs first and enables the ring later, the
thread finds that there is work each time it is about to sleep, goes
around, doesn't submit it, and so on. It uses up a CPU until the ring
gets enabled.

Entries in the SQ ring of a disabled ring are no reason to stay awake.
io_register_enable_rings() clears the flag and then wakes the thread, and
the flag is looked at after prepare_to_wait(), so the thread can't miss
that.

Fixes: 0298ef969a11 ("io_uring: clean R_DISABLED startup mess")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-37-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/sqpoll.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -380,6 +380,13 @@ static int io_sq_thread(void *data)
 				 */
 				smp_mb__after_atomic();
 
+				/*
+				 * Nothing gets submitted before the ring is
+				 * enabled, which comes with a wake up.
+				 */
+				if (READ_ONCE(ctx->flags) & IORING_SETUP_R_DISABLED)
+					continue;
+
 				if (io_sqring_entries(ctx)) {
 					needs_sched = false;
 					break;


