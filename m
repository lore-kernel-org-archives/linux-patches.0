Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207411;
	b=qdqmYmDOGdC8ZceHwdinWNJ0de8hMH/gVWH7TvZV64Upaoh1zb7D0qZJLYtSC8r2i/nj
	 tD5O6n06ayni74xKyrFnxrZz9djFetMfmuLp2miRXM2p3s2+4eXMub8SVGV5JhK3YgTzI
	 U4uyijYYLEB84j/XrBCcsRWqFDtrakTme61DOrBZzXpEQQ3INj67/QzZZKCgdCgSqF3FI
	 atT+5B13xjlcUV+DCIXPtfeo09G5+V4CPosLK9wuBd2/3rJdrh190ji14qFnsfG4FQNPC
	 MP5T1AHhiq1Y3B7Ux0+O8G2N/NolRGTkGLRcm88PDi9xV3yX69KE1h0YfcB5ytdAYdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207411;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=keaSVXUjlZR/XnDsb2IKm5sMQkdm3aykOzcPl07yk+I=;
	b=BZHYtjF8B6/jc9FRQjkTOdKb36epqte74fJuNqdm6tp0mYSZdOTgJU/TEERnurqURnKv
	 1oNFSTfLMp1VDeNdywa7dlufzZ1TY3Fls6q9GsHiqU/jEblflvDyC1b4bnRsM49wihQmq
	 4xvmml33qqI70OM7CYZzDF2cBvylNALLcK4tuEmZWHbGtLlcoaGn1+ZGxln9yfb31dvM2
	 GH1bgOveq7adVuC2go6yGnnIX1FICUAZG8Fjrkj36B06n9bO7rY3nuCZ2TVIcYaLVIl9b
	 tvMf8EBiPi8KC6AJGmrDgCHpYOO30HbciNhTz0DYkpuYNUq5tY9weUVU6Q0whPauM8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OZCtPqbo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1FD606A31C;
	Wed, 28 Oct 2026 17:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OZCtPqbo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0C11F01825;
	Wed, 28 Oct 2026 17:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207411;
	bh=keaSVXUjlZR/XnDsb2IKm5sMQkdm3aykOzcPl07yk+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OZCtPqbor5sgCdynGBcjopPzQH4CZR+8c2WL+77LsHzn6G8rsCecxhtLMi4C1S+Rq
	 OmMB4SV/i7OA6DOOSZiP9PgAex5/D8HTGYDhz0PJDe+DjPVN0HkJG6+hL3bTKcqSTP
	 aHPv+U3+PBO0TYB2BcTgGq9IO4y++yZdgzFtTHrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tamaki Yanagawa <ty@000ty.net>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 65/88] io_uring/net: keep recv buffer select length within MAX_RW_COUNT
Date: Wed, 28 Oct 2026 18:00:13 +0100
Message-ID: <20261028165943.646116319@linuxfoundation.org>
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
@@ -1228,6 +1228,8 @@ static int io_recv_buf_select(struct io_
 		*sel = io_buffer_select(req, &len, sr->buf_group, issue_flags);
 		if (!sel->addr)
 			return -ENOBUFS;
+		/* ring provided buffers can be up to 4G, keep len an int */
+		len = min_t(size_t, len, MAX_RW_COUNT);
 		sr->buf = sel->addr;
 		sr->len = len;
 map_ubuf:


