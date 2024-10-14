Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906321AAE38;
	Mon, 14 Oct 2024 14:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917261; cv=none; b=iQUJ2yPhNEPOr5x+h6Hq2BhvTqLjeg9ObcRVgdM5xlfgD/2j2dLuVExENZyKT18ywaQ73QkEqmrMua1RVQdRPPy+m2XepTsu3plCDbZ4sYmyor+UHNX6DLQQii7F/ZFw0S2koSoIIICE1K03oQz6tsjoK4pjl82BgNKQszfYlT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917261; c=relaxed/simple;
	bh=5Th43cCYoIe/c32yrT7odTRGBC+YIeEj6t1R00dS6dQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KRmw+BA7FO5bEZRIxK6k6yxdN/QVn4EpLgTEE5xNHbNH8/1GB4+QpM1eTMRikdKBq4ugoY2nuRH1St6ZUE3x3EkgD/vkMG2u2DW35BlWm9dLIL7IbxGMkx8uh5Ne/I14nE5hxbkOgZ/HFXEpc9+ReEcqPWmIJesnOlu5FBT2p6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XK+D1r98; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XK+D1r98"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F8F7C4CEC3;
	Mon, 14 Oct 2024 14:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917261;
	bh=5Th43cCYoIe/c32yrT7odTRGBC+YIeEj6t1R00dS6dQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XK+D1r98RbSUp454gmsvsbTdVMinv8ZOuSJ78BRvQDcO2G1XVBSRVN+dE1GEnv2do
	 OjmrXe/P8YbWS80oIJlx7/Y28wN+jH/bUbFnBQNqi7wFlgavRHytUQ87jXB8rMPgh8
	 x4GVe+qnfprmQiR7Yo7WGCITfS0qeStkAXOPFhjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 199/213] net: phy: Remove LED entry from LEDs list on unregister
Date: Mon, 14 Oct 2024 16:21:45 +0200
Message-ID: <20241014141050.727501538@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Marangi <ansuelsmth@gmail.com>

commit f50b5d74c68e551667e265123659b187a30fe3a5 upstream.

Commit c938ab4da0eb ("net: phy: Manual remove LEDs to ensure correct
ordering") correctly fixed a problem with using devm_ but missed
removing the LED entry from the LEDs list.

This cause kernel panic on specific scenario where the port for the PHY
is torn down and up and the kmod for the PHY is removed.

On setting the port down the first time, the assosiacted LEDs are
correctly unregistered. The associated kmod for the PHY is now removed.
The kmod is now added again and the port is now put up, the associated LED
are registered again.
On putting the port down again for the second time after these step, the
LED list now have 4 elements. With the first 2 already unregistered
previously and the 2 new one registered again.

This cause a kernel panic as the first 2 element should have been
removed.

Fix this by correctly removing the element when LED is unregistered.

Reported-by: Daniel Golle <daniel@makrotopia.org>
Tested-by: Daniel Golle <daniel@makrotopia.org>
Cc: stable@vger.kernel.org
Fixes: c938ab4da0eb ("net: phy: Manual remove LEDs to ensure correct ordering")
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20241004182759.14032-1-ansuelsmth@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/phy_device.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -3082,10 +3082,11 @@ static __maybe_unused int phy_led_hw_is_
 
 static void phy_leds_unregister(struct phy_device *phydev)
 {
-	struct phy_led *phyled;
+	struct phy_led *phyled, *tmp;
 
-	list_for_each_entry(phyled, &phydev->leds, list) {
+	list_for_each_entry_safe(phyled, tmp, &phydev->leds, list) {
 		led_classdev_unregister(&phyled->led_cdev);
+		list_del(&phyled->list);
 	}
 }
 


