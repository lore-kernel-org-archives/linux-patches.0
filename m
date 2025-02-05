Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774961537AC;
	Wed,  5 Feb 2025 13:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763904; cv=none; b=fuqXpXzTvQSzdc8t/q1WYuDcORYn3zpbXdxXqTaO62xed2r/jpABVATcuexhZPTic9lsBBlECNcHjMDc+G4X4omS42zTPoiMfROhS74zMd2QnP3Ri7yqpzFZ9qewKSTBvhTNVlTIm6JeGlvtRxG2qXIEbDbwkGKnSnPygk66nxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763904; c=relaxed/simple;
	bh=tSpLGOLlpxN/nXWUUEh93rZ3i2zjHOu0/A9142M49m8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BkHP8eUeLoA/hhZoq0DOR5mnyu0UFeynL7EbkXyOcYKbW2Vvoh68+XGOB7qekMINyXYqezg8b5HRNOm/EQ4A1Ev9+SGrMmclx1KfwdGhEIm2Ue2l5u6LuaRggbhijNScUpOwy1+YnPIh+JVlMw+Ai3cggbJrDFGrifwEaE5V07I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h4oD8Uuu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h4oD8Uuu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D850DC4CED1;
	Wed,  5 Feb 2025 13:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763904;
	bh=tSpLGOLlpxN/nXWUUEh93rZ3i2zjHOu0/A9142M49m8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h4oD8UuumeOKG9+09D3PKXKZFKXtgyokjRACZwq7436eRns4KrXipuN189386b2xN
	 KXI83jlC0NmN6SSWNOKOW/jwA305m24qXL2U7X76RkEW3dK02AXMyypn70I4KY9066
	 TWchVl6MzAV9+p/h0bn5Ono9knWHxVUonuyw+0zA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xueqin Luo <luoxueqin@kylinos.cn>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 118/393] wifi: mt76: mt7915: fix overflows seen when writing limit attributes
Date: Wed,  5 Feb 2025 14:40:37 +0100
Message-ID: <20250205134424.805064406@linuxfoundation.org>
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

From: xueqin Luo <luoxueqin@kylinos.cn>

[ Upstream commit 64d571742b0ae44eee5efd51e2d4a09d7f6782fc ]

DIV_ROUND_CLOSEST() after kstrtoul() results in an overflow if a large
number such as 18446744073709551615 is provided by the user.
Fix it by reordering clamp_val() and DIV_ROUND_CLOSEST() operations.
This commit was inspired by commit: 57ee12b6c514.

Fixes: 02ee68b95d81 ("mt76: mt7915: add control knobs for thermal throttling")
Signed-off-by: xueqin Luo <luoxueqin@kylinos.cn>
Link: https://patch.msgid.link/20241202031917.23741-3-luoxueqin@kylinos.cn
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/init.c b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
index 5ff260319282c..28f84220d50f0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -82,7 +82,7 @@ static ssize_t mt7915_thermal_temp_store(struct device *dev,
 		return ret;
 
 	mutex_lock(&phy->dev->mt76.mutex);
-	val = clamp_val(DIV_ROUND_CLOSEST(val, 1000), 60, 130);
+	val = DIV_ROUND_CLOSEST(clamp_val(val, 60 * 1000, 130 * 1000), 1000);
 
 	if ((i - 1 == MT7915_CRIT_TEMP_IDX &&
 	     val > phy->throttle_temp[MT7915_MAX_TEMP_IDX]) ||
-- 
2.39.5



