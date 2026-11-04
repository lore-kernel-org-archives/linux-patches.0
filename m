Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829262;
	b=iPaUlLI7yigHfUUsrJ+APmQyldvF+QbTfu+K5Yo1kFAAT4qJ7LvRiNCJmtugcF3kADKu
	 3JlbZ23EZTpfwo6LS9fP9FxUKVO8GVnWzIqhY29mFRRDjYtoUVz6iril0odOv+zmX5JM7
	 CbeYHrM6lVEdT5uRc1mg8KVz9Om66AYPq8C62/SKyvMoY0kzvCGUGNgQU6Tr79eibUNMK
	 Lu28bpXG++p1LUfxQ/8goWqL3zvL16xp/yBGnpz/Ya4Dv7/pJmP5jpCcPJbRNjNPwsqeJ
	 588Znku4mbmsgUgRM4nju09JAtgdnihjUvCODGYDvwy4P7BVHTeT6d4GbFC3faZbHKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829262;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nJQANoG22mnlUBZMdHZJFk9GkstSPVILfeD2zC6v7Bw=;
	b=HR7C2+ekXtF2ggXs+bvAHkhDf4z/3LOiCUfBp1zXkuxGyZKOH2qX1l8T66Mu3OS4AhR5
	 HbyeBA+lxqH+EMhMSWVQOrkRT2b+tPEPDpoFW5RYJ1dk5YWqCBeZLV9TcPGVdIfY//eRj
	 5C6zVEZ64/kNu12mxYDB0VyOAQ3TMux8kc99y5CznzJJKTtMJCr8Gv/pLqM61W5d9zpdY
	 +6HdpPE4+dvs74D35wLzN2/Q6f9jkujvFzPWgVySZKfc5gEQRDvKwo/pSRnZTswD1VMc3
	 LsXpXM+ky/Fk9Plt2MKTazsNVpSAwmcohIyCj6VJLJQqoPWeeiyqx/y1maHLen0V0ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S5lwJ21E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF686074595;
	Wed,  4 Nov 2026 21:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S5lwJ21E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A9671F000C1;
	Wed,  4 Nov 2026 21:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829261;
	bh=nJQANoG22mnlUBZMdHZJFk9GkstSPVILfeD2zC6v7Bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S5lwJ21EULoeTKASkXyP59CplTB3PmwfdP33vlTUtsKo3zK3yCpYgzz0Q5bpbcKQa
	 Uf8MGKsI+le18vNntP9bhu+JjGoq46yPwlPWLrpT5WOAGai2poZjE7JK4CBG7aySJA
	 vcPJ2GPX4/yC5Sx58XJiWXpEVoqQs17zPH0Hho5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.3 519/547] io_uring/net: keep recvmsg buffer select length within MAX_RW_COUNT
Date: Wed,  4 Nov 2026 16:11:43 -0500
Message-ID: <20261104211053.138506693@linuxfoundation.org>
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
@@ -1068,6 +1068,7 @@ retry_multishot:
 		sel = io_buffer_select(req, &len, sr->buf_group, issue_flags);
 		if (!sel.addr)
 			return -ENOBUFS;
+		len = min_t(size_t, len, MAX_RW_COUNT);
 
 		if (req->flags & REQ_F_APOLL_MULTISHOT) {
 			ret = io_recvmsg_prep_multishot(kmsg, sr, &sel.addr, &len);


