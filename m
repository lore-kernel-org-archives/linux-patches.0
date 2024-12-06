Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE75F53A7;
	Fri,  6 Dec 2024 15:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497789; cv=none; b=VgNxubwbpJibspCFuqktL4SNMFrb+nfJ2X90D7bXo97fWeEheLC/WwYBrnx3My/sn2ujNJj1p+70fRTpFPhlpZ10klY8/IIOP70dxZD6tNn/XixxyU0YefRfVhgOJQPUfa9CQkmWPkdXE0crKNWhjCzyK1NPoqfIVPCQ0gNp9Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497789; c=relaxed/simple;
	bh=3vxMxLEAn9t8azF+L+rmygspZcXy5t/Bz7XKgFwx53Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FJoUEP8/aP+lRXKF0B93WZjEgeyOxmHqzgOL1RdDxR92Fd6GKxLLxk3iPDQnD5xeMBvUeop0vIhN6twtgFTYkKojV9xHNJoucJXLz/CT8VqmB4HZRWhh+xpEczXt2CUwE2ZYihnE2alBNqlvV7vwA1rgzKR6Id4S7/Yg9pbW5IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dd9KKV5m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dd9KKV5m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F013C4CED1;
	Fri,  6 Dec 2024 15:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497788;
	bh=3vxMxLEAn9t8azF+L+rmygspZcXy5t/Bz7XKgFwx53Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dd9KKV5mU3B2IPKVGxCMCG1f4PXqttLZ06iI5C83cjZfjb3Dwlc0qP5wEtWCG+hSZ
	 plPUfJBGaJbQ19YTXE6LLd26E21YOymj0wRmdOwuMNSbTuHKTA67uw9JHU+Vvuam0f
	 909Ask2reiSnB0W8TAtH/ZSFoylFjqhp221EGtpM=
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
Subject: [PATCH 6.6 394/676] power: supply: core: Remove might_sleep() from power_supply_put()
Date: Fri,  6 Dec 2024 15:33:33 +0100
Message-ID: <20241206143708.741228173@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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
index 416409e2fd6da..1893d37dd575d 100644
--- a/drivers/power/supply/power_supply_core.c
+++ b/drivers/power/supply/power_supply_core.c
@@ -480,8 +480,6 @@ EXPORT_SYMBOL_GPL(power_supply_get_by_name);
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



