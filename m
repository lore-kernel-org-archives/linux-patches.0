Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86BF73446C4;
	Tue, 16 Dec 2025 11:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885499; cv=none; b=cA/imEH9sLtQbCHzRbMHfdPRQFFTn1mviznp7PLJC6OIGDqCfyJpvgFMW7ETQ/59LblWhF815WG3x4hcUzuvDdFJPlvR/03tv0NLf3EeOBPsbfotP4U8RXv+cmrmE2MKZhsB3IP9HquRFrVolUn3Ub+Y2pAtjky7NTdpyle084A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885499; c=relaxed/simple;
	bh=WLVv8oXSqKz5C48l6C6cm8K7MzWkbBws/37/y+Mnr+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fGz5nSEif9IjfsSTr3d3ZzcTNmQ+fznA7Wv+zBeuNzAZfqeY6R0KGDeycJLTag7nwgRXYfoUtBQn2ght1s4lvC0pI/dtbw0VVH1tpDHsqERVgnl8pAv6u0jnfb9gpbEuFtmWR873H5eSOAksgI2Lc8DcEAZpOcoLVIQ2umrSr2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XI5fL5ag; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XI5fL5ag"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C94C4CEF1;
	Tue, 16 Dec 2025 11:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885499;
	bh=WLVv8oXSqKz5C48l6C6cm8K7MzWkbBws/37/y+Mnr+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XI5fL5agV4y7Mok4eXBzi31TjbgmKO1FZVlDco4v1Zg1+oxDrtcupvOgMSEpOLBAC
	 NXjsgMZWow+bptF31cFSxMsh2ZMVtg4ixwsVJfK1NBGBCocc06qTujrSoQQt8oXqfH
	 gNI8fNAcbDCFJMD3pRM5y79BW28Uya3DFAAHe2SA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Abramov <i.abramov@mt-integration.ru>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 157/507] power: supply: wm831x: Check wm831x_set_bits() return value
Date: Tue, 16 Dec 2025 12:09:58 +0100
Message-ID: <20251216111351.211236688@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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



