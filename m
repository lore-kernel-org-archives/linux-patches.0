Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36E357CBC;
	Tue, 14 May 2024 11:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686941; cv=none; b=I7uHrdUQffDvwaEKSQMhFGQx0PqiNzanhemE4iKv779WkYLDBIFCN+f4ThmjqN9X4dbo+AUmQY3wdQjoanpfbKd54KcFRpt9N7tqK47IX9+BZlKSRN7XVjY3h2oKIcF73y71p4hp5fqvswyAVVmMfy5i3aSWBFZLoP0F1KewoFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686941; c=relaxed/simple;
	bh=jX6yqe5Dw7xvJ42MBf+s0CII3wV03+WFDbgztBXd4Uk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=njdKp5vFYuRRXJYxq/dDl0/lHQzjMHIDUkNMQagbrcdfLrkqg+xiL0QgssI+EB/LI8AyRW8B8KzXpZKSnDAQSlFuX46tpJP/D7Cf6Mr9QlAwdW3AdzgkGRidbHXhXkTrdOPxLPrNQedPDHC11Sz1Bk4MCgmkyI9j5ZujCoKdN6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vUxQJGND; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vUxQJGND"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BB70C2BD10;
	Tue, 14 May 2024 11:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686940;
	bh=jX6yqe5Dw7xvJ42MBf+s0CII3wV03+WFDbgztBXd4Uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vUxQJGNDQcVASvlKCz5zvvR5s8k3kQ0eYxASaKLTmbZsCnOy8KkoUs9OVSOqn4Fk9
	 tTx0bmbO3XuVSdgSTF8a/LabkG0dBTdan5qG5JUeGMwskOOEKpRkCFkFUn8N3VVqJx
	 WM4keSdigEJIdcj0gA20VQ0+2ru2PehWSWg+5t0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 11/84] pinctrl: mediatek: paris: Fix PIN_CONFIG_BIAS_* readback
Date: Tue, 14 May 2024 12:19:22 +0200
Message-ID: <20240514100952.117021206@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100951.686412426@linuxfoundation.org>
References: <20240514100951.686412426@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 3e8c6bc608480010f360c4a59578d7841726137d ]

When reading back pin bias settings, if the pin is not in the
corresponding bias state, the function should return -EINVAL.

Fix this in the mediatek-paris pinctrl library so that the read back
state is not littered with bogus a "input bias disabled" combined with
"pull up" or "pull down" states.

Fixes: 805250982bb5 ("pinctrl: mediatek: add pinctrl-paris that implements the vendor dt-bindings")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20220308100956.2750295-3-wenst@chromium.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Stable-dep-of: c5d3b64c568a ("pinctrl: mediatek: paris: Rework support for PIN_CONFIG_{INPUT,OUTPUT}_ENABLE")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-paris.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-paris.c b/drivers/pinctrl/mediatek/pinctrl-paris.c
index b613dda50151b..cb4979cefdd09 100644
--- a/drivers/pinctrl/mediatek/pinctrl-paris.c
+++ b/drivers/pinctrl/mediatek/pinctrl-paris.c
@@ -95,20 +95,16 @@ static int mtk_pinconf_get(struct pinctrl_dev *pctldev,
 			err = hw->soc->bias_get_combo(hw, desc, &pullup, &ret);
 			if (err)
 				goto out;
+			if (ret == MTK_PUPD_SET_R1R0_00)
+				ret = MTK_DISABLE;
 			if (param == PIN_CONFIG_BIAS_DISABLE) {
-				if (ret == MTK_PUPD_SET_R1R0_00)
-					ret = MTK_DISABLE;
+				if (ret != MTK_DISABLE)
+					err = -EINVAL;
 			} else if (param == PIN_CONFIG_BIAS_PULL_UP) {
-				/* When desire to get pull-up value, return
-				 *  error if current setting is pull-down
-				 */
-				if (!pullup)
+				if (!pullup || ret == MTK_DISABLE)
 					err = -EINVAL;
 			} else if (param == PIN_CONFIG_BIAS_PULL_DOWN) {
-				/* When desire to get pull-down value, return
-				 *  error if current setting is pull-up
-				 */
-				if (pullup)
+				if (pullup || ret == MTK_DISABLE)
 					err = -EINVAL;
 			}
 		} else {
-- 
2.43.0



