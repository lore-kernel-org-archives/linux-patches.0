Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209742;
	b=O0elseDC7MazSmgiVs9WdEzpkFS4D94qR7a8utQYhc8JMC62idGPAESTs/YOMSPAsLO7
	 6T9jvXsP0nwWmorIB/b/187KjwallI/2sQwkwpuRfJeuAFriuqyb3JwmZoiYAs1xp+HkF
	 cWm4jBB/56Tn83iKfHf2CxT17kv5fv926vShGPEb+Mw7qMe75Twka7KZ4ybXgBq4xirVN
	 w+m6hrCCrRAxI2mWrOCBVZvUywwTrI5UnK/69BAheUMonb5x+J6OHgCKsA8S27gi5efZj
	 /WOxUwPrk+F3700hDRq/VhuOD9thLSgsMH0/CbuzZ/FMt8QEpgAXHHh5POk8dg1b8uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209742;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gLB58zLceCs+tMOAjaQmm2315k0VWV3fjacjNSeIBcE=;
	b=qYJ+gv0K017UM+nWUvELK3eGmBZVhoqK71tZlDpHHpWvXZwhoeOhPH4Dj3+6bNp/Ze6+
	 2ee8cVk+mDcwSa7FJh5PPVnbbYx+feohdrw+vP0JJH6+ad8TzyGmp4Ru6cn3W7xfJyTKp
	 nCa4qS7GtRkWIsTaExBUgwFmrLrA8Ig4iOjDgyaLlOZ2lYuI6L42WHA0brlF6Tfoboo2o
	 1O0HRJOfyCml4nAwSPyY5BaYzMi8+4rKDhRGMFTtWm6y/pdGR2CQNOiI1NHmkgF5MKXYa
	 XJGYdbippO+7ZadfMNyPmjlQLgXJZRYkUR3YjcN4PHVr6V3YhjdiA7wyDVPlgDedeNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="sBeA8jN/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B46D606A31A;
	Wed, 28 Oct 2026 17:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sBeA8jN/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD82F1F01825;
	Wed, 28 Oct 2026 17:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209742;
	bh=gLB58zLceCs+tMOAjaQmm2315k0VWV3fjacjNSeIBcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sBeA8jN/mvzKANXRcIpG6nMnoL4FJHfGrVTteTHTunccS3AUD3YiTUKSLjPP2KlOq
	 s+8Hror4/fX43TEOli0kN80qnJq+BwhiF1zQfO6aEo24jPfIHLWvpRjnYG/JxS+kYR
	 BtOdRjtRCVQzPLcGPniv29ilEv6BQvUhM+alEDQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 061/109] io_uring/poll: drop stale double poll entry on rearm
Date: Wed, 28 Oct 2026 18:00:45 +0100
Message-ID: <20261028165943.795217100@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

Commit f2dbe87968a3aef74a11c025776d293b80964d3f upstream.

A file that uses two wait queues for poll, e.g. a tty, gets a second
io_poll entry, which IORING_OP_POLL_ADD keeps in ->async_data until the
request is freed. io_poll_add() can run more than once for a request
though: IORING_OP_POLL_REMOVE with one of the update flags disarms and
rearms it, and io_poll_task_func() reissues it if a wake up turns out to
be spurious. The second poll_wait() of the new round then finds
*poll_ptr set, with ->head cleared by the disarm, and __io_queue_proc()
fails what it takes for a third wait queue with -EINVAL.

For an update that means that the poll request is completed with
-ECANCELED, while the update itself reports success. For a spurious wake
up, e.g. tcsetattr() on the polled tty, the poll request fails with
-EINVAL.

Free the old entry and clear the poll flags before arming, which is what
io_arm_apoll() does for internal polling. All entries have been removed
from their wait queues at that point.

Fixes: b69de288e913 ("io_uring: allow events and user_data update of running poll requests")
Fixes: 6e5aedb9324a ("io_uring/poll: attempt request issue after racy poll wakeup")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-21-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/poll.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -915,6 +915,15 @@ int io_poll_add(struct io_kiocb *req, un
 
 	ipt.pt._qproc = io_poll_queue_proc;
 
+	/*
+	 * A poll update or a spurious wake up arms the request again. Forget
+	 * the entries of the previous round like io_arm_apoll() does, a stale
+	 * second entry would be taken for a third wait queue.
+	 */
+	if (req_has_async_data(req))
+		io_req_async_data_free(req);
+	req->flags &= ~(REQ_F_SINGLE_POLL | REQ_F_DOUBLE_POLL);
+
 	ret = __io_arm_poll_handler(req, poll, &ipt, poll->events, issue_flags);
 	if (ret > 0) {
 		io_req_set_res(req, ipt.result_mask, 0);


