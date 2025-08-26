Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31A9341660;
	Tue, 26 Aug 2025 13:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215808; cv=none; b=XXMcQCAJZnfs+j9GknvVyku8UxXuwtmMUMjLIYomniSILRDWfpTaYGVstpvo+NMGReHtK5M/cmcZHrIiv7bOBAV7hmLptnJYPZpc54R80S5iD8HHRwtYOfZjHsXilfgA7BMbgshNGTEvw5CYHSJ+e8B66JEtH6q0ExNDO6M4NsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215808; c=relaxed/simple;
	bh=62fYf+MRMu+OaeRFVLbJoEB8IVoIrVHsCS/dkAprHZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B4peLTO7KEunp6IxB3fuUlOW3J6v6Zw+oqYKQEHVB0EQ6ezDMxfL+7ColhRREuKI4lcBwaud5H46mfqe5cwNKXKEcZ6w7wdpoxLxq1fus7kVcaak6S6z1AHQu3tWjjRVNmWcNJTLEDmeh4QOaLaNJPq/CwE/smuxARctvc11Xkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DOG7VPJ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DOG7VPJ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31BF3C4CEF1;
	Tue, 26 Aug 2025 13:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215807;
	bh=62fYf+MRMu+OaeRFVLbJoEB8IVoIrVHsCS/dkAprHZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DOG7VPJ2xYyov2okQOQD0M839q+YfmGrI5eS1Eu55t/lrnhG5UjW9IK7aIZ4KiIv8
	 nall+WtabiWc49D4inF8WVlWR+ED/KMA1QusQxj703+zfw/Plzw3e4t+MGQCUuTb43
	 cExT5JV/6lTUbau7EyWO937u+pfIGgxGq2Oy8+t4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 174/644] pinctrl: sunxi: Fix memory leak on krealloc failure
Date: Tue, 26 Aug 2025 13:04:25 +0200
Message-ID: <20250826110950.784597069@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 30ca0fe5c31a..afe41ea0ff1e 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sunxi.c
+++ b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
@@ -335,6 +335,7 @@ static int sunxi_pctrl_dt_node_to_map(struct pinctrl_dev *pctldev,
 	const char *function, *pin_prop;
 	const char *group;
 	int ret, npins, nmaps, configlen = 0, i = 0;
+	struct pinctrl_map *new_map;
 
 	*map = NULL;
 	*num_maps = 0;
@@ -409,9 +410,13 @@ static int sunxi_pctrl_dt_node_to_map(struct pinctrl_dev *pctldev,
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



