Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DAA1ABEA2;
	Mon, 14 Oct 2024 14:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916191; cv=none; b=oNx0wPbWGPR6EvigrbaNj8X9XvbR+grGs8rcBf9XCT0JDOwTrn4MsNmyYAOPsr8d1qUTTXmaNGS02/5NPaoE98QV28danuQUO/RW8Kkkp/w+B1hdhKTET+HCg4z1aVOtbEUF7/1gMuh9xhI41CCK9iJj7hMyB1PkB4ypEVFnbSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916191; c=relaxed/simple;
	bh=8eSVKdW97W6QE2zMq9QqAp/dJmwxzXLJoXAJmVXjjak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jvGrKw8x+1ul4vjCpQ4N9Bg4Bvzs3NXW1dE/wvH0bzEbJ4gP6n1F1xJcBezm1oERh++mFDyiJCMe46pm5bkFFWbVsKUhS/h2eFMRWMOrwPWiKyBUGPUb1Z6XXfEB76PZ8RLlGw6p8JYR/P/ZxDMb1eKjP0w38ii4aiZiNLPaGqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wiCdGMMR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wiCdGMMR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E271BC4CEC3;
	Mon, 14 Oct 2024 14:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916191;
	bh=8eSVKdW97W6QE2zMq9QqAp/dJmwxzXLJoXAJmVXjjak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wiCdGMMR2yrcbh2u4m5Csmr6/TR0R74Q9UyUNMBzkmtG8wGBD3xN/YPlJTaNZPSFB
	 GvO0Dbzd6hC7LPFuay+81k7paZ3IvNV+WqfE8hiYYQVa+ItvIyf2J2b884ATSLdLQf
	 211OaCrwo7LAbA0l3ro5+UQgBawRE350cTYLKU9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 110/214] net: dsa: b53: fix max MTU for 1g switches
Date: Mon, 14 Oct 2024 16:19:33 +0200
Message-ID: <20241014141049.289559595@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 680a8217dc00dc7e7da57888b3c053289b60eb2b ]

JMS_MAX_SIZE is the ethernet frame length, not the MTU, which is payload
without ethernet headers.

According to the datasheets maximum supported frame length for most
gigabyte swithes is 9720 bytes, so convert that to the expected MTU when
using VLAN tagged frames.

Fixes: 6ae5834b983a ("net: dsa: b53: add MTU configuration support")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 57df00ad9dd4c..6fed3eb15ad9b 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -27,6 +27,7 @@
 #include <linux/phylink.h>
 #include <linux/etherdevice.h>
 #include <linux/if_bridge.h>
+#include <linux/if_vlan.h>
 #include <net/dsa.h>
 
 #include "b53_regs.h"
@@ -224,6 +225,8 @@ static const struct b53_mib_desc b53_mibs_58xx[] = {
 
 #define B53_MIBS_58XX_SIZE	ARRAY_SIZE(b53_mibs_58xx)
 
+#define B53_MAX_MTU		(9720 - ETH_HLEN - VLAN_HLEN - ETH_FCS_LEN)
+
 static int b53_do_vlan_op(struct b53_device *dev, u8 op)
 {
 	unsigned int i;
@@ -2267,7 +2270,7 @@ static int b53_change_mtu(struct dsa_switch *ds, int port, int mtu)
 
 static int b53_get_max_mtu(struct dsa_switch *ds, int port)
 {
-	return JMS_MAX_SIZE;
+	return B53_MAX_MTU;
 }
 
 static const struct phylink_mac_ops b53_phylink_mac_ops = {
-- 
2.43.0



