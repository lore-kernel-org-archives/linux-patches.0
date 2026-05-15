Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0A43CAA39;
	Fri, 15 May 2026 16:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860903; cv=none; b=Cjx7Ll/ZMy5iJjpC5gPFMss0XsIPhqBykW78tqys5j0wfPFC/Qy0A4RiQrZveUN0bjrQXxCFxOhEl7WCPDKUyCh+U90LTgRJos9tjCxyRD3X9Q0Q2+O+Awc7+ZSB/lFl3RlfLhgSS4ub+6YhelMAU2zo8YiKgMCfcZd05H2r56Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860903; c=relaxed/simple;
	bh=F2Q3HxO2F8MNxs0Xim5WNAw1mg5dTmHPX+j+W1jSULA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZFMh80AnVyReU95zjTn8Tyt3aPl/JEb7gXgOGEb151U5dkQn/yVPua4oAYKssDheIiU1obV3XI4/5sTxCK6L9u/NCbVHiAifxHG7a/7haKSmFun09neJBxNVsr8+F1fBMKEd0kZI1Na+RDP4ETHdWfQMhvy2p+u+8LXqKzLm4+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IhyD0NpD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IhyD0NpD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 020FFC2BCB0;
	Fri, 15 May 2026 16:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860903;
	bh=F2Q3HxO2F8MNxs0Xim5WNAw1mg5dTmHPX+j+W1jSULA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IhyD0NpD8Z5TUYN4ToV2D+i3MhJSEdQXW0ShnuEp5G736Wtmg6X1ntrW642vf7JAy
	 NnrYMlXe91Ubqcc9uffyUpybH19XTXYPXHqAkO2nxVVLpJzF+4xC/7zHrsNz4xxUp4
	 Qw4btBfmdxkTNh8ynuVpPV+eO5npTxMRVx+ltjmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.6 124/474] crypto: ccree - fix a memory leak in cc_mac_digest()
Date: Fri, 15 May 2026 17:43:53 +0200
Message-ID: <20260515154717.717325064@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


