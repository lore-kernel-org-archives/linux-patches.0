Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0CC14F9E7;
	Wed,  5 Feb 2025 13:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763801; cv=none; b=BuF4BciHSnATivr3zmc/RzpM2LwNREO1wMNJIDo05iAJX0iZ5OVKJMdk6mtry9tVYBRH8avpbSyKg/ymZ4JH0HMpA6I1b/hWGtL85bd94cQi05/Xfa8Om3CSx6TMxnIA8fOD0+1EE+OlQ17/vo4Vj1zFY9fezc8tnBOxuZWaRAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763801; c=relaxed/simple;
	bh=sV3Oz4AXC+lZssqLRbU8jjlxHigP4kmVxMWEFb16dfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZRPaRWUfuWCZGI1p+b0cMhODrIFh0r9CrGBQH09R7qnNyO8RW0mmsoAq3Y9J/ial6bWytDESsZSeOKe+N0UPw499bfyqnj0MVDgguAy53wbfqDAIRhD6+VRba1aKrIAQV6vub3cEoZlxJMtsJr1A6ATf/2p2Dwkwd4aoFJOs9Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SqcephLV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SqcephLV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DF27C4CED1;
	Wed,  5 Feb 2025 13:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763801;
	bh=sV3Oz4AXC+lZssqLRbU8jjlxHigP4kmVxMWEFb16dfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SqcephLVrVOyojlM4Mly7Aql9RugNHfHp39GPfzXhESYJAMNXI4GOY2xkoKtGu4PV
	 JQZVCl0/1nQxSB4pcqrlEJVOqDL9tUTXo2scoz+l3JmY8pmI9idvuQzj80lgfiDlCZ
	 OSl31PtCmji5qOZaBzu8+CDSKrcGzn0u9mT/tz7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Kemnade <andreas@kemnade.info>,
	Michael Nemanov <michael.nemanov@ti.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 107/393] wifi: wlcore: fix unbalanced pm_runtime calls
Date: Wed,  5 Feb 2025 14:40:26 +0100
Message-ID: <20250205134424.392481345@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Kemnade <andreas@kemnade.info>

[ Upstream commit 996c934c8c196144af386c4385f61fcd5349af28 ]

If firmware boot failes, runtime pm is put too often:
[12092.708099] wlcore: ERROR firmware boot failed despite 3 retries
[12092.708099] wl18xx_driver wl18xx.1.auto: Runtime PM usage count underflow!
Fix that by redirecting all error gotos before runtime_get so that runtime is
not put.

Fixes: c40aad28a3cf ("wlcore: Make sure firmware is initialized in wl1271_op_add_interface()")
Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
Reviewed-by: Michael Nemanov <michael.nemanov@ti.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://patch.msgid.link/20250104195507.402673-1-akemnade@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ti/wlcore/main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index bf21611872a3c..9706240ddd416 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -2533,24 +2533,24 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 	if (test_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS, &wl->flags) ||
 	    test_bit(WLVIF_FLAG_INITIALIZED, &wlvif->flags)) {
 		ret = -EBUSY;
-		goto out;
+		goto out_unlock;
 	}
 
 
 	ret = wl12xx_init_vif_data(wl, vif);
 	if (ret < 0)
-		goto out;
+		goto out_unlock;
 
 	wlvif->wl = wl;
 	role_type = wl12xx_get_role_type(wl, wlvif);
 	if (role_type == WL12XX_INVALID_ROLE_TYPE) {
 		ret = -EINVAL;
-		goto out;
+		goto out_unlock;
 	}
 
 	ret = wlcore_allocate_hw_queue_base(wl, wlvif);
 	if (ret < 0)
-		goto out;
+		goto out_unlock;
 
 	/*
 	 * TODO: after the nvs issue will be solved, move this block
@@ -2565,7 +2565,7 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 
 		ret = wl12xx_init_fw(wl);
 		if (ret < 0)
-			goto out;
+			goto out_unlock;
 	}
 
 	/*
-- 
2.39.5



