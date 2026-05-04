Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05E13DFC7E;
	Mon,  4 May 2026 14:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904746; cv=none; b=sPsfCcjenOM54brPzICbl+f9KmspGRhQjHabRNAdSZYKOktXBSZHqpHq1PqZNEzJB/4JbVA8CHnEb9dqNIpxC17UpGB+OqSyG/GW/fAAwkLVs8C78UHGi8UaTiu4e7TfOu7V42568sdK5pS9uYR02l3sAHJVhb2hygqfU2PP0Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904746; c=relaxed/simple;
	bh=q2ZyHzWzKfjyrO8GkATMf+mDtkxiZf2ykpVcie9aVdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jWIvRt7oGrl0Ilc1EkvUT33IlZEHEZ55yVYuz9At3wvITaymDezrmcEx3sDKIw2nEUXxt96e0Sy80AVulCfaUIkMi+n1OinfZhJJvSytnOG2QXOrV2IpRrF+Bjw1WYJajI3yAHNfpp8DYt926kFVpJlXplflH9ovQ63GHMf3tLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zr7cVG9S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zr7cVG9S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68377C2BCF5;
	Mon,  4 May 2026 14:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904746;
	bh=q2ZyHzWzKfjyrO8GkATMf+mDtkxiZf2ykpVcie9aVdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zr7cVG9Shy3i3lKvgsfE7tAkyDF03UkumJtnrikgjz4N5qCWGMjB1kiw6LIS4n1ec
	 Lnf/BsFTyFGY+bDleSovqcTUqqdsPE2J6+YkwbN1VD07Ko4RaztGCOtUgroTFGXXIu
	 lStIkdw4qLYiWSkSoLf1VbsBkAu7RaQeudlfxmX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 158/215] crypto: ccree - fix a memory leak in cc_mac_digest()
Date: Mon,  4 May 2026 15:52:57 +0200
Message-ID: <20260504135135.948092934@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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


