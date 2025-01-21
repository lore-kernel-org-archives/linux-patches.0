Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB0901F7089;
	Tue, 21 Jan 2025 17:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482330; cv=none; b=HJktsY6ukqyJxFyjTaHhV0QKZoB7ijWNgXTFUuLDt6A60lZJzbrvihLxmo7vSMH5XeLQTcDQyAbSGqNm6hiljcVoQavi7yfGi4+sdXy5zomcbvF4QzYME4Fvih0G5HqbhR4f1XLJQ6GrKbznTHz0xruUwAdoGbYvss8+EUtgLPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482330; c=relaxed/simple;
	bh=tqWNI3YGsPp7axxVsS5R2aIA1j6yTTl9KJSbVom3uJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kY3wbAgl3N2WaVW/kiK7ATqWry9UAqbw5A4FH1hYclBIfv36CnkhXlxYsJxhX/2OQSm8HW1FgQR+uaM8rYxwG49kE16ush4A4Aeq/caRE9IeVl9ivMf+ELygKa516vf9/KIi9LLXQrQ2nctNA/FZJKPuNRrRco0w32kibavYyPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bLOX18ef; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bLOX18ef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CEBCC4CEE0;
	Tue, 21 Jan 2025 17:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482329;
	bh=tqWNI3YGsPp7axxVsS5R2aIA1j6yTTl9KJSbVom3uJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bLOX18efM4AlHSHAJXGSVoVfbkHCc1rJJZgFCniV1oLNEmzPj1fRmIzNDO4yQGTRt
	 Cp2FBPJ6bXB/b/jt89PGm41lP/KQ9GbJUMOoj6uY4vzQWg4KwxKv849jC+ugPXhbYf
	 /looroemNV88PJn/jrgLSD1HTxGpJ1THruriJNgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 040/122] platform/x86: dell-uart-backlight: fix serdev race
Date: Tue, 21 Jan 2025 18:51:28 +0100
Message-ID: <20250121174534.528129518@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenyuan Yang <chenyuan0y@gmail.com>

[ Upstream commit 1b2128aa2d45ab20b22548dcf4b48906298ca7fd ]

The dell_uart_bl_serdev_probe() function calls devm_serdev_device_open()
before setting the client ops via serdev_device_set_client_ops(). This
ordering can trigger a NULL pointer dereference in the serdev controller's
receive_buf handler, as it assumes serdev->ops is valid when
SERPORT_ACTIVE is set.

This is similar to the issue fixed in commit 5e700b384ec1
("platform/chrome: cros_ec_uart: properly fix race condition") where
devm_serdev_device_open() was called before fully initializing the
device.

Fix the race by ensuring client ops are set before enabling the port via
devm_serdev_device_open().

Note, serdev_device_set_baudrate() and serdev_device_set_flow_control()
calls should be after the devm_serdev_device_open() call.

Fixes: 484bae9e4d6a ("platform/x86: Add new Dell UART backlight driver")
Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20250111180118.2274516-1-chenyuan0y@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell/dell-uart-backlight.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/dell/dell-uart-backlight.c b/drivers/platform/x86/dell/dell-uart-backlight.c
index 3995f90add456..c45bc332af7a0 100644
--- a/drivers/platform/x86/dell/dell-uart-backlight.c
+++ b/drivers/platform/x86/dell/dell-uart-backlight.c
@@ -283,6 +283,9 @@ static int dell_uart_bl_serdev_probe(struct serdev_device *serdev)
 	init_waitqueue_head(&dell_bl->wait_queue);
 	dell_bl->dev = dev;
 
+	serdev_device_set_drvdata(serdev, dell_bl);
+	serdev_device_set_client_ops(serdev, &dell_uart_bl_serdev_ops);
+
 	ret = devm_serdev_device_open(dev, serdev);
 	if (ret)
 		return dev_err_probe(dev, ret, "opening UART device\n");
@@ -290,8 +293,6 @@ static int dell_uart_bl_serdev_probe(struct serdev_device *serdev)
 	/* 9600 bps, no flow control, these are the default but set them to be sure */
 	serdev_device_set_baudrate(serdev, 9600);
 	serdev_device_set_flow_control(serdev, false);
-	serdev_device_set_drvdata(serdev, dell_bl);
-	serdev_device_set_client_ops(serdev, &dell_uart_bl_serdev_ops);
 
 	get_version[0] = DELL_SOF(GET_CMD_LEN);
 	get_version[1] = CMD_GET_VERSION;
-- 
2.39.5



