Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208006;
	b=PmKPLh5Kn3MKKSD6GODfRC1bcalL1l52h/p1tddcqkDSfHnDUfzEbr4O12pjJVfI7VQS
	 x1iP9OAa4ShXRSGNFWaKw+8Em3DAN1bfqfEP8qCpPIKJrUxnWLLqJ3xCC2xMOoSuJbH3P
	 RBPaAhhnbfeE7njeTACz4bkU8/atKPgeOoqYjPpfEanVWpT12zlv3PLkUW/v/WrahGw89
	 jO/27LhcyneF6CYP8ED0Iya5Uvw9sG6rZ/Il0HDrkbXdx6lCubCsMHa1ZnElMppn732mH
	 MPCib77gsVj6Mhi5xULDzYb1wSOSHfPnPoYvZcVwPo9AVxFp5Epj+dGFIi94MNMRCBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208006;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bdGCH9Jgzi4ZsdkMdmniCxR7WldY1s0/OQ9CRtMLANk=;
	b=ZixNBOyiIcOSyuDX7WXuneYpIIJd669yM9ip2RRGXH0a8Oh933qctgELg3M2pBxDMpwy
	 +BbdFcV51sIfPBn6e/79H0estfh98PaHVXmPftroWbI8cJiV4eSPci2W+gE0pxLanMGRb
	 YVQV0Lwi1hSO3z1wTLXeaI65NrizocSRjJV4MXPWN9WRGcqELB5evqEirpTcnJnAG3YWq
	 kisAAQYxwizw6/vD8JfkzdaQXJ+d/oqt0Sth1YCiJ+6nl5BcjuC+hsfx/4KHGDuuWflkz
	 /3uLxJ2LEkVCiK0/H9wipb1CgxuqcgehWp2q7a8j8kDKPsiRnaqQgQ1Ha6M5XY2eFOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N9JOEyBc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759D3606A31D;
	Wed, 28 Oct 2026 17:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N9JOEyBc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C474B1F01825;
	Wed, 28 Oct 2026 17:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208006;
	bh=bdGCH9Jgzi4ZsdkMdmniCxR7WldY1s0/OQ9CRtMLANk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N9JOEyBcc+mf4uVcf9qxhFe1GpRwIfY6KSjKQnPZ17tE9L3c2s/mpJ3XIR0/LUtfR
	 YplvB0ZHcRQrrROw0SH4pMq6I44N/POD2LGJ8YiaJBJaCXttfkSEQpoD9yp0Yk/I3U
	 ji5P7+mn4ybPJkfLWwiMthu7vyLEoeT/OLv2U82Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 214/247] io_uring/napi: dont busy poll past an expired timeout
Date: Wed, 28 Oct 2026 18:00:17 +0100
Message-ID: <20261028165952.488767877@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

Commit 21ed976c12f6b77d7ea028a4fe9a08e69a56179f upstream.

__io_napi_busy_loop() caps the busy poll time to what is left until the
timeout of the wait. The difference is negative if the timeout has passed
already, which is what an application gets if it uses
IORING_ENTER_ABS_TIMER with a time that isn't in the future any more. The
min_t(u64, ...) turns that into a huge value, so the cap has no effect
and the wait, which should return right away, spins for the full busy
poll time first.

Fixes: d5cce407e4f5 ("io_uring/napi: postpone napi timeout adjustment")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-34-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/napi.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -288,6 +288,8 @@ void __io_napi_busy_loop(struct io_ring_
 	if (iowq->timeout != KTIME_MAX) {
 		ktime_t dt = ktime_sub(iowq->timeout, io_get_time(ctx));
 
+		/* an absolute timeout may have passed already */
+		dt = max_t(ktime_t, dt, 0);
 		iowq->napi_busy_poll_dt = min_t(u64, iowq->napi_busy_poll_dt, dt);
 	}
 


