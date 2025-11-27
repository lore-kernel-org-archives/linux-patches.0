Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC54213254;
	Thu, 27 Nov 2025 15:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255725; cv=none; b=XTKfNeyOKtmIvf3OKsZpN5yuDE/Uv9Qs9sxAWkm092A9VaXktizG4UaVxymof8UEmIyOeGGuZyI3Jw2dBEd46y9SjP09v62R9x4dALRL101El6WHOvC02JWBsUvuPNXPQL3UaqJFHkXQFQUGSVtLtb7A4olpbzOIAU8ymZwDQL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255725; c=relaxed/simple;
	bh=bCRGyg2CifTtlB6VGDcTDQEkfwXcVHMzzR9q/RBKtoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K7fpCMHDMZzt/L03seGUywD0QkdvcAN8gHdXsnlAlmb6AFiEs/YojUKXUws93w3tGtUrNcVEsmyYRTc/M59STItXnK/KiZhjhOLGGCBk5g7xDG0dyqT8GCtpQGpUpRFfnUTGUt7aFzMMGkniorW1XWxyOHJMiEQQ4NrOAfB4EeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rk0Lrhe+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rk0Lrhe+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC1B6C113D0;
	Thu, 27 Nov 2025 15:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255725;
	bh=bCRGyg2CifTtlB6VGDcTDQEkfwXcVHMzzR9q/RBKtoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rk0Lrhe+d+gvZs+cy0QTWBQuVki52Ai3budB71LtDElGu20l1oy25dTnaXLbed4JE
	 g5W6EhVR85cisQ+Y6JFXv6sudhah+pHAHm5D2HDBI9cSHK8yImqrnX3M8bkmPNcywS
	 bSzE4bbhfbdDQFOwmZxVdj6MRozEaCkR3+jsvsKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 091/175] pinctrl: cirrus: Fix fwnode leak in cs42l43_pin_probe()
Date: Thu, 27 Nov 2025 15:45:44 +0100
Message-ID: <20251127144046.285860985@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 68abb6d6cecd8..a8f82104a3842 100644
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



