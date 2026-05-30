Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1B13A7848;
	Sat, 30 May 2026 18:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165820; cv=none; b=RaOGGVS6YGM39bOle6Bem2mloO6ZOZxUKyh7vg7D9tmtGE+Dnuu0/TTi5ZZxTuskOZWssfzjTwvBR93vLw5d3MbnoyLEng5CuhIC0vAsziLs79QcIjAEIIZ0SmW4EB2rep1ClGvyQT6HwNjgn8KpLZRLBmGr1KQ5KIpe0IDWMj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165820; c=relaxed/simple;
	bh=rk8Gbsqi3LdylGNphbJPCEic4J9yqDFJlP4iPH/ysAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GhT4n5GAPo1iVy5EVJJyYuSH3VoXguFhl8myg+WtvAnkICbcf/ozi2ffrzcLH5Sow5uUWrX1Xm4FpL7MFaQ6Qt2h/kwS6BbuR9V+xey0de5627Zvp5Kp7AmxYULqMDULw+AHnwBuYRX0l1zxDQOr0Ce11rDDPDSeMawAI+62b1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eky/o40E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eky/o40E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A42E1F00898;
	Sat, 30 May 2026 18:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165819;
	bh=QyTH85m3dJ8ile7YGN7EjzGlB0iQov0uGOnxxBEBi3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eky/o40EXQpmBcNrwOC62DKdEDzg9JTH+slfro+jE1BH7+aRoX6eO8+gLMx8K/nlS
	 e86Wz7akWNd9vwtwgAt9WzvY0RUGhgGOP6NNutAX3pcfNDpRWOCkQW6kUiChnZZxND
	 Eq3Gs8NdbHvRtf3bdjyUBKTybA5ABxQZneXUZ4ZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.10 192/589] crypto: ccree - fix a memory leak in cc_mac_digest()
Date: Sat, 30 May 2026 18:01:13 +0200
Message-ID: <20260530160229.953267587@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

commit 02c64052fad03699b9c6d1df2f9b444d17e4ac50 upstream.

Add cc_unmap_result() if cc_map_hash_request_final()
fails to prevent potential memory leak.

Fixes: 63893811b0fc ("crypto: ccree - add ahash support")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/ccree/cc_hash.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/crypto/ccree/cc_hash.c
+++ b/drivers/crypto/ccree/cc_hash.c
@@ -1448,6 +1448,7 @@ static int cc_mac_digest(struct ahash_re
 	if (cc_map_hash_request_final(ctx->drvdata, state, req->src,
 				      req->nbytes, 1, flags)) {
 		dev_err(dev, "map_ahash_request_final() failed\n");
+		cc_unmap_result(dev, state, digestsize, req->result);
 		cc_unmap_req(dev, state, ctx);
 		return -ENOMEM;
 	}


