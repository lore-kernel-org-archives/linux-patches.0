Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51841465A8;
	Tue, 25 Jun 2024 09:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309582; cv=none; b=an/gaLouD+BVr94xUNTnm5gbYezy80yM/TXbIseR3o3FY336s1j2p0j1Nxj/nD9UIz65ZKpSmB9pS4vgCJRs0P2ImQc35py81T9bqAmO+5rIwQgWi4de2cnF6csYAIJRKG6f8tsyhVk6CiTZqg9nd4yHAoZuqtr1USNiVTXsTQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309582; c=relaxed/simple;
	bh=0Mj3qBRiYkA9q4CZqbJSyQJg3XVnIgIWuHgOEVm5krM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CbaffbLkZp7iqBPAvyxZBfv8A9bFJPsqRHmgOR9hhHjT9XxpYO9qoANs8nslOEFzEfmlFfowOV1IesaE6bsE7+rx5cWngl4/2xlN2ouzMdnoAqUXasoPhkUIMLqRbIrH7V+hKAgi6WqZmBj5wjCghwMvCTuxqyO6zfMMITCJp4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ivhFZQzh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ivhFZQzh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40672C32781;
	Tue, 25 Jun 2024 09:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309582;
	bh=0Mj3qBRiYkA9q4CZqbJSyQJg3XVnIgIWuHgOEVm5krM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ivhFZQzhvb9f4fwx3qW/uo60FVPlW3FWJDZMqBiuJXnZ8Uz9oSDxGa1kAat9Y5khs
	 8YAOgVSQJeckG5c8m7NHRkLUDgxbKM8nm34KhzOP3mUprYCc81GmodwXSE2006Xu3j
	 oOYpm7J0Q8gJmFIt9F2Ndk9zlkn6m7O881guFdJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Liang <lxu@maxlinear.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 063/131] net: phy: mxl-gpy: enhance delay time required by loopback disable function
Date: Tue, 25 Jun 2024 11:33:38 +0200
Message-ID: <20240625085528.341380441@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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

From: Xu Liang <lxu@maxlinear.com>

[ Upstream commit 0ba13995be9b416ea1d3daaf3ba871a67f45899b ]

GPY2xx devices need 3 seconds to fully switch out of loopback mode
before it can safely re-enter loopback mode. Implement timeout mechanism
to guarantee 3 seconds waited before re-enter loopback mode.

Signed-off-by: Xu Liang <lxu@maxlinear.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: c44d3ffd85db ("net: phy: mxl-gpy: Remove interrupt mask clearing from config_init")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mxl-gpy.c | 35 +++++++++++++++++++++++++++++------
 1 file changed, 29 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
index cae24091fb6f7..1c4ad1ded2cb6 100644
--- a/drivers/net/phy/mxl-gpy.c
+++ b/drivers/net/phy/mxl-gpy.c
@@ -95,6 +95,13 @@ struct gpy_priv {
 
 	u8 fw_major;
 	u8 fw_minor;
+
+	/* It takes 3 seconds to fully switch out of loopback mode before
+	 * it can safely re-enter loopback mode. Record the time when
+	 * loopback is disabled. Check and wait if necessary before loopback
+	 * is enabled.
+	 */
+	u64 lb_dis_to;
 };
 
 static const struct {
@@ -682,18 +689,34 @@ static void gpy_get_wol(struct phy_device *phydev,
 
 static int gpy_loopback(struct phy_device *phydev, bool enable)
 {
+	struct gpy_priv *priv = phydev->priv;
+	u16 set = 0;
 	int ret;
 
-	ret = phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK,
-			 enable ? BMCR_LOOPBACK : 0);
-	if (!ret) {
-		/* It takes some time for PHY device to switch
-		 * into/out-of loopback mode.
+	if (enable) {
+		u64 now = get_jiffies_64();
+
+		/* wait until 3 seconds from last disable */
+		if (time_before64(now, priv->lb_dis_to))
+			msleep(jiffies64_to_msecs(priv->lb_dis_to - now));
+
+		set = BMCR_LOOPBACK;
+	}
+
+	ret = phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK, set);
+	if (ret <= 0)
+		return ret;
+
+	if (enable) {
+		/* It takes some time for PHY device to switch into
+		 * loopback mode.
 		 */
 		msleep(100);
+	} else {
+		priv->lb_dis_to = get_jiffies_64() + HZ * 3;
 	}
 
-	return ret;
+	return 0;
 }
 
 static int gpy115_loopback(struct phy_device *phydev, bool enable)
-- 
2.43.0



