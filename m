Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDEE01272AE;
	Tue, 14 May 2024 11:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687210; cv=none; b=YypkTl4ka/dedpJyi8SbqgOZs4LjP2BvW6KqqARt371BdsUI2K/uSYmU1ObL/B5rUqD15tn3BYJtYoauwY25afVc2OwuLblcbRyrvTGGGJzgo8hYleiq7QoSWii7xYMoq27ZIf2QV+8cz+zob2sg5wN1f+9pefDA+3G8Cf/ZRL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687210; c=relaxed/simple;
	bh=efyBg3beaq7YAM9C3VTgbqy1ckFJr9mFXwOgmebLi7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NXs0d5hk6yGpCzkuLsOPagFSdqn+xDehtcLiuV64zGkYUmK5n4pBiE8hKhZGu9TNDs4Fa89JzpRNS/0NLurgn30gT9L9JZQPBOC3bzXGcZs3PO1bZlBFd6pM2KJP1dDyO8uOHg65tR6czhToiuKhapKUmfdy+44CquVF21xW1TA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NLT5lvVF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NLT5lvVF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED2BFC32786;
	Tue, 14 May 2024 11:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687210;
	bh=efyBg3beaq7YAM9C3VTgbqy1ckFJr9mFXwOgmebLi7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NLT5lvVFKFQGRRYlKmMJCOdbqclTEdJGDxJuDuDE0JtcyU+TKLtl4hTtakWxCSzJa
	 mGK/BnzWHUYzojl8AgBpN7xdbrtUHur1OROxptS11NW05TGnMjr6nsMuTh9ogqyTXd
	 lHjO+UnFRT6bKhVtUQrW8kIAIVvBG4ZU5l7eKkfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Zeng Heng <zengheng4@huawei.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 018/111] pinctrl: devicetree: fix refcount leak in pinctrl_dt_to_map()
Date: Tue, 14 May 2024 12:19:16 +0200
Message-ID: <20240514100957.818330385@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100957.114746054@linuxfoundation.org>
References: <20240514100957.114746054@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zeng Heng <zengheng4@huawei.com>

[ Upstream commit a0cedbcc8852d6c77b00634b81e41f17f29d9404 ]

If we fail to allocate propname buffer, we need to drop the reference
count we just took. Because the pinctrl_dt_free_maps() includes the
droping operation, here we call it directly.

Fixes: 91d5c5060ee2 ("pinctrl: devicetree: fix null pointer dereferencing in pinctrl_dt_to_map")
Suggested-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Zeng Heng <zengheng4@huawei.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Message-ID: <20240415105328.3651441-1-zengheng4@huawei.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/devicetree.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/devicetree.c b/drivers/pinctrl/devicetree.c
index eac55fee5281c..0220228c50404 100644
--- a/drivers/pinctrl/devicetree.c
+++ b/drivers/pinctrl/devicetree.c
@@ -220,14 +220,16 @@ int pinctrl_dt_to_map(struct pinctrl *p, struct pinctrl_dev *pctldev)
 	for (state = 0; ; state++) {
 		/* Retrieve the pinctrl-* property */
 		propname = kasprintf(GFP_KERNEL, "pinctrl-%d", state);
-		if (!propname)
-			return -ENOMEM;
+		if (!propname) {
+			ret = -ENOMEM;
+			goto err;
+		}
 		prop = of_find_property(np, propname, &size);
 		kfree(propname);
 		if (!prop) {
 			if (state == 0) {
-				of_node_put(np);
-				return -ENODEV;
+				ret = -ENODEV;
+				goto err;
 			}
 			break;
 		}
-- 
2.43.0



