Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258043D47B0;
	Fri, 24 Apr 2026 13:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037518; cv=none; b=PmngMo1gQze8sWTQuX0K+Ygn++Lgb3aGkmbODNfMA4xZ+FRFCI7T8YLmVih5Sa2V6vjLEp9VePUsJitkBnJTjzDuVNeTfajUR1xXr6NrESEmhYh+AOs8gols4KHXE1vUev+ve/a2CIBRCzwZKCP++7tk6vo2gNUrcwDytzSl95o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037518; c=relaxed/simple;
	bh=8x7psqwsWrCAMKcIfcB2phTCN73208XJpeDuzhVNqe0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XUFqRp6as/zCC7sH7EmH0WtSNoM9GlCaWc+Libxu8VpLepz6AMsGQAGOnU+QnSCTSGDHV0/IpBaEOZt50ekQJaexKIWqCTLpOBOWK2Ysj98l/g+lK5Ew9f6IYu0Rq2zywTzQksIkW1+EaK2anLNzswEWVvMytUV2SGqwFPgR28w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jDppBb7w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jDppBb7w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BD94C19425;
	Fri, 24 Apr 2026 13:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037517;
	bh=8x7psqwsWrCAMKcIfcB2phTCN73208XJpeDuzhVNqe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jDppBb7w3BYGFID1ncLv5r2fOvCvEZoiD295P6tspqk+v1YkcxNr7bzptgmMCo3G0
	 K8+PYlvhk1OLmWZcItMPFdbCMFMsr6+6QPNYGs7K5t10fwsmUODYqQb594d6xfKV5f
	 5Ne5zqDii7YDhQhiiNjBD4OYbbYeVIrt8KzMrtuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfgang Walter <linux@stwm.de>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7.0 01/42] crypto: authencesn - Fix src offset when decrypting in-place
Date: Fri, 24 Apr 2026 15:30:26 +0200
Message-ID: <20260424132420.700264753@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132420.410310336@linuxfoundation.org>
References: <20260424132420.410310336@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


