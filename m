Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95DDE55C31F;
	Thu, 17 Sep 2026 15:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659966; cv=none; b=Kw+WPnhkERR21BQPJ8mJW6BsOmyM1qG6Sm69lco9cSCesqHJTlBk4giS6NyA3lj1aM+1F2dz42DtxRkp8TP0h9yi+MbIADqVR2HWuv5GvYT2yhWGVcNFrVB7+A69pOMn18cTOmy0Nt6TxROMDnVEwQIifYUH5tpdWdSZW143WzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659966; c=relaxed/simple;
	bh=bKxGI6rsEGGJvdugeUA0UTmHfJYPhbsoUmWxjbt+ne4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R0D37zBM4KarWgC8Gkd+zthCX74X/KPYApsSl7We0J2tgfraHSH2gYiJcLCabYXHw+i0w1TwOSkGMfnf8rmWhiVCLyYqlDcvtyk2qZAAu2Hg/MeNaAgbfLJcowi6DnLhdvY9hCgK5MHcvDpcyjyBLFhfQqPv14daJmzAfBwoIJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RlKEYvA7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RlKEYvA7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B0FA1F00898;
	Thu, 17 Sep 2026 15:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659961;
	bh=+WMmmGN45JcQKQusNKBYCHYN0oWIAl571ZtDssX88FY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RlKEYvA7c099yLBoas14zhOd+tTddCa3ZtG7XQOVjlJPAxJIGGDZ7+YAmrwW3H+Xn
	 zzWL+ymXoFXIMI+i08wWJCrOAZvU7rVzP53y7TLMiG4dm4w9KtnQSpWwrQQaykSvcn
	 2mhB2VRmuYC5VBV5zGdEqp6S9jbjvltz5BQh1pxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 432/733] net: phy: dp83867: handle the active-high LED polarity mode
Date: Thu, 17 Sep 2026 16:12:20 +0100
Message-ID: <20260917151402.604308786@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

[ Upstream commit 36a45facedd5c8e73bfb2403f8b0dbff05124c9c ]

Commit a274465cc3be ("net: phy: support 'active-high' property for PHY
LEDs") added PHY_LED_ACTIVE_HIGH and made of_phy_led() set the matching
bit in the modes mask when a LED node carries the 'active-high'
property. dp83867 was not part of that series.

dp83867_led_polarity_set() only recognizes PHY_LED_ACTIVE_LOW, so
PHY_LED_ACTIVE_HIGH falls through to the default case and returns -EINVAL.
of_phy_led() propagates the error, of_phy_leds() drops the LEDs registered
so far and passes it on, and phy_probe() fails. A device tree marking a
DP83867 LED as 'active-high', which leds/common.yaml allows and
ethernet-phy.yaml references for led@N nodes, thus stops the PHY from
probing.

Active high is what the function programs when no polarity mode is
requested at all, so the initial value of polarity already satisfies the
request and only the case label is missing.

The same series updated mxl-gpy in commit eb89c79c1b8f ("net: phy:
mxl-gpy: correctly describe LED polarity") and aquantia in
commit 9d55e68b19f2 ("net: phy: aquantia: correctly describe LED
polarity override").

Fixes: a274465cc3be ("net: phy: support 'active-high' property for PHY LEDs")
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Link: https://patch.msgid.link/20260903022839.4006614-1-donggeunyoo.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/dp83867.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index 88255e92b4cdb..61a941aa02d94 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -1150,6 +1150,9 @@ static int dp83867_led_polarity_set(struct phy_device *phydev, int index,
 		case PHY_LED_ACTIVE_LOW:
 			polarity = 0;
 			break;
+		case PHY_LED_ACTIVE_HIGH:
+			polarity = DP83867_LED_POLARITY(index);
+			break;
 		default:
 			return -EINVAL;
 		}
-- 
2.53.0



