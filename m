Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E271F3AF643;
	Sat, 30 May 2026 16:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160156; cv=none; b=HMRgIGde3WB/Tr9ceEmCOnfTp9EAq3dw1Cce5PU4ABb0esrlM5ze0cFuQpxZHAd2o6Zxn3IIXsz4EDBcSH9dfkj0r1NUTnd7F48WY7gVSBJVM0jo+maWVUSCmtV5g6qbicG/0aB+KvznfPNH3gr5EgdGF0CVaynkzH+0yxJF8yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160156; c=relaxed/simple;
	bh=9QSh8PIAZmF15RJCSuQFGAzrARTcW/DnGwwq9V17S9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K1Nn0DekbD/kI2uYZ4UxzpGg7vJm4kcqpUwVTsqjrboy1wfxnZ+MsgwE8vG5hYQvS9Aq/yU5AzpxC2IEHR0n+rPYTxYBH0CEv0zrPlOH7G8Dd2calCLgzcnv9vqkHpkrJZXgp3lR+eOGvw8KD1/mnQ2oscRysqmiM7StoB/2a8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LkXjjfLh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LkXjjfLh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 341EF1F00893;
	Sat, 30 May 2026 16:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160154;
	bh=XWzsxON6HFLvVApPp7A+HDBO8LNXJ9HaMnV42a62vWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LkXjjfLhPPM69iaZe4AQrDezbyMb2xp0otEvwevO24OAsDEkabIb449BFqsEFKnws
	 FNiehAfC1VKGtzhxAoMPK2Ny5sxHdENjs9tMRmCHJTJAtApZsuak/LKWkS/4uynpD5
	 TR0QodN8zYtSrdZumcwlMtHK/IyOs0/AxFR76R/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.1 259/969] crypto: ccree - fix a memory leak in cc_mac_digest()
Date: Sat, 30 May 2026 17:56:23 +0200
Message-ID: <20260530160307.632206523@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


