Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A4B3DEFF8;
	Mon,  4 May 2026 14:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903512; cv=none; b=MI+wWEEW7LXi+qe525EyytybcP7hAvAbELTJTx8qi8ONlr5/ubY5SacyE0FF8lyNDzyVcp015LJa8LbdIb3mNqnCbGO6sWy+gvUxBRD/aedlRGWkB9xN9FK6+ZM7hieuYeJ2xFPD1rd8p8lFSkJImioHNd5VFAXPRsPX1kigpCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903512; c=relaxed/simple;
	bh=77GPda1b/nBvZ/rAWONlw6whd/0/C4kwm9rGKHlnjqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pb5F/gxtJ6rYXBHi1HK96/fVB3j1E+aUrTunG0dGWHsJNktnc1PTgQz4GKPEYuSpBfeeUfHGMeUStaT5GbvI6aWDFp45jOnzfbI+v/zQA4RZ3PH+OAU12NnLv7gY4tHEgthHovnd72NwyGuC5WLe7sOTBc0bgUHvWn4iAgzVeRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V4L8gYLO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V4L8gYLO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5B67C2BCC4;
	Mon,  4 May 2026 14:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903511;
	bh=77GPda1b/nBvZ/rAWONlw6whd/0/C4kwm9rGKHlnjqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V4L8gYLOPUff3Nws59VhB3fKmCLJShKilflMVcmm1r4aVo4LolP/6jiJpUzuWQL0O
	 aMIrZMn2EOyakKh+zhFb6AYG19ZWyqY0Ig1QMUQUYPNdu+stp2ukndQYg5cMzWtICX
	 8iSlhacjtoibDkc1EPOJZbVgPW228uFLjQoZtFwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7.0 262/307] crypto: ccree - fix a memory leak in cc_mac_digest()
Date: Mon,  4 May 2026 15:52:27 +0200
Message-ID: <20260504135152.670667211@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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


