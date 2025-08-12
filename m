Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B294D2F291B;
	Tue, 12 Aug 2025 18:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024279; cv=none; b=jRZps2En14gPhBxaTcpCc2AAbFUBNnB5hg8ymz6nIbrWPPtAwx7DWNWbIsUa02FZTbMXCm8tdY1zaZUUdKEAcNqwtLyf3xjN58MTiQC596yZjbXh7ZKwUVMYqeCSbHhraLLdelYcwj9L5itAeg6oqG/E/5JqNHoafe5e5+6X/Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024279; c=relaxed/simple;
	bh=GJRgE58j8nEGf2YPiQi744n28Sq8g6AigGeTe1EuLgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XUmnJLGo1eAWqvkMlrL9pTCw2NuBCzpzsuNfx5rOvWKjV/M86Zn/BOgme0ojOrbWk/rLwKaZuvLOJsk+oEUxpGZXLRhotwZci4mLDDtsuPsUTAcP0+f+ealULsHA38xRRlBtesk1LH/kr6TUCX3JviPeioBnb2bw6umsDGV6PM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=svmQ1f2H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="svmQ1f2H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20B8CC4CEF0;
	Tue, 12 Aug 2025 18:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024279;
	bh=GJRgE58j8nEGf2YPiQi744n28Sq8g6AigGeTe1EuLgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=svmQ1f2HmnVF5L2vj9Vss+cqxUfC6pPHEqYDZ2LSyL7TGPqYSJhr6bX9unV6lyLC2
	 PXp3hUktgAtXMndYTN8StMvVyoWZvwd8rVwb9Rz/nFU1Pn9nAuyx7k55cxt/3UPMb9
	 pU+2+jSUb8vMUDW/3z3fU7QuhV6iWZjbroiC3JjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 327/627] pinctrl: sunxi: Fix memory leak on krealloc failure
Date: Tue, 12 Aug 2025 19:30:22 +0200
Message-ID: <20250812173431.731433069@linuxfoundation.org>
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

[ Upstream commit e3507c56cbb208d4f160942748c527ef6a528ba1 ]

In sunxi_pctrl_dt_node_to_map(), when krealloc() fails to resize
the pinctrl_map array, the function returns -ENOMEM directly
without freeing the previously allocated *map buffer. This results
in a memory leak of the original kmalloc_array allocation.

Fixes: e11dee2e98f8 ("pinctrl: sunxi: Deal with configless pins")
Signed-off-by: Yuan Chen <chenyuan@kylinos.cn>
Link: https://lore.kernel.org/20250620012708.16709-1-chenyuan_fl@163.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sunxi/pinctrl-sunxi.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/sunxi/pinctrl-sunxi.c b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
index bf8612d72daa..d63859a2a64e 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sunxi.c
+++ b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
@@ -408,6 +408,7 @@ static int sunxi_pctrl_dt_node_to_map(struct pinctrl_dev *pctldev,
 	const char *function, *pin_prop;
 	const char *group;
 	int ret, npins, nmaps, configlen = 0, i = 0;
+	struct pinctrl_map *new_map;
 
 	*map = NULL;
 	*num_maps = 0;
@@ -482,9 +483,13 @@ static int sunxi_pctrl_dt_node_to_map(struct pinctrl_dev *pctldev,
 	 * We know have the number of maps we need, we can resize our
 	 * map array
 	 */
-	*map = krealloc(*map, i * sizeof(struct pinctrl_map), GFP_KERNEL);
-	if (!*map)
-		return -ENOMEM;
+	new_map = krealloc(*map, i * sizeof(struct pinctrl_map), GFP_KERNEL);
+	if (!new_map) {
+		ret = -ENOMEM;
+		goto err_free_map;
+	}
+
+	*map = new_map;
 
 	return 0;
 
-- 
2.39.5



