Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B533375C5;
	Mon, 20 Apr 2026 16:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701230; cv=none; b=nVhzhFiqf+Xmg9WMV9DNtYaLQvGiMqsxLEwQXEOsgdXZQ5ZlX742igcUDjoUlRvrRn+s0eL5oqaDfqxvU4hzuclsg39HAoyGqHKBn3iPHYUZMHwCoFhLu+4HmI754safzOKBPPhMXn+ZPC4qK17XH/rxZD648MdazwgNdv9J0e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701230; c=relaxed/simple;
	bh=GQ6MPiG4qhj872iLFe3G6H1gI1RjrCikMzCERKxMRHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=syLeS+6aRDPiUeNvWng8+0/qLeMo6+BtNXRxKD7+5/JhN2u8IbmPsNpXq39Pu6bSpNnIUrTnoLfyWldnTaYhCU+BDhvmFU8LJqAstkICCB7tyCU3KOxkn7srmxe77KW0iF3EdY2iMbn9di6WemSDH5KwYlpsbjtrVGpfOxEdHJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zm5w58x0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zm5w58x0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E478BC19425;
	Mon, 20 Apr 2026 16:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701230;
	bh=GQ6MPiG4qhj872iLFe3G6H1gI1RjrCikMzCERKxMRHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zm5w58x0Chp4Uo+YGbGHna6yZ5B9L+QLmPdGx4cY0c69HeT7A/v0lAKql3FabVn3g
	 gWBwE4pYVmdq3ny7FebkEJgJEiEFFNNu35WMEnn1GQWaHSzCgdiAOgWhtZfGnjq7Vl
	 OQZgvUxf1/K7vv9WTvfeoD3FO3Wzsz22DllelRzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Marcin Nita <marcin.nita@leolabs.pl>,
	John Pavlick <jspavlick@posteo.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 032/162] net: sfp: add quirks for Hisense and HSGQ GPON ONT SFP modules
Date: Mon, 20 Apr 2026 17:41:04 +0200
Message-ID: <20260420153928.188943968@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
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
 drivers/net/phy/sfp.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 9d9c1779da900..90ffba8f79520 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -536,6 +536,22 @@ static const struct sfp_quirk sfp_quirks[] = {
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



