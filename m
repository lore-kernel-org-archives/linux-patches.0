Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054519;
	b=WCwQGg+1ejR/NluPJk2685RykdRkjKHq5Y7Gbl0gaCAwZdwZX2z3nizIQ4s+wfL42Umo
	 srDl+7TxuznlLPKtNlQKMuGHo2BJCkD9LK5zrCaOLfZ0Np6o5swnjJu8b0CF/VOwE6TPT
	 gkrNiJLeYuNaBaR8LOTPYnYuPWVl/ApqdxkaSFGsx4ksU6Am5tHgXDQLtKoNUDZxW6Qf1
	 qP8hUAjdLQGu+A9X6wYAXRU+iFWwMXhxC50cejcsOxb7wWK4/LiemFAkFhXC6sdbYfVCx
	 MlUhtvUclmL8EV+D2EkIkCg7Sza6HNhPQZ1/W992Qpqp7vomAJBn5Ve7EEH0HSUxbcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054519;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y77GK80Uv+p6OUPhlIVZKEFIVDyQCKW+yV3vo5zn6o4=;
	b=RO5kBzTrtAKj5mKM8ZoK+UiJbLfVYeRxmK11n+nSYf4sKfuVQ4uvvpo2ODXT5QLdoem4
	 MTWGBrKoZfb9EggEM2nIMhB242wIp9d/S8lQoOLhbxAiApv7dsQUx3/eVxiaTNxXrHz3y
	 U7F1W8JYZn9qzF6SFtDkp0i1+K6Vzs4DuJTEofFasag3Ge+uCoHQzspAzdeaN5RgTm6lP
	 0cc/xPwP7wnekiwRkuubi6fCFj1CxpyudOx9D7lbbM9bgJx+POcluXgsJNFPk5JBUYEoB
	 K4ziqhWiE6MAYaGQfj41FcXC7B7lsCaaaD8BcrpZttOipUwBjb8G/nY/uWqfou1NI7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hswslKI7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A567606A320;
	Thu, 19 Nov 2026 02:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hswslKI7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD1FD1F000C4;
	Thu, 19 Nov 2026 02:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054519;
	bh=y77GK80Uv+p6OUPhlIVZKEFIVDyQCKW+yV3vo5zn6o4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hswslKI7Uy9llaiApqIqvws9OnyL+lyy+bM2RiNcojPGAsrKWQJOoR77LEfhveE9+
	 tu4dTOqZyaqs1a3qIFNXoq+HTEfS334Hj3kU1Xs3PFxtw6NtEW0TgoFseVVCTYmz5l
	 HMSjjHX16DKZ/l9aWTDAHg/JghV4Meoz09fpBDUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhe Liu <liuzhe1@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1304/2214] blk-iocost: account flush sequence latency only once
Date: Wed, 18 Nov 2026 15:49:40 +0100
Message-ID: <20261118150103.672181240@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhe Liu <liuzhe1@kylinos.cn>

[ Upstream commit e9804489e27dd6e33aec5511fe3780ff3009f57f ]

A flush sequence with a DATA phase can complete its original request
twice. Both completions invoke ioc_rqos_done(), causing the request to
contribute two latency samples and adding the same queue wait time
twice. This gives such requests disproportionate weight compared to
ordinary writes, distorting the device-wide latency and queue wait
feedback used to adjust iocost's virtual time rate.

Skip requests marked RQF_FLUSH_SEQ in ioc_rqos_done(). The flag is set
when the request enters the flush machinery and is still set when the
data phase completes; blk_flush_restore_request() clears it before the
final completion, so accounting happens only once, after the whole
sequence finishes. The remaining sample covers the request's lifetime
through any postflush, and its queue wait time is accumulated only
once.

Fixes: 7caa47151ab2e ("blkcg: implement blk-iocost")
Cc: stable@vger.kernel.org
Signed-off-by: Zhe Liu <liuzhe1@kylinos.cn>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://patch.msgid.link/20261102061802.408173-1-liuzhe1@kylinos.cn
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-iocost.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 2c3047d2c80e1..eb19e92e8e5bc 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2808,6 +2808,9 @@ static void ioc_rqos_done(struct rq_qos *rqos, struct request *rq)
 	if (!ioc->enabled || !rq->alloc_time_ns || !rq->start_time_ns)
 		return;
 
+	if (unlikely(rq->rq_flags & RQF_FLUSH_SEQ))
+		return;
+
 	switch (req_op(rq)) {
 	case REQ_OP_READ:
 		pidx = QOS_RLAT;
-- 
2.53.0



