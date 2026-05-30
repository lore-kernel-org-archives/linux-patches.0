Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D527320CAD;
	Sat, 30 May 2026 17:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163426; cv=none; b=J/bc13uJ7UEcgxRxX7R/IkUja+AQuwmzM2mE+ZM6P7Hz0HNUdSEq5Y/Q+S5PsxpA4Fi8wpbfp803soc4LkB1Rx+D92LhKA5mkfxM0wXPoHU3FEF9aluSwlu9ZKVdVe4whEuGClHcKBnq6+nakZ4YdD5ww5UMo2Gtlu8+2ULULf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163426; c=relaxed/simple;
	bh=ZSsdJulcfqbb0NEqxoB37M/F0f+djhBcS6BbcBChR2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EQwZ0xSO7PXveJXGZnZOB2V9fHPmurLYbbfM61BY6nwRJuwJRL8w3+lqm2DJsGOvJ0zbkvsddDZZ9k7wlW7YpVRo12cbzPWdNbDf17xLOlgUChEsiJ2cjVtlsdFNlsLXAe60vf8FK++6Vyi7/skzJaCEvTqoJvjiuRnchmMnLlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ZlTf5T/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ZlTf5T/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFB7A1F00893;
	Sat, 30 May 2026 17:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163425;
	bh=JPun9QEQnLz9HSPFDFChC7/SgAM3EaJg4+S52Hl8CcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2ZlTf5T/21/NamtjsgGs/A39M+MjgqxFglXadJ8ydhlL1bv8um8QQcdEDKWlhBsAK
	 GHkVEIlb/HLVtRW7XSE+BrCBDjkrPfk7IcZOVAtpSCBpmZVIKX8QqU8gVXpaklVRCo
	 s6/adNmFZ4klwbMaZHFlyooJCwYJ5/CS2tCUvl8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.15 254/776] crypto: ccree - fix a memory leak in cc_mac_digest()
Date: Sat, 30 May 2026 17:59:28 +0200
Message-ID: <20260530160247.098000195@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


