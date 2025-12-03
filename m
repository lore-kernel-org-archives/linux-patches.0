Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5204313558;
	Wed,  3 Dec 2025 16:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778013; cv=none; b=b7Xr5j94wxjcMzimccNo4vEsS+b9k5XImMEqRsfNBLLfMyGiZ/LuZE4WGaOK6pHh0aw+V6XgAbrixDPBmY+aAgFE1OSKF93XUwlLtUW48GHn5skhhajS2QLgWPODFVwFBEcO5hgVIfpdK4mg0TcEQg+E4C7hR+qkXm8M+rwGhWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778013; c=relaxed/simple;
	bh=09/7jYpHF2Tf25CuFDKpAHy6i4USOYTg8mWypMkIXeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KTjMYuEYHB7YhdAOOH3Q++giPncA0vXhtQGJbp/wPuBOqnlmpag6Io4dgKKPXIJvRFuTIFh30bwF36N59AXsqCavVjPQjNM+odrSk8MBAQr/sPLBjgdodUtPkBINRALrBC63/frdraA3Hb3novGinbhJAlCdUrN1oRYRwI/Sf8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2qCHPRe1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2qCHPRe1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27E8FC4CEF5;
	Wed,  3 Dec 2025 16:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778013;
	bh=09/7jYpHF2Tf25CuFDKpAHy6i4USOYTg8mWypMkIXeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2qCHPRe1AR12REkOcJsgvDETUwMjr9ef7OLvTG4Mjda1BAi45xvguo9my3tkXXsfO
	 h3r/VVjZXx49RrBek3kvvQ1vbe2GNijyTTVZE1r7kGkXGTbQdRYorvcMCoXQOhvyhk
	 oxKzdfUNtqrxuGKIec1druSXSNSAuGn8ELzdMAA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 217/392] net: dsa: b53: fix enabling ip multicast
Date: Wed,  3 Dec 2025 16:26:07 +0100
Message-ID: <20251203152422.169615755@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f84f64d5a6163..228b470d13a0f 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -349,11 +349,11 @@ static void b53_set_forwarding(struct b53_device *dev, int enable)
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
index 77fb7ae660b8c..95f70248c194d 100644
--- a/drivers/net/dsa/b53/b53_regs.h
+++ b/drivers/net/dsa/b53/b53_regs.h
@@ -104,8 +104,7 @@
 
 /* IP Multicast control (8 bit) */
 #define B53_IP_MULTICAST_CTRL		0x21
-#define  B53_IP_MCAST_25		BIT(0)
-#define  B53_IPMC_FWD_EN		BIT(1)
+#define  B53_IP_MC			BIT(0)
 #define  B53_UC_FWD_EN			BIT(6)
 #define  B53_MC_FWD_EN			BIT(7)
 
-- 
2.51.0



