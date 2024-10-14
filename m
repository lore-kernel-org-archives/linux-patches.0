Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A7BC1ABECB;
	Mon, 14 Oct 2024 14:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917024; cv=none; b=Q6Y42xd8P0zDZN7Ey8DYCBb3uGTJdNNuizAYH7RkBb64fwypZ1qlMPNTQWM2KE05fJXlrfDdlB5e/WpBa+ACkDz89K0w2cvetXp3r3Yj78Xm7rL7lDAFYBqE6mRuEkqBlpExTKxUAX4Z1OWJArS/7DeLfNfnHfZUv3DcF69OaD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917024; c=relaxed/simple;
	bh=PRPfMoRnpNwebJgY/daLy88rmvw46zf76rvNyTHByRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TEOAO560EeAcwJxRuAR/OGw54Cf/H7nDnt4zVMoSZhEPt37H+HvJxqzkFsZnrhsJ4PI23flaxh8PryDiaYD4i85aoA3psH/mkcby9Ot+jUL7BOqHrcK0wiAa9A/yJadN6q/5x7C5zeqjUFzxXuvqfd+of/+8J5W3AQ1/391I+2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SYQHe3ar; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SYQHe3ar"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B7B7C4CEC7;
	Mon, 14 Oct 2024 14:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917024;
	bh=PRPfMoRnpNwebJgY/daLy88rmvw46zf76rvNyTHByRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SYQHe3ar8TQMriYvtjqJe997KXXeyHUjDZQaxMZs4FFF8LxXXDSaam3JSv2GoV0Dh
	 /ZDJ0Dh2MXZi2P+FLPxBtgNdHCHQJ16X75kgo2NL51CNPnWrhyv07iSmW0vFu9N55w
	 k/8ZaA5KOgpTrya7HuuAAWDNeyzHDMBLop+LpZNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 130/213] net: dsa: b53: fix max MTU for BCM5325/BCM5365
Date: Mon, 14 Oct 2024 16:20:36 +0200
Message-ID: <20241014141048.043574631@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit ca8c1f71c10193c270f772d70d34b15ad765d6a8 ]

BCM5325/BCM5365 do not support jumbo frames, so we should not report a
jumbo frame mtu for them. But they do support so called "oversized"
frames up to 1536 bytes long by default, so report an appropriate MTU.

Fixes: 6ae5834b983a ("net: dsa: b53: add MTU configuration support")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 0a1f7f1315721..b43b414b26969 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -225,6 +225,7 @@ static const struct b53_mib_desc b53_mibs_58xx[] = {
 
 #define B53_MIBS_58XX_SIZE	ARRAY_SIZE(b53_mibs_58xx)
 
+#define B53_MAX_MTU_25		(1536 - ETH_HLEN - VLAN_HLEN - ETH_FCS_LEN)
 #define B53_MAX_MTU		(9720 - ETH_HLEN - VLAN_HLEN - ETH_FCS_LEN)
 
 static int b53_do_vlan_op(struct b53_device *dev, u8 op)
@@ -2279,6 +2280,11 @@ static int b53_change_mtu(struct dsa_switch *ds, int port, int mtu)
 
 static int b53_get_max_mtu(struct dsa_switch *ds, int port)
 {
+	struct b53_device *dev = ds->priv;
+
+	if (is5325(dev) || is5365(dev))
+		return B53_MAX_MTU_25;
+
 	return B53_MAX_MTU;
 }
 
-- 
2.43.0



