Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C983F2FD1B2;
	Tue, 12 Aug 2025 17:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020676; cv=none; b=o+S0IaI9uwiSd2FF3MXWuyCfa2CUwr2YNWvx4T1fuRRG2b/DKXWIjwl0q9qomGLXg7WJm7ZxgycVvZ7OqYXWc9mK7BEdvE4V/75h3q2uifxPUOANeoYQ1VFsjZbXn760UdO4y1G1KdWUCf6zrydikv9QbFcukaw4oWDJhfqQqYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020676; c=relaxed/simple;
	bh=0PIjDJycrFk0kcX9UUA08NNhIdfi9YfI3UZPMRMWIIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U8wT8TorYyYNXMSzexfaO1NEX/8ZUzyXscaZfMXxSCOz/r57q8mO/Ndc7QK68TCh0Pzh3KbZ+YptrXehzF5zP9pphNw+k79XIsXRq5y/Y9oyFGWFaCt3TMf2Cfqv9gG+IM29PC0GHUtz/X5/OjlbUv8XWIlorMsLxIjnUgHDUVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hZcGOn27; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hZcGOn27"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A179C4CEF0;
	Tue, 12 Aug 2025 17:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020676;
	bh=0PIjDJycrFk0kcX9UUA08NNhIdfi9YfI3UZPMRMWIIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hZcGOn27ajx6DTA5JoZjgLlyZklXO5fbJN9RPoy7ZgM1c/KORGKwmygIsj1/LR8fu
	 iIh8axZ0Hag3/KFGwq3J96YWRTOAX39F8uDISlYZAL74EQQr0hZu/oioP/a20w1wKR
	 sCVtL1wOLPZv/C2G6YCGp4x4GYpWJ3SUHBbsKGX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 150/253] pinctrl: sunxi: Fix memory leak on krealloc failure
Date: Tue, 12 Aug 2025 19:28:58 +0200
Message-ID: <20250812172955.092421104@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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
index 6c04027d0dd9..df2e721297fc 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sunxi.c
+++ b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
@@ -396,6 +396,7 @@ static int sunxi_pctrl_dt_node_to_map(struct pinctrl_dev *pctldev,
 	const char *function, *pin_prop;
 	const char *group;
 	int ret, npins, nmaps, configlen = 0, i = 0;
+	struct pinctrl_map *new_map;
 
 	*map = NULL;
 	*num_maps = 0;
@@ -470,9 +471,13 @@ static int sunxi_pctrl_dt_node_to_map(struct pinctrl_dev *pctldev,
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



