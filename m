Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829069;
	b=Zgyp2YeQ16hV9qdmSYHNu/W3nq0ZrvwW+rC9ycGqnxwLKONsWKY3oG3k2oGPmOb6G2CZ
	 UAUUcIs7fEViMe111OmZe3b26GlQmV/PdUIiqSlTBPLRBFStjwx1qJv6iK9tdS0l7RF3N
	 BcQEaSjd47iIo3/fe83Z48CIHBYnr7A9c1H+UM9JIkY+2YDm8QL9sk66NdjICDPubR2FB
	 8xaQKNv4BTBeF1M/h4dOFIDwrbIfvOz7PKDfmaL6nEs5PDKTzisv5wKFDnBWZBek4Vgio
	 zB0AzbpPcJauGgQCy7qj2Hx+3mcbp4k1M1XB3U5IELd2MI7VHoy7fDao/NbCMLctgxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829069;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZtRWa0SSGWMmjoCEQqluk5JMw3i9e7XyJlvdQhUSq9g=;
	b=Z0aWEXOoOmvwtuf5dUGCobog9CfVOXxBy6g4w8Hcfl7e33xcc9+hLehM13vIELwtKg7J
	 6DLMgHN1yLaiexDGYrWPKN44L3k+VsTpYoycefaEXuDuj7rr9FIzEYbES9dZVIP1ZqqRz
	 shk5HuPf4HHz0QDgu7Cq5jcw+++lybMj6fNBGg37B3/p5LKFT7LtFMGLGsH8SmmJlfgwH
	 K01zKE/uNubIGui7FxI4fSx91ogVfovaFCmpj6jIwBAAsH9QbGVwzydvdJRUy+OFjvho5
	 utHM0OTksAdBwTkg2y2vF1UvuunyHkL/gYUUAPB37Zacp47Ponl5jIAQRGK88taLuRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IwLvSuTq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1519607075A;
	Wed,  4 Nov 2026 21:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IwLvSuTq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5119F1F00A17;
	Wed,  4 Nov 2026 21:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829068;
	bh=ZtRWa0SSGWMmjoCEQqluk5JMw3i9e7XyJlvdQhUSq9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IwLvSuTqZnG3mDt6bLwQj7/4ESifPdOek6Q6qWl4HJgQj6x+bOhbZgD/pcZNvN+D/
	 N2q1AZ5yqoAW4FQV/HpARvx30l2yXGLtNa35hFXE9DgXDW8+BasUxOm9RCAU+nZDwe
	 yFktvqh68D0nK95RVSYADO66aAH0hxj5QhB62shE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.3 423/547] nfsd: honour client-provided attributes for NFS4_CREATE_EXCLUSIVE4_1
Date: Wed,  4 Nov 2026 16:10:07 -0500
Message-ID: <20261104211050.358995637@linuxfoundation.org>
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

From: NeilBrown <neil@brown.name>

commit ddfabbc7840891e09cd500ab97c9cd36b650ec24 upstream.

When a file is created with a v4.1 OPEN which requests
NFS4_CREATE_EXCLUSIVE4_1, the request can include attributes to be set.
However when the mtime/atime are set to hold the verifier, the other
ia_valid flags are cleared, so no attributes requested by the client are
used.

This code was originally written for NFSv3 where NFS3_CREATE_EXCLUSIVE
never includes attributes.  When it was updated for v4.1, the fact that an
exclusive create CAN include attributes was not handled properly.

Fixes: ac6721a13e5b ("nfsd41: make sure nfs server process OPEN with EXCLUSIVE4_1 correctly")
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: NeilBrown <neil@brown.name>
Link: https://patch.msgid.link/20260717093001.1972119-2-neilb@ownmail.net
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4proc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -394,8 +394,8 @@ nfsd4_create_file(struct svc_rqst *rqstp
 	if ((iap->ia_valid & ATTR_SIZE) && (iap->ia_size == 0))
 		iap->ia_valid &= ~ATTR_SIZE;
 	if (nfsd4_create_is_exclusive(open->op_createmode)) {
-		iap->ia_valid = ATTR_MTIME | ATTR_ATIME |
-				ATTR_MTIME_SET|ATTR_ATIME_SET;
+		iap->ia_valid |= ATTR_MTIME | ATTR_ATIME |
+				 ATTR_MTIME_SET|ATTR_ATIME_SET;
 		iap->ia_mtime.tv_sec = v_mtime;
 		iap->ia_atime.tv_sec = v_atime;
 		iap->ia_mtime.tv_nsec = 0;


