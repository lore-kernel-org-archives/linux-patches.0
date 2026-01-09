Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62802F12D4;
	Fri,  9 Jan 2026 11:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959615; cv=none; b=PZqRK8lB6k86/lfFbpN4FOJ55pdGoYB6JRBeceD0p5TIkJXaMr/MVrR2sOPZNDIEt1JBMGlj9RXkl8/opzwoR4tcfT8hI47YX1vbEFkCh3Up5V3tLcXO75/MPKPXeDdLGcCEVcxvAdngjEBQSpuQVMUjn8SpknFYK0iCIlmoWuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959615; c=relaxed/simple;
	bh=EbBIxW4oZRfblB34ZskzVYmMgur95tLBvSIcS+S5PYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DJ3j4OgxYWNAuJRVbOGqDZXahPr47ATMe6cOBR/XndC13/2P7SKwyvQrl8Nlg3oznmj1KfVUmdysUVRHrEXgLilheaJp3SCdkgdArJ3ct9IkSaci4pgdRnLOl4uQTs4UObZ2X0SZeGuER+YzS+/sqXWAsPjQYqUR0J5ZrbvumEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MnuI8oxj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MnuI8oxj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2461AC4CEF1;
	Fri,  9 Jan 2026 11:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959615;
	bh=EbBIxW4oZRfblB34ZskzVYmMgur95tLBvSIcS+S5PYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MnuI8oxjK59/YfUEA372Pu84ecpZgaga/+L8FCMsyqZ5EgxXs24TAxEBbB1tLOMUf
	 4Wxp9sc77AvqQ+qRarc+pHg3m8MsDA9Hr3+AIAKdqAhq/RSfWnthv4cCQurve7wFLs
	 odGT9yxoScNY51apCoS5KrdAO+aUBihvwvuWYFpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Abramov <i.abramov@mt-integration.ru>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 115/737] power: supply: wm831x: Check wm831x_set_bits() return value
Date: Fri,  9 Jan 2026 12:34:14 +0100
Message-ID: <20260109112138.330981464@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 82e31066c746e..bbae77982d086 100644
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



