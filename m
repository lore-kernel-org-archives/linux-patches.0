Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44291345CAA;
	Mon, 20 Apr 2026 15:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700104; cv=none; b=SMDGy4u+1jItgc3As743oEK0PzrMssFqN2p/s3uXQgJq5naQMJ8+BFcEN0q9ESdmXX0qizd3rFhcs/k2j0XIsxzekIT6kncdFuqeL3C+Wn9btDm44szaUPJYIuNw+fQS613+tEtbUJ5o73F7BwdAE8U+FZzkT3+q6/t3STy1onQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700104; c=relaxed/simple;
	bh=AJfA4BhQEurmyFt6kJnvNyFUZFkyGHJbpfxaPd5oKss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AbmgnjjKs/48NJxCBUbBNdNjx2AjJNW1cxR7N4owc9gFzdvqaqtH26jba47tYT3K+m+0pBWmK7dOE4KQhFP+PwUuECGIgyWgKFWerYoh9lk54kiZC7zmpT8CTd3kpYY4G8boC0wJW0ZZAEzDJPFUfHBm/eoiON7YW7WztWP2Iag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ps5QDzam; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ps5QDzam"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 902F9C19425;
	Mon, 20 Apr 2026 15:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700103;
	bh=AJfA4BhQEurmyFt6kJnvNyFUZFkyGHJbpfxaPd5oKss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ps5QDzamSNjONSRja7PWHa5/6hjumYxNDm7Np1pKUfiUhpjHWzjQwo97IpqD0jNZ5
	 TPQkmvPvqYRKk+Gvr4mA7qIRVyHUtD2oKxE4PtZae4HAUjJBmr2hgz8cTzJeKkw01b
	 y7mUAJ89UHn+Bdgw/8nofyZl5TPEz418T3ANNVnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Marcin Nita <marcin.nita@leolabs.pl>,
	John Pavlick <jspavlick@posteo.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 044/220] net: sfp: add quirks for Hisense and HSGQ GPON ONT SFP modules
Date: Mon, 20 Apr 2026 17:39:45 +0200
Message-ID: <20260420153935.624305818@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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



