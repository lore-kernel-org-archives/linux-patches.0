Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB502FF163;
	Tue, 12 Aug 2025 18:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024936; cv=none; b=ra4/OqBGJ17K0PoPVma67Wa2opNSDOwiMkiPho4EMa+rOt/lmxOWcFU/YLBRpgVObif2ClO3dzv0/X/s+VHcwEMPCaDX+ZVju+yIB2ZgzccMVO5O7EMPVLLuzZ497T9yo8AFntFo0xzU+1J4Inb6QCRrYH6pzuUrZXI02Wj5D1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024936; c=relaxed/simple;
	bh=sB2q+n3YHqAXg9SdOCsEEwZomLIOFnFJvU7hZVacqWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PHFSMdKJFOsNzxm0pmm7o0TrsAJMHuqbD/0A0tE62ExSwHpeLsy/UM6w1iqHg7IaPUWgl5Me24Tmr/Mv/bNSssWKMeenVVgsl7AZD1WehVdE68+Zbg1Dr6kouz8KfAZZcWMBwaGexJpUZc80oj17nP3PZhawzdPNcepBMPlvmvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X7nbf98d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X7nbf98d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 390FCC4CEF0;
	Tue, 12 Aug 2025 18:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024936;
	bh=sB2q+n3YHqAXg9SdOCsEEwZomLIOFnFJvU7hZVacqWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X7nbf98djVybZIKTq6jkonCXd0TSvP7LTTQXHOmIXU+ME3RKdt8MdhnmptCry5SMK
	 LLzv0Qcbe1Goq+I1nncWBs0NXEcL3bflRcUlkhj8quJl5/2bMFWkjKUy/Q3hodny9N
	 MxwZRG8O5f8mF2z4v3n2dxwqvOp+MZXmZbnox8is=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Csaba Buday <buday.csaba@prolan.hu>,
	=?UTF-8?q?Bence=20Cs=C3=B3k=C3=A1s?= <csokas.bence@prolan.hu>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 519/627] net: mdio_bus: Use devm for getting reset GPIO
Date: Tue, 12 Aug 2025 19:33:34 +0200
Message-ID: <20250812173450.953470487@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bence Csókás <csokas.bence@prolan.hu>

[ Upstream commit 3b98c9352511db627b606477fc7944b2fa53a165 ]

Commit bafbdd527d56 ("phylib: Add device reset GPIO support") removed
devm_gpiod_get_optional() in favor of the non-devres managed
fwnode_get_named_gpiod(). When it was kind-of reverted by commit
40ba6a12a548 ("net: mdio: switch to using gpiod_get_optional()"), the devm
functionality was not reinstated. Nor was the GPIO unclaimed on device
remove. This leads to the GPIO being claimed indefinitely, even when the
device and/or the driver gets removed.

Fixes: bafbdd527d56 ("phylib: Add device reset GPIO support")
Fixes: 40ba6a12a548 ("net: mdio: switch to using gpiod_get_optional()")
Cc: Csaba Buday <buday.csaba@prolan.hu>
Signed-off-by: Bence Csókás <csokas.bence@prolan.hu>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250728153455.47190-2-csokas.bence@prolan.hu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mdio_bus.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index fda2e27c1810..24bdab5bdd24 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -36,8 +36,8 @@
 static int mdiobus_register_gpiod(struct mdio_device *mdiodev)
 {
 	/* Deassert the optional reset signal */
-	mdiodev->reset_gpio = gpiod_get_optional(&mdiodev->dev,
-						 "reset", GPIOD_OUT_LOW);
+	mdiodev->reset_gpio = devm_gpiod_get_optional(&mdiodev->dev,
+						      "reset", GPIOD_OUT_LOW);
 	if (IS_ERR(mdiodev->reset_gpio))
 		return PTR_ERR(mdiodev->reset_gpio);
 
-- 
2.39.5



