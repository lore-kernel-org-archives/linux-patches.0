Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD5C78C73;
	Mon, 15 Apr 2024 14:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191163; cv=none; b=FgYA3Xl7qufHaPtRnDtQdyRYW9DB+CDYD47JefT17KF2R3O01D99e/rXYmlVe921pEv2cogRv/KT/8lP8mTligVlzIvlj5vvdZvnJWtzmJFhggSCcTV4vNgGhJhKBxde32IlW9YQ/SqggJKM/6I/mANE1FZmQ21GxpHVzisR18I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191163; c=relaxed/simple;
	bh=48ZKRZhqYGFgG/X14IhEUpdhaz579zJfPYJk0NtoN+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HO117MQAi7aPFMrQLqa6gm9mTCijK7ctTMymFAX1zPyoqe8eXvmMR/xV84JD00Ni/x5RBXq2w4my8D3qG2fmoMVhLnAcrR0xDdibpVycnTw5urSxsFRUTo8ztW5GEXh6XUoJwOGebKR3tN+qxPWL3BWSGXrSXvfvybdUmuj0guA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sFhrVWlf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sFhrVWlf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 178D3C32783;
	Mon, 15 Apr 2024 14:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191163;
	bh=48ZKRZhqYGFgG/X14IhEUpdhaz579zJfPYJk0NtoN+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sFhrVWlf70bsKW+nayLG87jy1wfSpsa9VCnJ0Dqu0PvkTMjD7nywn7xKQgCwJsunF
	 ml84/Cs+yBZrsMAU8PgjngeDvbSKSPm72+fBHHjl+XXdIDgjrmgXwpEFoHuIw/NNIR
	 PrcDmPHFERS016dY/6v6pta9k4bVT388PUKkDI/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Noah Loomans <noah@noahloomans.com>,
	Guenter Roeck <groeck@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>
Subject: [PATCH 6.8 015/172] platform/chrome: cros_ec_uart: properly fix race condition
Date: Mon, 15 Apr 2024 16:18:34 +0200
Message-ID: <20240415142000.814707631@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Noah Loomans <noah@noahloomans.com>

commit 5e700b384ec13f5bcac9855cb28fcc674f1d3593 upstream.

The cros_ec_uart_probe() function calls devm_serdev_device_open() before
it calls serdev_device_set_client_ops(). This can trigger a NULL pointer
dereference:

    BUG: kernel NULL pointer dereference, address: 0000000000000000
    ...
    Call Trace:
     <TASK>
     ...
     ? ttyport_receive_buf

A simplified version of crashing code is as follows:

    static inline size_t serdev_controller_receive_buf(struct serdev_controller *ctrl,
                                                      const u8 *data,
                                                      size_t count)
    {
            struct serdev_device *serdev = ctrl->serdev;

            if (!serdev || !serdev->ops->receive_buf) // CRASH!
                return 0;

            return serdev->ops->receive_buf(serdev, data, count);
    }

It assumes that if SERPORT_ACTIVE is set and serdev exists, serdev->ops
will also exist. This conflicts with the existing cros_ec_uart_probe()
logic, as it first calls devm_serdev_device_open() (which sets
SERPORT_ACTIVE), and only later sets serdev->ops via
serdev_device_set_client_ops().

Commit 01f95d42b8f4 ("platform/chrome: cros_ec_uart: fix race
condition") attempted to fix a similar race condition, but while doing
so, made the window of error for this race condition to happen much
wider.

Attempt to fix the race condition again, making sure we fully setup
before calling devm_serdev_device_open().

Fixes: 01f95d42b8f4 ("platform/chrome: cros_ec_uart: fix race condition")
Cc: stable@vger.kernel.org
Signed-off-by: Noah Loomans <noah@noahloomans.com>
Reviewed-by: Guenter Roeck <groeck@chromium.org>
Link: https://lore.kernel.org/r/20240410182618.169042-2-noah@noahloomans.com
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/chrome/cros_ec_uart.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/drivers/platform/chrome/cros_ec_uart.c
+++ b/drivers/platform/chrome/cros_ec_uart.c
@@ -263,12 +263,6 @@ static int cros_ec_uart_probe(struct ser
 	if (!ec_dev)
 		return -ENOMEM;
 
-	ret = devm_serdev_device_open(dev, serdev);
-	if (ret) {
-		dev_err(dev, "Unable to open UART device");
-		return ret;
-	}
-
 	serdev_device_set_drvdata(serdev, ec_dev);
 	init_waitqueue_head(&ec_uart->response.wait_queue);
 
@@ -280,14 +274,6 @@ static int cros_ec_uart_probe(struct ser
 		return ret;
 	}
 
-	ret = serdev_device_set_baudrate(serdev, ec_uart->baudrate);
-	if (ret < 0) {
-		dev_err(dev, "Failed to set up host baud rate (%d)", ret);
-		return ret;
-	}
-
-	serdev_device_set_flow_control(serdev, ec_uart->flowcontrol);
-
 	/* Initialize ec_dev for cros_ec  */
 	ec_dev->phys_name = dev_name(dev);
 	ec_dev->dev = dev;
@@ -301,6 +287,20 @@ static int cros_ec_uart_probe(struct ser
 
 	serdev_device_set_client_ops(serdev, &cros_ec_uart_client_ops);
 
+	ret = devm_serdev_device_open(dev, serdev);
+	if (ret) {
+		dev_err(dev, "Unable to open UART device");
+		return ret;
+	}
+
+	ret = serdev_device_set_baudrate(serdev, ec_uart->baudrate);
+	if (ret < 0) {
+		dev_err(dev, "Failed to set up host baud rate (%d)", ret);
+		return ret;
+	}
+
+	serdev_device_set_flow_control(serdev, ec_uart->flowcontrol);
+
 	return cros_ec_register(ec_dev);
 }
 


