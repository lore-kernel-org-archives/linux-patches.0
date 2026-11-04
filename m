Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829260;
	b=3RzDRi1JPiZHHS6e9EbeNlY79QNBHyyS2gwt56OylqUeVMEpY2f2ES7rBzkpijlbm3a0
	 wUxXxTNsZIU4yXNbPiBAjWNt3XzqQVIimLaYxP4E2aQeCILkvl7EphiP8Ug0LBw45/XRl
	 O0fgL+IiEEW5WnwRxobxnc/KWUpZaOP85Ta1U+k3SB0uqOo0p95kp4qlMkPC6la3v7G/K
	 odXgf8zEFKBOqDN3OCyyFiS47N6if4U6cidowhH/wQnO2aCQCxe5M86vR2KS51QwAhN8z
	 gyjYRKfJzWI5HjUo/QBynz2U6b3rIozyiAbmrQxTAxA6wCVbqqWesfx3m/+WkVtIL+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829260;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2itmuGFapnXTAnOiZvb9362yULGLhjvqXZJXPful/i8=;
	b=lHdmWOmKMLwrqIsBA3JRUr/Od7jp9ACnM1lM3O6q2NM9Rpk2o0EFE0wWdNYF9iZts46l
	 VSzlAUUrZHnHpoQdEj+XIBfgahvFjiZSPrZ1sbhMpKBl6ENFInnFbw53nPDVFXdG3OHlN
	 7BFq9YWeiFXOCTovnX8COunBYM8n7ZuuObn1N+H2utg9R6lGkRaUNXP68RsaKOB5KCC9D
	 d5L5CpqCtzVmP0TQ0SICQmumU/kn4FnUy+5H932TkwqrLxTrj8NTTfGeJ+MtE6QL9sZ96
	 VqKwuEIH3amfEDSXnn5G4+1M6D/cKobxgaFNSoMWKTEWK+WLs1ItfFOxu8/n8m97jWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vUdQBIti;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC24D606A33B;
	Wed,  4 Nov 2026 21:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vUdQBIti
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84DEE1F0093A;
	Wed,  4 Nov 2026 21:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829259;
	bh=2itmuGFapnXTAnOiZvb9362yULGLhjvqXZJXPful/i8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vUdQBItisSXmef13gKms+zPTcWgt8kDFvWz5YQoomegrn8dU+AdmK6E2VRpek7siN
	 mUhGybU3pnh1I2so/hWftnHpoLMU1mGVfOexpAKpyU2an2NxKjYAWJVPADnXywfhW9
	 QDwV63LZb1jEqPlGWGhkEXk75mCfEW1puBkWexSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.3 518/547] io_uring/kbuf: advance head when a pickup empties the buffer ring
Date: Wed,  4 Nov 2026 16:11:42 -0500
Message-ID: <20261104211053.111452093@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Yichong Chen <chenyichong@uniontech.com>

Commit 8742f4b5a472c347fe568a73468a2d9e4d630b33 upstream.

io_ring_buffers_peek() flags the request with REQ_F_BL_EMPTY if the
buffers it picked were the last ones available, comparing head to tail.
When the loop breaks because max_len was exhausted the buffer was picked,
but head is left pointing at it, so the flag isn't set if it was the last
buffer. A bundle receive then retries, finds no buffer, and the request,
which has received data, is marked as failed on account of the -ENOBUFS.
That severs a link, and ends a multishot.

Fixes: 35c8711c8fc4 ("io_uring/kbuf: add helpers for getting/peeking multiple buffers")
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Link: https://patch.msgid.link/20261023091711.83481-1-chenyichong@uniontech.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/kbuf.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -326,8 +326,10 @@ static int io_ring_buffers_peek(struct i
 
 		arg->out_len += len;
 		arg->max_len -= len;
-		if (!arg->max_len)
+		if (!arg->max_len) {
+			head++;
 			break;
+		}
 
 		buf = io_ring_head_to_buf(br, ++head, bl->mask);
 	} while (--nr_iovs);


