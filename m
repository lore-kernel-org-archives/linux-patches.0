Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E241F361DA6;
	Wed, 30 Sep 2026 17:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788780; cv=none; b=o1Yq9kmjGn/j4GgZb0R8J1t/gREUYVyR0QNKJ0TUONJ1pgO5Qr+SwCY5iICg2I6tTiZFijHB+NyUDHqOgfc+4DRkPWbBhLda5ZVP8zB6+TH8wq2fsi6CYyo+QpmXUN4P+iszuimn25/vVRMVttgs7xBuQAqSb6ComFfssj9Lfjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788780; c=relaxed/simple;
	bh=U7gkOFzUs/9llRySCIPq9qb6vQ0YgAmLN+TwZewHNC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AgAqj2UIX5AsJMTra/kxHby8tDxO7h6wT0Wu45x8hlI1O8mKos7W1KZUv6VwcpoKM6MO5Prxitl7let18uFv9vXKyxODE+Aws9LEhhyCh9ytD2R+htCpJb9SvMxbKJHYQ15NV2Seiu7tiIUqt6V7hRpPgeayPBUY9IG3VXmkKF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PoY3nP3C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PoY3nP3C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 498EB1F000FF;
	Wed, 30 Sep 2026 17:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788778;
	bh=eCJNHNeXUoKhM893W2hUwC5YO9VIaIOnCuxDrmuUho4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PoY3nP3CPI99LQkWF6VlASRrkBpCd7HLsSHNi3JpLPgMMC9ZIox3BkDvoJbSoL2CJ
	 Q1wIOJknvG098WLzpyFbTCKLdS6k5HTMBv1KLh8iTwsKhGGTPbcPiFDzbLA4heNuAT
	 m9F1HEsjtn/oCM4dfGkAZarjkdrDyH5014VXlurY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+09103639e39c989e3ed3@syzkaller.appspotmail.com,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 244/877] Input: synaptics-rmi4 - fix GPF in suspend and resume when unbound
Date: Wed, 30 Sep 2026 17:19:15 +0200
Message-ID: <20260930152419.990101426@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


