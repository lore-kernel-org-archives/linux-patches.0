Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37733D1CC6;
	Thu, 15 Jan 2026 17:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499661; cv=none; b=b9Cy2ZVdlvB2+pfV5RYRUrVplUhUxBiMwvlrhl7FehHyIjwBEIw9V5u+k8Yd1jYtk5ZOV3MkkDXZO6iry51WMhibUr3VIJYrTUi8JdzNMep8awG8XXw3se96Yldv9k+69OIXZSgo+zRbNUIQVeaucUjzlS1Z8tDCznbvEPk9c7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499661; c=relaxed/simple;
	bh=xigkQMQ8pW0JCGIlB+aLhH314u6jPfM+QHNIBQKuCEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qS+VI9OLRJjQGN57hF4MrnDIRDJ5vnG9GQndMmY7RRFLR3UXjxVniCBV2cMM10tKduGEaYQSQpFxKp0Crung4qEQXFE5NdqHCPzYfbue8RikHQ1wTT0SC/9L5uDyty2mHT0dQ/jwYja4o5oN/ig4deCEnYLXgMyGaVUYW0zwQ2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y8ufTfZd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y8ufTfZd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D544C116D0;
	Thu, 15 Jan 2026 17:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499661;
	bh=xigkQMQ8pW0JCGIlB+aLhH314u6jPfM+QHNIBQKuCEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y8ufTfZd77AW4wyf0kP0x5+UF0VklmbeD0cNSu2A0S//V8AVaIt1DMHgQNHnYB5GZ
	 5HmqgvnD93Cej61KI7SL7As9VClIp0X50+0JH9UiRFAiO0gO6nEM0klKIh9dWfnnLS
	 8Xnm0orgQ5Cmnd4AfncRDcPzKI3Ar4duPJyVYgiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiumei Mu <xmu@redhat.com>,
	Xin Long <lucien.xin@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 273/451] crypto: seqiv - Do not use req->iv after crypto_aead_encrypt
Date: Thu, 15 Jan 2026 17:47:54 +0100
Message-ID: <20260115164240.761950622@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 50fdb78b7c0bcc550910ef69c0984e751cac72fa ]

As soon as crypto_aead_encrypt is called, the underlying request
may be freed by an asynchronous completion.  Thus dereferencing
req->iv after it returns is invalid.

Instead of checking req->iv against info, create a new variable
unaligned_info and use it for that purpose instead.

Fixes: 0a270321dbf9 ("[CRYPTO] seqiv: Add Sequence Number IV Generator")
Reported-by: Xiumei Mu <xmu@redhat.com>
Reported-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/seqiv.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/crypto/seqiv.c b/crypto/seqiv.c
index b1bcfe537daf..562ab102226a 100644
--- a/crypto/seqiv.c
+++ b/crypto/seqiv.c
@@ -51,6 +51,7 @@ static int seqiv_aead_encrypt(struct aead_request *req)
 	struct aead_geniv_ctx *ctx = crypto_aead_ctx(geniv);
 	struct aead_request *subreq = aead_request_ctx(req);
 	crypto_completion_t compl;
+	bool unaligned_info;
 	void *data;
 	u8 *info;
 	unsigned int ivsize = 8;
@@ -80,8 +81,9 @@ static int seqiv_aead_encrypt(struct aead_request *req)
 			return err;
 	}
 
-	if (unlikely(!IS_ALIGNED((unsigned long)info,
-				 crypto_aead_alignmask(geniv) + 1))) {
+	unaligned_info = !IS_ALIGNED((unsigned long)info,
+				     crypto_aead_alignmask(geniv) + 1);
+	if (unlikely(unaligned_info)) {
 		info = kmemdup(req->iv, ivsize, req->base.flags &
 			       CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL :
 			       GFP_ATOMIC);
@@ -101,7 +103,7 @@ static int seqiv_aead_encrypt(struct aead_request *req)
 	scatterwalk_map_and_copy(info, req->dst, req->assoclen, ivsize, 1);
 
 	err = crypto_aead_encrypt(subreq);
-	if (unlikely(info != req->iv))
+	if (unlikely(unaligned_info))
 		seqiv_aead_encrypt_complete2(req, err);
 	return err;
 }
-- 
2.51.0



