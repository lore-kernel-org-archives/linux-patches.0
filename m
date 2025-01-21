Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781581F708A;
	Tue, 21 Jan 2025 17:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482332; cv=none; b=qXfBaAY43TWKVTLo9lRiIInl9dK2F6Uu/q3VGoAHtEdoI2Z37ME81uyyLHyeMgxNhTylZA9ukcP7ZdElcwrF2QoTOcoGltReh7WTyfsdv0qY6cTA9G3m5JErAKRHC+p+3H+RlHgD9P/TgnaIJfrz+4ry6nJ93/ShW4l7W6QzmfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482332; c=relaxed/simple;
	bh=8PHG7NSRP0QNKGMCLBfmZrGG7QsA/YpGhuF0EdGbrFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TqBCijLMK//d0PF3Sx5tMzF6BXog0TXRmjj8e+6P8qoWl18P+l8gngJGtXy5ADsk5BY9aIDtodAdBw1VbO9kZ7/1J8Lz0Puok/h+YB+tJQbO2FEtr21aQwNi9KZTcQgR1/GCvQE9XtBltBTS81r8ROSpleASb4GSWYcOil+ml/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lT88oqXl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lT88oqXl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2249C4CEDF;
	Tue, 21 Jan 2025 17:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482332;
	bh=8PHG7NSRP0QNKGMCLBfmZrGG7QsA/YpGhuF0EdGbrFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lT88oqXlZpHqZLe6doYLQcCdbhLd3DWFAvH4z7ubAzhMJK2cZVXKpeW52TgqEEh0C
	 seH/SG6TwQLC/JVNZPRt8zEeVWxxVq1nybONcwqEKDipyQFHtUpVu3ERaQvNgzXZBa
	 2Q8Lr39S8WxZE4BmdjpURqIdB/iMINV3zxbdsCrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 041/122] platform/x86: lenovo-yoga-tab2-pro-1380-fastcharger: fix serdev race
Date: Tue, 21 Jan 2025 18:51:29 +0100
Message-ID: <20250121174534.563731849@linuxfoundation.org>
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

[ Upstream commit 59616a91e5e74833b2008b56c66879857c616006 ]

The yt2_1380_fc_serdev_probe() function calls devm_serdev_device_open()
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

Fixes: b2ed33e8d486 ("platform/x86: Add lenovo-yoga-tab2-pro-1380-fastcharger driver")
Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20250111180951.2277757-1-chenyuan0y@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/lenovo-yoga-tab2-pro-1380-fastcharger.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/lenovo-yoga-tab2-pro-1380-fastcharger.c b/drivers/platform/x86/lenovo-yoga-tab2-pro-1380-fastcharger.c
index d525bdc8ca9b3..32d9b6009c422 100644
--- a/drivers/platform/x86/lenovo-yoga-tab2-pro-1380-fastcharger.c
+++ b/drivers/platform/x86/lenovo-yoga-tab2-pro-1380-fastcharger.c
@@ -199,14 +199,15 @@ static int yt2_1380_fc_serdev_probe(struct serdev_device *serdev)
 	if (ret)
 		return ret;
 
+	serdev_device_set_drvdata(serdev, fc);
+	serdev_device_set_client_ops(serdev, &yt2_1380_fc_serdev_ops);
+
 	ret = devm_serdev_device_open(dev, serdev);
 	if (ret)
 		return dev_err_probe(dev, ret, "opening UART device\n");
 
 	serdev_device_set_baudrate(serdev, 600);
 	serdev_device_set_flow_control(serdev, false);
-	serdev_device_set_drvdata(serdev, fc);
-	serdev_device_set_client_ops(serdev, &yt2_1380_fc_serdev_ops);
 
 	ret = devm_extcon_register_notifier_all(dev, fc->extcon, &fc->nb);
 	if (ret)
-- 
2.39.5



