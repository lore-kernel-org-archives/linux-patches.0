Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB13C3570C4;
	Tue, 26 Aug 2025 14:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217390; cv=none; b=r5f3Un7y5Iu+hV6Fp8W60RZc86fFgJI2iUtHTiRV3p4LFBYpTnlWMDSPjn82KBPTa4XVYbVgV248jln/Nj1zeYyz0JjFilnUVRFM9AfvnysiopcOEGnOlmEyRPuZY68t/53HBtFz/ADY5w9s4GkM28JUDNXYdDaVhhvNz2CymqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217390; c=relaxed/simple;
	bh=r2bgp7xW3FHTmttCDBDkX+6zj3mu9N6cih92iNvTa88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P4Q92z0EDa7WKnfMTxQB2/wZc7EkjerJIoiT6FqgNdQpz8kYaKkNMYCteFyCuv/bLIvktn1fylv62zQ3XBYElczNbqkR09ZSaFXFai6Gmq+y4AIXnqkWg3l2nDFX6X5FmxlqhQoAWRPiLxr2DiKZ0kMTfIEq9cdZZICqKF8rqIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OF+wZTbw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OF+wZTbw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66067C113D0;
	Tue, 26 Aug 2025 14:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217390;
	bh=r2bgp7xW3FHTmttCDBDkX+6zj3mu9N6cih92iNvTa88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OF+wZTbwm00oJR3tXVkDSGDVJrS5tC6CTEXDw4AFJddfOiKZ2AokVCf0EP0Is1Xuy
	 5PvtglCROwMitcN+Ia9D5AMuTxBxYfu2lZ8/8IZ8bWXAUgkG+l4SyTMtERm1li5t3H
	 VGbxuSyfKBwNC2LtJIcR9jKIgagf++ATFNiDSGus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 125/523] pinctrl: sunxi: Fix memory leak on krealloc failure
Date: Tue, 26 Aug 2025 13:05:35 +0200
Message-ID: <20250826110927.594768029@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e4b41cc6c586..0a50f37c63f4 100644
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



