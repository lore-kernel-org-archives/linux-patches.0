Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B94511187;
	Tue, 26 Aug 2025 12:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212555; cv=none; b=bJr/VMWv7CbHaFwcXO/XfxQlnL98JJN71B/l2ZwboKrjQjUqeZZlVDM01At8rycvdrOsEk4NY4s47qLfVqmZNoBEctFc0NoqMCzN+EHncxvD16eCAR+h7OSpIIveDR4ghCtetNSO10fIFolgUtMCUL1eTU7hb858v8Cc+0lAKBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212555; c=relaxed/simple;
	bh=H/bh5ClxfZmAIDZ/LnEtySpcpB1XnnH5IpSbGwbu6WA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iljr242FT1MslHTZQseyX8gh2tv8HsFNjdVu9lKV07ZI1vlCtKmxvlJ4QNhTYAm0gi7ynWRAeHOzde0z7ozhEPwvBDF6mffkI8QmT52tPNb88j/JXOld0Saxwf4+42WDpbVSbqPGCLw4KoWbYk7dn+utvKgkrrMMW0MhTuORZIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z/dGgsRe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z/dGgsRe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FB5BC4CEF1;
	Tue, 26 Aug 2025 12:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212553;
	bh=H/bh5ClxfZmAIDZ/LnEtySpcpB1XnnH5IpSbGwbu6WA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z/dGgsRetTieU7Ysyb6KELadG28sySd3OqYJIlEG7UnTOOcI1aJjkBgm4NpPZOJcQ
	 3gJ7SfRDNYe0wYI/Qby58TcEI/Um+2swhXQCQ6LQRVdRTvcn7Zr9Cdy6nF2MjuXm1+
	 Nn3vbFVaEXLxjIulwiqM+s9l+vKODrJN35Ii0cRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Larysch <fl@n621.de>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 014/587] net: phy: micrel: fix KSZ8081/KSZ8091 cable test
Date: Tue, 26 Aug 2025 13:02:43 +0200
Message-ID: <20250826110953.314394159@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Larysch <fl@n621.de>

commit 49db61c27c4bbd24364086dc0892bd3e14c1502e upstream.

Commit 21b688dabecb ("net: phy: micrel: Cable Diag feature for lan8814
phy") introduced cable_test support for the LAN8814 that reuses parts of
the KSZ886x logic and introduced the cable_diag_reg and pair_mask
parameters to account for differences between those chips.

However, it did not update the ksz8081_type struct, so those members are
now 0, causing no pairs to be tested in ksz886x_cable_test_get_status
and ksz886x_cable_test_wait_for_completion to poll the wrong register
for the affected PHYs (Basic Control/Reset, which is 0 in normal
operation) and exit immediately.

Fix this by setting both struct members accordingly.

Fixes: 21b688dabecb ("net: phy: micrel: Cable Diag feature for lan8814 phy")
Cc: stable@vger.kernel.org
Signed-off-by: Florian Larysch <fl@n621.de>
Link: https://patch.msgid.link/20250723222250.13960-1-fl@n621.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/micrel.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -372,6 +372,8 @@ static const struct kszphy_type ksz8051_
 
 static const struct kszphy_type ksz8081_type = {
 	.led_mode_reg		= MII_KSZPHY_CTRL_2,
+	.cable_diag_reg		= KSZ8081_LMD,
+	.pair_mask		= KSZPHY_WIRE_PAIR_MASK,
 	.has_broadcast_disable	= true,
 	.has_nand_tree_disable	= true,
 	.has_rmii_ref_clk_sel	= true,


