Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207071;
	b=gAGfo2icrQLauStBdX/RxR8Brg4aZQrRNkcEqcK0wrJdIQ+fMVSCVQAzS8GLhekwMDyy
	 SkcHQWPU6xZspUUstzOFhh3/s1N7ZjciY9q6Y5WIbKUZjZ/Nzl9G43gXM7sxucTHBY95X
	 iMcCdOlMSK6u643kP6Br+jvpz1yLOyPPjIR9WFicPVHDIeFpEjFlnEJiYtVrmWP34sEEs
	 XYdm5IoFj9XiXUmJSEM64nYqKOCtTQrTFtSqcXQOa/xCgdQZVKGWnhXqYZB2TigoEV+9P
	 TDkB4ZQR+bJhDwvJR/Q7nqXqgGsFB26iN5NiN5LEwJV5mATY3LZcX0UW6QqJH9ZPwaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207071;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+cT7h/roBcofT6m0UPwWUhI336cn3OTUiQqfltSrkNk=;
	b=0jmEt2whU+lQ5i8TLnuDA/2IoxrHxYvDJnsQg+XjkAoHy3gjfx1iWDF1ieOb9Ejd2ZEB
	 Bz9y5Mp2rnfHxlpidKMNbFuEZTbL4FXDtvBG7+a2gSC5E939R45ygfRECwm8U92gZqx9C
	 7dJqF7DRoaUXVH24H11tfetFXJLG3616q5F5IPMv0Z9gQU/KgNqQI+RUeCcRvCY6HbkCr
	 YHq+D7KnmMKf0Psq1927Pi6jqWv6qcdbotYsMy5OrCRp2zabdml2wwilA9IyxZ3HsGDX5
	 JfiwrHkidRWRMhi/r3Mf7m32FccBWH291u0OLGoYCnvIzUm3df4Mjmcrtal+SPLrQug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pETCyUKN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE6C606A31E;
	Wed, 28 Oct 2026 17:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pETCyUKN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 289C41F01828;
	Wed, 28 Oct 2026 17:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207070;
	bh=+cT7h/roBcofT6m0UPwWUhI336cn3OTUiQqfltSrkNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pETCyUKNb18tzledUnPQOjlz4pVQBNQF9sLRFskexTCeWdUq2cqm+H/8J3vbT1alO
	 sQL6CRSIgtZ2cj7aeh77gyBCdFIapcGG3SsM2Ao+BJ8y9uA+d0og91dOUimZfmjvcT
	 5izXyRlRYXjgcXOZ98ARxDAKWgqxkvxK44OKQd6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tamaki Yanagawa <ty@000ty.net>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.3 16/38] io_uring/net: keep recv buffer select length within MAX_RW_COUNT
Date: Wed, 28 Oct 2026 18:00:03 +0100
Message-ID: <20261028165940.808864753@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165940.394092994@linuxfoundation.org>
References: <20261028165940.394092994@linuxfoundation.org>
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

From: Tamaki Yanagawa <ty@000ty.net>

commit 96262cfab554cf11412de7a6247f0e82c94e130f upstream.

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
@@ -1178,6 +1178,8 @@ static int io_recv_buf_select(struct io_
 		*sel = io_buffer_select(req, &len, sr->buf_group, issue_flags);
 		if (!sel->addr)
 			return -ENOBUFS;
+		/* ring provided buffers can be up to 4G, keep len an int */
+		len = min_t(size_t, len, MAX_RW_COUNT);
 		sr->buf = sel->addr;
 		sr->len = len;
 map_ubuf:


