Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1668D1A76B7;
	Tue, 30 Jul 2024 17:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359671; cv=none; b=HpLmi28ilthsWPUY8R7pWc094LzPgJRPboxJtaSjxDf3HuXTUF2XEQeudvnjbSAwVX7ugPOBKeWU8/Ulo9owF3ocu0mQh/5CIYGvT3DQgTF7X8Wm/hpl/uQH9J/omzD6ZlO5xLHgcIDkMnnX3Ni2EE6L7K2xSdS/kCYVT6Pf0aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359671; c=relaxed/simple;
	bh=dDT7yyOaZEc8XUrYiJrlkYNrOuXzQPBICHrzZCO/LOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kMI0S0C8Rq48KB3gredvV6PwzBzetW24pUFWq+Woki5ujWOvJ/+tePYIqWmzt14y8XFa2j/89Abm6FynRPKYVUeAEkCJGBstZ6EasmrpnqrG0ZK6ptqV5oiwI2zLZNC0wHP3fyLcYqp8lgProBO/bm0CQEN1kxpP/POdYg0vIZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sjo6EPpH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sjo6EPpH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A61DC4AF0A;
	Tue, 30 Jul 2024 17:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359670;
	bh=dDT7yyOaZEc8XUrYiJrlkYNrOuXzQPBICHrzZCO/LOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sjo6EPpH5IsD/FSw8TRn5Oj4F7/UxzPzgCWh9s3th750cxnp0f+Kaj/zR0Ajq839H
	 RBouRQERhiQbBolGxwoOOqKhQfXyD6tk/GAYVpZvhPOQvPV5RWMso26ty//NPERxFe
	 lz8rcYdUXKB7GCuzTzgsVA/apTyitOpJTkwlgN58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Roger Quadros <rogerq@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 520/568] phy: cadence-torrent: Check return value on register read
Date: Tue, 30 Jul 2024 17:50:27 +0200
Message-ID: <20240730151700.481061913@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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
index a75c96385c57a..a23d7f9b7d10f 100644
--- a/drivers/phy/cadence/phy-cadence-torrent.c
+++ b/drivers/phy/cadence/phy-cadence-torrent.c
@@ -1154,6 +1154,9 @@ static int cdns_torrent_dp_set_power_state(struct cdns_torrent_phy *cdns_phy,
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



