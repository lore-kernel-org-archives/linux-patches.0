Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9F122655B;
	Thu, 12 Dec 2024 15:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019022; cv=none; b=Snvv/hd+8rYgic1uFzdS5yi1WicciDmkolV6IWHVMxuYsEEbgJ2+Xx8K6Vw3dQxQH+du8g+4jc3VXhUqWNjHSkqjTJnfuoqmwIHyegNnfNRUEnvBX9icfru7hoxYErvzM+OAvlQsx1n/HxSkxFUglbeW/HCQgkamR0EpPOGEM5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019022; c=relaxed/simple;
	bh=M84qmAraPEAvZFAvrGGHjzxupcfSnt613hvbWMoKFTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qVG3FJqkqiKRRUpMg2lpGjCaucsuHnzAjccDC6QMlbd+t8S3+7n9Sbs4wBauN+fxwKuE19irET7drpxd/TF4E6HDw//OWICUtcz06cDPRaPMv883XK5XQzB2C1NApxxEYkggm9HzTbiUkMq8E+5oHCctMHAEino89YxFljhhrcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IVtUcghT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IVtUcghT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB541C4CED0;
	Thu, 12 Dec 2024 15:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019022;
	bh=M84qmAraPEAvZFAvrGGHjzxupcfSnt613hvbWMoKFTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IVtUcghTqtjNvsaMhcXXp5xrWwag0fqBEncAthBupxZYNY8AnUHjIU+M9bcSO9WJk
	 jmm2wU8Lxcj7NWxiaYyHC7mA5HrfcGhp9OYFyIUJhyKVvFwTEXA8wFFDtTY0pZmrdK
	 60vsxE8hKGD3SLHobYcIOEFW0AnA+id+AYOkTHSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 067/772] crypto: caam - Fix the pointer passed to caam_qi_shutdown()
Date: Thu, 12 Dec 2024 15:50:12 +0100
Message-ID: <20241212144352.709235253@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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
index c36f27376d7e0..9f6db61e5c0d9 100644
--- a/drivers/crypto/caam/qi.c
+++ b/drivers/crypto/caam/qi.c
@@ -765,7 +765,7 @@ int caam_qi_init(struct platform_device *caam_pdev)
 
 	caam_debugfs_qi_init(ctrlpriv);
 
-	err = devm_add_action_or_reset(qidev, caam_qi_shutdown, ctrlpriv);
+	err = devm_add_action_or_reset(qidev, caam_qi_shutdown, qidev);
 	if (err)
 		return err;
 
-- 
2.43.0



