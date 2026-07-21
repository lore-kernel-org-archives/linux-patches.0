Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48EDA376A06;
	Tue, 21 Jul 2026 17:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653738; cv=none; b=Oggt995YCa8a5R0O33MWhcd/TpkfScNHJLQ8PFoEhiPabizH7bZWX8ZFnA5oXOrF8cgnA499URGlHT/xhET8mu9JbYmYgdEPLYiKXZEjydtkpon+Y6+LOKUa2zqJusRiQCshCLtH+3EyexP54IXe79Zm65+lyIMzi+2wUtmV5tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653738; c=relaxed/simple;
	bh=nwwmZEQJgK1ogmfNcZGPE7+iYE1tcolGcLcOS48EFDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NnWu2IMxOb/kvfAUl/4rXkHnbFRJnNM/xvBiYZs13oEOALT9yCBCLjEKw+tonER+v5z9A6lJND+XP7AEjtmWjJvELh3A5N++OLbKx6wpNKOasgMmrS8babVYwfQ2Azybiy94zk6uwYHuSyGhklSNMD/YyAUs9cUlIjkHi1gJcP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BBPspVVH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BBPspVVH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B051B1F000E9;
	Tue, 21 Jul 2026 17:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653737;
	bh=WPOBIn15ljtw3MxmW7+On338aEy3SiGhiKzNyqxMYAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BBPspVVHv3Zl2iSMkablhOmF4wWaavcjxXhlZ+NfcPXr0M2/9BGzI2/8dOVyiYD8i
	 akhDi0i5GAWpZ/3Mi0nQwjblv11RXLwfi742YzfiRRdtr7O1XwR1BGdkp+1cRateVX
	 ANQul6tSTQ6gQukhSv0lejNBKvF8JRQSSJ9sdqPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicente Bergas <vicencb@gmail.com>,
	Damon Ding <damon.ding@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1441/2077] drm/bridge: analogix_dp: Fix PE/VS value shift mismatch during link training
Date: Tue, 21 Jul 2026 17:18:34 +0200
Message-ID: <20260721152626.793662008@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damon Ding <damon.ding@rock-chips.com>

[ Upstream commit 6bb8898f702385d363dc2c513a1efa62807f8068 ]

VS/PE values returned by drm_dp_get_adjust_request_voltage() and
drm_dp_get_adjust_request_pre_emphasis() are already encoded to their
native DPCD register bit positions. However, DPCD_VOLTAGE_SWING_SET /
DPCD_PRE_EMPHASIS_SET macros perform an extra internal shift. Feeding
the raw offset-bearing values directly leads to overlapping bitfields
and invalid lane training configuration, causing link training failures
and black screen.

Add right shift using DP_TRAIN_*_SHIFT constants to strip the DPCD bit
offsets before passing values to the SET macros and subsequent checks.
Apply this fix for both clock recovery and adjust training code paths.

Reported-by: Vicente Bergas <vicencb@gmail.com>
Closes: https://lore.kernel.org/all/CAAMcf8D-d+5n=H44KeKBSqWY42m+o32W+mO-r15VqWNyYhJL7Q@mail.gmail.com/
Fixes: d84b087c7662 ("drm/bridge: analogix_dp: Apply DP helper APIs to get adjusted voltages and pre-emphasises")
Signed-off-by: Damon Ding <damon.ding@rock-chips.com>
Link: https://lore.kernel.org/all/CAAMcf8D-d+5n=H44KeKBSqWY42m+o32W+mO-r15VqWNyYhJL7Q@mail.gmail.com/
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patch.msgid.link/20260623023506.309858-1-damon.ding@rock-chips.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/analogix/analogix_dp_core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
index 8dee5f2fbde516..00fe1f7893fba3 100644
--- a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
+++ b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
@@ -306,7 +306,9 @@ static void analogix_dp_get_adjust_training_lane(struct analogix_dp_device *dp,
 	lane_count = dp->link_train.lane_count;
 	for (lane = 0; lane < lane_count; lane++) {
 		voltage_swing = drm_dp_get_adjust_request_voltage(link_status, lane);
+		voltage_swing >>= DP_TRAIN_VOLTAGE_SWING_SHIFT;
 		pre_emphasis = drm_dp_get_adjust_request_pre_emphasis(link_status, lane);
+		pre_emphasis >>= DP_TRAIN_PRE_EMPHASIS_SHIFT;
 		training_lane = DPCD_VOLTAGE_SWING_SET(voltage_swing) |
 				DPCD_PRE_EMPHASIS_SET(pre_emphasis);
 
@@ -352,7 +354,9 @@ static int analogix_dp_process_clock_recovery(struct analogix_dp_device *dp)
 	for (lane = 0; lane < lane_count; lane++) {
 		training_lane = analogix_dp_get_lane_link_training(dp, lane);
 		voltage_swing = drm_dp_get_adjust_request_voltage(link_status, lane);
+		voltage_swing >>= DP_TRAIN_VOLTAGE_SWING_SHIFT;
 		pre_emphasis = drm_dp_get_adjust_request_pre_emphasis(link_status, lane);
+		pre_emphasis >>= DP_TRAIN_PRE_EMPHASIS_SHIFT;
 
 		if (DPCD_VOLTAGE_SWING_GET(training_lane) == voltage_swing &&
 		    DPCD_PRE_EMPHASIS_GET(training_lane) == pre_emphasis)
-- 
2.53.0



