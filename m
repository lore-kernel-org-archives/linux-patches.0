Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4D41F668A;
	Tue,  3 Dec 2024 14:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236677; cv=none; b=P51rtbxkv3PDUBC/lYveU3kp0Vhl1oZhKC8MG9Bu7KS51gDP37EaARzErCxnkDEKkTR2mfnJJsdK50EBrYprxEV035dwdZeT6TbPzWQL7v1mbmPXWH1uWP9t3b2OYq/DlnqY9Y0Vh7mokOFFD3n+XIHV13HLWRFlG7z+OR/ofbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236677; c=relaxed/simple;
	bh=Wy3qPFCtKj5qqYB73URvatoVL38Oa/a9ag+tK3qe9c4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kFpoEKTaNHsYHLDJqv353XASoZO+JpX+ScNa7rc1uNv2x83qh/vZAKkRV/t2hDDx/AB+1RqPJ5esprmu2u9UZHpsVzjxseCAquBx4VaFILWLqwutTAG/uxkEjlyFMZmDgTBFd1UouYTRIWBMc3JKHdgkM4YRJudIA4Ccpfe7Te0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r9+QDeel; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r9+QDeel"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CD3EC4CED6;
	Tue,  3 Dec 2024 14:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236676;
	bh=Wy3qPFCtKj5qqYB73URvatoVL38Oa/a9ag+tK3qe9c4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r9+QDeel3rbX+Eqixxo5pVeVr8pTJigXpOZH7EczXdDhTgzupTbSZOGZ4UbhDQodz
	 k9Mz6y3/rhoNHRhuDnSLu6ymnsc11l1f3dJhmtHG4ZoZ071NkBmRw8nE0kRLkm/H5r
	 GCQNypblIYn/wMTFhJW0YJZuYY3H2DjU8rZEVsOU=
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
Subject: [PATCH 4.19 088/138] power: supply: core: Remove might_sleep() from power_supply_put()
Date: Tue,  3 Dec 2024 15:31:57 +0100
Message-ID: <20241203141926.935109617@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 3715a6c2955b2..b89d89455bcb3 100644
--- a/drivers/power/supply/power_supply_core.c
+++ b/drivers/power/supply/power_supply_core.c
@@ -482,8 +482,6 @@ EXPORT_SYMBOL_GPL(power_supply_get_by_name);
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



