Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6947D1D049A;
	Wed,  2 Oct 2024 13:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876401; cv=none; b=b7qIUi3nleQ5KQ428B9GLqFoJ2s61XLHA0ZbjdozL8MJmyX7cayVICqGGIlmj/Ixab1s0HTQCyyriI5suQ3F3tlA6npqPYpRiXami0B0MuZZsZag7MxPWo+W/ffroHOJ46hthQ84SIlp/GKejcuSQQBxwmM5sVZ0FQbysWl3oOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876401; c=relaxed/simple;
	bh=Vss2kL3T/w2hVaM0dDHOtdnAgv18pSY5o7+twQei6tk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V1yLm+1mwTNckc4dkRg6qilXpDa9IbalT+CkoTVoifMi8LA4mmpZNuuL2Zi8YIugATHHwtdOVABO0OmO0URLw4jH4Wt8A7xXvoztxIfKTCJUSXpGxrxZgScu0np4WadvSgtRTB//Z9NUXtMl3ARKwlzJzoyxt8eVi4PnZ36e3dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k6AnhFGj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k6AnhFGj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 916C9C4CEC5;
	Wed,  2 Oct 2024 13:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876401;
	bh=Vss2kL3T/w2hVaM0dDHOtdnAgv18pSY5o7+twQei6tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k6AnhFGjjomDc9qOLGPRM77TFE0gzkHAIiIJnXIEXXHAyn/r2rvwinu5udcRF3dGL
	 JHhMBoPWqX1R7X+i+jVikmzSeX1L8WI8O6+Kxek6skcrjSNabJhTIToWG0uTi49dUu
	 e1x5a6FtjenKMVCBY0ZHM2TuNXDmFpzAEpIt7qZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangwu Zhang <guazhang@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 432/695] crypto: caam - Pad SG length when allocating hash edesc
Date: Wed,  2 Oct 2024 14:57:10 +0200
Message-ID: <20241002125839.706328142@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 5124bc96162667766f6120b19f57a640c2eccb2a ]

Because hardware will read in multiples of 4 SG entries, ensure
the allocated length is always padded.  This was already done
by some callers of ahash_edesc_alloc, but ahash_digest was conspicuously
missing.

In any case, doing it in the allocation function ensures that the
memory is always there.

Reported-by: Guangwu Zhang <guazhang@redhat.com>
Fixes: a5e5c13398f3 ("crypto: caam - fix S/G table passing page boundary")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/caam/caamhash.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index fdd724228c2fa..25c02e2672585 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -708,6 +708,7 @@ static struct ahash_edesc *ahash_edesc_alloc(struct ahash_request *req,
 		       GFP_KERNEL : GFP_ATOMIC;
 	struct ahash_edesc *edesc;
 
+	sg_num = pad_sg_nents(sg_num);
 	edesc = kzalloc(struct_size(edesc, sec4_sg, sg_num), flags);
 	if (!edesc)
 		return NULL;
-- 
2.43.0



