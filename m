Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1525286A3;
	Tue, 30 Jul 2024 17:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360580; cv=none; b=b/td3T2Q0CQE3W29bq5/TXjxbGgFfV8ljd5WplkH3fJ+AT7zNfIbRmxDtW8tGPLbTEg9AkbXmknOSLH/0qglu9OKYdh4ScX2Jixmck4yk2pWcuiAbh3d1MGTFWVs+GpFKFoTPrYRwulVK2wU2cEsrBTO+WevenxBACpxeenyx38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360580; c=relaxed/simple;
	bh=0/Y6LL/G47Sh3gGPeW6i9JHiv8QzC09EznejKWcqb98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LrIn9luaILN55nFddj6MciGbxchbLuYTM5K2uaU3Q7xyBzmiDEkPWUI1EhdLPjtGCHp8ji0TINuW4HI5GVK94cs+e1l8gx0oVBGII7gP0x17D0sgr+ybn/MU7EEe8VqtGxFJGfQxJVGFUXUDwratvDlgrym5CirksAdckcgDfig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wzvwUnB0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wzvwUnB0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D90C4AF0C;
	Tue, 30 Jul 2024 17:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360579;
	bh=0/Y6LL/G47Sh3gGPeW6i9JHiv8QzC09EznejKWcqb98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wzvwUnB0ziPFWRNQ+PxYfiC53UkA0MJw6tqiyQL9hntJDCs9KblkYiHuj5EESZBZ7
	 nTbeL+N+qe0gph/30WzuQWsyJcls0jn2hexpLJAdDw2FiJWEU0IC9jx1XF9goZC1W3
	 quQDPCO7qoa0szqm1P1SVpIJwdcm2+6H/DiW3l4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Roger Quadros <rogerq@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 743/809] phy: cadence-torrent: Check return value on register read
Date: Tue, 30 Jul 2024 17:50:19 +0200
Message-ID: <20240730151754.302266184@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 95924a09960cc..6113f0022e6ee 100644
--- a/drivers/phy/cadence/phy-cadence-torrent.c
+++ b/drivers/phy/cadence/phy-cadence-torrent.c
@@ -1156,6 +1156,9 @@ static int cdns_torrent_dp_set_power_state(struct cdns_torrent_phy *cdns_phy,
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



