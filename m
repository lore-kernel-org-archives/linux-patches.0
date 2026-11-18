Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054283;
	b=4TbPQ98Flim6wd/NI/krFfzDAkUSC6XTt1H8RsfzTn5kq24LJ4o/XtBsnBnsitTKRdor
	 HtqJxsx+UF9+6hhTeGQgDgWlpbd06hQ0uy6RunetHaW7OZH3YNU3N92leHhec0Tnf/K56
	 VPABt0jCGqgwCHUnG6aXCLxXV4/OHzVVZogKfu0c03NqYbcuFlpFtfQHEFQON+Om2RV98
	 uR+lLpAHiJBHHbf9LikWhRAudmd31vyrbnHrUgc7lv7CvVUxC5mmOSo6dJ5FNQHYhufxe
	 4MHVPy5dlp8Ebjuzq/4MvaVAx0NqK+IvILV1R3m+U2eamje9c6bl3YvuDXqpH9b9cVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054283;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZphQ3j6tDNJUFxc/OIpY6cI23R3rhttnD5zee5w2t+Y=;
	b=43cRnnoLZV2Z59c4yqEfITTLlE0YuS7NxSTsOvfCWfEkwE7+utkCoV2a8TE4zmeijOyV
	 F/dBAS4YLh6fb48tsBv/bbykcb6DqEHXXkjYS1tuHe4gRcdREESkKEf/ky09B5T6wG+vm
	 yYeNSET9steNlPCe70WnKsT3ugqpRuoeWPL4HTVr8pYwpVdlqnLW9qjOcfyDKIX0oPfhn
	 EiyoMD8WTOiXOLTROhlnBTHQQjxawC8ntFs3m9HdmVelF8LUI89qqm6X9KEoNnQcm00yn
	 1ppVbSywO+O9ZjPihjmvpxr5TNnJ4rPwyEwB5CJM9/nEUlHDU4W4snswoUyDFoss6+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PbItYwcZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B92606A320;
	Thu, 19 Nov 2026 02:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PbItYwcZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E0A71F000C4;
	Thu, 19 Nov 2026 02:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054283;
	bh=ZphQ3j6tDNJUFxc/OIpY6cI23R3rhttnD5zee5w2t+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PbItYwcZV7zPxht+D9sGV43nSjt5WasszBxKGm80aCxa2F3A7iaELodCIGLC9pU09
	 vZBMbyp0XTV9/cQqsTfhnPSOoKdBezWgrC8P4WwUfh7CQiNSZjYLHwlW3/yh6UfC0G
	 5a2M25AwNg3MyRfr6qVlX66SRkL6jxrUDsSiDmho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Yongkang <teel4res@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1220/2214] io_uring/timeout: count cancelled timeouts in cq_timeouts
Date: Wed, 18 Nov 2026 15:48:16 +0100
Message-ID: <20261118150100.583896321@linuxfoundation.org>
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

From: Cheng Yongkang <teel4res@gmail.com>

[ Upstream commit 1c8b49851543f41fc8bb18bcd1f15cc93d14b530 ]

io_timeout_cancel() posts the cancelled timeout's -ECANCELED CQE without
advancing ctx->cq_timeouts.  io_timeout_fn() and io_kill_timeout()
advance it for every timeout CQE they post, and io_flush_timeouts()
computes the number of non-timeout completions as

    seq = cached_cq_tail - cq_timeouts

to compare against each off timeout's target_seq.  The cancelled
timeout's CQE is therefore counted as a regular completion, so every
cancellation makes an already armed off timeout fire one completion
early.

A ring with a keep-alive timeout of off=4 completes it after two NOPs
when one off=100 victim is cancelled through IORING_OP_ASYNC_CANCEL, and
before any NOP when two victims are cancelled.  The cancel CQE should
count, but the cancelled timeouts' -ECANCELED CQEs must not: the
expected counts are three and two NOPs respectively.

Advance cq_timeouts when io_timeout_extract() succeeds, under
timeout_lock and before the -ECANCELED completion is queued, matching
io_timeout_fn() and io_kill_timeout().  The -ENOENT and -EALREADY paths
post no new timeout CQE and keep their accounting.  Both the
ASYNC_CANCEL and the TIMEOUT_REMOVE path go through io_timeout_cancel().

Fixes: bfe68a221905 ("io_uring: off timeouts based only on completions")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Cheng Yongkang <teel4res@gmail.com>
Link: https://patch.msgid.link/179328314078.648427.13761781546953594668@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[ sashal: Placed the cq_timeouts increment after the existing error return instead of adding an explicit success conditional. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index a87b24c77c0ee..f0b55c6e2d2fb 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -6264,6 +6264,8 @@ static int io_timeout_cancel(struct io_ring_ctx *ctx, __u64 user_data)
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
+	atomic_set(&ctx->cq_timeouts,
+		   atomic_read(&ctx->cq_timeouts) + 1);
 	req_set_fail(req);
 	io_fill_cqe_req(req, -ECANCELED, 0);
 	io_put_req_deferred(req);
-- 
2.53.0



