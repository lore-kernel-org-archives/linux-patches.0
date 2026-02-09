Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E1837E31E;
	Mon,  9 Feb 2026 14:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647994; cv=none; b=H0bvJz4xw14CIMLHwfr4rUjRhsQT08rY228ezobuGHo1iM5fgU3QHKqtWjRhiViVXcBNgfKofAZBjWjYtcZbw3C0iRvvHKNWB+Z9M/BuchaRi9UXTK7QKV/tvUQfVfXYfJE0fNd+ejqp+a+fBxzKWXQMt1ARIjlCrhEJjCwJ7Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647994; c=relaxed/simple;
	bh=oMdzd6zusunKkWAsNk14bPlXU+e+aNXQ5NL4MiIq4aI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RYTHBx5n9t7t9e8OOfOw+rgCvnlvXmK9reMyXoHOTXZkGCIxBUVbZZ6dqFFrM30nQfTHXw91bmdOdLOjirCf/nQHRhno/jnsgKzxXrBP9tcjmUZ2NfPyDtkc7a07Af+fsKPoze5l6DbZTzIZBcYERC6DukOwVaBvaYth47ajFHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lOAjSxqR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lOAjSxqR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28EFEC16AAE;
	Mon,  9 Feb 2026 14:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647994;
	bh=oMdzd6zusunKkWAsNk14bPlXU+e+aNXQ5NL4MiIq4aI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lOAjSxqR3l16dPnK2j4rP/TGq8meYvgBDr4zeXdouvEo6/N07HtiP+F5jl8cyqLE5
	 S+D4Mfzc+yS1WMed8+ET0i84LFtR1r/vGnZWGwTCXwo9ETuaLDPdXKr/7AypyG/8+0
	 2JED+6S3N3rQDht/EqosD+oLxmGp4wVJSrm8iN2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 089/113] net: sfp: Fix quirk for Ubiquiti U-Fiber Instant SFP module
Date: Mon,  9 Feb 2026 15:23:58 +0100
Message-ID: <20260209142313.381973048@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Behún <kabel@kernel.org>

[ Upstream commit adcbadfd8e05d3558c9cfaa783f17c645181165f ]

Commit fd580c9830316eda ("net: sfp: augment SFP parsing with
phy_interface_t bitmap") did not add augumentation for the interface
bitmap in the quirk for Ubiquiti U-Fiber Instant.

The subsequent commit f81fa96d8a6c7a77 ("net: phylink: use
phy_interface_t bitmaps for optical modules") then changed phylink code
for selection of SFP interface: instead of using link mode bitmap, the
interface bitmap is used, and the fastest interface mode supported by
both SFP module and MAC is chosen.

Since the interface bitmap contains also modes faster than 1000base-x,
this caused a regression wherein this module stopped working
out-of-the-box.

Fix this.

Fixes: fd580c9830316eda ("net: sfp: augment SFP parsing with phy_interface_t bitmap")
Signed-off-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://patch.msgid.link/20260129082227.17443-1-kabel@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/sfp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 05dd0cf093482..6153a35af1070 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -472,6 +472,8 @@ static void sfp_quirk_ubnt_uf_instant(const struct sfp_eeprom_id *id,
 	linkmode_zero(caps->link_modes);
 	linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseX_Full_BIT,
 			 caps->link_modes);
+	phy_interface_zero(caps->interfaces);
+	__set_bit(PHY_INTERFACE_MODE_1000BASEX, caps->interfaces);
 }
 
 #define SFP_QUIRK(_v, _p, _s, _f) \
-- 
2.51.0



