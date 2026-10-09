Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B674D7D29;
	Fri,  9 Oct 2026 14:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555544; cv=none; b=WB2bFr5/TR6TWItMTnHORMNhXg4JdRLMXO1BSfyW6qm2SbW7zp6uK4D5HHSMZGeKulAi68IN8gX9JFnQc35b0C4bMt/e+8GPOwyLqpFGB9H3t8Hb1LISjlBxrd/gzwwDTUYzmXWWB3/8KF2S56I22XANv8XoW6wdk5FSCEQl58I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555544; c=relaxed/simple;
	bh=LG4YcL9xv1rKYXZjs9/G3v2H+RSv4TQy0drx+TbIFgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FbmSyZ21OxfnZvVsqQEedOxgSKApI3sWA90Q26eUpV9JA4dSINqDd8C8w1UOI6YalIKd9+91tvA3ztjuojwnMlNFF+YiYBcMfVe05K58HF5v1NIv3DTaSNzozGeQ8uzmxEsES3Pqb/V62npGP6zdkEAOjSKndszhwo8hMLv6n0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RLX2gz7N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RLX2gz7N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B7AF1F00893;
	Fri,  9 Oct 2026 14:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555536;
	bh=+18cg5TfMaSY6672twVUJdv3bPTnld7GldP1huA+SVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RLX2gz7NYEgQOxYPN66RP68iDJSuPzJE96tdpxgyiv0P0WnDeuzXOtSXxZJtc1Ven
	 ZLJtZqeTdECbg+/xnYyrSxP2o55ex3OZ4F1YaAe1excy2ZReyak5FLjSVDrGqo7GiS
	 2WNC8wsyayMSck6BTcQu63+5lHpBJq8iEbCFTmtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junyuan Feng <a@lollipopkit.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 025/428] io_uring/zcrx: requeue multishot receives stopped by a local resource
Date: Fri,  9 Oct 2026 16:06:02 +0200
Message-ID: <20261009140946.621113912@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junyuan Feng <a@lollipopkit.com>

commit 98ad5b63f5041dc354a6e694f4a9436f74e0681b upstream.

A multishot RECV_ZC can go idle with unread TCP data when a
receiver-local resource runs out. An empty copy-fallback niov freelist
returns -ENOMEM; a full CQ returns -ENOSPC. After partial progress the
stop reason is lost: io_zcrx_copy_chunk() and io_zcrx_recv_skb() report
the copied bytes, and tcp_read_sock() drops an error from a later call
once earlier data was consumed. The edge-triggered request is then not
requeued, so it cannot consume the remaining data until another socket
event arrives.

Record in io_zcrx_recv_skb() when a walk stops before consuming the
length it was offered, and requeue if the pass still returned data. The
failed chunk is first on the next pass. The resource is usually still
exhausted by then, so that pass fails at once and ends the request with
an error CQE, which the application must handle by re-arming. The
request does not spin, and the stall becomes a visible error. Keep the
existing skb limit and SOCK_DONE handling.

Fixes: 11ed914bbf94 ("io_uring/zcrx: add io_recvzc request")
Fixes: bc57c7d36c4c ("io_uring/zcrx: add copy fallback")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-6-sol
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Junyuan Feng <a@lollipopkit.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://patch.msgid.link/010001a0cd914529-23df2f94-bbe0-49cd-ae5d-05922356fa12-000000@email.amazonses.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/zcrx.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -340,6 +340,7 @@ struct io_zcrx_args {
 	struct io_kiocb		*req;
 	struct io_zcrx_ifq	*ifq;
 	unsigned		nr_skbs;
+	bool			stopped_early;
 };
 
 static const struct memory_provider_ops io_uring_pp_zc_ops;
@@ -1727,6 +1728,9 @@ io_zcrx_recv_skb(read_descriptor_t *desc
 	}
 
 out:
+	/* Bytes left in len mean an error stopped the walk early. */
+	if (len)
+		args->stopped_early = true;
 	if (offset == start_off)
 		return ret;
 	desc->count -= (offset - start_off);
@@ -1763,8 +1767,9 @@ static int io_zcrx_tcp_recvmsg(struct io
 			ret = -ENOTCONN;
 		else
 			ret = -EAGAIN;
-	} else if (unlikely(args.nr_skbs > IO_SKBS_PER_CALL_LIMIT) &&
-		   (issue_flags & IO_URING_F_MULTISHOT)) {
+	} else if ((issue_flags & IO_URING_F_MULTISHOT) &&
+		   (unlikely(args.nr_skbs > IO_SKBS_PER_CALL_LIMIT) ||
+		    args.stopped_early)) {
 		ret = IOU_REQUEUE;
 	} else if (sock_flag(sk, SOCK_DONE)) {
 		/* Make it to retry until it finally gets 0. */


