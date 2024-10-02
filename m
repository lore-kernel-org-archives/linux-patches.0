Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16FF1D0977;
	Wed,  2 Oct 2024 13:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877495; cv=none; b=d9CtHpcCTs7PvPnk8gIOy84wlF9rYHUA0MOcmNU7Oi25vULGLlJyHwocGTdH59dInljoeJrVLZ58nkfbKJOmdyCuOIrJwILzYgYFGTeKitOKEFSNyWWOjkPNrx13LrqwVGiZ4AdwXMvcU3v1x1lfeWk/aN+wB4mZkUGEUJ+2GFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877495; c=relaxed/simple;
	bh=XqwcdggyNTXTz411KNHJXrtK29vNkn6UqnfaE4oJot4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aSgvIDudSl/p3rFwFYGTbiqln3d1Zt1sG6eiqRM37FII5J8SKkcZrIHL5wiJOV77JQoDU8Jj9B4RGa9d3HVlj0ee9qyf/HvHp1VMkdAILSxd1tJPkHykj7g0ddRVVdRXMCHtAQ/mCQISsZQsZDTb//W+e+IwCfuQ9OKkdiw8tYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IIAPUJnH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IIAPUJnH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 165DDC4CEC2;
	Wed,  2 Oct 2024 13:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877494;
	bh=XqwcdggyNTXTz411KNHJXrtK29vNkn6UqnfaE4oJot4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IIAPUJnHcU9BbUeu3p/7U91xDF2JTI+Xug1hCFw6sAAuUg8LSj9czYZEy8OrSTQbg
	 bWdEs6UakV61iFqHzRiM9ZIMzgHjriTZPUsDjpyNafp3IjTK/w80Gu1iPUMjRLJF6O
	 VH3ZHRozZCCJ+F1wZXV4zn7tEY4AicQfHf5j9Bw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 096/634] crypto: n2 - Set err to EINVAL if snprintf fails for hmac
Date: Wed,  2 Oct 2024 14:53:16 +0200
Message-ID: <20241002125814.897992668@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit ce212d2afca47acd366a2e74c76fe82c31f785ab ]

Return EINVAL if the snprintf check fails when constructing the
algorithm names.

Fixes: 8c20982caca4 ("crypto: n2 - Silence gcc format-truncation false positive warnings")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202409090726.TP0WfY7p-lkp@intel.com/
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/n2_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index 59d472cb11e75..509aeffdedc69 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -1357,6 +1357,7 @@ static int __n2_register_one_hmac(struct n2_ahash_alg *n2ahash)
 	ahash->setkey = n2_hmac_async_setkey;
 
 	base = &ahash->halg.base;
+	err = -EINVAL;
 	if (snprintf(base->cra_name, CRYPTO_MAX_ALG_NAME, "hmac(%s)",
 		     p->child_alg) >= CRYPTO_MAX_ALG_NAME)
 		goto out_free_p;
-- 
2.43.0



