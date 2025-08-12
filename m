Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E65E27781E;
	Tue, 12 Aug 2025 19:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026004; cv=none; b=EgjDVBKrieHmlQ99sqbyXaXabunbaOu/AHslzg5R/h/EXOM3meYIc3BdtYCAk5RUupC9pv0M87nA9yakw9CiHQ7VJpR6HveLWxU90pcVel8B4olN4UuKdoCqLIxkfYrIqpJOHrtVEsKXgmkyVEeOOYcmwcaaZ5s+oV07yh1/sDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026004; c=relaxed/simple;
	bh=b2JnFGLnFCzKsptOO09gae3u9GBsImgh1Qz8KE5vwBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OZ0buYkDn795UcRpcHTSyho0Z+piD9BeFcAU0GpOZ1mqgrs1fBQojKZE/t/YfA2zcr5qjJIvrCKstT2nkoBypHzyKcAC5fHX86r2nsxxLjMaWTQcPJQwI6hY1aZ0oP/3Vzm+WIIoeal162QqQz57ywm8o5YoG0P003n3HNHfhSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hULfklcQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hULfklcQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C496C4CEF0;
	Tue, 12 Aug 2025 19:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026003;
	bh=b2JnFGLnFCzKsptOO09gae3u9GBsImgh1Qz8KE5vwBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hULfklcQfGnRs+qyMGnyCALAOnv/IFrhEGTLgY9WCbVhBRkb4bl3TDeUdd5l+wkTW
	 as4ban7PUwpg1BY2y8HwwuKXsWWhW/2n85f0+GaWBpnMb8ft6XJMXRwHTtNIBUUF9J
	 PZey5NLfkm2UveWZaJ5B7DtpdtNs4km5/lzjuP6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristram Ha <tristram.ha@microchip.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 208/480] net: dsa: microchip: Fix wrong rx drop MIB counter for KSZ8863
Date: Tue, 12 Aug 2025 19:46:56 +0200
Message-ID: <20250812174406.048415960@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristram Ha <tristram.ha@microchip.com>

[ Upstream commit 165a7f5db919ab68a45ae755cceb751e067273ef ]

When KSZ8863 support was first added to KSZ driver the RX drop MIB
counter was somehow defined as 0x105.  The TX drop MIB counter
starts at 0x100 for port 1, 0x101 for port 2, and 0x102 for port 3, so
the RX drop MIB counter should start at 0x103 for port 1, 0x104 for
port 2, and 0x105 for port 3.

There are 5 ports for KSZ8895, so its RX drop MIB counter starts at
0x105.

Fixes: 4b20a07e103f ("net: dsa: microchip: ksz8795: add support for ksz88xx chips")
Signed-off-by: Tristram Ha <tristram.ha@microchip.com>
Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://patch.msgid.link/20250723030403.56878-1-Tristram.Ha@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz8.c     | 3 +++
 drivers/net/dsa/microchip/ksz8_reg.h | 4 +++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz8.c b/drivers/net/dsa/microchip/ksz8.c
index be433b4e2b1c..8f55be89f8bf 100644
--- a/drivers/net/dsa/microchip/ksz8.c
+++ b/drivers/net/dsa/microchip/ksz8.c
@@ -371,6 +371,9 @@ static void ksz8863_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
 	addr -= dev->info->reg_mib_cnt;
 	ctrl_addr = addr ? KSZ8863_MIB_PACKET_DROPPED_TX_0 :
 			   KSZ8863_MIB_PACKET_DROPPED_RX_0;
+	if (ksz_is_8895_family(dev) &&
+	    ctrl_addr == KSZ8863_MIB_PACKET_DROPPED_RX_0)
+		ctrl_addr = KSZ8895_MIB_PACKET_DROPPED_RX_0;
 	ctrl_addr += port;
 	ctrl_addr |= IND_ACC_TABLE(TABLE_MIB | TABLE_READ);
 
diff --git a/drivers/net/dsa/microchip/ksz8_reg.h b/drivers/net/dsa/microchip/ksz8_reg.h
index 329688603a58..da80e659c648 100644
--- a/drivers/net/dsa/microchip/ksz8_reg.h
+++ b/drivers/net/dsa/microchip/ksz8_reg.h
@@ -784,7 +784,9 @@
 #define KSZ8795_MIB_TOTAL_TX_1		0x105
 
 #define KSZ8863_MIB_PACKET_DROPPED_TX_0 0x100
-#define KSZ8863_MIB_PACKET_DROPPED_RX_0 0x105
+#define KSZ8863_MIB_PACKET_DROPPED_RX_0 0x103
+
+#define KSZ8895_MIB_PACKET_DROPPED_RX_0 0x105
 
 #define MIB_PACKET_DROPPED		0x0000FFFF
 
-- 
2.39.5



