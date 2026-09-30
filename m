Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 939974BA1E9;
	Wed, 30 Sep 2026 15:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783730; cv=none; b=Ann3BOrCZrolwMtoKBldGokytuFmF2prS4tMKQneqMvhFFp1rmN6z2RmikD8m9ah2qVBRSh5EzXJO3uKDRn93rxq9c9EI6faa8CxTP269Q9Lhbo0r5tX+lMEVQtmGYQc1uGf4pm8OKLyrvtkVZCxnPvelxI7PKmcCnJrERapQOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783730; c=relaxed/simple;
	bh=/f1e7wPHBBE0eT/34i5pkQJx1BetKBi9gqcl0G/ZWx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oqjZJVrf5bittthYMkR9JgBUeeI/S7VFDS1MKN37YnMcUWlNrcgGjlLKitMlXiC/fh0l3sxJ4KS+IndtD9RTZmF+RTArEiQ6lEPjaUWTPR5S0YL4G6uhp1qWK/aNwOz526uOa34ZdMdiTvXnQs82/OLpiFvUhy+Y/+fWw5K08oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DobLjXq5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DobLjXq5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FE081F00893;
	Wed, 30 Sep 2026 15:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783724;
	bh=qARH8NZIqQgXxC3hub4zVEztc2bKyRWpIBVKo6CBdbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DobLjXq5lACTi0sDr/7m7lUHcLAf/Dw4BMmZNNolNVqq/vC30GhstCpzFp5k1+Jsp
	 Alp1Bhfcv4ubHobJFvIEmQ+UCL6NSeJqjwo3q0CH4LAVUMTmEMTJ442HB4hSSag1DX
	 FcGY8P0tkRNrb/jSBXeX0ftA4ZJ7f22NWjSdi/As=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+09103639e39c989e3ed3@syzkaller.appspotmail.com,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 455/595] Input: synaptics-rmi4 - fix GPF in suspend and resume when unbound
Date: Wed, 30 Sep 2026 17:25:48 +0200
Message-ID: <20260930152357.468183355@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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


