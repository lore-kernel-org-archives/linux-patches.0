Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4EF3284B3B;
	Tue, 17 Feb 2026 20:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361145; cv=none; b=ZID1sDxXb+ymphx61Ktj1yy88AySN4YsUidQwS6nR69Xe5ZEm0eObeP+rAnfn0oUxuQZ/2pWHfCjuMAfNeauK7rOlhdrPU+Fr6jeATq5WzX2uBEqTSdtC7nR4CrMv3GgT2Tk5Z7JVvAYN2GEb98BqTUxFJM1bMnwG2ELaj0kKMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361145; c=relaxed/simple;
	bh=vBIqItv0LQI6d3sBtaO14p+q9nKxwVrA8s8vZ15QtVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AgfhUI/GiW/HaVMUW3CJW9YpfE/lPUW7jzjA1DRqibIxD2QR+lozSiQlGAHkZDW8o9dOBzLQa1wHGv2M+Y2FgRzwUzvnKJ2h0RrdUOXfDMS997m2x3lGRXd9CwxGdvu8Uq8dkh1HTrJ8ksyUvE/Dc8q8vDxWlxG7Y87+slMPvks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KVUIExbl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KVUIExbl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D04C2C4CEF7;
	Tue, 17 Feb 2026 20:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361145;
	bh=vBIqItv0LQI6d3sBtaO14p+q9nKxwVrA8s8vZ15QtVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KVUIExbl+gF8DryoyC5gRKLziZnPOyVRfLtvYd8qzCuPMXrO4Vyatei9dZyPb+l3V
	 qYmVtEZWDKt4MFiVHNZXHs5Nb9gnHmoq1DN+nUmE+Ad7L3kab2N8EDaVi+HZYJhXw7
	 Dri2OVIFRlUDKuPm9b/HSqOlMmf7CYewsTZKgCj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 15/64] net: sfp: Fix quirk for Ubiquiti U-Fiber Instant SFP module
Date: Tue, 17 Feb 2026 21:31:11 +0100
Message-ID: <20260217200008.083778772@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200007.505931165@linuxfoundation.org>
References: <20260217200007.505931165@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -376,6 +376,8 @@ static void sfp_quirk_ubnt_uf_instant(co
 	 */
 	linkmode_zero(modes);
 	linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseX_Full_BIT, modes);
+	phy_interface_zero(interfaces);
+	__set_bit(PHY_INTERFACE_MODE_1000BASEX, interfaces);
 }
 
 #define SFP_QUIRK(_v, _p, _m, _f) \


