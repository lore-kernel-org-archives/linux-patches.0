Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E247215F7C;
	Tue, 29 Apr 2025 17:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948067; cv=none; b=mPnqtC3EYw4MY5BKEJCECTfOFwoV7JehI52g8StWn1aXu+h/3b17FFHngSNDccIeZn8n/hTny3LRjROf4H7akHuo3EgvpUaXLSLBTXacAX/Ui1rWaisribJLQ4KNdBlPQO9CVHDJ+dd+PQgf/+STEc3Sa6RpHmYyV6zCGbxy6y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948067; c=relaxed/simple;
	bh=88CJpDiiqLrpe8diGmUlTPTmI7nC9w25DQ/Lup4WX8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=scKkWRWJ3JrkgTNRS8pPSPYDbw3xXSpe592WVqYGiGcokvWBYyCtWKK12aIUoZN6WRJA+m6Tfa5hs2G1IayaAocQvmTwrl2KOz07gkGJfQvsfgrCQPPTFmxhOllluOHxTKqhfuGnOZJRp3WrQX0KUmc+TXA0KBc9exTacaRqREE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ufaop5uN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ufaop5uN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45006C4CEE3;
	Tue, 29 Apr 2025 17:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948066;
	bh=88CJpDiiqLrpe8diGmUlTPTmI7nC9w25DQ/Lup4WX8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ufaop5uNHQKhU7Lw0teExQSCvQUjCEFEh3GLtr4ptUQyjWvSegRbJCU0uNWGgHSHM
	 p+lZAUExy4dFUiKnKFhFYdzVzqZ+iTiETuAouUx8i47LQP8adqRGrQXj8zALqdll6b
	 CciAmcQSuDqZ+aPPyO5OajCuhBhsWMDwmtFLFpOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andy.yan@rock-chips.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 182/280] phy: rockchip: usbdp: Avoid call hpd_event_trigger in dp_phy_init
Date: Tue, 29 Apr 2025 18:42:03 +0200
Message-ID: <20250429161122.555838975@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

From: Andy Yan <andy.yan@rock-chips.com>

[ Upstream commit 28dc672a1a877c77b000c896abd8f15afcdc1b0c ]

Function rk_udphy_dp_hpd_event_trigger will set vogrf let it
trigger HPD interrupt to DP by Type-C. This configuration is only
required when the DP work in Alternate Mode, and called by
typec_mux_set. In standard DP mode, such settings will prevent
the DP from receiving HPD interrupts.

Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
Link: https://lore.kernel.org/r/20250302115257.188774-1-andyshrk@163.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-usbdp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/phy/rockchip/phy-rockchip-usbdp.c b/drivers/phy/rockchip/phy-rockchip-usbdp.c
index 2c51e5c62d3eb..f5c6d264d89ed 100644
--- a/drivers/phy/rockchip/phy-rockchip-usbdp.c
+++ b/drivers/phy/rockchip/phy-rockchip-usbdp.c
@@ -1045,7 +1045,6 @@ static int rk_udphy_dp_phy_init(struct phy *phy)
 	mutex_lock(&udphy->mutex);
 
 	udphy->dp_in_use = true;
-	rk_udphy_dp_hpd_event_trigger(udphy, udphy->dp_sink_hpd_cfg);
 
 	mutex_unlock(&udphy->mutex);
 
-- 
2.39.5



