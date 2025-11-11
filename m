Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2232255F5E;
	Tue, 11 Nov 2025 01:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825362; cv=none; b=DHsNH6X5RMR7qNfzH5aKZ9M9md1CmtZkXTu2VvcCAxv04/8B8m87OfUIJ2TWG4tKPxPbsbWN6BH/zr9YhDfCWCfU4j3vP70vdfIIF3mHnRpZU+v7xbrMexLkES3tcuw6FTdWzMTIPZZbIOSZcZU9lRwLJRYoBW6q2Jai5P9bk/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825362; c=relaxed/simple;
	bh=UDqpHUsnR50Wgv0VUhMwkDtSitTLUF3pRsma1z6k+JU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lciefsRRSHB30vSOPuUNQsLZlP1NZatJU6dsbsP7lscyQhh3iqWxHT6UiV9jMhwELIuE9Gi3HBv4ZmPPO1yHAzj0CbbpcpdVPlSG8u3L2uyQFP/r3lJsZG4Ei8iEn/9ZRl9bSs+2rhJx1LBfUg9I2DKJMvqD4Ew98Mc7m4uVt9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NHxgf66S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NHxgf66S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91744C4CEFB;
	Tue, 11 Nov 2025 01:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825361;
	bh=UDqpHUsnR50Wgv0VUhMwkDtSitTLUF3pRsma1z6k+JU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NHxgf66SeC2NiJAXgdJLRT88Z4zbXOIcgeBUjC+JZcIhmjIlophYwgNd6GAyCe7yR
	 GzzCLQ0Sq8viKhjyfK6W2UB2K0G0tU6ZkhrKIktY4KEVREby31lq0U121eZi0ONFxn
	 wJEoKSDKeXZ9MH4rpXn30W3c5x31b5HbzOj/vzfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 771/849] net: dsa: b53: fix enabling ip multicast
Date: Tue, 11 Nov 2025 09:45:41 +0900
Message-ID: <20251111004555.069106497@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit c264294624e956a967a9e2e5fa41e3273340b089 ]

In the New Control register bit 1 is either reserved, or has a different
function:

    Out of Range Error Discard

    When enabled, the ingress port discards any frames
    if the Length field is between 1500 and 1536
    (excluding 1500 and 1536) and with good CRC.

The actual bit for enabling IP multicast is bit 0, which was only
explicitly enabled for BCM5325 so far.

For older switch chips, this bit defaults to 0, so we want to enable it
as well, while newer switch chips default to 1, and their documentation
says "It is illegal to set this bit to zero."

So drop the wrong B53_IPMC_FWD_EN define, enable the IP multicast bit
also for other switch chips. While at it, rename it to (B53_)IP_MC as
that is how it is called in Broadcom code.

Fixes: 63cc54a6f073 ("net: dsa: b53: Fix egress flooding settings")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20251102100758.28352-2-jonas.gorski@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 4 ++--
 drivers/net/dsa/b53/b53_regs.h   | 3 +--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index bb2c6dfa7835d..58c31049c0e7a 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -371,11 +371,11 @@ static void b53_set_forwarding(struct b53_device *dev, int enable)
 		 * frames should be flooded or not.
 		 */
 		b53_read8(dev, B53_CTRL_PAGE, B53_IP_MULTICAST_CTRL, &mgmt);
-		mgmt |= B53_UC_FWD_EN | B53_MC_FWD_EN | B53_IPMC_FWD_EN;
+		mgmt |= B53_UC_FWD_EN | B53_MC_FWD_EN | B53_IP_MC;
 		b53_write8(dev, B53_CTRL_PAGE, B53_IP_MULTICAST_CTRL, mgmt);
 	} else {
 		b53_read8(dev, B53_CTRL_PAGE, B53_IP_MULTICAST_CTRL, &mgmt);
-		mgmt |= B53_IP_MCAST_25;
+		mgmt |= B53_IP_MC;
 		b53_write8(dev, B53_CTRL_PAGE, B53_IP_MULTICAST_CTRL, mgmt);
 	}
 }
diff --git a/drivers/net/dsa/b53/b53_regs.h b/drivers/net/dsa/b53/b53_regs.h
index 309fe0e46dadf..8ce1ce72e9385 100644
--- a/drivers/net/dsa/b53/b53_regs.h
+++ b/drivers/net/dsa/b53/b53_regs.h
@@ -111,8 +111,7 @@
 
 /* IP Multicast control (8 bit) */
 #define B53_IP_MULTICAST_CTRL		0x21
-#define  B53_IP_MCAST_25		BIT(0)
-#define  B53_IPMC_FWD_EN		BIT(1)
+#define  B53_IP_MC			BIT(0)
 #define  B53_UC_FWD_EN			BIT(6)
 #define  B53_MC_FWD_EN			BIT(7)
 
-- 
2.51.0



