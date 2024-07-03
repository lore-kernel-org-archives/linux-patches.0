Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2907A17B503;
	Wed,  3 Jul 2024 11:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005995; cv=none; b=YjFryU/qd9MogjFWHgFuKLHhgloepG8zoq0/4PtKKT1r0ODJai1rs30DQtx+LRl0i02+EEPh4Db3PEAg19rYc9YbUUNxhhmpoKUEkaLmeM5tUTp8lLp6lo2mfJ+N8MLAIVk3aLt8Vv9pbvZsPhFz2t3tSQJMFgrndNXeiFiV5u0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005995; c=relaxed/simple;
	bh=f2HZc/anAxEU2xgODzTp9yVWvJHxpbB7rUx9fJwDzUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EcUYMAg5esBTgobw/ZvBp/DUULQWO9tjr5gcZsENZslWjsS2tqFSzcgvmFAusxSoKgk2pDeeUUCZODJYG79VXyIJsu+0a0j14OU1eXVSe1ygP28gMxJgCcYgYNmMcIE988dMUG1FuxsmcPVMfx3oSfupG9wY1Dja2QH2pOz7FNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ugtDy9ye; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ugtDy9ye"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95EACC2BD10;
	Wed,  3 Jul 2024 11:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005995;
	bh=f2HZc/anAxEU2xgODzTp9yVWvJHxpbB7rUx9fJwDzUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ugtDy9yemoP2boXI6yAP5wyMPwS0ij5uSlYlZn3OvLkWzu+PL3Mv4OwFIRcx467oa
	 +SEIU18oOOg85GT6exU8FjoVLuoKDg6o90dA7eHl+hCFAcG4MSmWFxus5DK67FfimS
	 g7/0sorN6m3s3HRQHIWFDkt37c7wz5iWkf+Yq7G4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Stuebner <heiko@sntech.de>,
	Huang-Huang Bao <i@eh5.me>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 265/356] pinctrl: rockchip: fix pinmux reset in rockchip_pmx_set
Date: Wed,  3 Jul 2024 12:40:01 +0200
Message-ID: <20240703102923.142198585@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 30e1dec1e2f68..4ff70527755a3 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -2206,8 +2206,10 @@ static int rockchip_pmx_set(struct pinctrl_dev *pctldev, unsigned selector,
 
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



