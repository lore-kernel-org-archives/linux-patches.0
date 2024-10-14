Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF081CA8D;
	Mon, 14 Oct 2024 15:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919909; cv=none; b=hIxqG3Qf7woALqTh4509KlMsHpPeLU5QPCTU9mDEv0972ix0fCWnTJu2fxJZIKkGTtybR40/Qknigyn72wTzbGOz3FPX18tn/Y4E604mhrr3Kwi6OunncHroVoOsVbmEHaUkVl05DSYweNocxaYOBtpHnJQA04WMSup/i+5yVKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919909; c=relaxed/simple;
	bh=EdzM6uN33khm1on2b9EZgbsUI+VlpL7gKr2X3ZOZZrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AXpu+EN2SwVVVXB7uHVH5OyYlepR1vpaFJs47t0lsT1tQIzlME0ETroOQBBw86z53vN6nfOpekZ+6gA9b8Htqx9qX3J/EhdUZ2b3+qQ23Rmxgann/JeXCkGFRnVBKympoeKg30yn31lrbZxjD88IY0NvXdu3ruv6qF4qOsNsqwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EH71IvKg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EH71IvKg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9F00C4CEC7;
	Mon, 14 Oct 2024 15:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919909;
	bh=EdzM6uN33khm1on2b9EZgbsUI+VlpL7gKr2X3ZOZZrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EH71IvKgCXASi42JdBkowkOjD3yTt+OXvPea0byjm2TIJPkh3yoDMOw3I2Gl0Hrtk
	 x+tkQQpJ21lV6O+id4NCoj8tgsLKVl78Pxg0r4hUQ4jsDtORRdfer8ox20orgFW3br
	 tOvYHRdVgEZaMY2e4pR4LTUb6XKowamJv/TY9TPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 743/798] net: dsa: b53: fix max MTU for 1g switches
Date: Mon, 14 Oct 2024 16:21:37 +0200
Message-ID: <20241014141247.259975584@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 862150c54e88e..82583edbb3f95 100644
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
@@ -2232,7 +2235,7 @@ static int b53_change_mtu(struct dsa_switch *ds, int port, int mtu)
 
 static int b53_get_max_mtu(struct dsa_switch *ds, int port)
 {
-	return JMS_MAX_SIZE;
+	return B53_MAX_MTU;
 }
 
 static const struct dsa_switch_ops b53_switch_ops = {
-- 
2.43.0



