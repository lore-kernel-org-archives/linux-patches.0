Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B724153365;
	Thu, 12 Dec 2024 17:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023740; cv=none; b=nSl5KH4J79SrrZE3moB4w4y8hPxNAhwkjXx7EULVkpzG6+d0xoAYiSly+L+1yK96ezg2MMPfb3Y7gp9/2YazXaypxnL5fJj1Or7OPjjJKUkwMgh+07la+hLUKgjed5fFiHatxzbKI8cvLxldJ8EgcEGPrSIdci9kgUTECcbkmlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023740; c=relaxed/simple;
	bh=3W5yoM+ihicTDJH0iXp5Ppje24aEQr/3BjRLu4PSaqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XseX26XPrDUtceweUKM9zEvgXWYX62quEgytPDCo0cdzyp3qF4gK3+cZgswlz+95O38DdP670ZhmurtliAUwn0HwXryEzMlkoHroAL7xEEGLQR5POuc8vAn/gzf3VxgIkQhU07EBIY5LTZeU1S2ZFq6bArjPPZRi88cQT6OCPgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ADBsUKuU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ADBsUKuU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CA61C4CECE;
	Thu, 12 Dec 2024 17:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023740;
	bh=3W5yoM+ihicTDJH0iXp5Ppje24aEQr/3BjRLu4PSaqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ADBsUKuU/JmwvMge29gVmPdgmhT78S32lk54mNt9KRqhr+aR67CwQKL5gyE/dNj6E
	 HhzBIUQRu7CRh8klri6nx/hoGUMXM44d0fstoRfUnuym7ClpbZE5uMkMy5Dc3tq+67
	 0NuQLzEI8AxAGINYE/FljEWnAE1OunOcRmxCPU8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 067/459] crypto: caam - Fix the pointer passed to caam_qi_shutdown()
Date: Thu, 12 Dec 2024 15:56:45 +0100
Message-ID: <20241212144256.165431920@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit ad980b04f51f7fb503530bd1cb328ba5e75a250e ]

The type of the last parameter given to devm_add_action_or_reset() is
"struct caam_drv_private *", but in caam_qi_shutdown(), it is casted to
"struct device *".

Pass the correct parameter to devm_add_action_or_reset() so that the
resources are released as expected.

Fixes: f414de2e2fff ("crypto: caam - use devres to de-initialize QI")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/caam/qi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/qi.c b/drivers/crypto/caam/qi.c
index ec53528d82058..8e9f6097114e3 100644
--- a/drivers/crypto/caam/qi.c
+++ b/drivers/crypto/caam/qi.c
@@ -768,7 +768,7 @@ int caam_qi_init(struct platform_device *caam_pdev)
 
 	caam_debugfs_qi_init(ctrlpriv);
 
-	err = devm_add_action_or_reset(qidev, caam_qi_shutdown, ctrlpriv);
+	err = devm_add_action_or_reset(qidev, caam_qi_shutdown, qidev);
 	if (err)
 		return err;
 
-- 
2.43.0



