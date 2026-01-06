Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63DA321B192;
	Tue,  6 Jan 2026 17:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720656; cv=none; b=QBfY6/Ole1S7E6AzbdyDfngv2/jqkkPtFInbx70Zxg8nPNQTjgRjRq88IfX/24iUdMdOi0K0PTGHePWDMV53brS+Ys1n8L2RqSI/q2hig19zA1oqoe2EkNN3EI+UBpDtlvdby+lfqqoVvxYy4BGek7b+heQy1P+lSB/M4sCS0XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720656; c=relaxed/simple;
	bh=cQpaNmfbHsOGFvZy9Uyde/mYrqAJPoQj8JtMvnycG/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JVBVE8RS2/yHsLrzypbJ8EvcKRqlVX/yMmJZ03R+CamfYeyKXJhY7qpVC2/KMBjYvH3reJpW0DapJwZnupWLf81kiLcKbjq4wnwmok8FYl7MdrT9IXcIQ0N731pgUyNUoD6ozLLMljrpw3+wD1BtTP72VvHJ4wlKVTpZWa/d+EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E8o2sfbz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E8o2sfbz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA221C116C6;
	Tue,  6 Jan 2026 17:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720656;
	bh=cQpaNmfbHsOGFvZy9Uyde/mYrqAJPoQj8JtMvnycG/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E8o2sfbz4yriPsyGNE9CV693j+3nuKEDNLjs4AALFNjtLal5Y9ccRglkEpgEFmXMr
	 CWJ5ItqXjajcWEOpkfLtwjNznwSzhTdyGjD6BsJhjvim0TVvBO6d6kLg9zdaAi4DA0
	 066PHwTe8TZgD0hLGh6qzcyeg+wuONwwb3vwd43A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiumei Mu <xmu@redhat.com>,
	Xin Long <lucien.xin@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 302/567] crypto: seqiv - Do not use req->iv after crypto_aead_encrypt
Date: Tue,  6 Jan 2026 18:01:24 +0100
Message-ID: <20260106170502.503434889@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 17e11d51ddc3..04928df0095b 100644
--- a/crypto/seqiv.c
+++ b/crypto/seqiv.c
@@ -50,6 +50,7 @@ static int seqiv_aead_encrypt(struct aead_request *req)
 	struct aead_geniv_ctx *ctx = crypto_aead_ctx(geniv);
 	struct aead_request *subreq = aead_request_ctx(req);
 	crypto_completion_t compl;
+	bool unaligned_info;
 	void *data;
 	u8 *info;
 	unsigned int ivsize = 8;
@@ -79,8 +80,9 @@ static int seqiv_aead_encrypt(struct aead_request *req)
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
@@ -100,7 +102,7 @@ static int seqiv_aead_encrypt(struct aead_request *req)
 	scatterwalk_map_and_copy(info, req->dst, req->assoclen, ivsize, 1);
 
 	err = crypto_aead_encrypt(subreq);
-	if (unlikely(info != req->iv))
+	if (unlikely(unaligned_info))
 		seqiv_aead_encrypt_complete2(req, err);
 	return err;
 }
-- 
2.51.0



