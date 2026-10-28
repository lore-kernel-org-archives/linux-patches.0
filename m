Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207309;
	b=GwXGIzr6poGCQT/II0t5/rGiTqKcdXEtX+BUpUCyCQ8+uVdmF79fFialt85f3B2fRMHz
	 X2LP0OnnA8oTQeGMfB8RTNmDcjAjgP0mJHW1jKH2eeEzvHB1gjSMFsSL8W+MAFQRjYp4A
	 CND9iBkvs/mZCZbfY6fkfBonr3DLT6Yf8Xwe3hq3LtqPpbJR6NM+ozwOfVxQ+c+aiZV7z
	 umj8VyJXg7vgkfrjlVY/ljfA8t4UhI/S460Z0UtKpmTJB1oOjYJKN+dGOaUYNyYk3mXui
	 tAzQzwSigkbDP2Wo/P+qVAL+Ry4imHICmDRhKxpjV97FVrFBRZK3SBMpFlvotvbcYdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207309;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0xK/8A58u3ZHhDBlZFX5euTYkVV+OEqg/zV/we2pWCo=;
	b=C/mf0tXjnNrWhfXqYcYPd5RfF2gFKJoibc/AaxT/G14DeHt3Y8xyjRjY3qycf4P7fnAx
	 D+29KF+axBpUD4pEaR7h9bFBbNmYgDoYYoxLmE0+x/YiXMuyh+u1GYVAdCa4nI3VL+3RA
	 q9QMO5QJQVFJ/+8HefKS5ol8z3WnolFst1ngb16vpp5R/GGadviUII1fotsDJaC2/dU/B
	 TkMBBlfvmdXWN6KmMD0Rj9yLnQ9A0HBISr0b08gHFfSDD79FnvjKQl3BU6ZJGehmzDIPb
	 GxWF6/tUGAbRjH5Zt3PVvJxac2sXFJUNhIqkwj5oLBXq+FgyNnBgH5sGZ0ksy4tfbJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V8W7+a1Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DEF5606A31A;
	Wed, 28 Oct 2026 17:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V8W7+a1Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 905061F01825;
	Wed, 28 Oct 2026 17:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207309;
	bh=0xK/8A58u3ZHhDBlZFX5euTYkVV+OEqg/zV/we2pWCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V8W7+a1Zhf5Y7R51+GpNrq+IrVWZs6VVEnE9s78/3u77D2nda7DNjTF6lQsRjwUlp
	 EbvuKPE2Wfe3kIiWfKbmdb/S6TmDV8uscBog+KatkqzVZCHAE9PxT5xiiUkz5v5uLG
	 BQb2rLugvrwpruGbmwvTqWOrEFuMWn7OazF1rVWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 58/88] io_uring/timeout: dont end a linked timeout with 1
Date: Wed, 28 Oct 2026 18:00:06 +0100
Message-ID: <20261028165943.479306642@linuxfoundation.org>
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
@@ -393,6 +393,9 @@ static void io_req_task_link_timeout(str
 			};
 
 			ret = io_try_cancel(req->tctx, &cd, 0);
+			/* a number of requests for futex and waitid */
+			if (ret > 0)
+				ret = 0;
 		} else {
 			ret = -ECANCELED;
 		}


