Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A41B54C97;
	Tue, 11 Nov 2025 00:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822564; cv=none; b=tX6K3ahiTj6d/MS3v75uvlVw5qIloK79GoZ2VuRo+mm2SU/0o8JZfk/cwpfHMOGasV91NLK0XobNCWPGzxvcWUOZP4nxTzU4EiulsvUN+paYssA6M954GwbYXAt/fN1hLjjsrrat1LSDV7K2WrgWsl/LrSXWzRMNOq76oAQGlco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822564; c=relaxed/simple;
	bh=Xz2FNJtVVFJ19lm/iLb5MNMnNcG0iOzh27qH4hEja6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=emWm2SvDMUO33HQFB0cek7Z1GuUaNkZrMLi0lVzMxlCQwRhWHIoI961cPDemHgBxdXMYP0OvKZQQZA+NIsOJeBLkm0IGkn2AQ4MN+ujuz8ftv08/MmYwtxp2kb9TwV0u045JBuM7WyeBxlXS03CQBFb11MB50OjwgScKvdemn0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iWmZSYqd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iWmZSYqd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C2A9C16AAE;
	Tue, 11 Nov 2025 00:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822564;
	bh=Xz2FNJtVVFJ19lm/iLb5MNMnNcG0iOzh27qH4hEja6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iWmZSYqdoS8+1efhNdpuOBlimZnxrlhMsylLbzA4ZpmIQtQkBowTnuPviYdsf3imc
	 M9cMNlTwyxPcbtVj28AJBKwSb59i/H/5NLvctpSPxkCNGoOu4sUMpLYFWa8TMDhftk
	 AmtX37ctP50sEmJD+vFi+8V2M3eNv+ULzr+H2LkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 075/565] net: phy: add phy_disable_eee
Date: Tue, 11 Nov 2025 09:38:51 +0900
Message-ID: <20251111004528.644972235@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit b55498ff14bd14860d48dc8d2a0b6889b218c408 ]

If a MAC driver doesn't support EEE, then the PHY shouldn't advertise it.
Add phy_disable_eee() for this purpose.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/fd51738c-dcd6-4d61-b8c5-faa6ac0f1026@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 84a905290cb4 ("net: phy: dp83867: Disable EEE support as not implemented")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/phy_device.c |   16 ++++++++++++++++
 include/linux/phy.h          |    1 +
 2 files changed, 17 insertions(+)

--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -3046,6 +3046,22 @@ void phy_support_eee(struct phy_device *
 EXPORT_SYMBOL(phy_support_eee);
 
 /**
+ * phy_disable_eee - Disable EEE for the PHY
+ * @phydev: Target phy_device struct
+ *
+ * This function is used by MAC drivers for MAC's which don't support EEE.
+ * It disables EEE on the PHY layer.
+ */
+void phy_disable_eee(struct phy_device *phydev)
+{
+	linkmode_zero(phydev->supported_eee);
+	linkmode_zero(phydev->advertising_eee);
+	phydev->eee_cfg.tx_lpi_enabled = false;
+	phydev->eee_cfg.eee_enabled = false;
+}
+EXPORT_SYMBOL_GPL(phy_disable_eee);
+
+/**
  * phy_support_sym_pause - Enable support of symmetrical pause
  * @phydev: target phy_device struct
  *
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -2030,6 +2030,7 @@ void phy_advertise_eee_all(struct phy_de
 void phy_support_sym_pause(struct phy_device *phydev);
 void phy_support_asym_pause(struct phy_device *phydev);
 void phy_support_eee(struct phy_device *phydev);
+void phy_disable_eee(struct phy_device *phydev);
 void phy_set_sym_pause(struct phy_device *phydev, bool rx, bool tx,
 		       bool autoneg);
 void phy_set_asym_pause(struct phy_device *phydev, bool rx, bool tx);


