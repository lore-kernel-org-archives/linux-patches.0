Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A151170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 13:57:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F62C433C9;
	Mon, 11 Sep 2023 13:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440633;
	bh=PklztfbmiBpwIxtkId3+NwrUzWvnWu7xGP6L0gYToPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EMIxGwuGmT2q0XDeZ2/MM04qAIYY+GNvKnuPWpwJnpRxtZcQIc5+P5gL4hXGLFqDs
	 yQSoGNhBlXywb5j542LbCE+MVhRAGmBCpXJEbtdOXmjjvr6RDzjfB/THn8vMBA5GTn
	 H5j+LGhEIKtECrKOrD29SE4bKCYfXQ2JDHoAGcno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 130/739] net: pcs: lynx: fix lynx_pcs_link_up_sgmii() not doing anything in fixed-link mode
Date: Mon, 11 Sep 2023 15:38:49 +0200
Message-ID: <20230911134654.716850285@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 2f4503f94c5d81d1589842bfb457be466c8c670b ]

lynx_pcs_link_up_sgmii() is supposed to update the PCS speed and duplex
for the non-inband operating modes, and prior to the blamed commit, it
did just that, but a mistake sneaked into the conversion and reversed
the condition.

It is easy for this to go undetected on platforms that also initialize
the PCS in the bootloader, because Linux doesn't reset it (although
maybe it should). The nature of the bug is that phylink will not touch
the IF_MODE_HALF_DUPLEX | IF_MODE_SPEED_MSK fields when it should, and
it will apparently keep working if the previous values set by the
bootloader were correct.

Fixes: c689a6528c22 ("net: pcs: lynx: update PCS driver to use neg_mode")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/pcs/pcs-lynx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/pcs/pcs-lynx.c b/drivers/net/pcs/pcs-lynx.c
index 9021b96d4f9df..dc3962b2aa6b0 100644
--- a/drivers/net/pcs/pcs-lynx.c
+++ b/drivers/net/pcs/pcs-lynx.c
@@ -216,7 +216,7 @@ static void lynx_pcs_link_up_sgmii(struct mdio_device *pcs,
 	/* The PCS needs to be configured manually only
 	 * when not operating on in-band mode
 	 */
-	if (neg_mode != PHYLINK_PCS_NEG_INBAND_ENABLED)
+	if (neg_mode == PHYLINK_PCS_NEG_INBAND_ENABLED)
 		return;
 
 	if (duplex == DUPLEX_HALF)
-- 
2.40.1



