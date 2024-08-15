Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC6918D630;
	Thu, 15 Aug 2024 13:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730101; cv=none; b=J8jgcy7ZSSkSwBX5RYhOfpph1QtHXN6tSgtx4JJSnTJvEw0pMRDs4vHX0is1QmmuL6NmO1I9e2NOiidP2Wf2IrIpXzIGL9M7DQjISYqC9Ki09icfMwnyk/9wEGQq9n3rM9SPQm//lY3txHv4jiWNgm1nw9LgNQZwr0tuiAotdfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730101; c=relaxed/simple;
	bh=3o9kaZXZecxFVM+eadTESP3bdRyuBt6EWU59TVw3kw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ast+igD1eRYQ8QD0UkHYg66bb1HlYmt5vnwoD5kFI5bPTWmAY1ob+UaiPEOozGmSt/qurpl85fEyIEpX795HtWxpUt799vERRXKXeE6n4XhRJcGxvVk3x+NvXEMx8utvEjHQZD6rHflGx6LA1K0N39hmloFjSDO6SuA522fZX2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=foKvLrok; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="foKvLrok"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F29DDC32786;
	Thu, 15 Aug 2024 13:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730101;
	bh=3o9kaZXZecxFVM+eadTESP3bdRyuBt6EWU59TVw3kw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=foKvLrokCF1X3U8WU8DBseUSsyrx1lQGX0jwWOaB05wsIPJIGWV/TCisijOQcQKYU
	 wuuGIuLUoTMq3kiBB8oJKZHPKLZcgp2CyclRRIlfWul73ncfjy1Eeot9qHGVuuFeFj
	 w3i1KNJtsN355ypYYF3zCJrxIqI/9zdkwV7l76jE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Roger Quadros <rogerq@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 264/484] phy: cadence-torrent: Check return value on register read
Date: Thu, 15 Aug 2024 15:22:02 +0200
Message-ID: <20240815131951.598991517@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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
index 415ace64adc5c..8f23146d62bf0 100644
--- a/drivers/phy/cadence/phy-cadence-torrent.c
+++ b/drivers/phy/cadence/phy-cadence-torrent.c
@@ -1056,6 +1056,9 @@ static int cdns_torrent_dp_set_power_state(struct cdns_torrent_phy *cdns_phy,
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



