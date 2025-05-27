Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C2442A9B;
	Tue, 27 May 2025 17:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368206; cv=none; b=jgqUcbFDuQu+s0k1AQUH60EIZkuHWDAY5r8wfZzuaWj/hVCCtYtG0Wc1JhHJ82Yc4us2B9cijsrFx9Y6sqnYDhjlGVwuZgUVsBnwFn3J0Z8pj1jkeA5VnNkSmxhrm9cnr/MTw9Bfpo+12MaLyu2mhXQURHMM2tn/hKyjDLSCzDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368206; c=relaxed/simple;
	bh=3GLT066KkJ2bCDLGokGtEc5QdyrmH0ScBPjvOoe5Xds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rXGVA1Ntz9y1TnC+elPmk1ALHVEI+9upFCN+fWKE+jI+fUFV7DhTFrZS4u6uS91umKcEYdlGLxuFMOp6146qj8cG/H584tiEXq8K/IRiRJp2jdi8WlVSmauL88gSzGf70gsaaT/Hz8T9s7FbPRQcfOXB1cpcSLkWWQd5atiJgo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AbjpSGf8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AbjpSGf8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0622EC4CEE9;
	Tue, 27 May 2025 17:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368206;
	bh=3GLT066KkJ2bCDLGokGtEc5QdyrmH0ScBPjvOoe5Xds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AbjpSGf89odoaD2TkmrPDt1wc4E4sHO0p88tBecibhjDbmdPNxefK3wj8jdKHtwGa
	 t+orKwjwfXZCuQbm8rGSknd7WItL0RUFHUe213RWsKXvUXV0aPxyDGROyxitKh8iBo
	 Cmvf762gjBUlyUor37izDqtIJgIEFCnda6O3yasc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 632/783] pinctrl: tegra: Fix off by one in tegra_pinctrl_get_group()
Date: Tue, 27 May 2025 18:27:09 +0200
Message-ID: <20250527162538.882216339@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 5a062c3c3b82004766bc3ece82b594d337076152 ]

This should be >= pmx->soc->ngroups instead of > to avoid an out of
bounds access.  The pmx->soc->groups[] array is allocated in
tegra_pinctrl_probe().

Fixes: c12bfa0fee65 ("pinctrl-tegra: Restore SFSEL bit when freeing pins")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Kunwu Chan <kunwu.chan@linux.dev>
Link: https://lore.kernel.org/82b40d9d-b437-42a9-9eb3-2328aa6877ac@stanley.mountain
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/tegra/pinctrl-tegra.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/tegra/pinctrl-tegra.c b/drivers/pinctrl/tegra/pinctrl-tegra.c
index 27823e4207347..edcc78ebce456 100644
--- a/drivers/pinctrl/tegra/pinctrl-tegra.c
+++ b/drivers/pinctrl/tegra/pinctrl-tegra.c
@@ -305,7 +305,7 @@ static const struct tegra_pingroup *tegra_pinctrl_get_group(struct pinctrl_dev *
 {
 	struct tegra_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
 
-	if (group_index < 0 || group_index > pmx->soc->ngroups)
+	if (group_index < 0 || group_index >= pmx->soc->ngroups)
 		return NULL;
 
 	return &pmx->soc->groups[group_index];
-- 
2.39.5



