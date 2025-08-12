Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3265E13AA2F;
	Tue, 12 Aug 2025 18:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024283; cv=none; b=spuue7LrvD9OYF53kOeG50RJv/TPhLioAbrszNbNaPpCOJhPgQ1cu4P9gYHvTcAPfZ4lfb9AArzDvvmCK76yu+c5v4/cFZ/PEEsUzdqZyb5ueA7Hw6GwOu3fqOzW4JtJiwuIHbD9jiz1Qi/vSrIuBnaXv2M9i9nABVJNpnVD4wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024283; c=relaxed/simple;
	bh=TTzazNfcb7eH2e4QzY55Ul0oLaRpBGNbyTcwLT725I0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GII3BaVniyawy6L53Hibax5Q1vwSRiewFxgUXR8ypg2PuzwC44nC7mZBnbXiDRGD/fwqB/pyirHIGyZO8koHgYmekp7TqIXrpYt2j7VS0asxfscOl1sBWUD5j8b18Ophfi8VUTiZYzCxA5HP4oK9hysmjaajfATkgSCHLQa+hOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pm7s6mXj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pm7s6mXj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96825C4CEF0;
	Tue, 12 Aug 2025 18:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024283;
	bh=TTzazNfcb7eH2e4QzY55Ul0oLaRpBGNbyTcwLT725I0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pm7s6mXjJnftfoV1FoH/EUwdUXUs0+c9ieYbyGSeJdb8Zt2CeimZxP/Ye5tM3UDd2
	 dd78jp06rFvm3BCDp/3zcP0jtFEcIdj3r/IzRYeN1oxj2GCK71KnwsK/79bRZ2S+dD
	 zmfHqYMwO41MYvtWmZpCw80f495YakNpEOdMlm5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 328/627] pinctrl: berlin: fix memory leak in berlin_pinctrl_build_state()
Date: Tue, 12 Aug 2025 19:30:23 +0200
Message-ID: <20250812173431.768463918@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuan Chen <chenyuan@kylinos.cn>

[ Upstream commit 8f6f303551100291bf2c1e1ccc66b758fffb1168 ]

In the original implementation, krealloc() failure handling incorrectly
assigned the original memory pointer to NULL after kfree(), causing a
memory leak when reallocation failed.

Fixes: de845036f997 ("pinctrl: berlin: fix error return code of berlin_pinctrl_build_state()")
Signed-off-by: Yuan Chen <chenyuan@kylinos.cn>
Link: https://lore.kernel.org/20250620015343.21494-1-chenyuan_fl@163.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/berlin/berlin.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/berlin/berlin.c b/drivers/pinctrl/berlin/berlin.c
index c372a2a24be4..9dc2da8056b7 100644
--- a/drivers/pinctrl/berlin/berlin.c
+++ b/drivers/pinctrl/berlin/berlin.c
@@ -204,6 +204,7 @@ static int berlin_pinctrl_build_state(struct platform_device *pdev)
 	const struct berlin_desc_group *desc_group;
 	const struct berlin_desc_function *desc_function;
 	int i, max_functions = 0;
+	struct pinfunction *new_functions;
 
 	pctrl->nfunctions = 0;
 
@@ -229,12 +230,15 @@ static int berlin_pinctrl_build_state(struct platform_device *pdev)
 		}
 	}
 
-	pctrl->functions = krealloc(pctrl->functions,
+	new_functions = krealloc(pctrl->functions,
 				    pctrl->nfunctions * sizeof(*pctrl->functions),
 				    GFP_KERNEL);
-	if (!pctrl->functions)
+	if (!new_functions) {
+		kfree(pctrl->functions);
 		return -ENOMEM;
+	}
 
+	pctrl->functions = new_functions;
 	/* map functions to theirs groups */
 	for (i = 0; i < pctrl->desc->ngroups; i++) {
 		desc_group = pctrl->desc->groups + i;
-- 
2.39.5



