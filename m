Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7975253949;
	Mon, 23 Jun 2025 13:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684942; cv=none; b=umCR8M8nKWad8oAcQ1PgG9LM3NDGChwxfQkIykZZVla2dtgPpU54+LDxFv9cE9po9B8XUdNe2RVxm7xaEcO0g92NBM4sXfj1SGkfHjzcqZv558B7+/PZW0wPDoFBmZK3Wz62uv8MC2uDGT68h8XFL5ikLbHmT4oOE4djzKdLNFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684942; c=relaxed/simple;
	bh=syVV5lvlg6c2FdBomXdZUgj9RMgqVAEl5IBqiZmbM04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aB2GUre4E8chIQiKClEZgxDEVt6PNlTwSF86KHmvrlEiCLtf1juA04+VmNuxDRJTc99NaV5XeM7hwAHPPR/Kipa5CAWCCRfJFlM+gVrddzTfNHzgUF9/n7GLfIV8HPmhJy2mEbVm8J1vQPqgm3absBaVgOfBcF7zmMpCGgHc7es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VP5zi8Wa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VP5zi8Wa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 327D4C4CEEA;
	Mon, 23 Jun 2025 13:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684942;
	bh=syVV5lvlg6c2FdBomXdZUgj9RMgqVAEl5IBqiZmbM04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VP5zi8Wa1fK0trPemB6zaWtufPLoYXuI/BgZx8hlu//2vRXMmn1Z7ldB3Xd9o7mlH
	 avTY0IrDAbYvnGX5t4iX5t1weTP7Wp9/quaZoaW/joUJPX2jl0g4SLXY4C1ZMbo6Vb
	 60vpXowgOD/Ub/NOZxIlTx00zAyevw0iB3HM/Jbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 014/355] crypto: marvell/cesa - Handle zero-length skcipher requests
Date: Mon, 23 Jun 2025 15:03:35 +0200
Message-ID: <20250623130627.202187423@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit 8a4e047c6cc07676f637608a9dd675349b5de0a7 ]

Do not access random memory for zero-length skcipher requests.
Just return 0.

Fixes: f63601fd616a ("crypto: marvell/cesa - add a new driver for Marvell's CESA")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/marvell/cesa/cipher.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/marvell/cesa/cipher.c b/drivers/crypto/marvell/cesa/cipher.c
index 8dc10f9988948..051a661a63eeb 100644
--- a/drivers/crypto/marvell/cesa/cipher.c
+++ b/drivers/crypto/marvell/cesa/cipher.c
@@ -449,6 +449,9 @@ static int mv_cesa_skcipher_queue_req(struct skcipher_request *req,
 	struct mv_cesa_skcipher_req *creq = skcipher_request_ctx(req);
 	struct mv_cesa_engine *engine;
 
+	if (!req->cryptlen)
+		return 0;
+
 	ret = mv_cesa_skcipher_req_init(req, tmpl);
 	if (ret)
 		return ret;
-- 
2.39.5



