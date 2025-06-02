Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B71020E026;
	Mon,  2 Jun 2025 15:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877476; cv=none; b=uGN8/GLMnjkWIg3Okdu4RpOI+AsKUt/4xAeC+vW8vMvKS/xDFxuPg9KGtmbLVHd5oMyEheV16FEiGdClyVF0AD6wiNUeM7BGFFo9Uhp0NSpnb2m1CHJyCCfCNHtU8STaINHeMUcRaXzaoG16YZ+rFN2XHpX3NDUuEa0AOBPAoDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877476; c=relaxed/simple;
	bh=z2G3UMBmpSrxLcGeS658lbRLtB1E17IIus96ytzqDSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JJ0fqilgsmBNnz4NJHjb9SRd4WLKz+8MqxeN9KuU6TGqWKn2OYRO2byC+jg269fvc44hXkvRhB71TWubJ37Wah5kCWJLzEbD5YkmRBd8nIfv7WCDtLevxbZR+Irn3QNwdaXq/6pvuVpBT2gp97Scq7l3S8NpdSwUe2/0++kiCzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WH4OGqTM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WH4OGqTM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7402EC4CEEB;
	Mon,  2 Jun 2025 15:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877475;
	bh=z2G3UMBmpSrxLcGeS658lbRLtB1E17IIus96ytzqDSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WH4OGqTM1nAuXFQ40hWFwBKGNKaBfkOJrV0w65Ut3E+35+HFiSlwk3dUpyuoG2n7K
	 6TasBkHzSGUgEXpvz12aPg4RKr+KyNs4ATfXP3oE6V1M6eErYIeSeizOl+IHNRWvNd
	 WM1TcON45sGM6J/uimkBvNdxoTS9qqIyiM4v2uEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.1 272/325] pinctrl: tegra: Fix off by one in tegra_pinctrl_get_group()
Date: Mon,  2 Jun 2025 15:49:08 +0200
Message-ID: <20250602134330.818382992@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 5a062c3c3b82004766bc3ece82b594d337076152 upstream.

This should be >= pmx->soc->ngroups instead of > to avoid an out of
bounds access.  The pmx->soc->groups[] array is allocated in
tegra_pinctrl_probe().

Fixes: c12bfa0fee65 ("pinctrl-tegra: Restore SFSEL bit when freeing pins")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Kunwu Chan <kunwu.chan@linux.dev>
Link: https://lore.kernel.org/82b40d9d-b437-42a9-9eb3-2328aa6877ac@stanley.mountain
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/tegra/pinctrl-tegra.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pinctrl/tegra/pinctrl-tegra.c
+++ b/drivers/pinctrl/tegra/pinctrl-tegra.c
@@ -305,7 +305,7 @@ static const struct tegra_pingroup *tegr
 {
 	struct tegra_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
 
-	if (group_index < 0 || group_index > pmx->soc->ngroups)
+	if (group_index < 0 || group_index >= pmx->soc->ngroups)
 		return NULL;
 
 	return &pmx->soc->groups[group_index];


