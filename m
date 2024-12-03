Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A8C1EF0AE;
	Tue,  3 Dec 2024 15:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239288; cv=none; b=orbSBoD/dqcT8Y1eKSao4pJtUZtRwccOaKeLWOPhyk3hoSJ8HIR3DVH7mcv3HU3DfLHdR2F1o6MNPbvTRv5a08Bras9XfUX28IXiFu1NgT9lEau5Ra+5HoiZ/gPGB5+5mcbkoozNYRhum43FrQF//y4kAIZ3oLb1T52Lscqc1Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239288; c=relaxed/simple;
	bh=zs8ILcSfykSA60K89fdWjh/GsV0kaWq3SxOAx9FONgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QlaD1gv/x2h3ePoLlwLzCfPfxlHV1ZMHP+C7fOgoJ8R+OhEAz5+2T6pK7gQNH2/SypDYMQfAcsvtfj1ZvVL60r+8aHuh7UAFHm2ACVKHvA5mQM+tDE12smrfFrEuvxB4wpayOQlbtX4gxhIPXn8fZzMI4RDuITV/Sdx31LhL2pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qplOnr4V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qplOnr4V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CF23C4CED6;
	Tue,  3 Dec 2024 15:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239288;
	bh=zs8ILcSfykSA60K89fdWjh/GsV0kaWq3SxOAx9FONgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qplOnr4Vwbk043yvyKGZ3YKeBagF2IGicFHu58sL1hKq62c02WYaM9X45gAucdFmV
	 AP6Flk/ImToJzsUX+k+naBtSVrfYUNSyRtiVFZF1dZ1fG0IZLDz6C+XAOtetqH1KwZ
	 PU+k70s5dPgNDjVy4n1nBHAzsoAotRGDAuHFfWX0=
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
Subject: [PATCH 6.11 562/817] power: supply: core: Remove might_sleep() from power_supply_put()
Date: Tue,  3 Dec 2024 15:42:14 +0100
Message-ID: <20241203144017.846852279@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index b43c2557241e7..06ce24abbe77f 100644
--- a/drivers/power/supply/power_supply_core.c
+++ b/drivers/power/supply/power_supply_core.c
@@ -483,8 +483,6 @@ EXPORT_SYMBOL_GPL(power_supply_get_by_name);
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



