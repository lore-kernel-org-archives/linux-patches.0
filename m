Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F4F1BE226;
	Tue,  2 Jul 2024 17:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941255; cv=none; b=BQuAPw1EzBdI3NjMgFeFsmhwbZtiKgSAMeTq3d5nBA7gtXJGnhQ4ihX0Ae2Cv4VwAFGTBrdwc5k352TmqOy+VZWB15t5Z9dNJnpQ8U6yj4SKOyNYPXGNmQ6jjY1SImjQG0+Lw5SNXxFoqxKhAZCmCYh/FLDaPKGcrJy8IRY05Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941255; c=relaxed/simple;
	bh=mGVfF0XpzDfvuScifMx6i9u9Hks/dqBqgwdVjAcaowc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mcjBJ3BPkFkaG5uPtDcHX3pFnGZGx+99PktEVpqHu4I6HFBLXbK2LPR3KV9QXIcKv0BLb4ISGwBhszmEInogsBDKKsZr9aJL1LAqFQPA8goh3JgD5yvSt8Z+h16LRDXL8AsqdsXS14W6OQEVHIGquGGd2GeQkc0ETqFyMNi/RgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EPQahCjF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EPQahCjF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCDD9C116B1;
	Tue,  2 Jul 2024 17:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941255;
	bh=mGVfF0XpzDfvuScifMx6i9u9Hks/dqBqgwdVjAcaowc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EPQahCjFu7NUQd+OkAlE8Cs3CvY+8MEhx0MeFDCJKtGRMxz+m8LLwm8UN9MW4NjLA
	 j/SiYTj3bNXlaWTEiF16buqP+ed52dbHO4JNrLgaJ9okRyRkFmWI0SBLj4HI/Z5Y6a
	 Y0t+a580j5xMw7m3TaXEg5s93li9og1D8HzVMDok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Stuebner <heiko@sntech.de>,
	Huang-Huang Bao <i@eh5.me>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 011/128] pinctrl: rockchip: fix pinmux reset in rockchip_pmx_set
Date: Tue,  2 Jul 2024 19:03:32 +0200
Message-ID: <20240702170226.661725036@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7a437ae674b76..d26682f21ad1e 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -2752,8 +2752,10 @@ static int rockchip_pmx_set(struct pinctrl_dev *pctldev, unsigned selector,
 
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



