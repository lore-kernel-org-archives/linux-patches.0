Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748D6151CD6;
	Tue, 20 Feb 2024 21:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464522; cv=none; b=CRCEyeObmCgALB1Di35xFdlygjE2ev1mwworcTkUsbkgI5hI9zbstNGi7fLur2J2YPP+TlZGejoMwHg47z49TiOjQQuKCVhDNoE8N2eZhpm5BsPe38xSrNLelZ16jgkpSA7kXLVQcV64K61Mr0yWEtU2Ce1ynUosQvLGOHzXCos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464522; c=relaxed/simple;
	bh=1maPodn/n0Yb56l/tPG4Y9FBwOozcUKSZpX+QPN3/6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X0kjnT4DnTmPDZqfWJC1a0kj7MxXkj5XE2w+dOkP8mvyKnhbb5Dx4MEEyAy9ja1tR7j9JWGLpVqITF374O6YIDH8ivj2F4XzhWUdLfXUooaWQ0MvSUc2o39/C7TVPQr+u9XKxnnbhhFnOSgDMTkIqXiVeRWsPEAxi7yiZjAtGpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fv5fex0k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fv5fex0k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D05C433C7;
	Tue, 20 Feb 2024 21:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464522;
	bh=1maPodn/n0Yb56l/tPG4Y9FBwOozcUKSZpX+QPN3/6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fv5fex0k6cwVhb1rkr5HWt6NTP7kKyxHqUHGWO+KEWRN6ZDRyd6xC8VBZK7m2A+2V
	 8gtdh/pGfkATEOICxb/wlPwH2ecwiPc8YF8xr/f++++H3fvKXnD9CGjutBewP9tdw3
	 rSA7/lq3oU/+u6lHT3QwY9UoKPsq56sl5zsU4FAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 051/309] net: tls: fix use-after-free with partial reads and async decrypt
Date: Tue, 20 Feb 2024 21:53:30 +0100
Message-ID: <20240220205634.790940817@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 32b55c5ff9103b8508c1e04bfa5a08c64e7a925f ]

tls_decrypt_sg doesn't take a reference on the pages from clear_skb,
so the put_page() in tls_decrypt_done releases them, and we trigger
a use-after-free in process_rx_list when we try to read from the
partially-read skb.

Fixes: fd31f3996af2 ("tls: rx: decrypt into a fresh skb")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 63bef5666e36..a6eff21ade23 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -63,6 +63,7 @@ struct tls_decrypt_ctx {
 	u8 iv[TLS_MAX_IV_SIZE];
 	u8 aad[TLS_MAX_AAD_SIZE];
 	u8 tail;
+	bool free_sgout;
 	struct scatterlist sg[];
 };
 
@@ -187,7 +188,6 @@ static void tls_decrypt_done(void *data, int err)
 	struct aead_request *aead_req = data;
 	struct crypto_aead *aead = crypto_aead_reqtfm(aead_req);
 	struct scatterlist *sgout = aead_req->dst;
-	struct scatterlist *sgin = aead_req->src;
 	struct tls_sw_context_rx *ctx;
 	struct tls_decrypt_ctx *dctx;
 	struct tls_context *tls_ctx;
@@ -224,7 +224,7 @@ static void tls_decrypt_done(void *data, int err)
 	}
 
 	/* Free the destination pages if skb was not decrypted inplace */
-	if (sgout != sgin) {
+	if (dctx->free_sgout) {
 		/* Skip the first S/G entry as it points to AAD */
 		for_each_sg(sg_next(sgout), sg, UINT_MAX, pages) {
 			if (!sg)
@@ -1583,6 +1583,7 @@ static int tls_decrypt_sg(struct sock *sk, struct iov_iter *out_iov,
 	} else if (out_sg) {
 		memcpy(sgout, out_sg, n_sgout * sizeof(*sgout));
 	}
+	dctx->free_sgout = !!pages;
 
 	/* Prepare and submit AEAD request */
 	err = tls_do_decryption(sk, sgin, sgout, dctx->iv,
-- 
2.43.0



