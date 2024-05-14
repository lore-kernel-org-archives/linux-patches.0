Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F577EEE1;
	Tue, 14 May 2024 11:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686786; cv=none; b=MwrYjcMB3jckgr7dOeBV1A3VngUL3a9ta5mPZ/UxkdB712o3/HeL8oP/CwZRd9Y52CxiozmKOjV208hs0vmD4avcSpeYKNPh2CsFcuN7xE6mDc8Xxy1XPwUherwlhuD7zPzsX2yDE/8RA7xl4KUgt5Pl7EEvo36eaKkYNWe/Vao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686786; c=relaxed/simple;
	bh=lHuKJgnjQa/T4r/QRRZ64kBfEGcVnKFEwey4VRODl0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PZkyf6KGZz+hR5V9+J1L4IZkgLstM0uGWkW/WyzeHdzSX8Iwh4I6ccvXnp5HnL2fUD+xI/t2dl+YUeWs27mOT5TXkn1IIa7Zy7aFhkUZ1JdtuBNVebm4U4qaWtb0+Rk0X4wJswUim6zY54mFtyMgQ7xcHLgQD0GGiXDvTC/xyb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2EV03oxy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2EV03oxy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C408EC2BD10;
	Tue, 14 May 2024 11:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686786;
	bh=lHuKJgnjQa/T4r/QRRZ64kBfEGcVnKFEwey4VRODl0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2EV03oxypb9MFApmYyt2gly9+sWPdo7saI3nC4sB2gueQ79g/PEvVeX3n6WWceSVm
	 l+2WNspgC3pHq0szCbugGLQhorUH1a/WDpwW9uK3x35xFhpjroA8ZhSyzhwjyflMWZ
	 VTGnqKaYZpQxkqeFDJFE49r8Jp402P2rU9jLB3QE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 09/63] pinctrl: core: delete incorrect free in pinctrl_enable()
Date: Tue, 14 May 2024 12:19:30 +0200
Message-ID: <20240514100948.365961367@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100948.010148088@linuxfoundation.org>
References: <20240514100948.010148088@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 5038a66dad0199de60e5671603ea6623eb9e5c79 ]

The "pctldev" struct is allocated in devm_pinctrl_register_and_init().
It's a devm_ managed pointer that is freed by devm_pinctrl_dev_release(),
so freeing it in pinctrl_enable() will lead to a double free.

The devm_pinctrl_dev_release() function frees the pindescs and destroys
the mutex as well.

Fixes: 6118714275f0 ("pinctrl: core: Fix pinctrl_register_and_init() with pinctrl_enable()")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Message-ID: <578fbe56-44e9-487c-ae95-29b695650f7c@moroto.mountain>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/core.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 99f062546f77e..052894d3a2047 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -2036,13 +2036,7 @@ int pinctrl_enable(struct pinctrl_dev *pctldev)
 
 	error = pinctrl_claim_hogs(pctldev);
 	if (error) {
-		dev_err(pctldev->dev, "could not claim hogs: %i\n",
-			error);
-		pinctrl_free_pindescs(pctldev, pctldev->desc->pins,
-				      pctldev->desc->npins);
-		mutex_destroy(&pctldev->mutex);
-		kfree(pctldev);
-
+		dev_err(pctldev->dev, "could not claim hogs: %i\n", error);
 		return error;
 	}
 
-- 
2.43.0



