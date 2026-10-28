Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209800;
	b=yT2jgfefdtvkxVgMO8D8cR4/qg1rg5j9kNNOk/gGqU+5PKKXFSg9lvNOB3pynhyRjuRX
	 /gyDd8eDCiXlI9mOK76SsocPFkoP+TRSGkQ6LD0HcJOYGfvuzUPCz1P8YECJmkCTY1fSe
	 ZVRLfvSaOa8v4rrRFEQbzRjfyiAR0uHuU8ocJcyi1nmhDjVrNvT057piOsSnkHnqJCadP
	 e+Ft6CT/OIxDZDEJgB6YguPWkycJczAJBa1obXGaQ78/o0DpWvjy/DNWIei2cyTV4eFkw
	 tIRQufPmps+6cYMeb00aTIwaZ07e+lV4kCAeaTfbkxUMIZrTS4Nhi8CIypH5YkK76CQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209800;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q6aBBvucv2SlOXhFnPxOZgHW0gc6uLjy0Z40R4wTIko=;
	b=SKxW7C4JBjzUx5JET7vbWgIQbddA24R40Zb90CBJIBUPD+/M17yFBjqqH3dvvbcbpRHB
	 KN9R2wYRP/nD9Snt2ERuOE06d2AwEPq+H1LQXv+YM0iWiHusC17bUSGWyBZHMGhNtr8dO
	 S2+K6R7VhKmsWLfkYGV9g/4W7HmI187b95F2S+0zuXP66FldpU12T/pI6M/vRgTJn1SmT
	 W85fNnrb5Y+kzDOJMYzy1VipkDraFy+ZFpNAoZrsAf6typeyJ1tSciTfTbagE0uqRr7MK
	 l5nzisdVtaJPQSpmyx2lj9EkWvK2dFh5FGXcYOkiAPFsjrSKUm0UILhPvApy47tC0VQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C4VrTCua;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B58606A31E;
	Wed, 28 Oct 2026 17:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C4VrTCua
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F06B81F01825;
	Wed, 28 Oct 2026 17:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209799;
	bh=q6aBBvucv2SlOXhFnPxOZgHW0gc6uLjy0Z40R4wTIko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C4VrTCuaYrzEKh3bCe7eRMXrXpXkEOU8JCGUDUOhWuLnTHCL6QdfJ57FFjtkXnJ4P
	 9Jc7DmSvZSqwoesdja89PQua1S5sPRi1Wxq4I3gLbIJjh7jKF5mzlBdYV0S5NBSwfa
	 wKM6vvf6AomZNRLd4Fc4fgRZCyosZZWxyiVlszKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 079/109] io_uring/timeout: dont end a linked timeout with 1
Date: Wed, 28 Oct 2026 18:01:03 +0100
Message-ID: <20261028165944.216306473@linuxfoundation.org>
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
@@ -342,6 +342,9 @@ static void io_req_task_link_timeout(str
 			};
 
 			ret = io_try_cancel(req->tctx, &cd, 0);
+			/* a number of requests for futex and waitid */
+			if (ret > 0)
+				ret = 0;
 		} else {
 			ret = -ECANCELED;
 		}


