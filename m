Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 349CE1E3764;
	Tue, 15 Oct 2024 12:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994207; cv=none; b=LnoNjOrx2XJC206F3q/Az7zOVZSbpz1TiWLrKa/I3ljNt3OA0fSIJHOgEhseQnqVNc4KWTwGYhJ0JoN5eIe9/1FQ7NO3EJ88d2pUXK7/oyhAd+1WzxfIAHHV+D8O7BlJmpGI7rqs1731vlo714Ucv91SxgYttT9Sx5xmqYddizw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994207; c=relaxed/simple;
	bh=02NhjCTPKsLe/EowNTNmUsqdHWgdgFLL+rXCoQcCFbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jz8/RlE59/q/tpcz8cqXokCQG0Vj1DSXrtk8KHoR7bMR7oAH8+J4m60xjRIWkVsSf7LvudRVF/RDTpbUOkOxXUIMZDUUWF2ZVmxGfUQ5HwlKaPNZJeN02l+GNKq3jUJq77PRtx+FauNZhSTseZFVQbSQWw9qdnK++J97MBUDsjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CuXPHyGy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CuXPHyGy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46131C4CEC6;
	Tue, 15 Oct 2024 12:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994206;
	bh=02NhjCTPKsLe/EowNTNmUsqdHWgdgFLL+rXCoQcCFbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CuXPHyGybC6EXgojMfnwM9ni6O6YqNjxtZDhNnYnC3xFb7oBmqUaFL35BbeAspUnq
	 QnYJZOf+/JKSVF6jPn5sZjLa3pQbRFa3iRhPuqnIyk1v3hAT/+IEaJL35bmqHr9Hm4
	 hWCAxdUYrKtUcVM+7U+7LD84bFQ1KUDmIDEo71zs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 637/691] net: dsa: b53: fix max MTU for 1g switches
Date: Tue, 15 Oct 2024 13:29:45 +0200
Message-ID: <20241015112505.611094409@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 03047486b9b85..be1550332326a 100644
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
@@ -2234,7 +2237,7 @@ static int b53_change_mtu(struct dsa_switch *ds, int port, int mtu)
 
 static int b53_get_max_mtu(struct dsa_switch *ds, int port)
 {
-	return JMS_MAX_SIZE;
+	return B53_MAX_MTU;
 }
 
 static const struct dsa_switch_ops b53_switch_ops = {
-- 
2.43.0



