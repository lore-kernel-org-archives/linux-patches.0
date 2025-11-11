Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B75E2701DC;
	Tue, 11 Nov 2025 01:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824807; cv=none; b=LtTYfhHo+gk1YsfSFxYGfSwogjSKt0hh4Igk95xufDohZAlkjrc9M0NaAWj3BYUVTIloFLtJ0qm480p97l1b/oM/4YJCYslHkDRhnpAmorCJ9t6K1tulSPzFjFd8Df6XTdLqvXxVal1WWhjxjxw6fdpoHJwRA36P9+kwZFLzjgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824807; c=relaxed/simple;
	bh=z1E0VnZkEx9QTfexSpg/UpUDdBspEOk2Jvso60jBajg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F9MBMV2b46qC7cMEoNzVgSV4/VHE1EHdZUCJNXNMw0qCrmYlcDQTZeVtJGQWXq/o7ZRAnWn8Hf5WjvosVgU6omxvL0VDr/L9QRdzWywEkqDuWTMJbdKdLxpJpt+aTcJxecFcGxvgDFELocUYGF7O9wrZ4MW59id6A3JPJ9v/5RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NEfndDiZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NEfndDiZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5323C116B1;
	Tue, 11 Nov 2025 01:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824807;
	bh=z1E0VnZkEx9QTfexSpg/UpUDdBspEOk2Jvso60jBajg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NEfndDiZfyP5R3GFzXHakPjf9bMjOXItHRJTH9J/IS98NDJwwJrtwppK47zXulRo7
	 EzkCOE50rU9xWxyICR//MC+g/xgA4mEWiNmtp/7jRQfzIr0kBbkAw1AxbtvGtc/yQO
	 KkeRg9/YKRToSRgGjs6EunTpAGAIfDzK8nU8rdtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 521/565] net: dsa: b53: fix enabling ip multicast
Date: Tue, 11 Nov 2025 09:46:17 +0900
Message-ID: <20251111004538.684812954@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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
index 914dbb86e1b07..a22f28f98faee 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -369,11 +369,11 @@ static void b53_set_forwarding(struct b53_device *dev, int enable)
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
index 5741231e0841d..2dca7dd76eb6b 100644
--- a/drivers/net/dsa/b53/b53_regs.h
+++ b/drivers/net/dsa/b53/b53_regs.h
@@ -110,8 +110,7 @@
 
 /* IP Multicast control (8 bit) */
 #define B53_IP_MULTICAST_CTRL		0x21
-#define  B53_IP_MCAST_25		BIT(0)
-#define  B53_IPMC_FWD_EN		BIT(1)
+#define  B53_IP_MC			BIT(0)
 #define  B53_UC_FWD_EN			BIT(6)
 #define  B53_MC_FWD_EN			BIT(7)
 
-- 
2.51.0



