Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C995E3B582F;
	Fri,  9 Oct 2026 14:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555667; cv=none; b=oBs1ipfM2X73QCodH/05oHB2EmvytR2JLZHxNBSX95wqSiXkKtEUv69SgaYVqQ9VBfw1CJh6qHKS5zo2lClEAx18mYrrOlSFMUYCLj/ijGUBU45t1YnH0JxneRsTtG2G8QYiFkTyFIW0nwyYdSEBCODAqO2R516sKAEtRsjEEwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555667; c=relaxed/simple;
	bh=G1y42HCrmI08Y3Jm9+rhpq9Ea6z4QP/zmX5zx7WOmbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XrzwotW7K6GwGgAqXdazP7DwFJcYEEaJNv2r8zPKUXErEKiu+9kXxOozLjVQtFwEzkXM+7r4nQa+cN88yv2zJPg4rYpdmtVUyYzp74ELNfReWyWazsgsFG3yCa28dtPiHb0qToTUh4rQRyM/pO1y5/eowIy8IJwt6BeLCiLZl4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qY1qXgSq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qY1qXgSq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E11D81F00898;
	Fri,  9 Oct 2026 14:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555665;
	bh=OYDZ0B1HRFlOEpc9SIhwnEC02JAvqW9NZqM9RR9JlRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qY1qXgSqK6PmQU9RzQK72vD5rHIBhRjt6BgHpFarDaxAUEcRV6fabukkZxGL9iGIT
	 liSFFrHNUDSwOJBoGhUpMkVvvlw0phKbC2nn80qbrHW0Akdm6sUFfIkZvlojGekQEb
	 fFgFxtDBvrF1MC31X8cLBoCLlsnsexNAR/92830E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 096/403] net: systemport: Fix RUNT MIB counter register offset calculation
Date: Fri,  9 Oct 2026 16:07:37 +0200
Message-ID: <20261009140954.332696601@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Florian Fainelli <florian.fainelli@broadcom.com>

[ Upstream commit 242935adfeb096f09b29fb2cfcf12f9eb2911fc6 ]

In UniMAC hardware, there is a 0xC byte gap between the RX MIB counters
and the TX MIB counters, and a second 0xC byte gap between the TX MIB
counters and the RX RUNT MIB counters.

In bcm_sysport_update_mib_counters(), 'offset' was only set to
UMAC_MIB_STAT_OFFSET (0xC) for all non-RX counters, omitting the second
0xC gap for BCM_SYSPORT_STAT_RUNT counters. As a result, all 4 RUNT MIB
counters were read from unmapped gap register space.

Fix this by setting offset to 2 * UMAC_MIB_STAT_OFFSET (0x18) when
reading BCM_SYSPORT_STAT_RUNT counters.

Fixes: 80105befdb4b ("net: systemport: add Broadcom SYSTEMPORT Ethernet MAC driver")
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20260922232440.598918-6-florian.fainelli@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bcmsysport.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index 8bfcfbe696b26..ff2512b2fe7b7 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -391,8 +391,10 @@ static void bcm_sysport_update_mib_counters(struct bcm_sysport_priv *priv)
 			if (priv->is_lite)
 				continue;
 
-			if (s->type != BCM_SYSPORT_STAT_MIB_RX)
+			if (s->type == BCM_SYSPORT_STAT_MIB_TX)
 				offset = UMAC_MIB_STAT_OFFSET;
+			else if (s->type == BCM_SYSPORT_STAT_RUNT)
+				offset = 2 * UMAC_MIB_STAT_OFFSET;
 			val = umac_readl(priv, UMAC_MIB_START + j + offset);
 			break;
 		case BCM_SYSPORT_STAT_RXCHK:
-- 
2.53.0



