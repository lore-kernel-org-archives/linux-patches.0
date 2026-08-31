Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F41843A7F7;
	Mon, 31 Aug 2026 13:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184619; cv=none; b=rNtHmMM5k9LzpLcklynXSDVkaze4verqiE/5qEca61//4dg318GiH3R70GHr8zO0e3sD98B9E0sSBPNTwVnbIpJnHyD2YfOitJBYL7eAbqRONDPKEXMWK8KlISYEdVwJQn2isd2gxKqxhp69dUIcKtU1yoDzI8vIC15kExPkd6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184619; c=relaxed/simple;
	bh=dM0OXpvXnthQDXMrWqktzipkCyvHxuqSbFf3uhZP8ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XQbNnY9jB42JkBjYPFfhw9W3RhZm/Lzlql6stTuini75JQWUFw0f3rZCljMDmEq14O6IpeEY/sJ5fnXIGTjeVSh3ujn+nBLB7iQkT78Bmo8TX1qOKvhpI2zVkX3vS3mnHVnErLr+l0it0HoX06r9BkxqAHJE5F3NN/nue+7PjpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oOmM0OY6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oOmM0OY6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DBFC1F00A3D;
	Mon, 31 Aug 2026 13:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184617;
	bh=2ESfLA3VaQ+9kdCiD5n0r5IiiugsCiIu3weveop3YEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oOmM0OY6FaV39jlWGeMCNqsVTIdTh5vQItsPruOg5kMP/M9IT1foRmikAAw8SKuT9
	 njxhF++nsdA1wjLgjmdXDAtnTcWPmT1TzoU9Jntk5Fwp9bEste/dFdAdOxK63vPxx8
	 VqfKPRCJ6mcm037Oe4xi/LgR9IfEGx/LjjYFO6qE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Jie Ho <jiajie.ho@starfivetech.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 33/91] crypto: starfive - Do not free stack buffer
Date: Mon, 31 Aug 2026 15:34:21 +0200
Message-ID: <20260831133401.456278236@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>
References: <20260831133359.468089036@linuxfoundation.org>
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

From: Jia Jie Ho <jiajie.ho@starfivetech.com>

[ Upstream commit d7f01649f4eaf1878472d3d3f480ae1e50d98f6c ]

RSA text data uses variable length buffer allocated in software stack.
Calling kfree on it causes undefined behaviour in subsequent operations.

Cc: <stable@vger.kernel.org> #6.7+
Signed-off-by: Jia Jie Ho <jiajie.ho@starfivetech.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/starfive/jh7110-rsa.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/starfive/jh7110-rsa.c b/drivers/crypto/starfive/jh7110-rsa.c
index 1db9a3d02848b..3116828d60a07 100644
--- a/drivers/crypto/starfive/jh7110-rsa.c
+++ b/drivers/crypto/starfive/jh7110-rsa.c
@@ -303,7 +303,6 @@ static int starfive_rsa_enc_core(struct starfive_cryp_ctx *ctx, int enc)
 
 err_rsa_crypt:
 	writel(STARFIVE_RSA_RESET, cryp->base + STARFIVE_PKA_CACR_OFFSET);
-	kfree(rctx->rsa_data);
 	return ret;
 }
 
-- 
2.53.0



