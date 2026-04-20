Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19ACB3C8716;
	Mon, 20 Apr 2026 13:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691060; cv=none; b=XE04DgYKy85rjXPuRmCpQCMotlEs72LWGEDrD2y70fEY13ROFGddVeQoIyFQGjACQqWqzDrs8C+/PJTr7fU/c8lKig/w84e8N7UukI1T0hJaOvTj5z2Hp/X4lmuBVF74ln5wRQmfG3bBdu5M8JXngmt3Jbnq1ngIQc0NK/pBJ28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691060; c=relaxed/simple;
	bh=+8K6dHnVzrZ3DomlPVMPG7Wb4KyVTqjmF1fazeZMeGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TejDx0rUHMycNFyM7sxtH3RfaVd3s3l7gUQ8S6RPELSpT45oTyhkB6vOdLv5H0LDTxcRICiOKYuT0aGGeQJ7EPQaVRNlBSsC8GT3pjcSLm8SNPn+t+dJr2oIuO4yfyJaajrEX/nYT8GIFNI0gy33QE0dS7ltS1GVnt6qq7Y9K20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sJgr+/p6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sJgr+/p6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 947BDC2BCB6;
	Mon, 20 Apr 2026 13:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691060;
	bh=+8K6dHnVzrZ3DomlPVMPG7Wb4KyVTqjmF1fazeZMeGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sJgr+/p6TQMyjXnc8Sjc3q1MonT9+TIzuLO7R3VVoDpk71vzQMw5qfrfIsLUmz9iZ
	 n6qbrOOpL1Kz77IaYM3sieJ9Ak654M+3/0RRX0VFSbV94sX92xydUuLoGHn1Ml5fYO
	 wgqiTvFVbBi9lTuaVuGy+XgJIUINDPEydnPiehp+LqHm7GGcvFtz8rJLJGGIHGvPWi
	 30jGCrNtCSzNpzQFtwUJaPdPhaBck3IjaM0p6DU+ho3XQvdnGjZOipy87bdw0LDHhi
	 zLT3SjCVPIqx33/fbshbXhmJurxI5cODTvwq2E/GztJZ+4yoCX2rrAgPj/oWjzihWe
	 KurXtRr8fQjeA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: John Pavlick <jspavlick@posteo.net>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Marcin Nita <marcin.nita@leolabs.pl>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux@armlinux.org.uk,
	andrew@lunn.ch,
	hkallweit1@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] net: sfp: add quirks for Hisense and HSGQ GPON ONT SFP modules
Date: Mon, 20 Apr 2026 09:08:56 -0400
Message-ID: <20260420131539.986432-70-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420131539.986432-1-sashal@kernel.org>
References: <20260420131539.986432-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: John Pavlick <jspavlick@posteo.net>

[ Upstream commit 95aca8602ef70ffd3d971675751c81826e124f90 ]

Several GPON ONT SFP sticks based on Realtek RTL960x report
1000BASE-LX at 1300MBd in their EEPROM but can operate at 2500base-X.
On hosts capable of 2500base-X (e.g. Banana Pi R3 / MT7986), the
kernel negotiates only 1G because it trusts the incorrect EEPROM data.

Add quirks for:
- Hisense-Leox LXT-010S-H
- Hisense ZNID-GPON-2311NA
- HSGQ HSGQ-XPON-Stick

Each quirk advertises 2500base-X and ignores TX_FAULT during the
module's ~40s Linux boot time.

Tested on Banana Pi R3 (MT7986) with OpenWrt 25.12.1, confirmed
2.5Gbps link and full throughput with flow offloading.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Suggested-by: Marcin Nita <marcin.nita@leolabs.pl>
Signed-off-by: John Pavlick <jspavlick@posteo.net>
Link: https://patch.msgid.link/20260406132321.72563-1-jspavlick@posteo.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 drivers/net/phy/sfp.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 7a85b758fb1e6..c62e3f364ea73 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -543,6 +543,22 @@ static const struct sfp_quirk sfp_quirks[] = {
 	SFP_QUIRK("HUAWEI", "MA5671A", sfp_quirk_2500basex,
 		  sfp_fixup_ignore_tx_fault_and_los),
 
+	// Hisense LXT-010S-H is a GPON ONT SFP (sold as LEOX LXT-010S-H) that
+	// can operate at 2500base-X, but reports 1000BASE-LX / 1300MBd in its
+	// EEPROM
+	SFP_QUIRK("Hisense-Leox", "LXT-010S-H", sfp_quirk_2500basex,
+		  sfp_fixup_ignore_tx_fault),
+
+	// Hisense ZNID-GPON-2311NA can operate at 2500base-X, but reports
+	// 1000BASE-LX / 1300MBd in its EEPROM
+	SFP_QUIRK("Hisense", "ZNID-GPON-2311NA", sfp_quirk_2500basex,
+		  sfp_fixup_ignore_tx_fault),
+
+	// HSGQ HSGQ-XPON-Stick can operate at 2500base-X, but reports
+	// 1000BASE-LX / 1300MBd in its EEPROM
+	SFP_QUIRK("HSGQ", "HSGQ-XPON-Stick", sfp_quirk_2500basex,
+		  sfp_fixup_ignore_tx_fault),
+
 	// Lantech 8330-262D-E and 8330-265D can operate at 2500base-X, but
 	// incorrectly report 2500MBd NRZ in their EEPROM.
 	// Some 8330-265D modules have inverted LOS, while all of them report
-- 
2.53.0

