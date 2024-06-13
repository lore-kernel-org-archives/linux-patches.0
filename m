Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4EB914265A;
	Thu, 13 Jun 2024 11:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279431; cv=none; b=nWrD6Z+AbkXednPTO+1gaUjDfuNs9hFTwgQf53v0cAeylO+AHhYtMM311hBkXZs9HIikZoq0Wn8Pgm6sHzf5SE0v2KSHVvXttXq43ZEyObncvKNUki1M+gPbsCE+MAdsIywke1ZlTTPt5kuVplypzz6typnc3sncfcE6UZNyZvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279431; c=relaxed/simple;
	bh=hLW6sSPmEHz+eCxnLZljcWU+qFfSRs67qHpTX419UT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RT7zI0m0TGt87RafcENc9z/S1mo/IEAjeXUPSwo3ZcqyRtGDHcSXk6BqdjukxUXHchhfyRh6+ETIZ6mfBsn8i0iF00mho+mDaDeRD3I0QvjwptlZziSlljazx1JxQAh0j/w1g+tOprgnHeQRYdThzjtWbnytKqy491yfVXSwAuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LN3SxZ+W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LN3SxZ+W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA068C32786;
	Thu, 13 Jun 2024 11:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279431;
	bh=hLW6sSPmEHz+eCxnLZljcWU+qFfSRs67qHpTX419UT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LN3SxZ+WZnH0ZeVIfUlgyabRGmtp62PLTIn3qKj69iKulzrC8MQEThyhn/YkgADRX
	 zl7s7rx/jjP/fEZqJAVdFgW0SXucWwHQZqboeH8Gg8GAQNpswyj04PeMJ9m9DtbIiB
	 +A2/RYNT6rnTxz155Mhn/EqWDm9WLAKOrnqR0sv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lewis Baker <lewissbaker@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.9 074/157] io_uring/napi: fix timeout calculation
Date: Thu, 13 Jun 2024 13:33:19 +0200
Message-ID: <20240613113230.285602991@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit 415ce0ea55c5a3afea501a773e002be9ed7149f5 upstream.

Not quite sure what __io_napi_adjust_timeout() was attemping to do, it's
adjusting both the NAPI timeout and the general overall timeout, and
calculating a value that is never used. The overall timeout is a super
set of the NAPI timeout, and doesn't need adjusting. The only thing we
really need to care about is that the NAPI timeout doesn't exceed the
overall timeout. If a user asked for a timeout of eg 5 usec and NAPI
timeout is 10 usec, then we should not spin for 10 usec.

While in there, sanitize the time checking a bit. If we have a negative
value in the passed in timeout, discard it. Round up the value as well,
so we don't end up with a NAPI timeout for the majority of the wait,
with only a tiny sleep value at the end.

Hence the only case we need to care about is if the NAPI timeout is
larger than the overall timeout. If it is, cap the NAPI timeout at what
the overall timeout is.

Cc: stable@vger.kernel.org
Fixes: 8d0c12a80cde ("io-uring: add napi busy poll support")
Reported-by: Lewis Baker <lewissbaker@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/napi.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/io_uring/napi.c b/io_uring/napi.c
index 883a1a665907..8c18ede595c4 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -261,12 +261,14 @@ int io_unregister_napi(struct io_ring_ctx *ctx, void __user *arg)
 }
 
 /*
- * __io_napi_adjust_timeout() - Add napi id to the busy poll list
+ * __io_napi_adjust_timeout() - adjust busy loop timeout
  * @ctx: pointer to io-uring context structure
  * @iowq: pointer to io wait queue
  * @ts: pointer to timespec or NULL
  *
  * Adjust the busy loop timeout according to timespec and busy poll timeout.
+ * If the specified NAPI timeout is bigger than the wait timeout, then adjust
+ * the NAPI timeout accordingly.
  */
 void __io_napi_adjust_timeout(struct io_ring_ctx *ctx, struct io_wait_queue *iowq,
 			      struct timespec64 *ts)
@@ -274,16 +276,16 @@ void __io_napi_adjust_timeout(struct io_ring_ctx *ctx, struct io_wait_queue *iow
 	unsigned int poll_to = READ_ONCE(ctx->napi_busy_poll_to);
 
 	if (ts) {
-		struct timespec64 poll_to_ts = ns_to_timespec64(1000 * (s64)poll_to);
+		struct timespec64 poll_to_ts;
 
-		if (timespec64_compare(ts, &poll_to_ts) > 0) {
-			*ts = timespec64_sub(*ts, poll_to_ts);
-		} else {
-			u64 to = timespec64_to_ns(ts);
-
-			do_div(to, 1000);
-			ts->tv_sec = 0;
-			ts->tv_nsec = 0;
+		poll_to_ts = ns_to_timespec64(1000 * (s64)poll_to);
+		if (timespec64_compare(ts, &poll_to_ts) < 0) {
+			s64 poll_to_ns = timespec64_to_ns(ts);
+			if (poll_to_ns > 0) {
+				u64 val = poll_to_ns + 999;
+				do_div(val, (s64) 1000);
+				poll_to = val;
+			}
 		}
 	}
 
-- 
2.45.2



