Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575E01F76DB;
	Tue,  3 Dec 2024 16:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242004; cv=none; b=pA8O6ujMG6i050k6B3E5iZENtWsPoYNVvWQ91ezj0e+a9zytEX4dE4wgF/5rQ7K1+2vovPE12TL+o190ysyFlkjrBSpROAfQ7TmOwFewI56Gs4RrDZP+Nk3G1JLtGJDUflzooaAK7mRIcRfuQ27DNU8vTOm9QvldDSzs7jwPAsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242004; c=relaxed/simple;
	bh=ffZOYcE8Xmu+LPX2AEBuLuNdqZcrHZ9k75QEzHc5oJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UzD+CtuUBprJs2hjOHrL9CndQqIJRZ/ZAfuQVE5bY5qF08kSjG2cGxfyoM3D3KGY18XueH/at4roZHXkGCCq4kXqunYx6Rz+N6GW/RKGSCfEw6jBBAQ/IPvquXC0v1GXYvimIEDOE4NLBFueiqVeLQHCZEFUWOT+jRHCOhv86C0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CqXZvLDF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CqXZvLDF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5E3FC4CECF;
	Tue,  3 Dec 2024 16:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242004;
	bh=ffZOYcE8Xmu+LPX2AEBuLuNdqZcrHZ9k75QEzHc5oJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CqXZvLDFvWz7Ob9Ub+1f+27WBidw4+Jq2aCCzJbYLN5OssBUK7jZGynN8JJ+kNLRg
	 IpIsDwQ3Mv4UBxMB/xKfeDKyjmz74gRv5zDaA4ewjQNPGOpU8NKyYXeeQGP9q5PDGM
	 vY4HezkuQIBipDn8rnO4uQkKP9KPTG5zJft3hf3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Tso <kyletso@google.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 548/826] power: supply: core: Remove might_sleep() from power_supply_put()
Date: Tue,  3 Dec 2024 15:44:35 +0100
Message-ID: <20241203144805.126961428@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit f6da4553ff24a5d1c959c9627c965323adc3d307 ]

The put_device() call in power_supply_put() may call
power_supply_dev_release(). The latter function does not sleep so
power_supply_put() doesn't sleep either. Hence, remove the might_sleep()
call from power_supply_put(). This patch suppresses false positive
complaints about calling a sleeping function from atomic context if
power_supply_put() is called from atomic context.

Cc: Kyle Tso <kyletso@google.com>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Fixes: 1a352462b537 ("power_supply: Add power_supply_put for decrementing device reference counter")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20240917193914.47566-1-bvanassche@acm.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/power_supply_core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/power/supply/power_supply_core.c b/drivers/power/supply/power_supply_core.c
index 49534458a9f7d..73cc9c236e833 100644
--- a/drivers/power/supply/power_supply_core.c
+++ b/drivers/power/supply/power_supply_core.c
@@ -484,8 +484,6 @@ EXPORT_SYMBOL_GPL(power_supply_get_by_name);
  */
 void power_supply_put(struct power_supply *psy)
 {
-	might_sleep();
-
 	atomic_dec(&psy->use_cnt);
 	put_device(&psy->dev);
 }
-- 
2.43.0



