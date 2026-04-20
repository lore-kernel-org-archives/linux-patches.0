Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9CAC33AD9A;
	Mon, 20 Apr 2026 15:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700759; cv=none; b=fBR0u8kfJC7GJDsgq0wmQEKg2rbtnK3v6dqB0GVnjcRZCNsVEAygOybZByUy2Cb9XKH3lLFJ3kkX5znlO5WRQn6m6UXzdVE7zuINkejD1JfDbW/gEYVQEQsgHcIefCLlvTS3ruztlYJwBNC48f2QNrW4WFl9HeC16S2ZV/HCOXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700759; c=relaxed/simple;
	bh=MYHS91XmdEuY4W4IjnevEDO01YrDhEiRMc0t4p8g5hM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i/1//LFFt9EnkFSYdlNeu7TeDyCLX+Q2Vrpe30RSuBThQ0LGEV8AjkCDWvoxDgV9HT0rVNkBGHLEa7oCxLqnI0yCNqxXFaG3Dqu1IMomkHYuZcQbeyX4ZMAlz+LYbl+ez1qiJTqIVRIb4fsv35p/7l3iHZpMRe0r1LUaQkpb3QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ojaK33zM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ojaK33zM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B3C0C19425;
	Mon, 20 Apr 2026 15:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700759;
	bh=MYHS91XmdEuY4W4IjnevEDO01YrDhEiRMc0t4p8g5hM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ojaK33zMqLGGeZ5e/i5JBBbt57kabJBobX0FJMbOQIPbwjaUjJX8D0Xnsj/Oc1eFW
	 w/uHidESPte2ZZF8A7ccJWn8MQgX7Xqc1i64dVm2kwIcnF0jiMUadh+N7Fu1DnwGrA
	 u9hGeXmaZUOKwnX1+XcMue8EjYsdI4KSCEJVfAw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Marcin Nita <marcin.nita@leolabs.pl>,
	John Pavlick <jspavlick@posteo.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 043/198] net: sfp: add quirks for Hisense and HSGQ GPON ONT SFP modules
Date: Mon, 20 Apr 2026 17:40:22 +0200
Message-ID: <20260420153937.168542679@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



