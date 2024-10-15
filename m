Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C001FC7D7;
	Tue, 15 Oct 2024 13:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998457; cv=none; b=WwxzfFhYocw+2RCQqsFu3bT3QFrGl+0bDQWuHnekf1fNgopesvYtVnTKkOU2wwYI6cfB7xOSiqLt7P56JvHdmTzq0Onr8DLD/RRiWpLeDSNt1ne9R3w1MF5/rNhjZDl3Cd5zM5vOhIfl5v2+KiZKpnmx+F/72saclGaaf/ok5X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998457; c=relaxed/simple;
	bh=28Seucim7wWJb6NCKXH/mtj9NK+8dBQSsDMB9x61YkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LniNmQu7mpO0IgmQ3eTtEOU+E/CA5WyLDsu95JgaEUvuubTC2VBvfpNO3ncD3dR2O0JWvQLsRhxl2QOf0LUIUwZFWNIQ+D5Bnb7D/xzd5A83+25XW4AM+bvh92pzjG/eH0eRNvtKrzKAIVXjz+RS+Nx8Ww8yqW1cKDyKpm6Fj98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WD1tzTPR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WD1tzTPR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42904C4CEC6;
	Tue, 15 Oct 2024 13:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998457;
	bh=28Seucim7wWJb6NCKXH/mtj9NK+8dBQSsDMB9x61YkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WD1tzTPRV5Fu0wB6QZueOc8fu8TUUUr+ThwFQcMUvZiEkVgQQXNHWSWScN2HMnBSx
	 kUtblj9GjcqcTP7Fg6Go60iIyA5fkQQ2CcskJu5mj3EPRmd3hlUi3SOtiyhKwpM03Y
	 tyHDN4ekYBlX4hPXWzzcvI3/LXgPkNz5mSGWtfVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 483/518] net: dsa: b53: fix max MTU for 1g switches
Date: Tue, 15 Oct 2024 14:46:27 +0200
Message-ID: <20241015123935.642181850@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5852acf496a30..f7ae17ee6a32e 100644
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
@@ -2191,7 +2194,7 @@ static int b53_change_mtu(struct dsa_switch *ds, int port, int mtu)
 
 static int b53_get_max_mtu(struct dsa_switch *ds, int port)
 {
-	return JMS_MAX_SIZE;
+	return B53_MAX_MTU;
 }
 
 static const struct dsa_switch_ops b53_switch_ops = {
-- 
2.43.0



