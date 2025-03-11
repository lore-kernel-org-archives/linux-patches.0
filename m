Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15AF41BD00C;
	Tue, 11 Mar 2025 15:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706401; cv=none; b=SusPTqxNQccFPv0YAz9tLBEmBzYAVJYcd6m/lMwpBU3210cn0P0vRcSaSaEd8vMaGcfCz8mZnTprcSDbO3QQ2z+FvuJK6zk8c0prOvvLWmterSpJ8BpNXffSeCD7OhtPDBx3DD3YkzOZWL1ddAwD5CaM3b2YBttLQrrN+fDiwsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706401; c=relaxed/simple;
	bh=4AvFVfFnc3whCgHg/Yv7emryCLk6mmsjjzk8Be+ptVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S1IHDPBLoK8e+rXHkUCbPFpSJP2EWdH0A7k9xN8QSnrhjCT/BDoyPcQZZqE5ZHqyTh4PeL8W/8id6VRXmZ5XDq7fx/zXCmrpICJVjfX6Ylfad52RfVBVq8VxmzFLovCGmm01/aR/MxKV0qpd9HeOz/2Ed39+I/nhN9sBuUi/F8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZO761mCf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZO761mCf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E1DCC4CEE9;
	Tue, 11 Mar 2025 15:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706400;
	bh=4AvFVfFnc3whCgHg/Yv7emryCLk6mmsjjzk8Be+ptVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZO761mCfvm5+xGFamyuqNoYdUAj4Mt1f1xoXX51pGfLePECkjT89LMiJjaftSumjk
	 anSZyNshtPNpCIY/1PXMP067Zage6TVpzonDCTTyXA8VnaPgjdP0OdoVPXtdtIu2qA
	 oFEQT0hzJZQAZkRlwNhq+V+szSqKHJn8m+NoZzdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Kemnade <andreas@kemnade.info>,
	Michael Nemanov <michael.nemanov@ti.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 035/462] wifi: wlcore: fix unbalanced pm_runtime calls
Date: Tue, 11 Mar 2025 15:55:01 +0100
Message-ID: <20250311145759.742131611@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6e402d62dbe4a..109c51e497926 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -2552,24 +2552,24 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
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
@@ -2584,7 +2584,7 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 
 		ret = wl12xx_init_fw(wl);
 		if (ret < 0)
-			goto out;
+			goto out_unlock;
 	}
 
 	/*
-- 
2.39.5



