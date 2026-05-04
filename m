Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFF83DEAC2;
	Mon,  4 May 2026 14:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904211; cv=none; b=r0xbBHIhjj3O9Nq0u1Swj3QGvx5d6LJ6Z1ryJugMLbw8k4oKky7WaaTc/KE5P5wacvSI0qO6C1cRytlxLcLMO2qa05rXw5YWhFlaC1svNOZxj33n2s2BJ2xt9usPXMiyW65j2C146AnH7jUvlyNj/vYmtQKPPlRzdK8qFCG5Uq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904211; c=relaxed/simple;
	bh=+axCjt+v8+7cYuLWS91bxb8Tt/D9jDSekkHzH03N1m4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tGmIwvT8JejhXQj56VK6lyXMwlyfQsjSj3uMuVBPObtK9zN2Nu+A27O+Oj2Maruc+Xg51hc0KobyPdd4wJS6ld1I55q1CnKOiz+CCZXWUgzJcRmoGW6na9zDbjlR2vCM6w+SboRvGmxMxNyv8NElozkHOC5ni0IA46vFAooVJTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fBtAEO+x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fBtAEO+x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 892F7C2BCB8;
	Mon,  4 May 2026 14:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904210;
	bh=+axCjt+v8+7cYuLWS91bxb8Tt/D9jDSekkHzH03N1m4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fBtAEO+xYLAuwhIl3Rj6PoSxAqRP6B3SH6Q2Y6cBivxrOe3/+g0vZBdHpPcBzzZ/C
	 IuI6lBCDje4pesqFlYtSCrdCenBbKlYhFrG0D9/tf9QvXKLihVzUUPMhoANa0LEFc0
	 SR9HD+McXyQu9p0+VplIlWQRBaZ+uerTqz0sqbeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 225/275] crypto: ccree - fix a memory leak in cc_mac_digest()
Date: Mon,  4 May 2026 15:52:45 +0200
Message-ID: <20260504135151.423612666@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


