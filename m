Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829272;
	b=IcZEtQ4lFK4mxwl9xMmw4LHe/kWuIuSHZpNIZpgJ/RplTyLmiPAuEaepFpFC4CS+psC5
	 CPxpp8wb9Y4fC9ADc6KH7YQo+B68ufjYfUCq9arwTo3kGgULB0GTsgEtWONNDEOaWKTrB
	 9Q2Chb8wFeiVjG1Mogi/MMoSWOA0FQ0JpGmMNaR+KYbm5YPUXgyRAIBLEo4v8O5X29LJZ
	 sj+CrzeUEVErGSIq2ImSohyltlv+RYuyZrpY2fQRd9jaSIhgsquAtRZBOO/gR7HY3blx/
	 9BUVFJt1e+ETb0RSCxQ3DvBikKZMoztnaHO7XIpBlcSv2IcOpWQXpkuJV4MTgGX1WOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829272;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Mg+JwnS90CMwvIEalIgqq2mxaTVLRKxuYwc36C/hHLY=;
	b=JkDPaHYjh0DygXih54Cokd0kLhvzKdMl+03scI+TjJZmaOspPJnGmXTnpSthy/MzsJzS
	 Gl/IlrOW0BoWBxlVLxPw47vrlEKVdw7n01ioKA86Gr49ser/dQRTdEmhKfljQLX3YhLco
	 o4UGCSvA2vC98H1d/VLGojiRWRuDtKKzpduJPU6OOMR5t5F8G8oia5tfXFpRt1+fMNKg5
	 3f/thpPQuOINLsEz107QCW40+gxB30+ZVyqum6WI1KLsKq3upQNEZwyG/vKrY71EznsYF
	 wKXzCOc3/QjKgvYrLgdj6XcR7Urk7ehpF/JCmMwQqpEd6gy7RXD+7rbgKG1lrDiXsaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cgYkwkHg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B16D6070AA2;
	Wed,  4 Nov 2026 21:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cgYkwkHg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF0D91F000C1;
	Wed,  4 Nov 2026 21:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829272;
	bh=Mg+JwnS90CMwvIEalIgqq2mxaTVLRKxuYwc36C/hHLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cgYkwkHg7BeaNJ/T+P7cPwvD7sbfnwNlHrdFpaoYz4Uj9wTU37ERruTQluTXGdZQr
	 5tqSeZDO4W3Y60rNoDFixuIBjOl4UBRLkejc2uh5uggcHlFBZ9xpJDcY7JIZ6v2tl8
	 K3Hymk7SiIYr9IJLfJ0NZXXQgrrcT5klyy5PRAjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dominik Maier <dmnk@google.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.3 520/547] io_uring/net: mask socket type with SOCK_TYPE_MASK in io_socket_bpf_populate()
Date: Wed,  4 Nov 2026 16:11:44 -0500
Message-ID: <20261104211053.166817435@linuxfoundation.org>
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

From: Dominik Maier <dmnk@google.com>

Commit e66907c3ba229399ecfb4ef032b95a4a071c894e upstream.

When an IORING_OP_SOCKET request is prepared in io_socket_prep(),
sock->type retains creation flags such as SOCK_CLOEXEC and SOCK_NONBLOCK
until __sys_socket_file() masks them off with SOCK_TYPE_MASK during
execution.

However, io_socket_bpf_populate() copies sock->type into
bctx->socket.type without masking off ~SOCK_TYPE_MASK. As a result, a
cBPF filter inspecting bctx->socket.type against socket types such as
SOCK_DGRAM or SOCK_STREAM can be bypassed by ORing SOCK_CLOEXEC or
SOCK_NONBLOCK into the socket type.

Mask sock->type with SOCK_TYPE_MASK when populating bctx->socket.type.

Fixes: cff1c26b4223 ("io_uring/net: allow filtering on IORING_OP_SOCKET data")
Assisted-by: ARTIST LLM
Signed-off-by: Dominik Maier <dmnk@google.com>
Link: https://patch.msgid.link/20261022232120.2537530-1-dmnk@google.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1734,7 +1734,7 @@ void io_socket_bpf_populate(struct io_ur
 	struct io_socket *sock = io_kiocb_to_cmd(req, struct io_socket);
 
 	bctx->socket.family = sock->domain;
-	bctx->socket.type = sock->type;
+	bctx->socket.type = sock->type & SOCK_TYPE_MASK;
 	bctx->socket.protocol = sock->protocol;
 }
 


