Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F2031578E;
	Fri, 21 Nov 2025 13:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731038; cv=none; b=IcYnQx+X49zQHnu3FCsyoOH8kkoAzvGEpL086W/fSkmihhax9SNsfhYOj86AqTQIZg9PFui30jl/Jit59HRNdILbTj3PMQR1rWgi4RCKf9v3K/xOyHvejtjtCsI3uNxEVn/UKbcWDCZn8WjeSxCs5xXtRG8jWTbVvGLkVIkk3QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731038; c=relaxed/simple;
	bh=idiyVHOyysQM/pqpsd7edGxETlaJyKbktDYuHk89+8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BAyy7WzXOWi2yKUe3RZ5Sxj4eoRX88NO1I6q3OmHEZLJaxxBc7Z4EYbbSnPzsnDdqhmZjAJb7400VNfN2YnNsanpbEuL4oSHBa+CjLngIeuisS6z0XT6Q/W0dfVe2eaDTlJqy2mY3t9sAQdd2RHlJDT62fANQ2dcQhleix0SSIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pmwpK4hd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pmwpK4hd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29415C4CEF1;
	Fri, 21 Nov 2025 13:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731037;
	bh=idiyVHOyysQM/pqpsd7edGxETlaJyKbktDYuHk89+8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pmwpK4hdXG79wLhLzMw7wvqtWY1qAlT8AKiSHDg2QZCajQz0LH2qwrkbguo4ayuhJ
	 7TtMIIvLYs2LWkcqs3cVtQ09zoVuGlQ7+adLmjUb002feRN+cMKjV8/ngBTZiWFI18
	 hMrGPTmCcEXZwWy0BZwPsXFiDDzKQt2ifsECAdTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Buday Csaba <buday.csaba@prolan.hu>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 068/247] net: mdio: fix resource leak in mdiobus_register_device()
Date: Fri, 21 Nov 2025 14:10:15 +0100
Message-ID: <20251121130157.042206201@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

From: Buday Csaba <buday.csaba@prolan.hu>

[ Upstream commit e6ca8f533ed41129fcf052297718f417f021cc7d ]

Fix a possible leak in mdiobus_register_device() when both a
reset-gpio and a reset-controller are present.
Clean up the already claimed reset-gpio, when the registration of
the reset-controller fails, so when an error code is returned, the
device retains its state before the registration attempt.

Link: https://lore.kernel.org/all/20251106144603.39053c81@kernel.org/
Fixes: 71dd6c0dff51 ("net: phy: add support for reset-controller")
Signed-off-by: Buday Csaba <buday.csaba@prolan.hu>
Link: https://patch.msgid.link/4b419377f8dd7d2f63f919d0f74a336c734f8fff.1762584481.git.buday.csaba@prolan.hu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mdio_bus.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index cad6ed3aa10b6..4354241137d50 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -73,8 +73,11 @@ int mdiobus_register_device(struct mdio_device *mdiodev)
 			return err;
 
 		err = mdiobus_register_reset(mdiodev);
-		if (err)
+		if (err) {
+			gpiod_put(mdiodev->reset_gpio);
+			mdiodev->reset_gpio = NULL;
 			return err;
+		}
 
 		/* Assert the reset signal */
 		mdio_device_reset(mdiodev, 1);
-- 
2.51.0



