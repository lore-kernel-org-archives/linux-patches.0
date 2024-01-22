Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276D06313F;
	Tue, 23 Jan 2024 01:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975009; cv=none; b=sdISEadCcfb9iGQcnaXtV6jXRUeB8rkH0ysElZHKlnllm2WeqBx7qug4RzKOq+8whtDob/1fj7srzomFd45OUiLYvRaWffxdFaktvaRlXPr83sCcSwwu2gsGFsD7CQ6IpFglU/d6uofs/Nv9UZ7+pyGsuns45GpoCI11STI/mtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975009; c=relaxed/simple;
	bh=uqx0WdfAAuava7/b3IH8R+R12G2C+QQNbaBd1Lswt9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DEZFlCKvqRJgHkCZgbgTmB/UlMasWIhOckXwgj9bU9D7IvbrR2mspsasJwgnZw3811XOA+2j1Fm8XfZJvto8SZYm2zA9i3oBalYfR5rC8L5SijvekSwhUCMeNyUkBsHKvZ1t4I9Q2FyVq6G6qSoVCPAjxGCg5c2HaKdz62Dqc8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NcFGzTCG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NcFGzTCG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 870D9C433C7;
	Tue, 23 Jan 2024 01:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975008;
	bh=uqx0WdfAAuava7/b3IH8R+R12G2C+QQNbaBd1Lswt9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NcFGzTCGAGiVz3/QS0ymjVhKkaZSE6JG8MPVASskwRH93/dgxvqpeREZxlrjt42cS
	 Xzup/KqX8L5qsVJEHSBeD1AQzfQ0Ns9Jg5kfch4g9GBi1Z0JZQ25ergr+3AtvKS3jj
	 FnKBkyUoRgqJbaBLHkcV+XPzzoZcm45fiwKbNMYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 321/374] usb: core: Fix crash w/ usb_choose_configuration() if no driver
Date: Mon, 22 Jan 2024 15:59:37 -0800
Message-ID: <20240122235756.063182715@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 44995e6f07028f798efd0c3c11a1efc78330f600 ]

It's possible that usb_choose_configuration() can get called when a
USB device has no driver. In this case the recent commit a87b8e3be926
("usb: core: Allow subclassed USB drivers to override
usb_choose_configuration()") can cause a crash since it dereferenced
the driver structure without checking for NULL. Let's add a check.

A USB device with no driver is an anomaly, so make
usb_choose_configuration() return immediately if there is no driver.

This was seen in the real world when usbguard got ahold of a r8152
device at the wrong time. It can also be simulated via this on a
computer with one r8152-based USB Ethernet adapter:
  cd /sys/bus/usb/drivers/r8152-cfgselector
  to_unbind="$(ls -d *-*)"
  real_dir="$(readlink -f "${to_unbind}")"
  echo "${to_unbind}" > unbind
  cd "${real_dir}"
  echo 0 > authorized
  echo 1 > authorized

Fixes: a87b8e3be926 ("usb: core: Allow subclassed USB drivers to override usb_choose_configuration()")
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20231211073237.v3.1.If27eb3bf7812f91ab83810f232292f032f4203e0@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/core/generic.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/core/generic.c b/drivers/usb/core/generic.c
index 57f6cab36ef6..77aefe0f4fc5 100644
--- a/drivers/usb/core/generic.c
+++ b/drivers/usb/core/generic.c
@@ -59,7 +59,16 @@ int usb_choose_configuration(struct usb_device *udev)
 	int num_configs;
 	int insufficient_power = 0;
 	struct usb_host_config *c, *best;
-	struct usb_device_driver *udriver = to_usb_device_driver(udev->dev.driver);
+	struct usb_device_driver *udriver;
+
+	/*
+	 * If a USB device (not an interface) doesn't have a driver then the
+	 * kernel has no business trying to select or install a configuration
+	 * for it.
+	 */
+	if (!udev->dev.driver)
+		return -1;
+	udriver = to_usb_device_driver(udev->dev.driver);
 
 	if (usb_device_is_owned(udev))
 		return 0;
-- 
2.43.0



