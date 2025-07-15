Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C672E3AEA;
	Tue, 15 Jul 2025 13:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586846; cv=none; b=P8vyQDXt24IbXr87ZgULshZAytuu9nDkihU7fF7LcsrdRz7jQ+F8aN6Np10g0Yd2/R3V/9a54W0BRTlRcsZbDCb6NLYwc4l3lT16ffKugT0sHZgfZ7ndqVUlY5D2inlIS+Xpq5/fI3sQztbOnTsjHYsCaIYk+2J9VDbGl57AFgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586846; c=relaxed/simple;
	bh=Nezzx/sc24y28zKcF6HAMmx3m1kH3qt3ddPDAG2oWng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CPH2Y+A19tdm+ac42MAs+LpTwM0UHtgW6kKs6zvpRCMDLkZDhh1UEhYAu844lV6pIREXrSpVI74ya/TEBcMY3iVyTxMO9XbAXCkd3dataQQGEho0em5VBeVW+Usy+/RN9zAw60wd6IMpV0cZFi2mq6KKarP00ycX5w41qShNDgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RDBlps2G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RDBlps2G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DB72C4CEE3;
	Tue, 15 Jul 2025 13:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586846;
	bh=Nezzx/sc24y28zKcF6HAMmx3m1kH3qt3ddPDAG2oWng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RDBlps2G9mGma5mdRplrG/LfDlQmOyWk23uCU7ihi69IUwYW918YrtGlRCRzF+qzq
	 P0iwRjJIuzbRutWrkpqMJ5UJcxp+3EQqDRUeYB8EtazfJqtw2WOyOAAoG5ktz2WItO
	 8h47preporZmmj1AQCrrWLOZEhzubfz2bs2gkawQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.15 071/192] pinctrl: nuvoton: Fix boot on ma35dx platforms
Date: Tue, 15 Jul 2025 15:12:46 +0200
Message-ID: <20250715130817.785763851@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit 46147490b4098e200b7d7d3ac4637a3e4f7b806a upstream.

As part of a wider cleanup trying to get rid of OF specific APIs, an
incorrect (and partially unrelated) cleanup was introduced.

The goal was to replace a device_for_each_chil_node() loop including an
additional condition inside by a macro doing both the loop and the
check on a single line.

The snippet:

	device_for_each_child_node(dev, child)
		if (fwnode_property_present(child, "gpio-controller"))
			continue;

was replaced by:

	for_each_gpiochip_node(dev, child)

which expands into:

	device_for_each_child_node(dev, child)
		for_each_if(fwnode_property_present(child, "gpio-controller"))

This change is actually doing the opposite of what was initially
expected, breaking the probe of this driver, breaking at the same time
the whole boot of Nuvoton platforms (no more console, the kernel WARN()).

Revert these two changes to roll back to the correct behavior.

Fixes: 693c9ecd8326 ("pinctrl: nuvoton: Reduce use of OF-specific APIs")
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/20250613181312.1269794-1-miquel.raynal@bootlin.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/nuvoton/pinctrl-ma35.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/nuvoton/pinctrl-ma35.c b/drivers/pinctrl/nuvoton/pinctrl-ma35.c
index 06ae1fe8b8c5..b51704bafd81 100644
--- a/drivers/pinctrl/nuvoton/pinctrl-ma35.c
+++ b/drivers/pinctrl/nuvoton/pinctrl-ma35.c
@@ -1074,7 +1074,10 @@ static int ma35_pinctrl_probe_dt(struct platform_device *pdev, struct ma35_pinct
 	u32 idx = 0;
 	int ret;
 
-	for_each_gpiochip_node(dev, child) {
+	device_for_each_child_node(dev, child) {
+		if (fwnode_property_present(child, "gpio-controller"))
+			continue;
+
 		npctl->nfunctions++;
 		npctl->ngroups += of_get_child_count(to_of_node(child));
 	}
@@ -1092,7 +1095,10 @@ static int ma35_pinctrl_probe_dt(struct platform_device *pdev, struct ma35_pinct
 	if (!npctl->groups)
 		return -ENOMEM;
 
-	for_each_gpiochip_node(dev, child) {
+	device_for_each_child_node(dev, child) {
+		if (fwnode_property_present(child, "gpio-controller"))
+			continue;
+
 		ret = ma35_pinctrl_parse_functions(child, npctl, idx++);
 		if (ret) {
 			fwnode_handle_put(child);
-- 
2.50.1



