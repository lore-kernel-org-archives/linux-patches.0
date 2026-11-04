Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826939;
	b=mZrkBLVsUpPkzkxFISDqaHq6ZFrQ+Xf6eRYOdhQSrTLXeSzol4TypHYJblERka94TWyc
	 MffcRlgEMHqt8bk4LKsbvxe9nyB83zw3ZCT/Q5Kcyz04ItA48x061tc/ydpKQ+m8vEjN5
	 ecj0R5ezG0mk0YUZJQJ1K9P6kSrxneXYFSAiemzVHpI06a4VnWz/nR56g6BGeRB3V7qVj
	 KMW0MKMgGmkTVhGykMtnlpCpI4tnKYsN4NXzzSBlsr0x6vs3aClS3CEpR1jvLSh+cdhmC
	 6X8U7W0qnFV4xdUWTfq/9MiESLwX0DiO1bblFsHJSdGj5N15kBwCgvXE/K8pz+GsoGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826939;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=31JBdM/kx5qwRvUiXPyZ5+wejG99KM36TsLTS6vGZKk=;
	b=BaPn4DgsCLKV6aiHuOdPnK7ZdoVKoeAEC5ZlwLs8Np4fIzSx8saSKSDYFaygTyV//wzt
	 aV0cZoPGTU3WignpWvTgKjSQrpcFS7Xpb6YNTzzqiB1fPMuUsnL8XSaBcyFKCcjRiDS4e
	 lc/a8MZALu916AvD6UsJO4K3yFwojXdgloj6zdTNP2KpkJt8IY+o13dNBp8HhvlWccelS
	 KZTMMZ3HJBHDPiC99ROa/k2vTLfKRI1SI5i2PWzz6ug+jYZkQNW32C8v3quDizsiTHICU
	 SR0AOoi96S8QKthGcNWqM0PBb29WAQqnTT5Kn4iTHiBEkQtGanBT1UACaqr3xSLt/zA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="jfVfc/j7";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193056070757;
	Wed,  4 Nov 2026 21:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jfVfc/j7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FFAF1F00A15;
	Wed,  4 Nov 2026 21:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826939;
	bh=31JBdM/kx5qwRvUiXPyZ5+wejG99KM36TsLTS6vGZKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jfVfc/j7YWEXlo80IUpz0y3lCvqXk7nqiAZqZmbmepMiaR2OQFyBf5OhyNgwsfQso
	 l5flvhUGihDqT0QoI9ppn1fjSkt5wF6k1W74X8RaxwQQVW/spHJFvlKefso5Dr1l0s
	 SE3BtTN27Cv/NXr/zXoeh/vEr/2q81gRcAE/Aj+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 058/547] io_uring/timeout: dont end a linked timeout with 1
Date: Wed,  4 Nov 2026 16:04:02 -0500
Message-ID: <20261104211039.933722005@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit c74193430febdd120e35936dda3e5aeec3a54405 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/timeout.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 75c5d22c1d7f1..43a40bda7735c 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -393,6 +393,9 @@ static void io_req_task_link_timeout(struct io_tw_req tw_req, io_tw_token_t tw)
 			};
 
 			ret = io_try_cancel(req->tctx, &cd, 0);
+			/* a number of requests for futex and waitid */
+			if (ret > 0)
+				ret = 0;
 		} else {
 			ret = -ECANCELED;
 		}
-- 
2.53.0



