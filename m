Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209820;
	b=trfy7xIvgSYgdgupPuORfw4KxrbqZmRwWfU07O3CTt1LrNRV6xXRxgnHOHIZ39tbzPez
	 hXx0Hd1wUbjr5AC+idPGFipWBmdgMI48pvUveLmKpNO2vE8YF+daoZ9FSZRfmFDHf1cCY
	 fV82qQwuvJrBP4wwTRQAxZJmTnCoZOdq0Pg7du1OE3fdnBq85OM5I/6lnwmvSH63ypXDn
	 P287lk3cn0T8uZkwseuzGQpLBsy2/KcZlhkCo4OR5C8V59K1dSkYnad3a8lQ8r0J+3P9S
	 63ii3FmqyrvzQy+MMxlq83D8ImIujxM0Oef6weUp6gCLwlr9VoIh4Pv9UWci8aiUPqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209820;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=21ZSfipS7MUxgvFR2FreX8bFPWv4e+zRaF+2UvZv0xI=;
	b=tcPgUSkcW8xvJ/ggi5/a4wLS1+HB7NL1GQqYckTzsD5Wn8mpcWcN7XSwErWCQ/cB5H+2
	 5Fd7K03CzmNd8jAP5XBtJ+uFfewCY5ihj5TN4A9AJ0BIkZbYQOgiqD/NEb+KCG1y47ick
	 +/0AUea+hF+hj0d2KxV6YKrOrdV69Dz06zSa/DAJASkJtKprXAqLNDoisZCDXZuuTULVI
	 at4kT8lQHIMm5gnZyKdRRhWRVgWx553F14QAB64KjG7G8HV1wkpZH343AlRX0klcDIsCg
	 zECsEvtsFIL2mfvmeXUhyz6ZCnJ8ZextHXwp5+zFP/HldVMn0IvoXLhpZHnZu9wQx7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=djPOdHRV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9FCD606A323;
	Wed, 28 Oct 2026 17:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=djPOdHRV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06DAE1F01825;
	Wed, 28 Oct 2026 17:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209819;
	bh=21ZSfipS7MUxgvFR2FreX8bFPWv4e+zRaF+2UvZv0xI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=djPOdHRV3Gzb4TPVlQ3tti1TdGj6IjQJDwH6fPzIJLiOXVShhyZqBZkBGVa2guNDJ
	 ecRFY/UZ21hnl4SseBCS5Casu/aM2ywObJQ9uiB4Ue5J//ojFfc5/3iLSTCGe9OshK
	 miCqUVYnnOwdfJRU3+AoUrlKC+c6HeRcDeuXHvKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tamaki Yanagawa <ty@000ty.net>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 086/109] io_uring/net: keep recv buffer select length within MAX_RW_COUNT
Date: Wed, 28 Oct 2026 18:01:10 +0100
Message-ID: <20261028165944.381728108@linuxfoundation.org>
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
@@ -1195,6 +1195,8 @@ static int io_recv_buf_select(struct io_
 		*sel = io_buffer_select(req, &len, sr->buf_group, issue_flags);
 		if (!sel->addr)
 			return -ENOBUFS;
+		/* ring provided buffers can be up to 4G, keep len an int */
+		len = min_t(size_t, len, MAX_RW_COUNT);
 		sr->buf = sel->addr;
 		sr->len = len;
 map_ubuf:


