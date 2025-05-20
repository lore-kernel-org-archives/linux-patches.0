Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6217A21D5BE;
	Tue, 20 May 2025 14:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750652; cv=none; b=tYFpe7JK7cPVhbtuPWT1oB/Y4TEty5TItWF+ACuHUm3SXqipXDeUnqBOAOUYq9e1QfNcXPmw59s1ajdqYd6cPVHnD8kW7AuFmNQadzr5UMXWbcVjQlsxtRK4g9fqEcjvaNlW+xVpV79Rg76T0KrDoLT2LCdWlIHqhAb3fs5OHGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750652; c=relaxed/simple;
	bh=LG/aG8Kadoew9UK1qlybc04nTR5W1e5aoL+7jba/eXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NonyUq9R7TTEw8t4QCMUjriprQ7BmI2yyRxIVFmxNxu7aYlpMlacq5fcWvZXBuvgY+5mS6TUrbCxKrcZ8P5Q0nsTBgVdlClykLVwf9uRJeO8mek+L+0tnLmRsLQUASYu4jH87rT9lPOrqDqoXqbBXWh1vImY+aPHHPpTOKkEp4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dj+VIwKr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dj+VIwKr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A17FC4CEE9;
	Tue, 20 May 2025 14:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750651;
	bh=LG/aG8Kadoew9UK1qlybc04nTR5W1e5aoL+7jba/eXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dj+VIwKrKCQnsdXrp8YBF+XvcmnPcDk5P+55o3hVVpy+kKOTPgd2Hd3KSwsXy17+Q
	 hvBFHwmtUTaRsUOgloVa2JHWRDLnlUh0X4c03U+hkw2+ITZoajBEFJyKNrKfgSluNc
	 lFtmeizSpTUZfp8POec/R3dpOIyl6ldfhd0BAZjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 047/145] octeontx2-pf: Fix ethtool support for SDP representors
Date: Tue, 20 May 2025 15:50:17 +0200
Message-ID: <20250520125812.418646841@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hariprasad Kelam <hkelam@marvell.com>

[ Upstream commit 314007549d89adebdd1e214a743d7e26edbd075e ]

The hardware supports multiple MAC types, including RPM, SDP, and LBK.
However, features such as link settings and pause frames are only available
on RPM MAC, and not supported on SDP or LBK.

This patch updates the ethtool operations logic accordingly to reflect
this behavior.

Fixes: 2f7f33a09516 ("octeontx2-pf: Add representors for sdp MAC")
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c  | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index 2d53dc77ef1ef..b3f616a7f2e96 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -315,7 +315,7 @@ static void otx2_get_pauseparam(struct net_device *netdev,
 	struct otx2_nic *pfvf = netdev_priv(netdev);
 	struct cgx_pause_frm_cfg *req, *rsp;
 
-	if (is_otx2_lbkvf(pfvf->pdev))
+	if (is_otx2_lbkvf(pfvf->pdev) || is_otx2_sdp_rep(pfvf->pdev))
 		return;
 
 	mutex_lock(&pfvf->mbox.lock);
@@ -347,7 +347,7 @@ static int otx2_set_pauseparam(struct net_device *netdev,
 	if (pause->autoneg)
 		return -EOPNOTSUPP;
 
-	if (is_otx2_lbkvf(pfvf->pdev))
+	if (is_otx2_lbkvf(pfvf->pdev) || is_otx2_sdp_rep(pfvf->pdev))
 		return -EOPNOTSUPP;
 
 	if (pause->rx_pause)
@@ -937,8 +937,8 @@ static u32 otx2_get_link(struct net_device *netdev)
 {
 	struct otx2_nic *pfvf = netdev_priv(netdev);
 
-	/* LBK link is internal and always UP */
-	if (is_otx2_lbkvf(pfvf->pdev))
+	/* LBK and SDP links are internal and always UP */
+	if (is_otx2_lbkvf(pfvf->pdev) || is_otx2_sdp_rep(pfvf->pdev))
 		return 1;
 	return pfvf->linfo.link_up;
 }
@@ -1409,7 +1409,7 @@ static int otx2vf_get_link_ksettings(struct net_device *netdev,
 {
 	struct otx2_nic *pfvf = netdev_priv(netdev);
 
-	if (is_otx2_lbkvf(pfvf->pdev)) {
+	if (is_otx2_lbkvf(pfvf->pdev) || is_otx2_sdp_rep(pfvf->pdev)) {
 		cmd->base.duplex = DUPLEX_FULL;
 		cmd->base.speed = SPEED_100000;
 	} else {
-- 
2.39.5



