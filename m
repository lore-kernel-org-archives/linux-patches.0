Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061162;
	b=aVx8Jj2xpKhAD6m9PWh8X3kJkSzv33MYFIvN4yG+QzqwcqE8sgaY4T1jPx3dHcR33ul7
	 8ndU0162UeWCit3XPm3cMiRrEtc8lZXVeOcMWv+eKk4w2d7togH2uHMX3IPyIQwLDktjd
	 yCzzipzxOBtHT4qb+WxAzsSFNLK2e8/M4/TUfRzoJ0XG7ffYRLTsuUbVssh1Hx8gK5y5O
	 fwyHucJkpO6LiSsMIPPxazHCIQu1SAubDun+U+GL7LzxUXP2GdP43JL/WnmcwrXYa2vP3
	 Qn24OT27bNWeNOkEMwv3SZGFLKKrwL2R6+IvUXGc+5naH/Mc6C20qo9hsOEG57EA+mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061162;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u3PQFwfmH+wUY45TFB9KTdPMtbL04cqPyjmOz57Ooko=;
	b=F/3zK8A8dBXxfhQlExtnddgLuw7It+OWP1cHduNA7BhOcGrZed0bv+8dD+0IIqlLISnf
	 3ChhjKoXa4KauBywhQE0fhtLDi+Xv28oX/5ZkzirnjJPMTkmb+mtfmJdMhaPzyI2RV76E
	 dFmLa7dZonNpF6D6sStp+Ck6Y/xNvRWFfq9nIWlJiU1ORZiyloftHxyBg1wLJvIXI14ng
	 A5/OMXAjuMcsqYcoqZPmfaoXe3xLZzx6BM8d4v2p9rEMCFFrOo885UOKiR/TSGftRp9mY
	 uJUsv2sdBgD3QvBb6Q2A5jmromgGFDLmjZmAjyvcKFecKkDodd5pNZJ8eJifeI9TYQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K9j1Kj1A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05BBD606A325;
	Thu, 19 Nov 2026 04:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K9j1Kj1A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5914B1F000C4;
	Thu, 19 Nov 2026 04:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061161;
	bh=u3PQFwfmH+wUY45TFB9KTdPMtbL04cqPyjmOz57Ooko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K9j1Kj1ANzBVBMaHtn/CS5hUZ93W0nkSOR15FPaXB80IUIKLwnzjaTgv4QHWb5O5F
	 nsjVzR2zikZhX+wzwwlO0ieR9XK85+SY35PxDQ1riSgAT1vbPF90uiHCC8DHfnjiVD
	 +kwCg/uCZW6hIRaMofaR0Q14f7tDakwp2hOpCjT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1453/1848] power: supply: ab8500_btemp: Fix event temperature reporting
Date: Wed, 18 Nov 2026 15:58:11 +0100
Message-ID: <20261118150020.232129818@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 95990cda8e42dda4bd3f1475d578323981bd8579 ]

The event-aware path initializes its local temperature to zero and
compares that zero against the thermal thresholds. Consequently some
events report the measured temperature after it crosses the event
threshold, while others always report the threshold.

Start with the measured temperature, clamp it according to the active
event, and convert to tenths of a degree only once. This path is used
by AB8505 and later variants.

Fixes: 1f855824757e ("ab8500-btemp: AB8500 battery temperature driver")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260916-ab8500-charging-v1-5-e986ed321cc6@kernel.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ab8500_btemp.c | 28 +++++++++-------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

diff --git a/drivers/power/supply/ab8500_btemp.c b/drivers/power/supply/ab8500_btemp.c
index 5a1adceb6974d..a191effd5d63b 100644
--- a/drivers/power/supply/ab8500_btemp.c
+++ b/drivers/power/supply/ab8500_btemp.c
@@ -756,39 +756,29 @@ static void ab8500_btemp_periodic(struct ab8500_btemp *di,
  */
 int ab8500_btemp_get_temp(struct ab8500_btemp *di)
 {
-	int temp = 0;
+	int temp = di->bat_temp;
 
 	/*
 	 * The BTEMP events are not reliabe on AB8500 cut3.3
 	 * and prior versions
 	 */
-	if (is_ab8500_3p3_or_earlier(di->parent)) {
-		temp = di->bat_temp * 10;
-	} else {
+	if (!is_ab8500_3p3_or_earlier(di->parent)) {
 		if (di->events.btemp_low) {
 			if (temp > di->btemp_ranges.btemp_low_limit)
-				temp = di->btemp_ranges.btemp_low_limit * 10;
-			else
-				temp = di->bat_temp * 10;
+				temp = di->btemp_ranges.btemp_low_limit;
 		} else if (di->events.btemp_high) {
 			if (temp < di->btemp_ranges.btemp_high_limit)
-				temp = di->btemp_ranges.btemp_high_limit * 10;
-			else
-				temp = di->bat_temp * 10;
+				temp = di->btemp_ranges.btemp_high_limit;
 		} else if (di->events.btemp_lowmed) {
 			if (temp > di->btemp_ranges.btemp_med_limit)
-				temp = di->btemp_ranges.btemp_med_limit * 10;
-			else
-				temp = di->bat_temp * 10;
+				temp = di->btemp_ranges.btemp_med_limit;
 		} else if (di->events.btemp_medhigh) {
 			if (temp < di->btemp_ranges.btemp_med_limit)
-				temp = di->btemp_ranges.btemp_med_limit * 10;
-			else
-				temp = di->bat_temp * 10;
-		} else
-			temp = di->bat_temp * 10;
+				temp = di->btemp_ranges.btemp_med_limit;
+		}
 	}
-	return temp;
+
+	return temp * 10;
 }
 EXPORT_SYMBOL(ab8500_btemp_get_temp);
 
-- 
2.53.0



