Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB2C42BC5B;
	Thu, 16 Jul 2026 13:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209950; cv=none; b=DHj7MJ/ZJmsVwHynCQrHot8yCWfgd6DyEs7AsdvOlQWGbguXeeMPox4S0/Q7T98f71/dnNq9xkiz0XDErmpoEhIjFVR8zyplVhBUdM9gvooyg6nC4K1+pqdKL7t5cE2tRJ5QTnX/DSd0/UK5xoayKC6wP/nBAPQVk6wTVvULfIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209950; c=relaxed/simple;
	bh=FAbNyh92583jBlgUz9y98NriIH/fcTp2fnGJbptVOBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tzjtJaQBmBqTu1UX+SEmMmXWLheI4sDU2xQ2CHdMWtXsBXx5rIXoOBL9Oo52lYMFLArnhnyth7Z1eKdKj0ff0FLTsmHr8T5oR2HJAjewzVWckOxaS+SqwBUW1wJ1xZDi8nsMQWeaZKmJuJFAl4TFSha37JRJiQzwl/zSubDsnaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q9s2vGrp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q9s2vGrp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1614D1F00A3D;
	Thu, 16 Jul 2026 13:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209946;
	bh=I28lmJtHLvvh/rLcpWu5OtD/g2swFOBqZUak9d4a3f8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q9s2vGrpfKKBUkoTOnc1su7ohcI9bpyszhFVifjV1kFcdvLy4yG/eVa4+iU4cxyqn
	 cnFbOolUgLiyqZVHgYfbx1I7wPPKpx9RW2FO+3DsS7lP2chg27rpTHni8qUTgZctlM
	 VcEPZrdk5Sud3qtNRrchGHbfIQLJ9gt4hjUrfFPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7.1 379/518] crypto: drbg - Fix the fips_enabled priority boost
Date: Thu, 16 Jul 2026 15:30:47 +0200
Message-ID: <20260716133056.119369409@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit a8a1f93080efc83a9ff8452954429ae379e9e614 upstream.

When fips_enabled=1, it seems to have been intended for one of the
algorithms defined in crypto/drbg.c to be the highest priority "stdrng"
algorithm, so that it is what is used by "stdrng" users.

However, the code only boosts the priority to 400, which is less than
the priority 500 used in drivers/crypto/caam/caamprng.c.  Thus, the CAAM
RNG could be used instead.

Fix this by boosting the priority by 2000 instead of 200.

Fixes: 541af946fe13 ("crypto: drbg - SP800-90A Deterministic Random Bit Generator")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/drbg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1832,7 +1832,7 @@ static inline void __init drbg_fill_arra
 	 * it is selected.
 	 */
 	if (fips_enabled)
-		alg->base.cra_priority += 200;
+		alg->base.cra_priority += 2000;
 
 	alg->base.cra_ctxsize 	= sizeof(struct drbg_state);
 	alg->base.cra_module	= THIS_MODULE;


