Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3684C1C007E;
	Tue,  2 Jul 2024 17:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940806; cv=none; b=TIabCri3EpGNCQ6R0Z5kkhAEzCoyYh7IWRnkC7OHgDl8a7RhVcP832crJMdba3LMDV4u2sFqmfWDLpeMMMakTfybV98bBLQEhKiz6+aMm2p0t+wA1vbGzPUuu9xUyLeYHpZyX5neqytBPNL7xNk1A4plUo4Akob5dx0a+Vyh2Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940806; c=relaxed/simple;
	bh=SlOoHxtrxaSUoihrQPeeLJVaULpHzejnMHJBSfaeWE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WI1FZYJ9hd524nRBpJ5OId4Q7Vi0X9EgrSVmVNSE3zx6eCybMiPZqu1B2LCIh1okMmS9/P+cU3CNUqIj0MMLZVaEABfA4Oc0pFmWc9vBCTjuSOaJO0SZjS8MqZTbqPgD/4YfPIO04QAuAIJE5z/XEWk/oCQm33u+mDEfX59XD+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T2FpRFIf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T2FpRFIf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93862C116B1;
	Tue,  2 Jul 2024 17:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940806;
	bh=SlOoHxtrxaSUoihrQPeeLJVaULpHzejnMHJBSfaeWE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T2FpRFIfAB5/Xx9d8mp0O/hFvJ9djmtg+m3fy6zHuilyrVnCUX/nzxJa3fymY0bYR
	 fqTh0SrdBPp+jwVXSm0eN40qhKfEgNHaimW1S7FaVPxxTGwT3vC+ZebFTCbCgNu9S+
	 yZyniyphCJoCsb2fzD3gQeI9nZ+0zCKzZ19v47wM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Stuebner <heiko@sntech.de>,
	Huang-Huang Bao <i@eh5.me>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 011/163] pinctrl: rockchip: fix pinmux reset in rockchip_pmx_set
Date: Tue,  2 Jul 2024 19:02:05 +0200
Message-ID: <20240702170233.481415878@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 974f16f83e59d..caf8d0a98c327 100644
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



