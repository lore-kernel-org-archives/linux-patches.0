Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E9C1684BE;
	Fri, 13 Feb 2026 13:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770991017; cv=none; b=LNIMuUkgj6KGA7QrXapiLKvsF+xL5ERScpaHtnzdj1PxciNTyPMamn2oUrOHvhtkSc54FNhFN3+ZOuTlgc1kvve8d2/864XXhPbKDgI6HDZ7Nyz39u1bug00Uj1TJ1bDVb8fbNPdzsIWkGgT/+azmChEckIuTNJcUWS6X6JNGYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770991017; c=relaxed/simple;
	bh=tY1ri1hvf/NUzuEql13jtPrqU7NfnscERObCqoHhIkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l5GEJGtxdx0twoVDXgCPb8OfAZGo4S2ca12X5Eck0eD3ohwNN7BCEqYjHyCSfiTbDH4mSdMPD7LEoEi+38IuwXqS+Q8/h+hu8ohFDYK9Xofe/14yX7j1T2wKwhpqdTrnnHaX1ETtbnDYFTKaiuX2X/NLvXq4UFZMYkekDPPVlEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a09lBGHq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a09lBGHq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C400C16AAE;
	Fri, 13 Feb 2026 13:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770991017;
	bh=tY1ri1hvf/NUzuEql13jtPrqU7NfnscERObCqoHhIkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a09lBGHqubZDUV7XqoLc/nmSH03xot1BSfZ0MCR2iymw549lCiK0O/wW0aDSjUwnw
	 TGaK/nEWFnzLWn/kPQP/Jf4DKUfIdHkIW8PoVVMcfoASBFkC8eGW6BwCo8U6ZONxbR
	 j5Z5lZC9ReXV0jVo+NsGygj5GRXSbgFeLYj+itsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 17/25] net: sfp: Fix quirk for Ubiquiti U-Fiber Instant SFP module
Date: Fri, 13 Feb 2026 14:48:43 +0100
Message-ID: <20260213134704.509590338@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213134703.882698935@linuxfoundation.org>
References: <20260213134703.882698935@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Behún <kabel@kernel.org>

commit adcbadfd8e05d3558c9cfaa783f17c645181165f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/sfp.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -431,6 +431,8 @@ static void sfp_quirk_ubnt_uf_instant(co
 	 */
 	linkmode_zero(modes);
 	linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseX_Full_BIT, modes);
+	phy_interface_zero(interfaces);
+	__set_bit(PHY_INTERFACE_MODE_1000BASEX, interfaces);
 }
 
 #define SFP_QUIRK(_v, _p, _m, _f) \


