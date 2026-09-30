Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ACB33749F6;
	Wed, 30 Sep 2026 16:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786111; cv=none; b=P7Qj1QsUnBawNOoAZ0LRwYJ3I7IvNCf82X4ElVVj24TNAhdBKklzd8dsTmTb8VX81uWP3NfSHwv4lif7UuJEcrlQE63lU0CrE/z7zHt6ivDQmimFEqs1YeYFx1hs3umEVE42fACtJgA5X1ZCC7q+BTVJUAJ/Uyjf8789lO+dx4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786111; c=relaxed/simple;
	bh=MD4G3y3ej0lffhVTYA2TYOvzbAUrkLdzI0MPtgunGEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JIAwXBrKFtwOgWojzC/kpE9AAi0PXG7+B3umf2adCSYOmRxEia6mPI8pobDCOqHIVLEUv4NFuK9mYgw5BQfnMsmo27G//3aBXTUhmZbiHwq8c/gpW8ut9TFnGFZ3u/cRa3xj6zI9LppsX+RzmTyxqboH8GXO5rCEIR9+fk9h544=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0FB+/+9S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0FB+/+9S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B2C61F000FF;
	Wed, 30 Sep 2026 16:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786109;
	bh=+QGwRwzGjqS+XsMZbgNUNSAkDfdC90pNC3RtPavDCWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0FB+/+9SBrP0YNyOQK7nH9iAUI1bgi8MP4X11U4mq1McNpFNNqN5D3mMsMXj6mIvu
	 4yaUsYBhQulbBtWU5TXuLM/gYm9NRnY6A0g1pfhLJJnanBAug5goUsOiiaxV30TeyO
	 keuJl2Ug56rbT4/IuqIM+nR8vk7t+UCRMMsidkyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+09103639e39c989e3ed3@syzkaller.appspotmail.com,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 747/982] Input: synaptics-rmi4 - fix GPF in suspend and resume when unbound
Date: Wed, 30 Sep 2026 17:24:43 +0200
Message-ID: <20260930152432.801613075@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit fe10579b6dc3f0dac61e51e1797cacbba5039ac2 upstream.

Transport drivers (such as rmi_i2c and rmi_spi) invoke
rmi_driver_suspend() and rmi_driver_resume() on their child rmi_dev
device during system power management events. However, transport drivers
are fully registered and operational even if the physical RMI driver
failed to bind or probe the rmi_dev device.

When rmi_driver_suspend() or rmi_driver_resume() is called on an unbound
rmi_dev, dev_get_drvdata() returns NULL. Calling rmi_disable_irq() or
rmi_enable_irq() without driver data attached causes a NULL pointer
dereference and General Protection Fault when attempting to lock
data->enabled_mutex.

Fix this by checking if driver data is attached to rmi_dev in
rmi_driver_suspend() and rmi_driver_resume(), exiting early if
no driver data is present.

Fixes: 2b6a321da9a2 ("Input: synaptics-rmi4 - add support for Synaptics RMI4 devices")
Reported-by: syzbot+09103639e39c989e3ed3@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=09103639e39c989e3ed3
Cc: stable@vger.kernel.org
Assisted-by: LLM
Link: https://patch.msgid.link/anQe8UiyUR4x0flD@google.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/rmi4/rmi_driver.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/input/rmi4/rmi_driver.c
+++ b/drivers/input/rmi4/rmi_driver.c
@@ -946,6 +946,15 @@ int rmi_driver_suspend(struct rmi_device
 {
 	int retval;
 
+	/*
+	 * Transport driver will try to suspend RMI device even if physical
+	 * driver did not bind to the RMI device, because transport device
+	 * (I2C, SPI) is fully registered and operational. Exit early if
+	 * there is no driver data attached to the RMI device.
+	 */
+	if (!dev_get_drvdata(&rmi_dev->dev))
+		return 0;
+
 	retval = rmi_suspend_functions(rmi_dev);
 	if (retval)
 		dev_warn(&rmi_dev->dev, "Failed to suspend functions: %d\n",
@@ -960,6 +969,10 @@ int rmi_driver_resume(struct rmi_device
 {
 	int retval;
 
+	/* Skip if not fully bound to RMI driver */
+	if (!dev_get_drvdata(&rmi_dev->dev))
+		return 0;
+
 	rmi_enable_irq(rmi_dev, clear_wake);
 
 	retval = rmi_resume_functions(rmi_dev);


