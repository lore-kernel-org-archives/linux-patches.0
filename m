Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207995;
	b=n5TL7wp+3ev+22n1QjOFBZUbU8bRQ2bl4A3TZ1juZkwSI5dEHcOPTOWDQxSVkQ9hbTlB
	 1bvRAlEYyEPAtbCIDCD4VgByno86K0tJ1CTR0qrvfZNWve9aC3pNClHb9XXW+DQgvi/un
	 ka8KhJz+TaHkTHd+q9qZP8068e1L7zS243ti2tVlSj/9k8x68qtE09TOn6fsNLSMuit0t
	 F3+Q9buUeZp6H7sF6pDk7Bv3347/60ny3ziOw2nHB9ILIkQvppR/pIgHYdw6bGsJWsp30
	 Iigesk4RbyaTEI5NGrxXlTzyeagwPMbyMxul5QH3VMkhbNxiwuUVAxfTLSaBdmetG0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207995;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C2jGIRZ2Hs+EVXLqNm6SUE4FtQlg6IGcNTFbG4OpzF8=;
	b=q9h/H5cWJp4E/3BeU79NERO9A+uYdpXtsznxOj+jnniNY+n/0YOvtSqSfHPu/dnSSjQY
	 2hTTf335pf4gwLuxWZvIzBF7+B4Mp9RSirpvT5AQY/ontmTdmuyT/+YbTetrgN7GwdfaD
	 cbkggtN1lKwifjJxzpwZv9JoNf+sXxLOHnoBNj/T2VtSG8Sv8mho7s+Huv0d3GlIKy4VA
	 9z34KG2AZJsc4QI6xdqQ/lzbA7dj20iMp12dP7fjuXQJ/I3PNxnCy7SX3uONvN4jcQjed
	 ZQkLZmWFzWNMFOZg7tSX1fbOTzKugv8Qr63vMcz5/3VcCHFhhCkfqLwXvhOLl9vjUFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HZJ9EvSM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D05606A31A;
	Wed, 28 Oct 2026 17:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HZJ9EvSM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506D01F01828;
	Wed, 28 Oct 2026 17:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207994;
	bh=C2jGIRZ2Hs+EVXLqNm6SUE4FtQlg6IGcNTFbG4OpzF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HZJ9EvSMWFADnf/WO7Be3bzEuzorXBt/i8haBmNTL7kRsZx2aYLh0L+A85Y/ghFMj
	 5ikjCVsSJeSSxcrUJcPledfRksrjKEqDd03Jq0NSwcvi+Xpz4Bsw1eehUBmzhx/fbF
	 bkWQ3F4/+sfJ1AkipGLo+tBAh1M1JgffYt1rEMfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 211/247] io_uring/timeout: keep repeat count on multishot update
Date: Wed, 28 Oct 2026 18:00:14 +0100
Message-ID: <20261028165952.417798743@linuxfoundation.org>
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

Commit 3dc2a32cd356ee382aa4a8c7d844c53b2c0ad83b upstream.

IORING_TIMEOUT_UPDATE clears ->off of the timeout it updates, to turn a
timeout that waits for a number of completions into a pure one. For a
multishot timeout ->off isn't a sequence though, it tells whether the
number of repeats is limited: io_timeout_finish() only looks at
->repeats if ->off is set.

A multishot timeout that was set up to fire N times hence fires forever
once its interval has been updated. Leave ->off alone for those, they are
never treated as sequence timeouts anyway.

Fixes: ea97f6c8558e ("io_uring: add support for multishot timeouts")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-30-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/timeout.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -407,8 +407,10 @@ static int io_timeout_update(struct io_r
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
-	timeout->off = 0; /* noseq */
 	data = req->async_data;
+	/* for a multishot request this isn't a sequence, keep the repeats */
+	if (!(data->flags & IORING_TIMEOUT_MULTISHOT))
+		timeout->off = 0; /* noseq */
 	data->ts = *ts;
 
 	list_add_tail(&timeout->list, &ctx->timeout_list);


