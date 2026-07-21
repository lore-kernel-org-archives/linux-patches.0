Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1094B46D2B9;
	Tue, 21 Jul 2026 17:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653990; cv=none; b=FIEBdAMFiKoUVSv5T2KFekWp9MpquNsWB5bitXEEFTgYM94gaM0bsopGP3z6hrQcZnZcFrbzROPsgg6MAExSOOfWFAqr0rztxFMMxXbrItdMy63433vfjOBNnRdjdkpS5XJgfo9jEJ+Q2tJLuBgoXgrbv1dECIF4sNZcDYDMkHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653990; c=relaxed/simple;
	bh=0kCuKGqTjlt1t6YnKkjRTfROophxZ4ZPgvAXBeRayrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u3gSd03fbDgOzWVO4P6b2w2mi++IwxqMXO32zQ1IL4zHe6AAD4UzY6I+nbASVwrRvCuVpIJJYOflG5r9ECaQgy0CFiRKtcijdT1kz9WO1X2/fNWU40uRltqz34B1xvV1hoG/TpYtCFKxec/lyryy6d/KqZt1ap7kYSOhuust24M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SavVUahM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SavVUahM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75AA41F000E9;
	Tue, 21 Jul 2026 17:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653989;
	bh=hiEwih0c1C4GBE1tXZ9+V2ny7lYir5kdE+7fEZYEvFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SavVUahMt3Ovbq9oBI4a3bna0VgjzqWzrWARtS/564F9eEXJ76yaWf/Mu9qtZxQI3
	 sQaHX2ffYFVEP3KZExdE4nilgnQslWdfZkVKyPclfkxODEHOQW6YTl/YxXMTMzw2gl
	 Qxr+wOsO9RCmCWkl76SM1MtYHZmtGs3W9OiEWXJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 7.1 1536/2077] arm64: dts: rockchip: fix Ethernet PHY not found on PX30 Ringneck
Date: Tue, 21 Jul 2026 17:20:09 +0200
Message-ID: <20260721152629.004787760@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quentin Schulz <quentin.schulz@cherry.de>

commit ae653cb854f36d1555681ce70ca3d80d0ec73516 upstream.

When not passing the PHY ID with an ethernet-phy-idX.Y compatible
property, the MDIO bus will attempt to auto-detect the PHY by reading
its registers and then probing the appropriate driver. For this to work,
the PHY needs to be in a working state.

Unfortunately, the net subsystem doesn't control the PHY reset GPIO when
attempting to auto-detect the PHY. This means the PHY needs to be in a
working state when entering the Linux kernel. This historically has been
the case for this device, but only because the bootloader was taking
care of initializing the Ethernet controller even when not using it.
We're attempting to support the removal of the network stack in the
bootloader, which means the Linux kernel will be entered with the PHY
still in reset and now Ethernet doesn't work anymore.

The devices in the field only ever had a TI DP83825, so let's simply
bypass the auto-detection mechanism entirely by passing the appropriate
PHY IDs via the compatible.

Note that this is only an issue since commit e463625af7f9 ("arm64: dts:
rockchip: move reset to dedicated eth-phy node on ringneck") as before
that commit the reset was done by the MAC controller before starting the
MDIO auto-detection mechanism, via the snps,reset-* properties.

Cc: stable@vger.kernel.org
Fixes: e463625af7f9 ("arm64: dts: rockchip: move reset to dedicated eth-phy node on ringneck")
Signed-off-by: Quentin Schulz <quentin.schulz@cherry.de>
Link: https://patch.msgid.link/20260421-px30-eth-phy-v2-2-68c375b120fd@cherry.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/px30-ringneck.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/rockchip/px30-ringneck.dtsi
+++ b/arch/arm64/boot/dts/rockchip/px30-ringneck.dtsi
@@ -344,7 +344,7 @@
 
 &mdio {
 	dp83825: ethernet-phy@0 {
-		compatible = "ethernet-phy-ieee802.3-c22";
+		compatible = "ethernet-phy-id2000.a140";
 		reg = <0x0>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&phy_rst>;


