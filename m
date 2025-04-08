Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4BA1269839;
	Tue,  8 Apr 2025 12:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116206; cv=none; b=Bu0CprsuUIIwVkdSoaQ4VN1dSEgomvr9ATEB8RxdqBCtEf6ykEPwEJFeyTNEC2Nu6Pa55lmTwumr1uKmJYXbvmLpOXC8dCUZGf/I9deN4/DNdvPokV4evquusVVOUJo5HQXASHeopMJ5gJyD+eL5SR23qELgQX4zVec4Y/pisEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116206; c=relaxed/simple;
	bh=pi5nI257IOnDgk+lI8I2xZPf1+0APvBXeq7vy0lkUIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iHLFht/Wl8sK1jIDCoLJdgytKq6PwQZMkqHqHWfgh67S9gxNIyF3U+mmkNAeEYFFf6xUz6GZVvFDt7PpXR5d7+yjgHAKrq2SIyiYMMg5lDYDc1IMpujfbuNw7QpkXR19DQkljBaVjWecN96v4GfihRraF2G2kS3iFdkNqSAhoOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i32TYk78; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i32TYk78"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 040AFC4CEE5;
	Tue,  8 Apr 2025 12:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116206;
	bh=pi5nI257IOnDgk+lI8I2xZPf1+0APvBXeq7vy0lkUIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i32TYk78vcD44Lk9poPrDXjPjhemFlz1BzdUD+lzVqh90SpJ4KoLQw3nz3BPcbwUY
	 PExqIo99wkRkx/ngxKllCPa3HO0EsW63TRzIpOh5O3oRC7rkKhAK0Cqm/3BZM7taOp
	 6dVIMSKUWIHz7V8Y0/2kOziDdbKb8U7MhV9nhTcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 047/423] drm/bridge: ti-sn65dsi86: Fix multiple instances
Date: Tue,  8 Apr 2025 12:46:13 +0200
Message-ID: <20250408104846.846157046@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 582cf4f73a74c..95ce50ed53acf 100644
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



