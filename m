Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F039423EAD;
	Sat, 12 Sep 2026 08:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202454; cv=none; b=AiIt6Qz1zIT0Eg6JN2ca3ti00TPvu/AIQh4Qr7FKt5aoAL5FH10NBfHv/RZjgAdoHJctXllXsdXrCtBLGvg+1NW9voMk300zWHmovQNKUtOLepZYIDohPCLZm7jsH8Q6czhHURWZva/osE6gR0LIgr/UK2VzxfjBLByRbfFemDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202454; c=relaxed/simple;
	bh=cx2KqRuuvK7zAnBXzm6Dp6QXrcvHh4cUNc4oEttMNGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ABLn+g1RISdURgWEr9lmm2zovl0JQXtxIYIx5Ndnu9GrPsYIK8o5Pts9FKwQN2Q2EV6fBULbBqUFpNQfW2uFKgyzTYuKrG0W7PWfDioC/luG8zuLbRZS3kliWK17q1Cpo9WF6pyCOkHYOHAtkGQU63RqmEdL1yzyCQ8nbEf8Pms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S1Yj5mZl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S1Yj5mZl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D32F01F000FF;
	Sat, 12 Sep 2026 08:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202452;
	bh=mFjOrkQqthzJR1oLGFAQ1xdwto0DSMKNXd433mmjd7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S1Yj5mZlWqPGEIS20YLoEicCFNT/9oG9U0f0YBmVjWNfNABoL5kJkThOYrOEkfExQ
	 2b0J//f2VQnxHE/KSOb+GR5hoQkTYQzjNR10th5uxOl+VWd6pBMdDF7BdarYhuCfCl
	 nXq/jPLjfWRzFeGnax3zvXw568kLA7V/gpQNCxRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1206/1815] ASoC: tas675x: sort the register default table
Date: Sat, 12 Sep 2026 08:49:16 +0200
Message-ID: <20260912065717.319926695@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 3521d209ca70bf77b8c1dcccab5ca4df9468877f ]

reg_defaults must be sorted by ascending register address, as
regcache_lookup_reg() locates entries in it with bsearch().  See commit
fd80df352ba1 ("regcache: Add support for sorting defaults arrays").

TAS675X_AC_LDG_CTRL_REG (0xb5), TAS675X_TWEETER_DETECT_CTRL_REG (0xb6),
TAS675X_TWEETER_DETECT_THRESH_REG (0xb7) and TAS675X_AC_LDG_FREQ_CTRL_REG
(0xb8) are listed before the 0x7c - 0xa0 block, which leaves 14 of the
69 entries unreachable.  regcache_reg_needs_sync() then cannot compare
them against their default and reports that a sync is needed, so they
are written to the device on every regcache_sync() even when they were
never touched.

Sort the table by register address.

Fixes: 133c81f84471 ("ASoC: codecs: Add TAS67524 quad-channel audio amplifier driver")
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260805104149.9795-6-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas675x.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/sound/soc/codecs/tas675x.c b/sound/soc/codecs/tas675x.c
index 82526362de7be..404706b621567 100644
--- a/sound/soc/codecs/tas675x.c
+++ b/sound/soc/codecs/tas675x.c
@@ -1924,15 +1924,6 @@ static const struct reg_default tas675x_reg_defaults[] = {
 	{ TAS675X_PWM_PHASE_M_CTRL_CH2_REG, 0x00 },
 	{ TAS675X_PWM_PHASE_M_CTRL_CH3_REG, 0x00 },
 	{ TAS675X_PWM_PHASE_M_CTRL_CH4_REG, 0x00 },
-	{ TAS675X_DC_LDG_CTRL_REG,         0x00 },
-	{ TAS675X_DC_LDG_LO_CTRL_REG,      0x00 },
-	{ TAS675X_DC_LDG_TIME_CTRL_REG,    0x00 },
-	{ TAS675X_DC_LDG_SL_CH1_CH2_CTRL_REG, 0x11 },
-	{ TAS675X_DC_LDG_SL_CH3_CH4_CTRL_REG, 0x11 },
-	{ TAS675X_AC_LDG_CTRL_REG,         0x10 },
-	{ TAS675X_TWEETER_DETECT_CTRL_REG, 0x08 },
-	{ TAS675X_TWEETER_DETECT_THRESH_REG, 0x00 },
-	{ TAS675X_AC_LDG_FREQ_CTRL_REG,    0xC8 },
 	{ TAS675X_REPORT_ROUTING_1_REG,    0x00 },
 	{ TAS675X_OTSD_RECOVERY_EN_REG,    0x00 },
 	{ TAS675X_REPORT_ROUTING_2_REG,    0xA2 },
@@ -1943,6 +1934,15 @@ static const struct reg_default tas675x_reg_defaults[] = {
 	{ TAS675X_GPIO1_OUTPUT_SEL_REG,    0x00 },
 	{ TAS675X_GPIO2_OUTPUT_SEL_REG,    0x00 },
 	{ TAS675X_GPIO_CTRL_REG,           TAS675X_GPIO_CTRL_RSTVAL },
+	{ TAS675X_DC_LDG_CTRL_REG,         0x00 },
+	{ TAS675X_DC_LDG_LO_CTRL_REG,      0x00 },
+	{ TAS675X_DC_LDG_TIME_CTRL_REG,    0x00 },
+	{ TAS675X_DC_LDG_SL_CH1_CH2_CTRL_REG, 0x11 },
+	{ TAS675X_DC_LDG_SL_CH3_CH4_CTRL_REG, 0x11 },
+	{ TAS675X_AC_LDG_CTRL_REG,         0x10 },
+	{ TAS675X_TWEETER_DETECT_CTRL_REG, 0x08 },
+	{ TAS675X_TWEETER_DETECT_THRESH_REG, 0x00 },
+	{ TAS675X_AC_LDG_FREQ_CTRL_REG,    0xC8 },
 	{ TAS675X_OTW_CTRL_CH1_CH2_REG,    0x11 },
 	{ TAS675X_OTW_CTRL_CH3_CH4_REG,    0x11 },
 };
-- 
2.53.0



