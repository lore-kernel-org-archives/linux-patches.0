Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E452269CE6;
	Tue,  8 Apr 2025 12:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114312; cv=none; b=nW/ukwZksOrCl6GYVDSnz8HU+y3lDQ476HlNR/HBNddnZhBHcY4BUtwk4/aRYgAaez5CRV9sRI/91hRvqg79M2hlgrWgJI8Jz4qF2b3jzdpV89w5YCDFGa6igD/pahcaXxLwJalWA0Tp5iRCzEMqNeI0Ca/c9Tdh5mlF/P2IqU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114312; c=relaxed/simple;
	bh=gqLS9oNVWkT4Ve3rHLoou/JBLwdBkgm9hpXM7GttNhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MeAhqHK9BOkci6tuKfhap9pX0MH+AHnkrrxKE+o7IwmDAEHd1h8t1OHqZowtjKc7XABHcr3TxBoGhsi/XrD3JJLJwPRDkAoGU2V9+eoxMPFCsLdP98CiBLJVjMWU8AvYE0EPVHv00qkmXZiMmHvMb6zujOIXR9Zr6kAQ65zxrVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TrJCHJeE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TrJCHJeE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 925BCC4CEE5;
	Tue,  8 Apr 2025 12:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114311;
	bh=gqLS9oNVWkT4Ve3rHLoou/JBLwdBkgm9hpXM7GttNhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TrJCHJeEr852xUvo7vmvFM4qTtoftzHRfD76bx0FJSgHj3s9bMtQUk6xISrsU02aq
	 jqRfT+U1VT+X1JHwmjwIItmMgHVmfuJ5ihPH/uAqajvinnoWleN9sT4V7MCGwMC42m
	 E/ObpmR5zDB2fIwMywi0BpNfHmzchKDDVMvAJXi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 060/499] drm/bridge: ti-sn65dsi86: Fix multiple instances
Date: Tue,  8 Apr 2025 12:44:32 +0200
Message-ID: <20250408104852.731830228@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 574f5ee2c85a00a579549d50e9fc9c6c072ee4c4 ]

Each bridge instance creates up to four auxiliary devices with different
names.  However, their IDs are always zero, causing duplicate filename
errors when a system has multiple bridges:

    sysfs: cannot create duplicate filename '/bus/auxiliary/devices/ti_sn65dsi86.gpio.0'

Fix this by using a unique instance ID per bridge instance.  The
instance ID is derived from the I2C adapter number and the bridge's I2C
address, to support multiple instances on the same bus.

Fixes: bf73537f411b ("drm/bridge: ti-sn65dsi86: Break GPIO and MIPI-to-eDP bridge into sub-drivers")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/7a68a0e3f927e26edca6040067fb653eb06efb79.1733840089.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ti-sn65dsi86.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/bridge/ti-sn65dsi86.c b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
index 9e31f750fd889..fb452d1b46995 100644
--- a/drivers/gpu/drm/bridge/ti-sn65dsi86.c
+++ b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
@@ -480,6 +480,7 @@ static int ti_sn65dsi86_add_aux_device(struct ti_sn65dsi86 *pdata,
 				       const char *name)
 {
 	struct device *dev = pdata->dev;
+	const struct i2c_client *client = to_i2c_client(dev);
 	struct auxiliary_device *aux;
 	int ret;
 
@@ -488,6 +489,7 @@ static int ti_sn65dsi86_add_aux_device(struct ti_sn65dsi86 *pdata,
 		return -ENOMEM;
 
 	aux->name = name;
+	aux->id = (client->adapter->nr << 10) | client->addr;
 	aux->dev.parent = dev;
 	aux->dev.release = ti_sn65dsi86_aux_device_release;
 	device_set_of_node_from_dev(&aux->dev, dev);
-- 
2.39.5



