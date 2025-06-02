Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06579221299;
	Mon,  2 Jun 2025 14:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873809; cv=none; b=Dbrhn7/Ds9NHUOhUcEUstCXytNvdy+M13JTyB9f3FeK4LeOJz70C0El5hQwqZeExqHj26qmICydC9R8eNh99vJstcQf4ZCZvdH/SAeyj4dIV5iCeYjW6DV7EbbprgSAjTue9DJfi+dzDoywRp3RSdL/LRYzxkYQ7UIM6FHdneDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873809; c=relaxed/simple;
	bh=kOSqluYLxH+Cwz9MWRrDkXOtYBj6vANutT4bKfNHX8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mJ3yR97hIiKLFxWonxB/D/9B+jB/GxPsw7JHI2+EKtbLyqJWe/ogD5o1AUBrmYBrWADOm6nfoNy/xWPhyTPJZMCg1f+3asTgMisyXDouWwu4i3BsQJkMVuFnCGwukJ88HKpZfir2Z3AMqUL13Gmj3teRRENs2X/gSiYFUXXyySQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MzfmVxg4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MzfmVxg4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2498EC4CEEB;
	Mon,  2 Jun 2025 14:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873808;
	bh=kOSqluYLxH+Cwz9MWRrDkXOtYBj6vANutT4bKfNHX8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MzfmVxg4PQJ22yKaMOPbwzRgxlI+g4RXjBo3jPup/aExbQqcSvPXtz79jM05LdeeO
	 FJJzAmmLfkdGraXpnxy/MaVfzmei+fEy05gaqN6/8bBsHt2EQzXP9a2T/NZtocb1Cb
	 UyDUrTDxeOiwMmSn9/JxG5X81NFYdXjufoZXcYLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Simon Horman <horms@kernel.org>,
	=?UTF-8?q?Cs=C3=B3k=C3=A1s,
	=20Bence?= <csokas.bence@prolan.hu>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 259/444] net: fec: Refactor MAC reset to function
Date: Mon,  2 Jun 2025 15:45:23 +0200
Message-ID: <20250602134351.439950463@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Csókás, Bence <csokas.bence@prolan.hu>

[ Upstream commit 67800d296191d0a9bde0a7776f99ca1ddfa0fc26 ]

The core is reset both in `fec_restart()` (called on link-up) and
`fec_stop()` (going to sleep, driver remove etc.). These two functions
had their separate implementations, which was at first only a register
write and a `udelay()` (and the accompanying block comment). However,
since then we got soft-reset (MAC disable) and Wake-on-LAN support, which
meant that these implementations diverged, often causing bugs.

For instance, as of now, `fec_stop()` does not check for
`FEC_QUIRK_NO_HARD_RESET`, meaning the MII/RMII mode is cleared on eg.
a PM power-down event; and `fec_restart()` missed the refactor renaming
the "magic" constant `1` to `FEC_ECR_RESET`.

To harmonize current implementations, and eliminate this source of
potential future bugs, refactor implementation to a common function.

Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Csókás, Bence <csokas.bence@prolan.hu>
Link: https://patch.msgid.link/20250207121255.161146-2-csokas.bence@prolan.hu
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 52 +++++++++++------------
 1 file changed, 25 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 7261838a09db6..291c88a76a27f 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1079,6 +1079,29 @@ static void fec_enet_enable_ring(struct net_device *ndev)
 	}
 }
 
+/* Whack a reset.  We should wait for this.
+ * For i.MX6SX SOC, enet use AXI bus, we use disable MAC
+ * instead of reset MAC itself.
+ */
+static void fec_ctrl_reset(struct fec_enet_private *fep, bool allow_wol)
+{
+	u32 val;
+
+	if (!allow_wol || !(fep->wol_flag & FEC_WOL_FLAG_SLEEP_ON)) {
+		if (fep->quirks & FEC_QUIRK_HAS_MULTI_QUEUES ||
+		    ((fep->quirks & FEC_QUIRK_NO_HARD_RESET) && fep->link)) {
+			writel(0, fep->hwp + FEC_ECNTRL);
+		} else {
+			writel(FEC_ECR_RESET, fep->hwp + FEC_ECNTRL);
+			udelay(10);
+		}
+	} else {
+		val = readl(fep->hwp + FEC_ECNTRL);
+		val |= (FEC_ECR_MAGICEN | FEC_ECR_SLEEP);
+		writel(val, fep->hwp + FEC_ECNTRL);
+	}
+}
+
 /*
  * This function is called to start or restart the FEC during a link
  * change, transmit timeout, or to reconfigure the FEC.  The network
@@ -1095,17 +1118,7 @@ fec_restart(struct net_device *ndev)
 	if (fep->bufdesc_ex)
 		fec_ptp_save_state(fep);
 
-	/* Whack a reset.  We should wait for this.
-	 * For i.MX6SX SOC, enet use AXI bus, we use disable MAC
-	 * instead of reset MAC itself.
-	 */
-	if (fep->quirks & FEC_QUIRK_HAS_MULTI_QUEUES ||
-	    ((fep->quirks & FEC_QUIRK_NO_HARD_RESET) && fep->link)) {
-		writel(0, fep->hwp + FEC_ECNTRL);
-	} else {
-		writel(1, fep->hwp + FEC_ECNTRL);
-		udelay(10);
-	}
+	fec_ctrl_reset(fep, false);
 
 	/*
 	 * enet-mac reset will reset mac address registers too,
@@ -1359,22 +1372,7 @@ fec_stop(struct net_device *ndev)
 	if (fep->bufdesc_ex)
 		fec_ptp_save_state(fep);
 
-	/* Whack a reset.  We should wait for this.
-	 * For i.MX6SX SOC, enet use AXI bus, we use disable MAC
-	 * instead of reset MAC itself.
-	 */
-	if (!(fep->wol_flag & FEC_WOL_FLAG_SLEEP_ON)) {
-		if (fep->quirks & FEC_QUIRK_HAS_MULTI_QUEUES) {
-			writel(0, fep->hwp + FEC_ECNTRL);
-		} else {
-			writel(FEC_ECR_RESET, fep->hwp + FEC_ECNTRL);
-			udelay(10);
-		}
-	} else {
-		val = readl(fep->hwp + FEC_ECNTRL);
-		val |= (FEC_ECR_MAGICEN | FEC_ECR_SLEEP);
-		writel(val, fep->hwp + FEC_ECNTRL);
-	}
+	fec_ctrl_reset(fep, true);
 	writel(fep->phy_speed, fep->hwp + FEC_MII_SPEED);
 	writel(FEC_DEFAULT_IMASK, fep->hwp + FEC_IMASK);
 
-- 
2.39.5



