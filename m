Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831882;
	b=G6eoighXuwadKuu1YaAQLDvilGsgrMrINgl7i2IizNNVufbcZhx54TYIbj0bJ8AXLakY
	 K/GpJLyMiRObQvprVZVXpCb7Uvv5iosUvNN9UauZZ1ZxZlCvZFiRXpc++IdtUMhPoxiwu
	 TmaBxwfDF0p4NOvIwmaXbf6TikbjS0Uqx1dKbr7qM63VRLQ68vTuNPH98UfcNSnXgQlw7
	 w9oxpgzSi71NaoMbIY+oeZkRhJGRjSmpPa3jMTRevWukvkidCuTNvuBe+8cRD0FDJ694A
	 jOlgQkPa9LcnIVd78UeecoZDD/vs0rjxI0LJwinyAPjxw16MbJxb3Tux6ykTg21eMGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831882;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dQeUDfiTMk6Jt/v5Is5NQKobejpNYw3cUgfLhbK1UFc=;
	b=sbCGsPmOCwBGX6D8uMHLXPFZyll+MZhkxP7FwtjVePv49Vx8GSLqDOS3ARmg4OlZTADJ
	 NdOng+4Zl0ambBtSh/TUsMTiGTuVs0m+m6V0dZRRvf8rlHHf93eUaP9fH2CvT25nxvNVa
	 jDir1fTaggiZQE/ycK3rb3D1aoQRcAyChEt3yRzvKQnWgEsjvfkDqbjzLYXWzGYu4VjAY
	 NQ0gwoD/1Ed87/C/f1XFXF2Lh+aeOX9v4XMvoyARrrv1vGK3DdaY3f2o4JTiWZtbQ1BeY
	 ZsO13jSUKp0B2ugp+TErJSoISBUBXwPCK0DV7rD0xaYJikgbMCke9xw/c7Vo7lBPO8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m4nyrSDE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F25B606A33F;
	Wed,  4 Nov 2026 22:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m4nyrSDE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 892521F000C1;
	Wed,  4 Nov 2026 22:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831881;
	bh=dQeUDfiTMk6Jt/v5Is5NQKobejpNYw3cUgfLhbK1UFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m4nyrSDE5bbiGzYT2WgHA/T7LMnQ/3SMyyeUO1vqWpG9FE17djpZtYw2HUc5BXK5R
	 ilw81cMObJnJwDqlKcNDYNPy0bxEeXx1XCrMdOSONcxFp7hQhl2O8IwpM9nm8uDAuz
	 bs8wgzuUzPKqk4P7DpTpWLY/kJFyK7dnHIhnRua0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 0972/1005] io_uring/net: keep recvmsg buffer select length within MAX_RW_COUNT
Date: Wed,  4 Nov 2026 16:11:45 -0500
Message-ID: <20261104211110.290898076@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
@@ -1066,6 +1066,7 @@ retry_multishot:
 		sel = io_buffer_select(req, &len, sr->buf_group, issue_flags);
 		if (!sel.addr)
 			return -ENOBUFS;
+		len = min_t(size_t, len, MAX_RW_COUNT);
 
 		if (req->flags & REQ_F_APOLL_MULTISHOT) {
 			ret = io_recvmsg_prep_multishot(kmsg, sr, &sel.addr, &len);


