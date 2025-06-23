Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D273D230BC2;
	Mon, 23 Jun 2025 13:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685628; cv=none; b=LLyzUuLSYywnLx8yEvCtAe2iWVuJ6QzuDsVoNLO+X3xeHUbvtKhzOEOy5rZUItHRa5UXlz5HNlVKFNYVtq3RDsBFSAu4rV+wdWeyJdwodxGPjj72b48WGmxIZ8dWVYdlIIj9LccCGwVPnLNlXCxOpP8FFTRPHr0Hl09/c6lYZwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685628; c=relaxed/simple;
	bh=cN/bHekkMP857K12ZY5OiSA0tsR4+q/f5vY619vD/KY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DI4l2Q+fSMvzdrE8AWPN8najXppsD5+N+qThORuX1QbnGyBDiPYTE6H1ism5Qte7BBbkfWpJA9Wkv8Va/ZfcFB6q64R7hn/bo8v1Mf4f9atqCT2YYJJMgBS9WzHSyysMRcR5ZB+MDOAjFrFAoNaIbbPy6gJ9O+Ph6zxvRm19/qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=laqf2zFl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="laqf2zFl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 661A7C4CEEA;
	Mon, 23 Jun 2025 13:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685628;
	bh=cN/bHekkMP857K12ZY5OiSA0tsR4+q/f5vY619vD/KY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=laqf2zFlVDXb2N8PG4FCUyAC6Py3ZrApI6inb2XjeJj1ae/IhV1Y2pz2YaTkNz4nt
	 QmXjMoB/yqBNrU+ULQ+jox0E4doyIzwdGJH1QAZdaVY1BQPWbHkjSkqiE+lRJ/pIZq
	 9dR+W37p6giG/ep/KkmRjKiNTCNNk4qE4f2fa5Xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 020/508] crypto: marvell/cesa - Handle zero-length skcipher requests
Date: Mon, 23 Jun 2025 15:01:05 +0200
Message-ID: <20250623130645.750219450@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0f37dfd42d850..3876e3ce822f4 100644
--- a/drivers/crypto/marvell/cesa/cipher.c
+++ b/drivers/crypto/marvell/cesa/cipher.c
@@ -459,6 +459,9 @@ static int mv_cesa_skcipher_queue_req(struct skcipher_request *req,
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



