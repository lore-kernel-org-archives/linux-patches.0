Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207272;
	b=rwF74Dx0obF9bx0KilHzVEW0NhtplaQ9J97xevYZCN0efL/RcGmLg5oL7XK6p7GWCoR4
	 5WiW56flm39onevMTCzx4rxV7gJVFwNvDKg4c9zNkyMph+Ef9pEkZDkOlc9ntwPPpQglh
	 NTAq3u/wjAzzeTYa5QNrNl6EKimZkSXQ3YNs5xUO0Oa87+BcH4F8e2mi9LQcBm9GBHqS2
	 fhcHehvDKb0jkQ/mzaHl9xNGrU3kWWHEP9DZ5OWXTMZbESph/7Q6dZAoGTffd5mXnP4oq
	 q+XDsGEhH4ZQ1wxapRlaymrLxYUxZrM/57fsJ6vXbuH459aicJjkKvwwVpUjNEI3eJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207272;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IOBXUIFiPUpQfdj5X++3y5ITEIeHdFmJ984LwqZGg+o=;
	b=MZHot6tpvY8wInos1Vmr5bg/JHii6kzQUL0oQN1vZGnZCq7kHCBvI7s8CJ8K1T5RALSl
	 s1KF+Y7qoo6TzRsxMoAdyMjZDnp2WvkWJmTwEe51YqXj/+QOPpMK6Tk1f/XNUv2+FF/Gy
	 Ju9sUWkTXW9rPMPWovc9hSF/g/963182Mgpi7F5OYBzevcNDU4UHYaBP0M9OQWJV64OOA
	 XjT2nlLkXnQ5BBdVdx+UqR3FJfB54WOeOH0ETehiu3+8aSFzCXhbYWZDeIaQPPFPyviOH
	 D2n7tVSvsBZmifPi8+jhYwYhVnxLWkPQQOc28c2CA03oTWdIe0kbx2ObeJ83ofNKQ9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zRghagvQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC36606A31A;
	Wed, 28 Oct 2026 17:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zRghagvQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F3321F01825;
	Wed, 28 Oct 2026 17:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207272;
	bh=IOBXUIFiPUpQfdj5X++3y5ITEIeHdFmJ984LwqZGg+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zRghagvQOkF8YpnY9Iq64xfua905r9J5QP/J57xAVKAtgzwaMTAhL1N/6Gfct3g4I
	 UJBpJiD2AK6qaj/MrtlQX+actZu8J6ph2nFBkIB7Nb90sVd0toN8Rmof7jg9mQyl2B
	 KNUja6oyPvE9JPxtzdcxB1ZBjlmKMO5cRIdQC/bQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 47/88] io_uring/timeout: use the right clock for ABS updates
Date: Wed, 28 Oct 2026 17:59:55 +0100
Message-ID: <20261028165943.221961609@linuxfoundation.org>
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

Commit dad82eb1805d76c555224e4030319e3844642b64 upstream.

io_parse_user_time() converts an absolute time from the time namespace of
the caller to the host's view, for the clock given by the flags. The
flags of IORING_TIMEOUT_UPDATE and IORING_LINK_TIMEOUT_UPDATE can't name
a clock, the updated timer keeps running on the clock the timeout was
set up with. So the time is always converted as if it was
CLOCK_MONOTONIC.

In a time namespace with a monotonic offset, that moves the new expiry of
a CLOCK_REALTIME timeout by that offset, although the clock isn't
affected by time namespaces at all, and the one of a CLOCK_BOOTTIME
timeout by the difference between the two offsets.

Do the conversion when the timeout has been looked up and its clock is
known. The update is run by the submitter, its SQPOLL thread or one of
its io-wq workers, all of which share the time namespace.

Fixes: 9cc6bac1bebf ("io_uring/timeout: honour caller's time namespace for IORING_TIMEOUT_ABS")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-31-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/timeout.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -458,6 +458,8 @@ static int io_linked_timeout_update(stru
 	io = req->async_data;
 	if (hrtimer_try_to_cancel(&io->timer) == -1)
 		return -EALREADY;
+	if (mode == HRTIMER_MODE_ABS)
+		ts = timens_ktime_to_host(io_timeout_get_clock(io), ts);
 	hrtimer_setup(&io->timer, io_link_timeout_fn, io_timeout_get_clock(io), mode);
 	hrtimer_start(&io->timer, ts, mode);
 	return 0;
@@ -479,6 +481,8 @@ static int io_timeout_update(struct io_r
 	/* for a multishot request this isn't a sequence, keep the repeats */
 	if (!(data->flags & IORING_TIMEOUT_MULTISHOT))
 		timeout->off = 0; /* noseq */
+	if (mode == HRTIMER_MODE_ABS)
+		time = timens_ktime_to_host(io_timeout_get_clock(data), time);
 	data->time = time;
 
 	list_add_tail(&timeout->list, &ctx->timeout_list);
@@ -511,7 +515,12 @@ int io_timeout_remove_prep(struct io_kio
 				  IORING_TIMEOUT_ABS |
 				  IORING_TIMEOUT_IMMEDIATE_ARG))
 			return -EINVAL;
-		ret = io_parse_user_time(&tr->time, READ_ONCE(sqe->addr2), tr->flags);
+		/*
+		 * The clock is that of the timeout to update, an absolute time
+		 * is converted to the host's view once that has been found.
+		 */
+		ret = io_parse_user_time(&tr->time, READ_ONCE(sqe->addr2),
+					 tr->flags & ~IORING_TIMEOUT_ABS);
 		if (ret)
 			return ret;
 	} else if (tr->flags) {


