Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D140185E42;
	Wed,  3 Jul 2024 10:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004148; cv=none; b=mL7pl5dkxvLMGW8vcnJ0lVoB52aEmegEUZ5t+ybN/glwDjis5iHy3mAyiM515K/9PScUInq1MQIWLj4bn3ydq6mxHr1nUTCVFd2X4px58XCPnYv0HJ0ZyP3LiFVyUduwdkCfwJ/jefGQu+oCk20Q8v6/uiYmcDH49/kRKNC863Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004148; c=relaxed/simple;
	bh=6+WZ++feB8YuL1ENwg9DixvYba5srXSh9Z6HfzhAv/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E0qAuVZOGkp7MijuTUQ720ivBw77GGCz/5b6fn84mFvkcFNX2UbxY4x7d42v4nYywaBdRhuXAw9n/CVv15aUG5TLoRASXknEcvyRw2KZpIKM1XPBKhdlBqCuonqT11Ls06eVu4s36lq2WbmkG6Hrbxv3LZ6Uao3iyp7f4d5rsQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=np0aC5KW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="np0aC5KW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 960BCC4AF0B;
	Wed,  3 Jul 2024 10:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004148;
	bh=6+WZ++feB8YuL1ENwg9DixvYba5srXSh9Z6HfzhAv/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=np0aC5KWOWUaTjaGMYmSoX+iCIddb3ZHDNG+2io3j+MRCl3YP9jl5+kN5lsoDmHJa
	 AdFXpUwF/vGWtJGSFvcZReHLUPVButUSEdKQFOsb5iEhCtVZclvL4i9+qREST/6/ty
	 kvlZTzEGKS5q6aquP5eNuFg7l8eQltAunUUlRoZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Stuebner <heiko@sntech.de>,
	Huang-Huang Bao <i@eh5.me>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 137/189] pinctrl: rockchip: fix pinmux reset in rockchip_pmx_set
Date: Wed,  3 Jul 2024 12:39:58 +0200
Message-ID: <20240703102846.653471800@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index deedfc4da2d76..7f2e854e0386c 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -2235,8 +2235,10 @@ static int rockchip_pmx_set(struct pinctrl_dev *pctldev, unsigned selector,
 
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



