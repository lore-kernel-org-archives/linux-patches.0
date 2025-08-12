Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973982FABFC;
	Tue, 12 Aug 2025 18:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025017; cv=none; b=kUhkERVGaE6UEVVWyWs4Ray5fcWmFvOulhdh9DgB+5c/ezxsITllokGBWnLlHuMc5f2BMkDPC0jyqY+xLYKCWMMPtTTT+dtWapyd5mzWEEgvbsXH9LJJCkqpBrU0lVRkE6wuJUJJfSvvAqlveEK1cH04403maqRKbGA4+AKoviQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025017; c=relaxed/simple;
	bh=kaJJDdhQ873sp3RLo+GuW9modz9dA+jRnM+wldsj/+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q15NRjPL9AjQ2+A5KoCLacMIUIKHUClVRj4nvsyPsKeQl96iQyAQqFSRvJkUFsJIMqN0PAGgF30CfkY9eZOC3NPbGa0sBoIGu1PcaJDdAJmtFO6vmCW1izCd4/Dum89+wAel8ghrzNzqXV/Gc7rub8KeUgicHCgsoHMUMwMOOHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cslrzLf4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cslrzLf4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0990EC4CEF0;
	Tue, 12 Aug 2025 18:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025017;
	bh=kaJJDdhQ873sp3RLo+GuW9modz9dA+jRnM+wldsj/+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cslrzLf4xb256Nuo0vva5KhHciEQMCv79EB6BZ4aRBFAC3r4RtbhkTskmNmlHN/uA
	 e9XZaVJMwtMUMnH37lYWaMe2wPaz9BpAVH1jo12ZA54z50NIxBHt/0pKt1oem8YR8/
	 UpnEUa9dnpJ6sdSDMn+yTWdrxwi6dBijLLL1FCAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 545/627] Revert "net: mdio_bus: Use devm for getting reset GPIO"
Date: Tue, 12 Aug 2025 19:34:00 +0200
Message-ID: <20250812173452.639813226@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 175811b8f05f0da3e19b7d3124666649ddde3802 ]

This reverts commit 3b98c9352511db627b606477fc7944b2fa53a165.

Russell says:

  Using devm_*() [here] is completely wrong, because this is called
  from mdiobus_register_device(). This is not the probe function
  for the device, and thus there is no code to trigger the release of
  the resource on unregistration.

  Moreover, when the mdiodev is eventually probed, if the driver fails
  or the driver is unbound, the GPIO will be released, but a reference
  will be left behind.

  Using devm* with a struct device that is *not* currently being probed
  is fundamentally wrong - an abuse of devm.

Reported-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/95449490-fa58-41d4-9493-c9213c1f2e7d@sirena.org.uk
Suggested-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Fixes: 3b98c9352511 ("net: mdio_bus: Use devm for getting reset GPIO")
Link: https://patch.msgid.link/20250801212742.2607149-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mdio_bus.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 24bdab5bdd24..fda2e27c1810 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -36,8 +36,8 @@
 static int mdiobus_register_gpiod(struct mdio_device *mdiodev)
 {
 	/* Deassert the optional reset signal */
-	mdiodev->reset_gpio = devm_gpiod_get_optional(&mdiodev->dev,
-						      "reset", GPIOD_OUT_LOW);
+	mdiodev->reset_gpio = gpiod_get_optional(&mdiodev->dev,
+						 "reset", GPIOD_OUT_LOW);
 	if (IS_ERR(mdiodev->reset_gpio))
 		return PTR_ERR(mdiodev->reset_gpio);
 
-- 
2.39.5



