Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4672C3268;
	Thu, 15 Jan 2026 17:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498992; cv=none; b=ED30lCsqNdjU19p48eLJS9e2yBfwtyXWUwlWz+PL3AXp5gzKb0WqSlR6yWh5+lcVyOZq04CKvydJj2+JlITz9iWe/GW6cZmIsqlwbIZeQOtNtsqIxOlpiZGGLB5vVkRblmbIJq7Cd379VSmqiuk/B6Jb3BPZLyXmOiIkXVJJaMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498992; c=relaxed/simple;
	bh=Xd5WSdC5GDGnX7eV0vrLVhOAKzVXjm19HQWsRE+9Uvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t+CfQJKgCBg3Czpu9BByaHivDkIk7YyD8yPXKV1ZIJHkrNo0Z8uB7GvUtjukwbLRt40bDIUNvJkD4wnfrfOZdZCYtRPwbcpRf7cvewcoXoS5j+HdMTRFCeOCQiCzQLDUO01MEG72W1YXFiQ2OfM5Dz8+4KVgv4yUTH1KqjlRd/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qfBvmOb4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qfBvmOb4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 228FAC116D0;
	Thu, 15 Jan 2026 17:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498992;
	bh=Xd5WSdC5GDGnX7eV0vrLVhOAKzVXjm19HQWsRE+9Uvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qfBvmOb4II9hszw5+qB0oCeqZbuzfwY84k9vm6EJrLw7iRAQdaBUM5NGDpSJIcXKe
	 13JXp1T4+r4mbVB6HglFOoPRej/oVYL0HmZOr2C+1+Yj5EXkeUtl++WpORPK4jGmpv
	 IDu2kQkztaOLLuVPN6C1Ed28j5GMrMlBqf4NGsfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Abramov <i.abramov@mt-integration.ru>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 053/451] power: supply: wm831x: Check wm831x_set_bits() return value
Date: Thu, 15 Jan 2026 17:44:14 +0100
Message-ID: <20260115164232.818600997@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 18b33f14dfeef..aae655109862c 100644
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



