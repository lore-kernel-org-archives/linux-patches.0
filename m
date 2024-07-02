Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B083B178381;
	Tue,  2 Jul 2024 17:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719939983; cv=none; b=nADw1jyq8PK38tQDDcZ+p9lenrvvdy9Nwo7c7EhS5dGBSlkGKvSOrUw6SzyWJ/934eFmbdzR1lq5NIMCtSXZshwDt+u6EdDpbt72JzWfgGe/Azug1iSuSGuDWCMqtxrZU3+xKq3qrqHKJXUN6Ee8dgNPLZ3KSQ++T3jumGLGSSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719939983; c=relaxed/simple;
	bh=TsFXOn7ETLqX55CK+2RRlidlEj79e6dOZAPGOX8PQuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RL0ujWnS9sC314i3ZH2hxTzU322UHJykh8H9Bw3E4TAg3JfXzTFMAJQsbga6WEPTskOfVE0V7tiq5lBtfidVdn86pUi9/VMU3Mpgb20l2bQ6BFdtDQYNvqzvFMCclh9350VJSwRf/CBTmKkaMn42SV4WjScwbcROEMT7vrd3pGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p7jlqvRW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p7jlqvRW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18CCCC116B1;
	Tue,  2 Jul 2024 17:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719939983;
	bh=TsFXOn7ETLqX55CK+2RRlidlEj79e6dOZAPGOX8PQuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p7jlqvRWErKRORHB7B1DdtSSFE8V4UFVw5S5eGM8oIR6zmvfaqN7q3oT+1cvCNIg+
	 eWsPstevfPaX0JSnz5T7dpGeO/Mr6QsipAKDB6z/1DtZs5V0217kSsyCJJcv8yQh6V
	 HbGHmpGI857I1Me/nWJxuRCZ9t5k8RjHTAFTolpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Stuebner <heiko@sntech.de>,
	Huang-Huang Bao <i@eh5.me>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 009/222] pinctrl: rockchip: fix pinmux reset in rockchip_pmx_set
Date: Tue,  2 Jul 2024 19:00:47 +0200
Message-ID: <20240702170244.328124321@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huang-Huang Bao <i@eh5.me>

[ Upstream commit 4ea4d4808e342ddf89ba24b93ffa2057005aaced ]

rockchip_pmx_set reset all pinmuxs in group to 0 in the case of error,
add missing bank data retrieval in that code to avoid setting mux on
unexpected pins.

Fixes: 14797189b35e ("pinctrl: rockchip: add return value to rockchip_set_mux")
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Huang-Huang Bao <i@eh5.me>
Link: https://lore.kernel.org/r/20240606125755.53778-5-i@eh5.me
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-rockchip.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index 24ee88863ce39..3f56991f5b892 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -2751,8 +2751,10 @@ static int rockchip_pmx_set(struct pinctrl_dev *pctldev, unsigned selector,
 
 	if (ret) {
 		/* revert the already done pin settings */
-		for (cnt--; cnt >= 0; cnt--)
+		for (cnt--; cnt >= 0; cnt--) {
+			bank = pin_to_bank(info, pins[cnt]);
 			rockchip_set_mux(bank, pins[cnt] - bank->pin_base, 0);
+		}
 
 		return ret;
 	}
-- 
2.43.0



