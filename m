Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2523081AF;
	Wed,  3 Dec 2025 15:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776447; cv=none; b=uq08Z4nh8/scGZWYwzWLhxYJChWTef2hkcG4WHJRCXDmg+gEaibH7X1f5ZgcIiPGfZDx/qEGhNtaTZLaCQQEDL2kte1vIAKr3Vw03+x3R1VhIQZnN3xCesWBZFHwBHnEnOP9ZT70QKT+S1V+soRLXV/3yFdDYO3qJIb+GnIiD9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776447; c=relaxed/simple;
	bh=aZTNB4uN1FZTvF+odpv5bvczAu6NzRKNV5y6Puk+s34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I+X+myDmzRK+8f4gi4ZyL8ABJSWfVpkSxK5OpPNX1YgjYjgGLn1u799SmRlkcN2mgJjjPZAeZBzfgu9Noi8uoHtRGqTLe8oW+Xi6q82W77ckSaH5qrhbpKWRX6+Y7kWtEtHNyOJPTqDnuxVsj0gxsao+JhylQQKUkHopejFX31Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NZdXi16d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NZdXi16d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E220C4CEF5;
	Wed,  3 Dec 2025 15:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776447;
	bh=aZTNB4uN1FZTvF+odpv5bvczAu6NzRKNV5y6Puk+s34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NZdXi16ds21j2X2SgtnPYkvf9BWvsJig7EU5zB/lixbk6GFDpjb5TAXsyUMo/JFgq
	 ehyxLCE446onwIHso9RBizBMWqyvf7m0zI7WOxdQ5kH+iZvMMXXtOO+E9o0Bedf+Nc
	 XnAER7tLRgnLdbfllwMpcd8gWpbeTdLtckFYSNSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Buday Csaba <buday.csaba@prolan.hu>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 186/300] net: mdio: fix resource leak in mdiobus_register_device()
Date: Wed,  3 Dec 2025 16:26:30 +0100
Message-ID: <20251203152407.518369992@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d15deb3281edb..d7a65a5c855e5 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -80,8 +80,11 @@ int mdiobus_register_device(struct mdio_device *mdiodev)
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



