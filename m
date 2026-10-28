Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209805;
	b=Ge1NCavtkSu4t0gxr9GZKnEuqWQt8u3YTBp+fC/y/bUxEG+mB2Ppu0GLxOMYK0Q+CIvT
	 GFdNiY9jxLcx8X14l5RSj3pk7iKDxyPqDqHW8RUhn7HV5iZrhM79s6AS2ncbsUSXYlNyM
	 wfFYL+7eo877M6QrtDPgt3q/4j4c8xuJSdAYH5CoJj4/zoSUXj0ys6JI4zSEBYi+lK4C5
	 9F19io/g942KLbSgWfKxCBuwOwlVyP6bWgadkjdE8DJmB2XumPh48jOvONV8SJgvB1QTI
	 Ls2+iqhjh8YzgXdlwOAB6PQyj9rP+YptPMZ7sIuk0ZMZhWyyCwRbW6M27AndQn5nyOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209805;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CvIoEbJrJVyuXstc3betopEXa722VPIif7YFvJRj2DY=;
	b=futXV+CHOoPlB4k8/N2l4bJKE9wL/lTJY6Maf/18egIlweZitwC1Oa0S1Ukozv2ctvP0
	 kR954ahwEqYGt7MO/cY/wvV09+fW1oYz6H9aJJxJhfTRNrrTU396bV/Selb2ImZkjyv0q
	 mnLh49rb9s/fgS4vtRmTlK6h81YT9mHV0R45IEjm3qqqtFjQ1V4rGLdNHhlZtZNycz6pq
	 EOou3Gy7SGhvA2YAdAY5YgifGRsedQTeFca/E5di/0XnVii4+OmWE2K5aOoN1uCTpYeBO
	 XekZGrZ9KMVwtbHIOnOwvJoPQYICrj4frfvBItQmMWS6F1wykS46rEKZm+T/6DDZ2RQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M0wtGGM4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8D8606A31A;
	Wed, 28 Oct 2026 17:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M0wtGGM4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B7F51F01825;
	Wed, 28 Oct 2026 17:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209805;
	bh=CvIoEbJrJVyuXstc3betopEXa722VPIif7YFvJRj2DY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M0wtGGM4Tw45uMB4FWp9P95cQy5hk6ABRF8HnXBlKdFS2uqFNfNlmpHabP3Ezar/B
	 ky7b3ixu59/wM59M9EFjL+GvQBhj+y/LCvjBlXS0WbSEWFDy6M+1l6x93jKsB9kAmY
	 ZW9HlaZUf4SE3KYf34jo45hnHixx94/c1JdQP3bU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juanlu Herrero <juanlu@fastmail.com>,
	Anand Natarajan <anand@meta.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 081/109] io_uring/poll: avoid retry wakeup loss when dropping ownership
Date: Wed, 28 Oct 2026 18:01:05 +0100
Message-ID: <20261028165944.262826494@linuxfoundation.org>
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

From: Juanlu Herrero <juanlu@fastmail.com>

Commit 937d38dcacd675dc0572d6c9b6743960df3128ed upstream.

If a wakeup sets IO_POLL_RETRY_FLAG between the owning task consuming
the existing instance of IO_POLL_RETRY_FLAG and the loop check
of io_poll_check_events(), then we stall on processing the request
until an unrelated wakeup comes along.

Using atomic_cmpxchg instead of atomic_sub_return to guarantee both the
count v and poll_refs are 0 and no wake-ups are missed.

Cc: stable@vger.kernel.org
Fixes: a26a35e9019f ("io_uring: make poll refs more robust")
Signed-off-by: Juanlu Herrero <juanlu@fastmail.com>
Assisted-by: LLM
Suggested-by: Anand Natarajan <anand@meta.com>
Link: https://patch.msgid.link/20261013-pu-cmpxchg-v1-1-4ddc10fd8a03@fastmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/poll.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -310,7 +310,8 @@ static int io_poll_check_events(struct i
 		 * Release all references, retry if someone tried to restart
 		 * task_work while we were executing it.
 		 */
-	} while (atomic_sub_return(v, &req->poll_refs) & IO_POLL_REF_MASK);
+		v &= IO_POLL_REF_MASK;
+	} while (atomic_cmpxchg(&req->poll_refs, v, 0) != v);
 
 	io_napi_add(req);
 	return IOU_POLL_NO_ACTION;


