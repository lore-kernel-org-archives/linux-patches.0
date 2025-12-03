Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4998B30B520;
	Wed,  3 Dec 2025 15:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776363; cv=none; b=YqOTEG1Z0S7DEXX5fgKnWxtzm6DH7572kNnIvhVBr5G4E9J94sk/QHu8i1kAiMpuWX/1XKxsC+GY0BDGaIqHte70ZqWhiFaHYijz7lQr9dPKkirZ+YrSg/aryDwse1lsbyvKPFnxXDSu9DpD/LuR1d263CIhccjQHDzG1n+/sUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776363; c=relaxed/simple;
	bh=iqAG+2nCmBF5sjEVqfCwrm8iKzc7G84M3DP217tDqAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DPy1G9G9pQUNHfS46O1jOBymt08efWzK47lf5tV6D24RsnslCuNh4VAZdKlbUsAtyQyL9RqM0zem/yglIoXXklvFlSvBHf6BFSixB/f+5q2tMb49H+ScACY6jAAnC8eKEs80xKoYTxpbwzV7aCpEdgkg1QYNym2XeTvpN2D24pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=umOxh4TM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="umOxh4TM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A23D6C116B1;
	Wed,  3 Dec 2025 15:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776363;
	bh=iqAG+2nCmBF5sjEVqfCwrm8iKzc7G84M3DP217tDqAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=umOxh4TMRAtXl9keZmi8REmOE91vXTkY3E0teaBAvbuM9BKOug24nwlcRSFJzxi0H
	 kMlyWYhqstVk3Xg3zpwgfRU6mJ9iEkY2dncgEG7j0tGuV1ycIo9EI9Jbkq86yPw66a
	 kklu52+JvJXe71wg3UoC/FLJFqMsE7udfd1safUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 160/300] net: dsa: b53: fix resetting speed and pause on forced link
Date: Wed,  3 Dec 2025 16:26:04 +0100
Message-ID: <20251203152406.545234218@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit b6a8a5477fe9bd6be2b594a88f82f8bba41e6d54 ]

There is no guarantee that the port state override registers have their
default values, as not all switches support being reset via register or
have a reset GPIO.

So when forcing port config, we need to make sure to clear all fields,
which we currently do not do for the speed and flow control
configuration. This can cause flow control stay enabled, or in the case
of speed becoming an illegal value, e.g. configured for 1G (0x2), then
setting 100M (0x1), results in 0x3 which is invalid.

For PORT_OVERRIDE_SPEED_2000M we need to make sure to only clear it on
supported chips, as the bit can have different meanings on other chips,
e.g. for BCM5389 this controls scanning PHYs for link/speed
configuration.

Fixes: 5e004460f874 ("net: dsa: b53: Add helper to set link parameters")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20251101132807.50419-2-jonas.gorski@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 361f9be65386e..704ec51a1500e 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1151,6 +1151,10 @@ static void b53_force_port_config(struct b53_device *dev, int port,
 	else
 		reg &= ~PORT_OVERRIDE_FULL_DUPLEX;
 
+	reg &= ~(0x3 << GMII_PO_SPEED_S);
+	if (is5301x(dev) || is58xx(dev))
+		reg &= ~PORT_OVERRIDE_SPEED_2000M;
+
 	switch (speed) {
 	case 2000:
 		reg |= PORT_OVERRIDE_SPEED_2000M;
@@ -1169,6 +1173,11 @@ static void b53_force_port_config(struct b53_device *dev, int port,
 		return;
 	}
 
+	if (is5325(dev))
+		reg &= ~PORT_OVERRIDE_LP_FLOW_25;
+	else
+		reg &= ~(PORT_OVERRIDE_RX_FLOW | PORT_OVERRIDE_TX_FLOW);
+
 	if (rx_pause) {
 		if (is5325(dev))
 			reg |= PORT_OVERRIDE_LP_FLOW_25;
-- 
2.51.0



