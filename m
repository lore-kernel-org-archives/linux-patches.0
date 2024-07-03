Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DACB13E024;
	Wed,  3 Jul 2024 11:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004950; cv=none; b=j0o802MkqFRggHxuaEo3QBVs0cwMWuplv5pmp5gW57Adslw4fWxEGEV6edRCLrwrd2Y5suer/WUcLTpj2RMyGfvZ042rGXtLwR5hOimP5vKvcnLpNGtsia46oBOOEcn31qFrugCc6/kMGFnnFJjWKrRX4Cb4gwo547u0bYviKkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004950; c=relaxed/simple;
	bh=wP4GfPFBQb4aiYLSUfXihyewmpyPXtd6NamwMpPrH98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qvzuuwLCs7xHDqnv188qa4flZrWzyYT16zlDF0Tf4HM7sfM+tks15oHAjp5QC/Cb7KUQlgg9KvO7z5nHd1GOMmMFtchy9wo/G+4qKiPEkndcMMSdjTe/YGuA4Vch89H4z/MrJiO7ADkB16DoPnzdaeLm8/+6TAU7qhrZMtrAPSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=heBsNAM4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="heBsNAM4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25636C2BD10;
	Wed,  3 Jul 2024 11:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004950;
	bh=wP4GfPFBQb4aiYLSUfXihyewmpyPXtd6NamwMpPrH98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=heBsNAM4gBu3iZObvsMJF4LaeUZ4s4fKoT4/JE1y6RhWod23Soa+UN8+ejgem4opK
	 FQn1OIMKtXodhUOnYQ+KXRSZH6beE/sWRb3JKS1jZ2sgOd/Lc5Eh/VTscGk5GRkJIW
	 2mtnP73T7/v8MGDdkCb0Kxe/9yn8E2DsitxEUzlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Stuebner <heiko@sntech.de>,
	Huang-Huang Bao <i@eh5.me>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 210/290] pinctrl: rockchip: fix pinmux reset in rockchip_pmx_set
Date: Wed,  3 Jul 2024 12:39:51 +0200
Message-ID: <20240703102912.093053654@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7637b25c6edf7..02b41f1bafe71 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -2131,8 +2131,10 @@ static int rockchip_pmx_set(struct pinctrl_dev *pctldev, unsigned selector,
 
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



