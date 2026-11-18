Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035602;
	b=5HYb1+CKCz0/VPHIr2HjeITEPlI5ZK2p1Rl51V971orT47ZBEYly2Q8NKEbixxRijE2g
	 WIWvyQ4C9K5zT66FzcXVtfufU9OwuMT0awjIjjpyW5/F2YYOlnWC1OLIspqeGCPtZX0OR
	 VXHa/z8dJJrN/NQC/7ATBwsXXDH9lxENPZFmRNEUF3bDfSCyBv2YbQXidLooHygWArOP/
	 P2qRpAW04+DtyXiVXwqO4THYL82ZLmgTrtR37YUi/OQjKLr3tcdyQZD1psdzl1RplBMi8
	 jSDj4ceYwK8EXIAWWcnLY8p9bhIxVKYX9QAwAe19p1Y9gqBtCzuaKiZJcKVJAxEmgeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035602;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VUyqGv8iJoPHJfvqeBJRQVA2kuYSOxpRI7iAgPzJM8o=;
	b=ftHPNkMa2GeCWK1SNvIimkOF1i+pVgj/jHpVuLU9mbAK5hBVEcJmRfYa83rXe7OsUQ/g
	 HK9JR/K2jMwCp26oBvK201Wn7MZ99RlBJXntY76fYAAanMnPZWxHfY4qZf1eWntw5WxLx
	 pBtTkq9aH9Gw2HjhpY0ZRNXXMWM8qHTdGlYmH1VHowN1M47Od4iuwkh3rx/8Dkin69Lk/
	 dXKt5LhhqYkiFyKGtMqcMhrwTume8eD1ZHCZ0bIL2OGUw62EJo/VBmH3m46Gk+ALf/vbd
	 3T9QnlSHtXS9WhdPI6iREF/B5K3ty27Dryy7lhAYgf+eKtuy9MgjCsMfNrGW3PB0IVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w5+4vZrj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A72606A330;
	Wed, 18 Nov 2026 21:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w5+4vZrj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B64C1F000C4;
	Wed, 18 Nov 2026 21:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035602;
	bh=VUyqGv8iJoPHJfvqeBJRQVA2kuYSOxpRI7iAgPzJM8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w5+4vZrjRFHx7lL/oYpiiD/cFHwNSu6V+rAKBb/6oE2+nBijW70v8k9l24JLGlvrz
	 D/8ekfUB/nSw0EQpN3D/JniTGX6ubzbwMlB3+oGPLT0fBjBdbga17xUEClzdPvapwI
	 yMAMr9CXuJdCw8sVpfUgcD8Bo8aspgKLu+aiAcEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 0745/3318] io_uring/net: keep recvmsg buffer select length within MAX_RW_COUNT
Date: Wed, 18 Nov 2026 15:22:47 +0100
Message-ID: <20261118150340.969984646@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -857,6 +857,7 @@ retry_multishot:
 		buf = io_buffer_select(req, &len, issue_flags);
 		if (!buf)
 			return -ENOBUFS;
+		len = min_t(size_t, len, MAX_RW_COUNT);
 
 		if (req->flags & REQ_F_APOLL_MULTISHOT) {
 			ret = io_recvmsg_prep_multishot(kmsg, sr, &buf, &len);


