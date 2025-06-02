Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74476224B01;
	Mon,  2 Jun 2025 14:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874193; cv=none; b=KONSzLLLuutCbNWrsu3MJtMffNb/R7ngiB/x1LXrM3mrWptX3GDG9WXMD9TDFbfZkqcODTRaeGystQnRnPVbe+XQJtgP6jcvo9hl+eneQdxuc/UQShqjW5Rr1djOO3vuT4dtmFGGsD7fQP/Ebfnkalh0UNAX8IVXPB31aT20Ttk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874193; c=relaxed/simple;
	bh=eWulnOs6ADPVkpPqxwtRlZAIsQL9qec8Wna97bKTmR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dWz5AYVJ1OYipS6MtOV0OCKosJWXtgi6JIz5sdB10w83sl9faKsbyNpSfChRb45bWNK2efC0a/ncGB7kho1AOC5hZBqrEETXCEhUpTW4M0+49ey+O/WrJZfcD1j7NNLYQEBw/aLlyIM3rb8ChXp+n2DCNbsho0LptTUSdAqoBaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UAprGRBN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UAprGRBN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76CE1C4CEEB;
	Mon,  2 Jun 2025 14:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874193;
	bh=eWulnOs6ADPVkpPqxwtRlZAIsQL9qec8Wna97bKTmR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UAprGRBNEGdItwblcT7ay3ok+PlX9QFMWq03YtjrQ5Bi6o7Qg5XEuUhh55YaTcuXS
	 yJCcX8ZMhivIqiDN+cTRkYQGcG51WiaCh8M5xBLMOFim9KG9DJClmki01hikg2YzKT
	 TtKDj0iMbalvesN2SzbfYqb/+a2ci42ppnduT3w8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.6 388/444] pinctrl: tegra: Fix off by one in tegra_pinctrl_get_group()
Date: Mon,  2 Jun 2025 15:47:32 +0200
Message-ID: <20250602134356.655281941@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -307,7 +307,7 @@ static const struct tegra_pingroup *tegr
 {
 	struct tegra_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
 
-	if (group_index < 0 || group_index > pmx->soc->ngroups)
+	if (group_index < 0 || group_index >= pmx->soc->ngroups)
 		return NULL;
 
 	return &pmx->soc->groups[group_index];


