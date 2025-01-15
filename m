Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB631DB142;
	Wed, 15 Jan 2025 10:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937978; cv=none; b=GvEGp/d4RcSQtmG56DNFMePVRaPi+QZC8NalSLGUurVkq04YdW/9XK0W3N9JNrYvLSenhoq/75Ixnn37frfWpnlvEko5VcoAUrPVJGcihpCbGntoG5/CwOOeF40bqJj/45XRB4X4Hhyg2FULD/X+o+qu+2M8GvNseZI0NpRXjT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937978; c=relaxed/simple;
	bh=4JdmfBfoi0/3BKaIwmkelI915ZmszeNr01xcQEkhnno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ROAc4WxXDn07dVkSJTzczKMQWr3zc3Zy/hOLZKHeKZkS+CakJF8SZrsB/Rww3rd7ho83YpNf707/ceZxOpvx0W+rFH367R3ydp92OohqxQRs7EzM5JxTz5FrWmF5154CxPj9a2RdlCZC+cEL5HiMMjG4eU6MMUgMry2z30fNcmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O4SmImu3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O4SmImu3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2010C4CEE1;
	Wed, 15 Jan 2025 10:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937978;
	bh=4JdmfBfoi0/3BKaIwmkelI915ZmszeNr01xcQEkhnno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O4SmImu3gEC94DtP65TKSVLyDbzUIcA0QQIdZ3uk2j3Ln7D/kJZBWOnmyLV6SQgMG
	 O7I6cNzNvPm9IpPCxrFD3zl7ss0uz041s95kmTjHcefMnUCXZ4wKVvj8HW4cZxY6iW
	 EoL+bnIABT88iNlEXm4mnVYgz08kGJQhw/TTG8Ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Lan <lanhao@huawei.com>,
	Jian Shen <shenjian15@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 047/189] net: hns3: fix missing features due to dev->features configuration too early
Date: Wed, 15 Jan 2025 11:35:43 +0100
Message-ID: <20250115103608.236698153@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao Lan <lanhao@huawei.com>

[ Upstream commit ac1e2836fe294c2007ca81cf7006862c3bdf0510 ]

Currently, the netdev->features is configured in hns3_nic_set_features.
As a result, __netdev_update_features considers that there is no feature
difference, and the procedures of the real features are missing.

Fixes: 2a7556bb2b73 ("net: hns3: implement ndo_features_check ops for hns3 driver")
Signed-off-by: Hao Lan <lanhao@huawei.com>
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Link: https://patch.msgid.link/20250106143642.539698-3-shaojijie@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 4cbc4d069a1f..73825b6bd485 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2452,7 +2452,6 @@ static int hns3_nic_set_features(struct net_device *netdev,
 			return ret;
 	}
 
-	netdev->features = features;
 	return 0;
 }
 
-- 
2.39.5



