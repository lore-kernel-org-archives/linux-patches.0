Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B7763C;
	Thu, 15 Aug 2024 14:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732175; cv=none; b=STgjHn99DX+nqxPgx90WaNYIA1yptnpxNghII/z94IlJNi8Vw3iLP9MX12qszk/hziWYlT0Yqcn7OU2UmhvAvD6mgWASYBVOxuvUoBQookxk5ZiJFSqIRXJT5eQgzRAlLglAhgjLN29woMcwtvMHS9sAfo5ZSv5SdDdZejL4Y6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732175; c=relaxed/simple;
	bh=Nwm6ogMst77Q7PqkVSUbVSjOPlvS4K4ZevJG5BE6ks0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DnmT484Zy+jIBtgiowbtdNDEVhmCQizP4cKSCcjVX94xllm9HD0ZThAzXwom5FKK48zbX79B6bg0EHAyI+6AyF2/FE5gD9371mK1EYA6KVHz8AFanvStbS07QQgEzpNZfUJtasbYZjanvGTjrDPV/Ey7oa7nWWVuK3TmT7jh1Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wx2xEGkH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wx2xEGkH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E92C3C32786;
	Thu, 15 Aug 2024 14:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732175;
	bh=Nwm6ogMst77Q7PqkVSUbVSjOPlvS4K4ZevJG5BE6ks0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wx2xEGkHwtOKdxEsQuPUp0QcZkN5EEXU3a2EZq1N3FvELUwnOQ85In5348oulkyHF
	 EebbFgg72MmfAc9j0nPQUEUYzxDHvldKcMYjktGWj+8XsGVGsXjjQDrUmXBnjpIK5M
	 KKUoelY2G5eIeyFlo8XcdKzH0fxuzL6RgpPwxrvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Lalaev <andrei.lalaev@anton-paar.com>,
	Marco Felsch <m.felsch@pengutronix.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 098/352] Input: qt1050 - handle CHIP_ID reading error
Date: Thu, 15 Aug 2024 15:22:44 +0200
Message-ID: <20240815131923.047202967@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

From: Andrei Lalaev <andrei.lalaev@anton-paar.com>

[ Upstream commit 866a5c7e2781cf1b019072288f1f5c64186dcb63 ]

If the device is missing, we get the following error:

  qt1050 3-0041: ID -1340767592 not supported

Let's handle this situation and print more informative error
when reading of CHIP_ID fails:

  qt1050 3-0041: Failed to read chip ID: -6

Fixes: cbebf5addec1 ("Input: qt1050 - add Microchip AT42QT1050 support")
Signed-off-by: Andrei Lalaev <andrei.lalaev@anton-paar.com>
Reviewed-by: Marco Felsch <m.felsch@pengutronix.de>
Link: https://lore.kernel.org/r/20240617183018.916234-1-andrey.lalaev@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/keyboard/qt1050.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/input/keyboard/qt1050.c b/drivers/input/keyboard/qt1050.c
index 403060d05c3b3..7193a4198e214 100644
--- a/drivers/input/keyboard/qt1050.c
+++ b/drivers/input/keyboard/qt1050.c
@@ -226,7 +226,12 @@ static bool qt1050_identify(struct qt1050_priv *ts)
 	int err;
 
 	/* Read Chip ID */
-	regmap_read(ts->regmap, QT1050_CHIP_ID, &val);
+	err = regmap_read(ts->regmap, QT1050_CHIP_ID, &val);
+	if (err) {
+		dev_err(&ts->client->dev, "Failed to read chip ID: %d\n", err);
+		return false;
+	}
+
 	if (val != QT1050_CHIP_ID_VER) {
 		dev_err(&ts->client->dev, "ID %d not supported\n", val);
 		return false;
-- 
2.43.0



