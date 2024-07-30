Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E7701A6195;
	Tue, 30 Jul 2024 16:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358512; cv=none; b=olvx07yBHa+lWZBUj0LC6rGX9K3SSyQhdH8kpwqKAcRdXVNSzb+aa4/STXiXWEV3UC40h8oYCX2e7tnSXHQ0zGR7ZdlniSM5jGf8o2bWgNU1D8sWJBr/DZE3rejUnub7S4WZFDTSibF8uUWnz2S/ZiYwLEiNvN+mjxl2c+NYjCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358512; c=relaxed/simple;
	bh=C9joSy2NvxkK3nidKQPNmwgrf8N8FLvEQJTy79+RfEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CdQ8qleDxoNVlfMWuicNVpZTnXh+AgZHwbMU5RcdF1mB1iJ4yFWNb2o3uEJQkJKjoaFHnP4GdR2Twj6650uDTbEDvgfwk/suKq6IIhRymJOFDxEuCS7/F2CFxRnKbUpUpuDdpxsr0pAEQWxcKQE0jEW7zpFkeFU743sYEPzWv8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GaiXA78D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GaiXA78D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F2A6C32782;
	Tue, 30 Jul 2024 16:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358512;
	bh=C9joSy2NvxkK3nidKQPNmwgrf8N8FLvEQJTy79+RfEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GaiXA78DfupeCDx0wNk384mBSNnHAnCh1gfACg7p2NtwW/I/rFmCb2Q+XJtbSSroq
	 Ft3P1myC6k/aOqd84zEF8Smh+G6PxfAZXNH/hCMgpetQEZZE+6GTxrWHxgZRvMdam2
	 ew45No9yX8q3r2ili8AGnUKVMucPg7ESGq9VjAKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Roger Quadros <rogerq@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 397/440] phy: cadence-torrent: Check return value on register read
Date: Tue, 30 Jul 2024 17:50:30 +0200
Message-ID: <20240730151631.309672495@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

From: Ma Ke <make24@iscas.ac.cn>

[ Upstream commit 967969cf594ed3c1678a9918d6e9bb2d1591cbe9 ]

cdns_torrent_dp_set_power_state() does not consider that ret might be
overwritten. Add return value check of regmap_read_poll_timeout() after
register read in cdns_torrent_dp_set_power_state().

Fixes: 5b16a790f18d ("phy: cadence-torrent: Reorder few functions to remove function declarations")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Reviewed-by: Roger Quadros <rogerq@kernel.org>
Link: https://lore.kernel.org/r/20240702032042.3993031-1-make24@iscas.ac.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/cadence/phy-cadence-torrent.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/phy/cadence/phy-cadence-torrent.c b/drivers/phy/cadence/phy-cadence-torrent.c
index f099053c583c0..34a380ce533a1 100644
--- a/drivers/phy/cadence/phy-cadence-torrent.c
+++ b/drivers/phy/cadence/phy-cadence-torrent.c
@@ -1087,6 +1087,9 @@ static int cdns_torrent_dp_set_power_state(struct cdns_torrent_phy *cdns_phy,
 	ret = regmap_read_poll_timeout(regmap, PHY_PMA_XCVR_POWER_STATE_ACK,
 				       read_val, (read_val & mask) == value, 0,
 				       POLL_TIMEOUT_US);
+	if (ret)
+		return ret;
+
 	cdns_torrent_dp_write(regmap, PHY_PMA_XCVR_POWER_STATE_REQ, 0x00000000);
 	ndelay(100);
 
-- 
2.43.0



