Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BEE829A9;
	Fri, 15 Nov 2024 06:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653204; cv=none; b=La23fskU0NgI6WJSYXuhZMm810vfoQ4H2hZo7J8dOGA12JcgKnGQhBhEi37DUiw8VGDVYr9NKnwIBOCmn/APXlM1dREH5WCjvCR7UTsPeSlazdpUWQXYZeohdzDAdTWsMB7hhDmCpme790VAb6d0qixVVIeFT7HYSh+nfFlzTNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653204; c=relaxed/simple;
	bh=Uq8hhrHYfJcm5YC0GTEEJog/vs8fW6o7jVU8Dc0NmQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=crK3xa7ZrIvlqRvMH7bBFlEAr8+3rVyFlHlnY9HLDMsFTZUeNN/Kft2q3mVLB7FoKmjmhlJyNfyDRReapfPFAXdWYdNT2zWzIYQfxGyHwCJmsiIDx6+h4/SGAEzK7te3R4qBQiQiKVIYshDqZNgKQzcdjrnwBTdEnzR7tIpVNcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J6mFbkfW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J6mFbkfW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EBB0C4CECF;
	Fri, 15 Nov 2024 06:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653203;
	bh=Uq8hhrHYfJcm5YC0GTEEJog/vs8fW6o7jVU8Dc0NmQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J6mFbkfWGD/q7+XvKZeP5fyXd0Dmsb2y+vR/UrbxOHXODu3lmryBhbUKEVG/5favJ
	 zSi05/pq/WpU96v5la4uksRNeiHq2BCre4ezGmOKvRoRuMv7C17mXoPwytO0cnDIjF
	 CNysFtuL0ACqcy9ngneIqdO2XH6OvyfwxTIaRW+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 17/63] crypto: api - Fix liveliness check in crypto_alg_tested
Date: Fri, 15 Nov 2024 07:37:40 +0100
Message-ID: <20241115063726.543014915@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.892410236@linuxfoundation.org>
References: <20241115063725.892410236@linuxfoundation.org>
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

[ Upstream commit b81e286ba154a4e0f01a94d99179a97f4ba3e396 ]

As algorithm testing is carried out without holding the main crypto
lock, it is always possible for the algorithm to go away during the
test.

So before crypto_alg_tested updates the status of the tested alg,
it checks whether it's still on the list of all algorithms.  This
is inaccurate because it may be off the main list but still on the
list of algorithms to be removed.

Updating the algorithm status is safe per se as the larval still
holds a reference to it.  However, killing spawns of other algorithms
that are of lower priority is clearly a deficiency as it adds
unnecessary churn.

Fix the test by checking whether the algorithm is dead.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/algapi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 122cd910c4e1c..192ea14d64ce6 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -396,7 +396,7 @@ void crypto_alg_tested(const char *name, int err)
 	q->cra_flags |= CRYPTO_ALG_DEAD;
 	alg = test->adult;
 
-	if (list_empty(&alg->cra_list))
+	if (crypto_is_dead(alg))
 		goto complete;
 
 	if (err == -ECANCELED)
-- 
2.43.0



