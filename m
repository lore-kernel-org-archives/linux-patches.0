Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8087D274B3C;
	Thu, 27 Nov 2025 14:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764254943; cv=none; b=Zmpa+QAPDk9JwVzsYL9R+r0s07j5W84lh3tgKVwyNeVmQhHAdAFeNAFuJatic1ivaARLJEJfHrUOlR6JXGP8H7i4khcwwloItiwDQYTywv+zngwiM/YPZp/ARtBIIpaTBWqNbOLgcJxQCqzvdBTZfkMoggItUAF5TTP/KdNVNgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764254943; c=relaxed/simple;
	bh=/2Fk9yQpjHRenTt8pTRlDTITM9bW9R6LtnEJWAabv+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tJgqwkHNRc9U/6UnBtSs5jPnm3arkaYiwcXeKWvAVwH6as90bNLnRogjrY+zFAcrlxv23tjPFuhb6o3wIdPKPrK1bsp6WEe2ovJy5yhM/24PTXKTvqUQpOYtxHrfLc7FXQgH6ZwRY4HLxx5a5sMC3GIgMpdufd7bnREOpuUv/ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wyJhcx75; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wyJhcx75"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C6A8C4CEF8;
	Thu, 27 Nov 2025 14:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764254943;
	bh=/2Fk9yQpjHRenTt8pTRlDTITM9bW9R6LtnEJWAabv+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wyJhcx75SfziI1yq2f+tbc5wldUCpLzuSxeFJpRL36V2E4xTcKitgfDrrveqy7pA8
	 rGoltVuxSmm5h+OvzqiTKCqgmLoExgB3t7kVybUW3rh5oKVJ4px3zPF7k1ueVueL/8
	 ZwMGwAe72tCdF4hlfUVacKZ+SZcrdc5g1fjXM4pM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 40/86] pinctrl: cirrus: Fix fwnode leak in cs42l43_pin_probe()
Date: Thu, 27 Nov 2025 15:45:56 +0100
Message-ID: <20251127144029.293245190@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144027.800761504@linuxfoundation.org>
References: <20251127144027.800761504@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 9b07cdf86a0b90556f5b68a6b20b35833b558df3 ]

The driver calls fwnode_get_named_child_node() which takes a reference
on the child node, but never releases it, which causes a reference leak.

Fix by using devm_add_action_or_reset() to automatically release the
reference when the device is removed.

Fixes: d5282a539297 ("pinctrl: cs42l43: Add support for the cs42l43")
Suggested-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/cirrus/pinctrl-cs42l43.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/cirrus/pinctrl-cs42l43.c b/drivers/pinctrl/cirrus/pinctrl-cs42l43.c
index c096463184195..e1ac89be7c847 100644
--- a/drivers/pinctrl/cirrus/pinctrl-cs42l43.c
+++ b/drivers/pinctrl/cirrus/pinctrl-cs42l43.c
@@ -532,6 +532,11 @@ static int cs42l43_gpio_add_pin_ranges(struct gpio_chip *chip)
 	return ret;
 }
 
+static void cs42l43_fwnode_put(void *data)
+{
+	fwnode_handle_put(data);
+}
+
 static int cs42l43_pin_probe(struct platform_device *pdev)
 {
 	struct cs42l43 *cs42l43 = dev_get_drvdata(pdev->dev.parent);
@@ -563,10 +568,20 @@ static int cs42l43_pin_probe(struct platform_device *pdev)
 	priv->gpio_chip.ngpio = CS42L43_NUM_GPIOS;
 
 	if (is_of_node(fwnode)) {
-		fwnode = fwnode_get_named_child_node(fwnode, "pinctrl");
-
-		if (fwnode && !fwnode->dev)
-			fwnode->dev = priv->dev;
+		struct fwnode_handle *child;
+
+		child = fwnode_get_named_child_node(fwnode, "pinctrl");
+		if (child) {
+			ret = devm_add_action_or_reset(&pdev->dev,
+				cs42l43_fwnode_put, child);
+			if (ret) {
+				fwnode_handle_put(child);
+				return ret;
+			}
+			if (!child->dev)
+				child->dev = priv->dev;
+			fwnode = child;
+		}
 	}
 
 	priv->gpio_chip.fwnode = fwnode;
-- 
2.51.0



