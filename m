Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061848;
	b=AUo5IrFXQvqJaID3kt/Gxw84emyMkTI731a+sUV8XCuSctomu8SlnWxhe7IxdD1EsMSg
	 W5wCHdi9GE7NMfV1gLAO06bwiaTjJwE2UNTzI2P/lYgqjhxouJGiQB8dQYcWIBGTpRV7n
	 gcxyxK1AlZYXz8dye5oYXi6r7ZSypQuXowG240rZ0d9PdE+4rPsDbY16YFb/9km5WPOtA
	 tEJVhbbWZfCCe5zC+sLcxhdHKU9vYHpy7GK/THe8ud93G99Wy420RrN3Wbh4hzMm6JyGr
	 /L7TfEskK++9dY0665r/+84fCKLFfC8KCqE8IEO89Oth75UGken1UPhnzuKDaHCTsnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061848;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IZWafHOcVlNS3IN5ZwviSYiOER8o4pp5bzWUpAQ2nWE=;
	b=rzUBwZUmc+zziKgcWuH7vdOOn/aRr0yAz7mTHMdAs8XYDSWuZmyHfRyUH9WhPlV+XBig
	 avG3xrSsfsmvoIgh1qldkFmarAIHQGhrZFlnePKhA2vxKQc75kSnI6oDNGYPSZV7py83P
	 DivVwyse55apFdoMHLk0JwRa+kbifHhsCG4L2DFt4JojDEAhHAbpc2Z/f9Gu3AwTDYdws
	 60ZfrtMPuFAEsqUBjwmSyPwS1sV9trChUzSOtEXZpMazS8TTy/+HU8ga7O4EYfKVkoveq
	 /op00pJ0A8Rf+s8+lnMLzKwGkAsAjhRfOU0Tus+8Kv0gZW/OIgfevrM1FT1nzJBKfFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IARv336I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC45606A32C;
	Sat,  7 Nov 2026 14:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IARv336I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B5A51F0089F;
	Sat,  7 Nov 2026 14:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061847;
	bh=IZWafHOcVlNS3IN5ZwviSYiOER8o4pp5bzWUpAQ2nWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IARv336IwEZVgVQQKT2V2qYcIHm0vTt6YSzsv52c+tshz6KpvN3B74qqqdY+9zYbu
	 EOTuxd34ZMPDpvPc9/0B5fTk5VcaiX54qqOqCtMKFKh0V7CQWV5sDLBX/p7NvVeJSb
	 niVa7n6RyayPAlSf1OUEFiYbk8Pltd3hNK0RDgmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 0829/1536] io_uring/net: keep recvmsg buffer select length within MAX_RW_COUNT
Date: Sat,  7 Nov 2026 08:47:25 -0500
Message-ID: <20261107135020.830363405@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Yichong Chen <chenyichong@uniontech.com>

Commit 18d3f56eb6e6500a65d81cf265f0fe74fd9ecab6 upstream.

io_recvmsg() takes the transfer length from the ring provided buffer when
sqe->len is 0, and such a buffer can be up to 4G. min_ret is an int, so 2G
or more makes it negative and the (ret < min_ret) block is skipped, and the
oversized length reaches the socket layer unchanged: an empty socket then
completes with 0 instead of arming poll, and a short read is reported as
complete. Clamp the length to MAX_RW_COUNT, as io_recv() does.

Fixes: c7fb19428d67 ("io_uring: add support for ring mapped supplied buffers")
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Link: https://patch.msgid.link/20261023112209.87979-1-chenyichong@uniontech.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |    1 +
 1 file changed, 1 insertion(+)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1061,6 +1061,7 @@ retry_multishot:
 		sel = io_buffer_select(req, &len, issue_flags);
 		if (!sel.addr)
 			return -ENOBUFS;
+		len = min_t(size_t, len, MAX_RW_COUNT);
 
 		if (req->flags & REQ_F_APOLL_MULTISHOT) {
 			ret = io_recvmsg_prep_multishot(kmsg, sr, &sel.addr, &len);


