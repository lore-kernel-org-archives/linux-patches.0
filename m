Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906A120F090;
	Tue, 17 Jun 2025 15:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174936; cv=none; b=iEmirU7oTaA4oEFOGfXFzhz5kw2nbXNe680IlUiWjQAZ6Nu+JS708dDBaBsdZ8dHCBOvCl3H+ej1RCnODOaz0ugrQnDeOEFwTtQkjVja6hqCHtIYd5UQaI9vDdXuMxHGgVhoQQYz5pnZLJMs+EAwGmG6V0KGaQOaEEj5PR3AE9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174936; c=relaxed/simple;
	bh=mNJ15ttJ3O+VQA+TFkyklOE2xkiwYu6+DRQyyKGwGq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hhyerz0zlqy1diner2vrfs68b1nz9ZjJSy9bQWlSuSkJzjz6SgdfN8nQ3ZYSxaI4ZXXvrgtdnXwZbiTOPMb/nfecR7lZOXxYO8ipavQtau5chsObYOtJov+Az3iXv9JRJ5dR7LoHjkjGt8oWbnsuuNPTsQK7dnyB/4jHs/K0y/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SuAPYl+o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SuAPYl+o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3B4BC4CEE3;
	Tue, 17 Jun 2025 15:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174936;
	bh=mNJ15ttJ3O+VQA+TFkyklOE2xkiwYu6+DRQyyKGwGq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SuAPYl+odVPN/HHwaaOZ4UK0qr9yzbOaE2U//jk1SqZFtsfAlmX3/aCqylNNTLfh3
	 4Us20NQmlIIFjahvHKqciYMhlWWAxGDI9GBJRA2iOsB2tC4GX4GvWuOZF27G9BWGpB
	 I5T6nbXdoCITkaVTz6AFQ8TBGMSOe/L5SiqaALFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 035/780] crypto: marvell/cesa - Handle zero-length skcipher requests
Date: Tue, 17 Jun 2025 17:15:43 +0200
Message-ID: <20250617152452.930742733@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index cf62db50f9585..48c5c8ea8c43e 100644
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



