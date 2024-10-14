Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4DD1A28C;
	Mon, 14 Oct 2024 14:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916541; cv=none; b=JidXdX60PXzqbLbTBnx+tH/Bq0qlDbAs1tMIjTwuyEEJ5VzlyyC83ATLglSIB5eR6Z0Y0g1e2Qa/6euU71ACtZ840eoTV4WuCgq1ro8eaBupCnyB1l9+Kw+46wzcL1lMV4jI2FP0LJgMY6Wbhhj/a1hfFSKlsAPxYd4oLGTbdoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916541; c=relaxed/simple;
	bh=4oaJUhaWp3AT3+kNeh1SbKYSTTkKnlPP+ZM/umlc0Bw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jeGQEvfTHKXe/PKYbauORk7cwMTerWqtVySyMFLO91BlsWMHLBAsTx0VQMsM0y33qFja3LxhK9mkmkcHyGMdJfkOfc2BkbJw/aYZjGd10c5zeJiSCMSGieLmdHkLLwKnexf4dS4XznWxPfptkXP/gim6m7DJ4vx4HVaWcaS6Ua8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A8PUp0mc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A8PUp0mc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04A8FC4CEC3;
	Mon, 14 Oct 2024 14:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916541;
	bh=4oaJUhaWp3AT3+kNeh1SbKYSTTkKnlPP+ZM/umlc0Bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A8PUp0mcHGDcsMrYVAW8PyRNv2OhPiniRCaTlEWarAsKE9bDIEgbyBrxgYTFbLJbV
	 Oj5DtDwCsAAFNpuXVdGAFW1KRnDoQSD3KSgE/rfyuxG27XNe4HKpTfF+H7AquiMcqK
	 TQ/w09DrJGSbkwNnsQ0CmGWG9iq46HcziH+GJWTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.11 195/214] net: phy: Remove LED entry from LEDs list on unregister
Date: Mon, 14 Oct 2024 16:20:58 +0200
Message-ID: <20241014141052.586390479@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3249,10 +3249,11 @@ static __maybe_unused int phy_led_hw_is_
 
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
 


