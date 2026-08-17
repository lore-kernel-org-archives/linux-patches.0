Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F147D43E9C4;
	Mon, 17 Aug 2026 15:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980064; cv=none; b=G4wAcNDcmydfWdc2vlykGWwlTxgVmA0oz8dp+3oOMAWzrx+Ic46HGtYIXwVpNJEaXyUgRoGv48RHaAGR4DwpSVFF+SkwDkV2l2keDwhJFS7EUfyH/SFlpDvuvm4AAyLfa3zCdsyHInnnhZU87fS2CbVOfm7SRY+Zv4iLWFobkGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980064; c=relaxed/simple;
	bh=svl92ASHKdFsyCF1FaWOx9MrgjkhnfAqHiHq1uVhgK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k1AsXNxY9Pt4l9/IP7n3H0AAdQcAoegJm0EVBW2HJ0eiNbPL50erbInRSf4nMRL5hCaIlDgKrTS8oyuhatBnJXgI+Kq9MuoEuBYs9V3cwM5ce3Wg9Eu3ci/GPvYa9gwpb+KD0zd/Rea8zA6f6qIsLYMAaEjdkvAUx935pfMjHkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jbz+Ve/j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jbz+Ve/j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AAB01F00A3E;
	Mon, 17 Aug 2026 15:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980062;
	bh=ii5HBH/VsBpSxZMmmdsko51JaiSls1TbtHREu9xGm78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jbz+Ve/j1LUyovJYyOZDhh8mtkAqy8hd6obN8FSeZOgfCrDgEYN1H0z2pGglD0qG+
	 m0hgCpZtNmSLOEJ3LEKQlhLtX8NLkDhgnpH0S7TKIN8Ycrr0J1hqJzc2xtSSSIWq/6
	 f1AvSoIqw0iCa8LDCsSPOvaUk2zJ5f6Il7vTsTJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nava kishore Manne <nava.kishore.manne@amd.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Michal Simek <michal.simek@amd.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 441/609] phy: zynqmp: use read-modify-write for SERDES scrambler bypass
Date: Mon, 17 Aug 2026 15:32:17 +0200
Message-ID: <20260817132558.852546239@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nava kishore Manne <nava.kishore.manne@amd.com>

commit 21e0749f931702765b9d52d05740092bc87fcd8d upstream.

xpsgtr_bypass_scrambler_8b10b() used xpsgtr_write_phy() which performs
a full register write, silently clearing any bits beyond the intended
bypass control fields.

Switch to xpsgtr_clr_set_phy() with clr=mask, set=mask to set only
the bypass bits while preserving the remaining bits in each register.

Fixes: 4a33bea00314 ("phy: zynqmp: Add PHY driver for the Xilinx ZynqMP Gigabit Transceiver")
Cc: stable@vger.kernel.org
Signed-off-by: Nava kishore Manne <nava.kishore.manne@amd.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Acked-by: Michal Simek <michal.simek@amd.com>
Link: https://patch.msgid.link/20260627155229.2791113-3-radhey.shyam.pandey@amd.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/xilinx/phy-zynqmp.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/phy/xilinx/phy-zynqmp.c
+++ b/drivers/phy/xilinx/phy-zynqmp.c
@@ -491,8 +491,12 @@ static void xpsgtr_lane_set_protocol(str
 /* Bypass (de)scrambler and 8b/10b decoder and encoder. */
 static void xpsgtr_bypass_scrambler_8b10b(struct xpsgtr_phy *gtr_phy)
 {
-	xpsgtr_write_phy(gtr_phy, L0_TM_DIG_6, L0_TM_DIS_DESCRAMBLE_DECODER);
-	xpsgtr_write_phy(gtr_phy, L0_TX_DIG_61, L0_TM_DISABLE_SCRAMBLE_ENCODER);
+	xpsgtr_clr_set_phy(gtr_phy, L0_TM_DIG_6,
+			   L0_TM_DIS_DESCRAMBLE_DECODER,
+			   L0_TM_DIS_DESCRAMBLE_DECODER);
+	xpsgtr_clr_set_phy(gtr_phy, L0_TX_DIG_61,
+			   L0_TM_DISABLE_SCRAMBLE_ENCODER,
+			   L0_TM_DISABLE_SCRAMBLE_ENCODER);
 }
 
 /* DP-specific initialization. */


