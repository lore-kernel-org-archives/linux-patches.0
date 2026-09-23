Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439DA531633;
	Wed, 23 Sep 2026 14:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173360; cv=none; b=O8LjZZIfCSFCfy+qt1pEqhfFqYNPagWRh5X31dyWJM2IYgy8SM9LXRMWfEw+2ni2riAq4PMXzUPLTwN7PwqoJ5d+15vM/oH/HxONa4abdsXGGvnPEj49yANAivnsJM3MH21Bl4jiHItZ/j6baHUdZmYnRtWbGB1AV9BqG5jnIlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173360; c=relaxed/simple;
	bh=2LDVOcCHQjBGIEVC7fMCEjCWY/DQmO/4tNnUYAk6EdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WU3Lj4CH6tb+hxiHAa+IYUqggf9hc1CRoEJHGCtKsrQU5PblRWVtpmjv59luRrv4GR79+DZsn4zOh6Big+MOzrK4Sks+H9JmAxaMqY+LDlPqGgGyu/Hq918o0ddqxEmduGpEKaeNPoQYh+P1V1m4suZ/wKWaDjgwcf/tOIJJ2pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bc9FcfC6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bc9FcfC6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A32E61F000FF;
	Wed, 23 Sep 2026 14:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173359;
	bh=ClG84Irm/kcen+h60R0jDcu7wMWPlVWpbupkOAxqO3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bc9FcfC6hEPuipPMknzefNzEfioElqF5JuntOJtLqoJI/DuQRdXwEJhtZktOE8AWr
	 2mgB8/l+TzGv/Wwxez+gmQnFZMoa9iSf46LjwRJF75d0GeS9IeZtD9cTtmsWRTd1dv
	 LrO2UdJUcqGG9QVZA8WdPiFPATHPzZzDfY/7Ea6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Gal Pressman <gal@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 187/438] net: stmmac: do not overwrite phc_index when no PTP clock is registered
Date: Wed, 23 Sep 2026 16:03:28 +0200
Message-ID: <20260923140649.611233420@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

[ Upstream commit f0ef4b1eaed000a304726a43091588e8426ba08a ]

stmmac_get_ts_info() reports phc_index as 0 when hardware timestamping
is supported but no PTP clock has been registered yet (e.g. while the
interface is down). Zero is a valid PHC index and would make userspace
resolve the wrong clock; the absence of a clock should be reported as
-1.

The ethtool core already initializes phc_index to -1 before invoking
the get_ts_info callback (ethtool_init_tsinfo()), so just drop the
erroneous assignment.

Fixes: 9364fa7fcf12 ("net: stmmac: Remove setting of RX software timestamp")
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Link: https://patch.msgid.link/20260914-stmmac-fix-phc_index-v2-1-bf3d90373fe4@oss.qualcomm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index 92585d27ab883..2a4882f2a498d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -1013,8 +1013,6 @@ static int stmmac_get_ts_info(struct net_device *dev,
 
 		if (priv->ptp_clock)
 			info->phc_index = ptp_clock_index(priv->ptp_clock);
-		else
-			info->phc_index = 0;
 
 		info->tx_types = (1 << HWTSTAMP_TX_OFF) | (1 << HWTSTAMP_TX_ON);
 
-- 
2.53.0



