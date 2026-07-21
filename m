Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB43B47042E;
	Tue, 21 Jul 2026 20:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664096; cv=none; b=hLSZFdhX8ydHvyesBM64dlBylXHVPigs6dvrc3Np4rgm4Mqj4dR7CvEGVTWVF7jhBWn2rHvVM47loLVqn7JAjJx31kp2/a8SDC/ZLcuYR/qcbYO5zQGuMQQPNu0Wh/SJFaq6agJLrooVddHi9r8tN7aYsai6tQejxXOZlBfXUuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664096; c=relaxed/simple;
	bh=ZyxC0iornrnI9+CQgzt1VmQ5qSZ5PXbWWdxQEx9V3uI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a8D4V4NFmCaA4dO9LP3h+zgKHmgooCuq38ZsEs1cqrJcUK3PRJFTMP7XRPRB2Pq2/tEn/nsU7zPIWXoxMRlTr0d8J0deBzUL2daRkb182SfK69s7pbUToQ1R+RJ16I4JCcb1iABM/9ATqMo/2ExgwHOyW6hvevZDC//LQQhfoYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tXB/SE7A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tXB/SE7A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E56DF1F000E9;
	Tue, 21 Jul 2026 20:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664093;
	bh=ddnX+mB0tWYh21VqKN4mIQRkbpohpi1a/C9jMLTfZxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tXB/SE7Ao0UUn6P0mztXEC2GsxbN72EwIeUjYfw31wCKE7jWAx4kKyzoOwjz/6wmW
	 lzFagQr/qWpNRVLqdymnrkwCA587IdXZm7jSZj+UzdilmSHeulx6QD6jDGWRSWUWra
	 /PiWgj6mvBNz/UmVpaMhcgwSYM/GQGOwgBjPMKiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.12 1071/1276] hwmon: (w83793) remove vrm sysfs file on probe failure
Date: Tue, 21 Jul 2026 17:25:14 +0200
Message-ID: <20260721152509.953320416@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

commit 77b983757280c69b0290811669ff1d31022e5f1d upstream.

w83793_probe() creates the vrm sysfs file after creating the VID files
when VID support is present.

The normal remove path deletes vrm, but the probe error path only
removes the sensor, SDA, VID, fan, PWM and temperature files.  A later
probe failure can therefore leave vrm behind after the driver data has
been freed.

Remove vrm in the probe error path next to the VID files, matching the
normal remove path.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://lore.kernel.org/r/20260615064806.51139-1-pengpeng@iscas.ac.cn
Cc: stable@vger.kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/w83793.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hwmon/w83793.c
+++ b/drivers/hwmon/w83793.c
@@ -1917,6 +1917,7 @@ exit_remove:
 
 	for (i = 0; i < ARRAY_SIZE(w83793_vid); i++)
 		device_remove_file(dev, &w83793_vid[i].dev_attr);
+	device_remove_file(dev, &dev_attr_vrm);
 
 	for (i = 0; i < ARRAY_SIZE(w83793_left_fan); i++)
 		device_remove_file(dev, &w83793_left_fan[i].dev_attr);


