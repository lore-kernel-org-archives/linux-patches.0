Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B3A35503A;
	Tue, 16 Dec 2025 12:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887282; cv=none; b=bRz6qQucsrgqXeid5khqrzjgQZTlrG/626//92L81ueHrCSncfGlOni1bxBFEasBiMQPNP0RXLlTyt3WP7jdX4IKSaUhT1k1PJNBE9b1qMczTVahL2QZ30FZ89yJX+vCLqWxgjtF46ERJG+S5xNLl1e9J3qx6PmCURi8Nlv/UZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887282; c=relaxed/simple;
	bh=QnplSGF5q2bmvtRviEvPoMAakfxQRCRnuwZJ1oPpc/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kAuOzFAi64S63a+mDvr7Ou+3MlYsEzfm7in1bLPKzJz+yOJqHcCZV/glIRuxnDFeR+0iZTjE5VEtUQSFD8o5AR2/oj9gzZXbZRpUgdc9R/ZGHFnacgcNYqLEckoOZg/UwpUh9px9C3HPl3dUVFYDjOrPHSHsBxm1c+5yNeqPcbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KtIGzcgL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KtIGzcgL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88B70C4CEF5;
	Tue, 16 Dec 2025 12:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887282;
	bh=QnplSGF5q2bmvtRviEvPoMAakfxQRCRnuwZJ1oPpc/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KtIGzcgLtDR2U+BulBlYIqnHXoqZ9KC6Hr+YwH2vqAJngcvXLYfqg0aSkyADlU699
	 OJDGYYS1oq6v7evd3Wc818GRn/dCg60vVW0VQgMx0Y72tzjv+103Zfv6XuSLEsJltn
	 jMTxKTactole6Lc0ZxJQ6Pmd4Lrnd7p5JSnohZXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Abramov <i.abramov@mt-integration.ru>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 183/614] power: supply: wm831x: Check wm831x_set_bits() return value
Date: Tue, 16 Dec 2025 12:09:10 +0100
Message-ID: <20251216111408.003968026@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Abramov <i.abramov@mt-integration.ru>

[ Upstream commit ea14bae6df18942bccb467fcf5ff33ca677b8253 ]

Since wm831x_set_bits() may return error, log failure and exit from
wm831x_usb_limit_change() in such case.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 626b6cd5f52e ("power: wm831x_power: Support USB charger current limit management")
Signed-off-by: Ivan Abramov <i.abramov@mt-integration.ru>
Link: https://patch.msgid.link/20251009170553.566561-1-i.abramov@mt-integration.ru
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/wm831x_power.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/power/supply/wm831x_power.c b/drivers/power/supply/wm831x_power.c
index 6acdba7885ca5..78fa0573ef25c 100644
--- a/drivers/power/supply/wm831x_power.c
+++ b/drivers/power/supply/wm831x_power.c
@@ -144,6 +144,7 @@ static int wm831x_usb_limit_change(struct notifier_block *nb,
 							 struct wm831x_power,
 							 usb_notify);
 	unsigned int i, best;
+	int ret;
 
 	/* Find the highest supported limit */
 	best = 0;
@@ -156,8 +157,13 @@ static int wm831x_usb_limit_change(struct notifier_block *nb,
 	dev_dbg(wm831x_power->wm831x->dev,
 		"Limiting USB current to %umA", wm831x_usb_limits[best]);
 
-	wm831x_set_bits(wm831x_power->wm831x, WM831X_POWER_STATE,
-		        WM831X_USB_ILIM_MASK, best);
+	ret = wm831x_set_bits(wm831x_power->wm831x, WM831X_POWER_STATE,
+			      WM831X_USB_ILIM_MASK, best);
+	if (ret < 0) {
+		dev_err(wm831x_power->wm831x->dev,
+			"Failed to set USB current limit: %d\n", ret);
+		return ret;
+	}
 
 	return 0;
 }
-- 
2.51.0



