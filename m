Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208112;
	b=Ijdi9Nwh9nRdx+WHO+sB61mbjq42twex72DJNMqmhk8BscNXPuPoyYNvqfMWWYxQS0Uk
	 +wCNgouU1XUYtHdQW2phBHCDIvfO0OeL6Odp3STgJzWNhMZW9lMWxnGFjvgN2HVr/jKZg
	 fwMmps5lUGOYLUy7Mn75ZzJYAXqMjwuZtWhVQ7LMzWF/fIqCHj5JWrje2Vx5pJScnICPV
	 XHYHv/fOFZ9ci27qV4R9iv1nz+cZrwdoxIxm4w9AdxnNf6T+Re2ieBvCIWuNcODe0DxfH
	 OjcYv1PRBEYOMa94+RNdM91xKVCnrKvyWXz8feeqlULArQi0Y+yoHLdEH9rDh980v2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208112;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h5Bm0RADF+XA0dCpafDmA71RMCSztMBLzXU24OB4RnA=;
	b=y0Ac6qgwV6VE7FD0GeGcFB4Vj21B9argK5ViglyRjq9m2VJq5Ee1sutwmKpQh/oRFkcD
	 VhptFuoFbF7FpUc0iKgFeBNPlSyHF0mx1QUxDSUsYUCkytnotg1EHk0V+4QNkif29wq/q
	 hR62MkfAObvbXWWZUAAbE7EIMB5q4OInoAkUa4VqXeK5xMpKyHfIoib+nS/AH/lXjqP6u
	 mEBAbQy5qTT1xAEytrahJzkDI9EMStgSpI4wZtN5iEV8f9Q4JDDviQSZkS+1SshTx9/RQ
	 IC6L1iffqTMdScJtn1mf0uQLUr0QL9xW08QQq+snwG6TVviP2/OyXxvKQbcL9GYdEFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZOVKgUpu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1627F606A31F;
	Wed, 28 Oct 2026 17:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZOVKgUpu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67D931F01828;
	Wed, 28 Oct 2026 17:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208111;
	bh=h5Bm0RADF+XA0dCpafDmA71RMCSztMBLzXU24OB4RnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZOVKgUpuO+EOK9CcsI5pqZ3RWgILutov6HhU8JXl4BenqLLWXJw5o+e6hRfDXjoKY
	 sRUGF2TJ3LCO3piqc72DgNDqETo5rKQCbeTs1azBrSN4QGJ+LOXzxuY5xpqXL3OUEC
	 AQLevu8KCH+n/8/0skZbud1JHf5IV+v0M3idPgNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tamaki Yanagawa <ty@000ty.net>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 227/247] io_uring/net: keep recv buffer select length within MAX_RW_COUNT
Date: Wed, 28 Oct 2026 18:00:30 +0100
Message-ID: <20261028165952.796668884@linuxfoundation.org>
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

From: Tamaki Yanagawa <ty@000ty.net>

Commit 96262cfab554cf11412de7a6247f0e82c94e130f upstream.

Since commit dcbd1c054848 ("io_uring/net: let io_recv_buf_select return
the length of the buffer region"), io_recv_buf_select() returns the
selected length as an int. For a non-bundle recv with sqe->len == 0 the
length comes from the ring provided buffer, which can be up to 4G, so a
buffer of 2G or more makes io_recv() fail the request with a bogus
negative result (e.g. -2147483648) instead of receiving into it. Clamp
the length to MAX_RW_COUNT, which import_ubuf() limits the transfer to
anyway.

Fixes: dcbd1c054848 ("io_uring/net: let io_recv_buf_select return the length of the buffer region")
Cc: stable@vger.kernel.org
Signed-off-by: Tamaki Yanagawa <ty@000ty.net>
Assisted-by: Claude:claude-opus-5-5
Link: https://patch.msgid.link/20261018042227.1105-1-ty@000ty.net
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1188,6 +1188,8 @@ static int io_recv_buf_select(struct io_
 		*sel = io_buffer_select(req, &len, issue_flags);
 		if (!sel->addr)
 			return -ENOBUFS;
+		/* ring provided buffers can be up to 4G, keep len an int */
+		len = min_t(size_t, len, MAX_RW_COUNT);
 		sr->buf = sel->addr;
 		sr->len = len;
 map_ubuf:


