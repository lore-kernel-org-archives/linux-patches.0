Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2228442B21;
	Mon, 17 Aug 2026 14:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976182; cv=none; b=BhpYgA13QNpum2w0KASj8u72cBd+Aqn+zAozCOxO6Ax8QfuzWrbQ26xTvR1FMAB1yJInV2Wxsjba15IxwmULr4A4Cn8uu76SniRVSY8yHBSvz1MxaoZyJrJBjH9Hm0EoxUkV1tWSsyNPayebaqlWk63cJdvo6v0SRaIPvEnf7zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976182; c=relaxed/simple;
	bh=cZy7OUHlQD2qZur7gvKx9FIuXw7t/w5RHX5X8ZXhiBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cAlabS8+i3FWRksDwlUE/aDw6QJuG70SUccERyFMlrKXL5XkNyK8HEWqEjaeXqWVeCo8PLBgQF7KGGzLt2KzKlAfUJIGSP5R6kvp6hUI/IXIvMI/vUJWkKDepVxp5LaHmjKmPecGknEtBRuWSV99zxD+tE7cP87aC3OCWBUnDnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yAk4T7Dz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yAk4T7Dz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17B0D1F00A3A;
	Mon, 17 Aug 2026 14:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976181;
	bh=2QSDEsdHKKfnj7fp6456jCSZcfF9TPayg7MvCuWPlaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yAk4T7Dz0cIQcJ49tBlCK/YaAokIPszccgEsSiyOz+jEiIKEwfEEkqmM+sU6B3vOY
	 7n6q6IQFDLFmzZYxs7zCCtaNl70Il/M62Tt4fFfh+DsQPS1YVaSwksunQrTPJ7Wd49
	 X5TnsRIZ2utN6Zi3RR2B96K+OX3HwwOF8JqW0sFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nava kishore Manne <nava.kishore.manne@amd.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Michal Simek <michal.simek@amd.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.10 286/389] phy: zynqmp: use read-modify-write for SERDES scrambler bypass
Date: Mon, 17 Aug 2026 15:32:05 +0200
Message-ID: <20260817132550.263779207@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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
@@ -413,8 +413,12 @@ static void xpsgtr_lane_set_protocol(str
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


