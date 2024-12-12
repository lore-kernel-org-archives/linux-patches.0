Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1AF922330D;
	Thu, 12 Dec 2024 17:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023514; cv=none; b=buRwI5N5WNtupboPPvlxGVvFko83lXkzqrHzGgw8M9fsThTtCi/Ra7Vm6YXyTFzu49RdmnE725mrEoYU5G33kEO4uxVOv05s3M1RUEdOzQON3xYTgy78dhpZhYZGvgxQsw80fSPo1QBueSkEuN4rk0V9IJ22lDseY5wJRxUp2II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023514; c=relaxed/simple;
	bh=F5m0XiJAnE8vcmA7gHA3uNV6hy7hxC2W/Y+w1Yv+s5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YJGb5AJGtAwQ/xOwHodeLWpGjMZPjG/gEfKFEkGyFcx9XmxHuUSpwOvd9TBiueQkd4mZxZDOAZmMSex7Yoc7ygNxPrdYHIVEwzTTYvsc1GghVLb1qMvOMYzIwAQGzmXaP+WIRGnrtg6NWoymVl9RR7h2rMxn+nlolo/Aes/+p9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JjxWG4aZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JjxWG4aZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF137C4CED0;
	Thu, 12 Dec 2024 17:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023514;
	bh=F5m0XiJAnE8vcmA7gHA3uNV6hy7hxC2W/Y+w1Yv+s5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JjxWG4aZydXC8M8Hsb04hoFnOLFXi1c0X8/j//ybuAc0Ew8m58RxM1WpkunkHLfvd
	 dXxfX3I6JA/PvAmWY2NOS+jtfKq3PFIP+sYZBi4RTHjabbCd9wBejaN5iShahZVlBD
	 BCSF62MC28Z/eM+GvLHQCyG+b9LNfhJCYW4xsN3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristram Ha <Tristram.Ha@microchip.com>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>,
	=?UTF-8?q?J=C3=B6rg=20Sommer?= <joerg@jo-so.de>
Subject: [PATCH 5.15 559/565] net: dsa: microchip: correct KSZ8795 static MAC table access
Date: Thu, 12 Dec 2024 16:02:34 +0100
Message-ID: <20241212144333.960086042@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristram Ha <Tristram.Ha@microchip.com>

commit 4bdf79d686b49ac49373b36466acfb93972c7d7c upstream.

The KSZ8795 driver code was modified to use on KSZ8863/73, which has
different register definitions.  Some of the new KSZ8795 register
information are wrong compared to previous code.

KSZ8795 also behaves differently in that the STATIC_MAC_TABLE_USE_FID
and STATIC_MAC_TABLE_FID bits are off by 1 when doing MAC table reading
than writing.  To compensate that a special code was added to shift the
register value by 1 before applying those bits.  This is wrong when the
code is running on KSZ8863, so this special code is only executed when
KSZ8795 is detected.

Fixes: 4b20a07e103f ("net: dsa: microchip: ksz8795: add support for ksz88xx chips")
Signed-off-by: Tristram Ha <Tristram.Ha@microchip.com>
Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jörg Sommer <joerg@jo-so.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/microchip/ksz8795.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -25,6 +25,8 @@
 #include "ksz8795_reg.h"
 #include "ksz8.h"
 
+#define KSZ8795_CHIP_ID         0x09
+
 static const u8 ksz8795_regs[] = {
 	[REG_IND_CTRL_0]		= 0x6E,
 	[REG_IND_DATA_8]		= 0x70,
@@ -52,13 +54,13 @@ static const u32 ksz8795_masks[] = {
 	[STATIC_MAC_TABLE_VALID]	= BIT(21),
 	[STATIC_MAC_TABLE_USE_FID]	= BIT(23),
 	[STATIC_MAC_TABLE_FID]		= GENMASK(30, 24),
-	[STATIC_MAC_TABLE_OVERRIDE]	= BIT(26),
-	[STATIC_MAC_TABLE_FWD_PORTS]	= GENMASK(24, 20),
+	[STATIC_MAC_TABLE_OVERRIDE]	= BIT(22),
+	[STATIC_MAC_TABLE_FWD_PORTS]	= GENMASK(20, 16),
 	[DYNAMIC_MAC_TABLE_ENTRIES_H]	= GENMASK(6, 0),
-	[DYNAMIC_MAC_TABLE_MAC_EMPTY]	= BIT(8),
+	[DYNAMIC_MAC_TABLE_MAC_EMPTY]	= BIT(7),
 	[DYNAMIC_MAC_TABLE_NOT_READY]	= BIT(7),
 	[DYNAMIC_MAC_TABLE_ENTRIES]	= GENMASK(31, 29),
-	[DYNAMIC_MAC_TABLE_FID]		= GENMASK(26, 20),
+	[DYNAMIC_MAC_TABLE_FID]		= GENMASK(22, 16),
 	[DYNAMIC_MAC_TABLE_SRC_PORT]	= GENMASK(26, 24),
 	[DYNAMIC_MAC_TABLE_TIMESTAMP]	= GENMASK(28, 27),
 };
@@ -601,7 +603,13 @@ static int ksz8_r_sta_mac_table(struct k
 				shifts[STATIC_MAC_FWD_PORTS];
 		alu->is_override =
 			(data_hi & masks[STATIC_MAC_TABLE_OVERRIDE]) ? 1 : 0;
-		data_hi >>= 1;
+
+		/* KSZ8795 family switches have STATIC_MAC_TABLE_USE_FID and
+		 * STATIC_MAC_TABLE_FID definitions off by 1 when doing read on the
+		 * static MAC table compared to doing write.
+		 */
+		if (dev->chip_id == KSZ8795_CHIP_ID)
+			data_hi >>= 1;
 		alu->is_static = true;
 		alu->is_use_fid =
 			(data_hi & masks[STATIC_MAC_TABLE_USE_FID]) ? 1 : 0;


