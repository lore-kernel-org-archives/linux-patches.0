Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A453D5645;
	Fri, 24 Apr 2026 13:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038061; cv=none; b=q9kOpoxEUDGIWqZxGBF0IpLk9JcDYRMDNYvE7GWmRR0CBfXRZDEwlrbu2buVMEKNu48nJ58jRmXo4AoSm1Oh0BpaguCaid0bsecSRX9pokr0AsmwSHZn3nhpDl9wtMfHGQrnDJKv8eiuosA4MHLi9/Gx1XfXf/y04YCaivehBpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038061; c=relaxed/simple;
	bh=oe38wSUhMoWOUkSNbM/mSyin2l6g/C3XBxCsS52Nd2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ESL+jo4xO/aRQstqMSFhSBNLYXQ6bm5GCy0vXOYfN4tvkKvanJSYW1SdPZBdN6zK8Rltjxn6BulE1ChEpmowcnQrkpHVjUxBLaqrvd0Zk7KKzP8XB39D8mRbcNHvwFa5J9qc6XLHzGAOwNLsj9pKse3pKw6qQ0CuSau43MXyw5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bKHiEyrZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bKHiEyrZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F44C19425;
	Fri, 24 Apr 2026 13:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038060;
	bh=oe38wSUhMoWOUkSNbM/mSyin2l6g/C3XBxCsS52Nd2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bKHiEyrZoqZHmORH2GRqMWL+7NNcLeiCgFdFHffyQ6HvK28hJwOMpNa7GCwG6y/8P
	 8XvawoRVWm2Mlcbdsfp8TgAyN6SNw35825ChQXFkhkrLx1nKjtRHy+1bBYU7Z+dqiU
	 kwUNa7BtNvn2B+DgdV2CFkxG4DmAEGsPfYLHK990=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfgang Walter <linux@stwm.de>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 01/55] crypto: authencesn - Fix src offset when decrypting in-place
Date: Fri, 24 Apr 2026 15:30:40 +0200
Message-ID: <20260424132430.305557573@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132430.006424517@linuxfoundation.org>
References: <20260424132430.006424517@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 1f48ad3b19a9dfc947868edda0bb8e48e5b5a8fa upstream.

The src SG list offset wasn't set properly when decrypting in-place,
fix it.

Reported-by: Wolfgang Walter <linux@stwm.de>
Fixes: e02494114ebf ("crypto: authencesn - Do not place hiseq at end of dst for out-of-place decryption")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/authencesn.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/crypto/authencesn.c
+++ b/crypto/authencesn.c
@@ -228,9 +228,11 @@ static int crypto_authenc_esn_decrypt_ta
 
 decrypt:
 
-	if (src != dst)
-		src = scatterwalk_ffwd(areq_ctx->src, src, assoclen);
 	dst = scatterwalk_ffwd(areq_ctx->dst, dst, assoclen);
+	if (req->src == req->dst)
+		src = dst;
+	else
+		src = scatterwalk_ffwd(areq_ctx->src, src, assoclen);
 
 	skcipher_request_set_tfm(skreq, ctx->enc);
 	skcipher_request_set_callback(skreq, flags,


