Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207289;
	b=A9LFrow8GSQpzGzlTsQthAiE0I1P8FQF1FMldvRRUL87eVgKdclaTpw5oac7wnMkkzAy
	 /Y4J2nIj/QtRDorCRNSdgcGw4PoJouhVo+VL2j9YwCVaLshEqxQr6Pod4vZMnpwUcoZd9
	 aaxH49j0nrLW0OacGyIjohcSI8pahwyhl2MolNYpo439prrThxSGv2j/p5oJBuNiViZFh
	 lFRtwyaepAURYDiIl3ZD9U7Q0PUTaV+obSfTvydRG46Cwe5i+7+ihIM3WBxAkilHivter
	 ZGcmWPMXVVOv+BncAU5/Y2eTo59fH3xx82zQ/ziNDA4noY2m8NEbAGdIKLLMmaokHOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207289;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O19rvXqPNpJJWLXOafdfnmDHa4ahwm4rZA9S7Qao0UY=;
	b=4rmV81P9S6COQpeQQQIRvm6f5Pbp/RGwOYAfhqGQV2ZaDDGFS9aHcKVXv1ro9LfjmVcM
	 0B6f8EDWp51UIL3EZ0udY9KcZMH/oAqCHoz52DOjIfG66UwDInrRDN9WjLS684zrv0viG
	 6MBe+5KpSUHdaaND05OJJryD+KTv5Rt6tVj+CK9mQzwijNb0HTgmMZHvySumkakrUdYBN
	 mmghzmE5EJ6Kt/KEsFZcVxnKpMeNu5CjSQTga1MqfFLbojwcLbuiUzcyjaJ+eH7/pgofU
	 FdWfGEmiWlxmJtSsHSELpW0KeJZmfTvR9gq28t0vNPZLYSCvsSsl3b3XRU4QpSKuLDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="hxqM/Kxj";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A90606A31D;
	Wed, 28 Oct 2026 17:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hxqM/Kxj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA0861F01825;
	Wed, 28 Oct 2026 17:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207289;
	bh=O19rvXqPNpJJWLXOafdfnmDHa4ahwm4rZA9S7Qao0UY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hxqM/Kxj7P2mlpnvi5qe+8e5DcWyn65ohN7i62WgNgFWWQK5ZGK8CVrgd0C2CpkK9
	 nT3QHxlt6pUwT4GZajgXIbqjWcTTO0RRe4BCFONN5g42vbYkTVY00dEsYVYcbSThTK
	 DW3tHOW8Zc6u9PY6VTF5g2if4pdqXm+W05vZ+z9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 52/88] io_uring/kbuf: handle index wrap in last buffer check
Date: Wed, 28 Oct 2026 18:00:00 +0100
Message-ID: <20261028165943.338292969@linuxfoundation.org>
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

Commit 6e773b5161506a4d0e739eb3aa4667d28f20219c upstream.

io_ring_buffer_select() flags the request with REQ_F_BL_EMPTY if it takes
the last buffer of the ring. Head and tail are 16-bit counters, but
"head + 1" is computed as an int. If head is 65535 and tail has wrapped
to 0, that compares 65536 to 0 and the flag isn't set.

A bundle receive relies on the flag to tell that there is no point in
trying to get more data. Without it, it goes for another round, finds no
buffer, and the request, which has received data, is marked as failed on
account of the -ENOBUFS. That severs a link, and ends a multishot.

Fixes: c3f9109dbc9e ("io_uring/kbuf: flag request if buffer pool is empty after buffer pick")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-36-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/kbuf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -203,7 +203,7 @@ static struct io_br_sel io_ring_buffer_s
 	if (unlikely(tail == head))
 		return sel;
 
-	if (head + 1 == tail)
+	if ((__u16)(head + 1) == tail)
 		req->flags |= REQ_F_BL_EMPTY;
 
 	buf = io_ring_head_to_buf(br, head, bl->mask);


