Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F19188713;
	Fri, 15 Nov 2024 06:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653574; cv=none; b=puoiZetAHyjO9e+6sfTtu0MjInKz3af34MNW14rb0RzKFKPtQmAA0DPLaI9kTdUy9M04qk1Cz5Vko1aUwOI0ptUKv8nyog/JAt3PrOls3UOD0EhEIqfV5uoXzqXf3eMH6gA2+QGXkA1KzeyqYqrz2BYyRQ9hOzPvF6uqizbvqxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653574; c=relaxed/simple;
	bh=/ZSHt3FAtYUux+B8VngxCOl9vPO1B/ycoCxwOivolg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eG5dgeN0vEzJ2uAKnHNa/BOYdp8eHLzN45zoVDSvwL9Grc8mKquOT3VHDED++NkxGOtI/yrFO/oQWLqC1TyeloOaMpC6T5pH3S99HTRsXqaUKeFA0MrTVgn3ycgPJy6ybcZink3ZraOsy3R3PbS7/fUzmTMJGJjO/sj0wLVIb1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KsdzUArv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KsdzUArv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA10C4CECF;
	Fri, 15 Nov 2024 06:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653574;
	bh=/ZSHt3FAtYUux+B8VngxCOl9vPO1B/ycoCxwOivolg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KsdzUArv9PRrnRS3VAw5kN8KSXzMy/oohNJ2zPmryw5ef2+f3TrtMvtKVGoQmsC5K
	 Tz1V3F7Z4pAAvtYnxxAiPRaTlITYTDGn8G5dbu+YFAz89R6S5/3fUwfc/kP47EouW5
	 u+7tLeccXlS28fmO/6S/KXK0rBS2Do6oWaLlheT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 14/39] crypto: api - Fix liveliness check in crypto_alg_tested
Date: Fri, 15 Nov 2024 07:38:24 +0100
Message-ID: <20241115063723.125788676@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.599985562@linuxfoundation.org>
References: <20241115063722.599985562@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5dc9ccdd5a510..206a13f395967 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -341,7 +341,7 @@ void crypto_alg_tested(const char *name, int err)
 	q->cra_flags |= CRYPTO_ALG_DEAD;
 	alg = test->adult;
 
-	if (list_empty(&alg->cra_list))
+	if (crypto_is_dead(alg))
 		goto complete;
 
 	if (err == -ECANCELED)
-- 
2.43.0



