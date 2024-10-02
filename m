Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE2C1D04B6;
	Wed,  2 Oct 2024 13:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875467; cv=none; b=Gda1u5escPbvJCs6vnDo7rZtuUmx5RDs0HS+VJUiDoS+DKdqzAXQ/nMxKRmcGFpcFdV4GkYS+8a07W53sQ9ypXI0VTPrI8uAv+JKbWEze+4nD9ulVOTcFHhwocyDuht99vV6yA4D+muEEeX7OejeP2bmlZVfyd+ltz3U92JUQnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875467; c=relaxed/simple;
	bh=nTZpSdznELTNLY2NDLMpYHIj++KqG1exJTbqDLdRXSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F5BpIc+6cBLf6sj53+vkcBkTSdp69n3eu9qTd7Kd02csKMh/l7cTUafCwRc6bA9NMNubbo4PHZuSxSe6kDTMBjqino+Nu1g+UZcFN6Qigxr+qQAXm6rwVpzzpf7MYa4YwosLf6SV8173M5/5qFz0n5hb+8w5Tj+a/7gbdZrzoS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=15mgPAg5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="15mgPAg5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 245B6C4CECE;
	Wed,  2 Oct 2024 13:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875465;
	bh=nTZpSdznELTNLY2NDLMpYHIj++KqG1exJTbqDLdRXSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=15mgPAg5Dy8RAxc6phlrNYgdL19apwdb4iGbeMgjyCTCJRbvSxFvyRMVF6QiFh20M
	 A5sfDT48D/6kCD1OloDlmPYTm1PJ+V1OnEnILAcN3wBRpfJaawSlywDxznuvkw7Uwh
	 rdwV7khGOlMfnXDl5tmt6zynEV72OvKIAuzjhjxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 110/695] crypto: n2 - Set err to EINVAL if snprintf fails for hmac
Date: Wed,  2 Oct 2024 14:51:48 +0200
Message-ID: <20241002125826.864423791@linuxfoundation.org>
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
index 251e088a53dff..b11545cc5cb79 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -1353,6 +1353,7 @@ static int __n2_register_one_hmac(struct n2_ahash_alg *n2ahash)
 	ahash->setkey = n2_hmac_async_setkey;
 
 	base = &ahash->halg.base;
+	err = -EINVAL;
 	if (snprintf(base->cra_name, CRYPTO_MAX_ALG_NAME, "hmac(%s)",
 		     p->child_alg) >= CRYPTO_MAX_ALG_NAME)
 		goto out_free_p;
-- 
2.43.0



