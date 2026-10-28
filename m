Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208038;
	b=AGgabqkzSUJlq5Q84+AWWtVmukYniv1Szn1KicCdKhSFi4MQoY8ACqQBJjrdqKMyyfPQ
	 0DqmrJR+l1uBkMQswHrt6yuSZu6R5B1zNuNhabWKMUJ0X/vbvOoOyd9+uu59PrfR73+kj
	 0dY18UV8FllKPxdW7EO6jV4tlOgUhQ9Uk5ED+VxEkRGQH1ky+wi3SMzJRwrqayPfKL2a/
	 lFpQqNs8rvg6Hi2iy7l+ahab5Cf4vrPjhscB+Fk7GPOpzdWqvzWKdmtYhsa9hkceMo75p
	 I0KSM4ueIv5ZwBebdfC6yPKve9YNcMiRarc1wUtvZGc6damYjTpa4jn1sF1rx9VAwBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208038;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4H6PIWPgZAeIXqryN0qH2OWf++Z896gIPleWxMlphlI=;
	b=Ws0HcVB++DjMV8yG510dyhnjlixolVZC8n1nDFmec3HAQekxlwvcJaXnpsa7AzIs5YK1
	 g1nQeQLSHqSKIT9uyMOaHv5IQDcnSBZ9p5Mnvq4Jy2ss3DS28GgOPhEYVoMURWITOaQGn
	 +tNxz1vcIVedhzU41PfSYmAAgXgn+6OLUQLWidx4UL2OiJfZkb59P3NeKp80Tm7irUPi/
	 t1Xsva8pRW6ST98isjNjhAhPKvFRZIu2r2EWoZlWg6tGReRXGfViDFoLc6DkveMq0I58I
	 XdQ/wwzYqU0UGvnfmxOWv8vKrWLraAbS+OdMrXUMBhRn3v34GABquq2af8gy9eyNDzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eR5dNVip;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30CA606A31A;
	Wed, 28 Oct 2026 17:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eR5dNVip
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 202F51F01825;
	Wed, 28 Oct 2026 17:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208037;
	bh=4H6PIWPgZAeIXqryN0qH2OWf++Z896gIPleWxMlphlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eR5dNVipek47Y7dRrzKCLLPpG2YwU0ryOp6qqK+cbLoIMNSSq0zWs2QcDZdoW+Zns
	 8qbEXxg0Rmcpjw9DMBbiLUdFzHL7QvOkn/c0TpQZ+vcBMgdG8k6bQ7WuaTLzZWvihA
	 kmA32EPO5h+gJW44ruNlh8bVV1nYZtVZT6mXFAXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 220/247] io_uring/timeout: dont end a linked timeout with 1
Date: Wed, 28 Oct 2026 18:00:23 +0100
Message-ID: <20261028165952.632007980@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

Commit c74193430febdd120e35936dda3e5aeec3a54405 upstream.

A linked timeout that fires cancels the request it is linked to, and
completes with -ETIME if that worked out:

	ret = io_try_cancel(req->tctx, &cd, 0);
	...
	io_req_set_res(req, ret ?: -ETIME, 0);

io_try_cancel() returns 0 or an error, except for requests that are parked
on ->futex_list or ->waitid_list. io_futex_cancel() and io_waitid_cancel()
return the number of requests that they have cancelled, and
io_try_cancel() hands it on.

So the linked timeout of an IORING_OP_FUTEX_WAIT, IORING_OP_FUTEX_WAITV or
IORING_OP_WAITID that it has cancelled completes with 1, each time.

The waitid test of liburing checks for that 1, and has to be changed to
expect -ETIME, which is what the linked timeout of any other request
completes with.

Fixes: f31ecf671ddc ("io_uring: add IORING_OP_WAITID support")
Fixes: 194bb58c6090 ("io_uring: add support for futex wake and wait")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-42-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/timeout.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -317,6 +317,9 @@ static void io_req_task_link_timeout(str
 			};
 
 			ret = io_try_cancel(req->task->io_uring, &cd, 0);
+			/* a number of requests for futex and waitid */
+			if (ret > 0)
+				ret = 0;
 		}
 		io_req_set_res(req, ret ?: -ETIME, 0);
 		io_req_task_complete(req, ts);


