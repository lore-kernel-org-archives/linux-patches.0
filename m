Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79ED633FE27
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301182; cv=none; b=fYeWqMvwVQM84X1G6iJvJ8Hrb8ip3yLfn+RUJa5Dhn8yyEmspwqTYQCZFRYuF3jpg8sv8+EkwRPEq6TY+cI3npmoCssqGfFsOsk4M3z9nYDDtycV1c29zjvglu5QE1DuN2Fv4Axjm3+uA5g0wihe49ewhxZ0ehZ/h3fYJywLLLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301182; c=relaxed/simple;
	bh=gruoONGr1LBGtKcr1XKUcE1mXzaxkW8h7qwHuPBVHY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ALPTjsUEzEHEiuAY0jIuZzFPmOh4DzHe7iiOGHdbX5NakfysU81jPKcW8c2doDkUrLy1uAjGk/X1kOBcdkTbVbtzYACMdpsUsdUlMW6AHWC3sCcW9UmmveQTx/J6lzAEwoBf9Xc8CR7z6HS6L/aD4PUpcEAP2qrmp/YelkJ5WTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mMgcd0gj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mMgcd0gj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCBD4C116D0;
	Sat, 28 Feb 2026 17:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301182;
	bh=gruoONGr1LBGtKcr1XKUcE1mXzaxkW8h7qwHuPBVHY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mMgcd0gj9u8L6bVSz36Z0esAFG1qasWUmqIujzwoMScCknzVp5GZLugaD0oVgQM4L
	 mu4HpNQXFguhmdT4z9CcozLKbN89zDHTH9lpWvepnxcTzd0QLMEmXcDuotkh+nOHSr
	 bfG0wpbIMui0r3AJZXTxaj5REq9opuVG9yDGUy1fJMJBFRiP+EPfbhDRd6nbw1AdEt
	 XZYacBTuP9AYo5FvU/lWzEaGGzK3WodJxwBiTy5j7jvyce3s8L4Xkm7vHDKftcOn14
	 7mr8Na3ZdK5s8Mbwi2K06Ps0jvfxHXJyKtdL9HU4mQGigKFshtXlhlHJrTL4ATEw4N
	 tvOsYtfHwxFJA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Aleksandar Gerasimovski <aleksandar.gerasimovski@belden.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 351/752] phy: mvebu-cp110-utmi: fix dr_mode property read from dts
Date: Sat, 28 Feb 2026 12:41:02 -0500
Message-ID: <20260228174750.1542406-351-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Aleksandar Gerasimovski <aleksandar.gerasimovski@belden.com>

[ Upstream commit e2ce913452ab56b3330539cc443b97b7ea8c3a1a ]

The problem with the current implementation is that it does not consider
that the USB controller can have multiple PHY handles with different
arguments count, as for example we have in our cn9131 based platform:
"phys = <&cp0_comphy1 0>, <&cp0_utmi0>;".

In such case calling "of_usb_get_dr_mode_by_phy" with -1 (no phy-cells)
leads to not proper phy detection, taking the "marvell,cp110-utmi-phy"
dts definition we can call the "of_usb_get_dr_mode_by_phy" with 0
(#phy-cells = <0>) and safely look for that phy.

Signed-off-by: Aleksandar Gerasimovski <aleksandar.gerasimovski@belden.com>
Link: https://patch.msgid.link/20260106150643.922110-1-aleksandar.gerasimovski@belden.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/marvell/phy-mvebu-cp110-utmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/marvell/phy-mvebu-cp110-utmi.c b/drivers/phy/marvell/phy-mvebu-cp110-utmi.c
index 59903f86b13f5..dd3e515a8e865 100644
--- a/drivers/phy/marvell/phy-mvebu-cp110-utmi.c
+++ b/drivers/phy/marvell/phy-mvebu-cp110-utmi.c
@@ -338,7 +338,7 @@ static int mvebu_cp110_utmi_phy_probe(struct platform_device *pdev)
 			return -ENOMEM;
 		}
 
-		port->dr_mode = of_usb_get_dr_mode_by_phy(child, -1);
+		port->dr_mode = of_usb_get_dr_mode_by_phy(child, 0);
 		if ((port->dr_mode != USB_DR_MODE_HOST) &&
 		    (port->dr_mode != USB_DR_MODE_PERIPHERAL)) {
 			dev_err(&pdev->dev,
-- 
2.51.0

