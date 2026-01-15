Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8CF274B43;
	Thu, 15 Jan 2026 16:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496162; cv=none; b=ZG3Hz4KXQpulQlQt3Y5SP4dS+L1mlVyQVrUIzclNSkWnzuIHXc/l4G+I+qynqg4vAoujVTeKZibskhHmKhhmAh1w8MdXubhyyY8jlLP6HcaZmRjiHN5P8ONjnJUu/fUwKE4i39q0r83rluKZTtPuMGtY+nl0R/jUZAtzrBrzW9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496162; c=relaxed/simple;
	bh=/KpZFH33uDTI0ho4gtR1f3YfXBWYr1iXiQwyWbEZzoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i+o0nUBZl5RwYvoxsohT8/24Y0xLkToZKm5/DeT7ByUO9Ikj7rFRBNJ1Y/xWqjzCObB4ZWjzbsQYIIcjui5AdUNGFvdK2VtArjahwMXTjauvIi+yxo7dAak0sIHL5IOCZz5vrKsZnAzBGR0XgVQx1gwXigIwr6FZVYbDKDtwvSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nun6OIOD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nun6OIOD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECFC5C16AAE;
	Thu, 15 Jan 2026 16:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496162;
	bh=/KpZFH33uDTI0ho4gtR1f3YfXBWYr1iXiQwyWbEZzoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nun6OIODDVOvsrhVSDzg/nFnbkIF8CfcXTPv6d040COPh9O3Af9iGICjCOEie0IdG
	 uf8IkgmF+fNjXq9Q2n4yVkBoK9o0Ofg7jnOjqHB/CYFB5yB1UcePRx548bygd+cRaz
	 O6pqXWMiOAAB/SHEG3cY/q1JALh/lprTRF1GwzNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Radaelli <stefano.r@variscite.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 099/181] net: phy: mxl-86110: Add power management and soft reset support
Date: Thu, 15 Jan 2026 17:47:16 +0100
Message-ID: <20260115164205.894960408@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefano Radaelli <stefano.r@variscite.com>

[ Upstream commit 62f7edd59964eb588e96fce1ad35a2327ea54424 ]

Implement soft_reset, suspend, and resume callbacks using
genphy_soft_reset(), genphy_suspend(), and genphy_resume()
to fix PHY initialization and power management issues.

The soft_reset callback is needed to properly recover the PHY after an
ifconfig down/up cycle. Without it, the PHY can remain in power-down
state, causing MDIO register access failures during config_init().
The soft reset ensures the PHY is operational before configuration.

The suspend/resume callbacks enable proper power management during
system suspend/resume cycles.

Fixes: b2908a989c59 ("net: phy: add driver for MaxLinear MxL86110 PHY")
Signed-off-by: Stefano Radaelli <stefano.r@variscite.com>
Link: https://patch.msgid.link/20251223120940.407195-1-stefano.r@variscite.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mxl-86110.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/phy/mxl-86110.c b/drivers/net/phy/mxl-86110.c
index e5d137a37a1d4..42a5fe3f115f4 100644
--- a/drivers/net/phy/mxl-86110.c
+++ b/drivers/net/phy/mxl-86110.c
@@ -938,6 +938,9 @@ static struct phy_driver mxl_phy_drvs[] = {
 		PHY_ID_MATCH_EXACT(PHY_ID_MXL86110),
 		.name			= "MXL86110 Gigabit Ethernet",
 		.config_init		= mxl86110_config_init,
+		.suspend		= genphy_suspend,
+		.resume			= genphy_resume,
+		.soft_reset		= genphy_soft_reset,
 		.get_wol		= mxl86110_get_wol,
 		.set_wol		= mxl86110_set_wol,
 		.led_brightness_set	= mxl86110_led_brightness_set,
-- 
2.51.0



