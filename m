Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80FFB2550DD;
	Mon,  1 Dec 2025 11:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588695; cv=none; b=SgPGAviX0buA2dtcGJFIE/cROO/uQS79WBk5S8jW/K0OzT5aOh6fJLV1fRFRm4J+raoBjPL6tOeUvL+JGuTZXTpcCx6e9r+wNdzUWYokpImOFbKyqztX4+Q8g8yTlomJ+nC1d/yLuKMwbk+48+YD2KqlfyCEfsEGoHcb6yMa28g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588695; c=relaxed/simple;
	bh=7d/JbfFcwZpUQNTLbrcMABwE8Ge4XTv3wQXicOpBI9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nn+C4/p0OGqawitT3QWbfkAelTjNvY3gKQrog6nizdymuAr9r5YkvHXY4byrBOTAvKjBRC4IP1TgV5f4vW8AENeycPsp6yb69W2hj0BXCU+J/cnqGWZRtuhdWQ/e0r54D8uoYqYWR2HTzOXlyvtZGW1NmU0hw6CDLv2+0fVMSTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0lv+LIZk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0lv+LIZk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04AB8C19421;
	Mon,  1 Dec 2025 11:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588695;
	bh=7d/JbfFcwZpUQNTLbrcMABwE8Ge4XTv3wQXicOpBI9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0lv+LIZkKh/5Ga1kY5wR3Abr34b1Kr6bmV9qjWn94Dxu1/xPmvdGvOTFfPjqPXbau
	 ySnZ5lswPiLkQEMcT1LMuIGdyNRHrjEa0les6al3I9DiD3EeyLrQmL7uIoxeU2vgPL
	 RyTP2sdAHmdlp5ZruEm9qASw0QxdkbL+RBirkyek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Buday Csaba <buday.csaba@prolan.hu>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 138/187] net: mdio: fix resource leak in mdiobus_register_device()
Date: Mon,  1 Dec 2025 12:24:06 +0100
Message-ID: <20251201112246.209350878@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 931b9a6c5dc50..bdce184759eff 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -89,8 +89,11 @@ int mdiobus_register_device(struct mdio_device *mdiodev)
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



