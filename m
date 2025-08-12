Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43E32F8BE7;
	Tue, 12 Aug 2025 17:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021484; cv=none; b=fR9HmSD2sl+Urp5jVaUaTZ1Le3g3D6/dyG3llDRLNoVs0SJm3HgebsoZsjNiQgXIwmX6AdSU37+rw7Ip2Ho7etiSVO3+fM/fwM++6GDzXtFLosN7lDW/XwzklEc1fBGxTGJ2uf4vi2dsPjKbsRwKuQCgKib+C68Q/DGC7QFPxcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021484; c=relaxed/simple;
	bh=4xc3kcAnWfKxcrmA/Q2yKhTQe/LGSDzW/1fKZji2imA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RRBaanhKQZaOLcSUTedtvoIVavE2uyJT9uOSBz58ckllqBZZiGs4VEOl8Wvna4zp5dXlNZeB7HHWX8CJll0Ff0QQ96MjrYOg8+y06m2DaW/HYrvbvxRE/BIvyj34z9RCNAICHwsOtzZVwmxxJTIRGZgrwz0nJF+sAFlug9ofASg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x4WLxJ0p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x4WLxJ0p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1376DC4CEF0;
	Tue, 12 Aug 2025 17:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021484;
	bh=4xc3kcAnWfKxcrmA/Q2yKhTQe/LGSDzW/1fKZji2imA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x4WLxJ0pZCMTOypeYhEeZWWDA82tk0cvP8Pj7W4TRhquLgzOKxGvslDximRrAps8p
	 NjuG3GVdNyBBO9M1sPHp6KjwDB0yzJn3FwqCBgw1R3iIVIkljwhma4vjkomq93iSyQ
	 nCqrBopY2KMV+dQD0Vo673TMwxkOZG2ly5NfcpbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 119/262] pinctrl: sunxi: Fix memory leak on krealloc failure
Date: Tue, 12 Aug 2025 19:28:27 +0200
Message-ID: <20250812172958.177603844@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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
index 73bcf806af0e..fc11c3d55fa8 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sunxi.c
+++ b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
@@ -395,6 +395,7 @@ static int sunxi_pctrl_dt_node_to_map(struct pinctrl_dev *pctldev,
 	const char *function, *pin_prop;
 	const char *group;
 	int ret, npins, nmaps, configlen = 0, i = 0;
+	struct pinctrl_map *new_map;
 
 	*map = NULL;
 	*num_maps = 0;
@@ -469,9 +470,13 @@ static int sunxi_pctrl_dt_node_to_map(struct pinctrl_dev *pctldev,
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



