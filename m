Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CBB749365B;
	Mon, 31 Aug 2026 14:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185152; cv=none; b=lRbg8xlEG3HcvhWYlxNJ3coPlPU/TeFD1mofYeKuQ5CsMhpOQBP5jt7Ls22hqJB0sP3h2KRrsupzlx6y0tu6MOm2M5gpw+7F3VBFv0582cauV74Re9B2FfLs//S/pkjj0ztSNeJ8bhaDYvhCrkUI7tN86oOfuoixO/M2J+bkAgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185152; c=relaxed/simple;
	bh=97zoGd7XE4Ifl40KSvjHmtnfMv8Vjn9dhX70/Tc3U2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rMem0lHBvKitV4J/3cUJHtXApdPGqpMAwR9Whp8NAoS/Aq9IIBCDxci42UxR9+gwcSKpAWnwzPsuCAq79vFUBXuNPiR9i6iCaqDu5hzfNc0WLrr3G6GzoeBPjmriggTmwPChptJQJumkv8iowGwhXyrGpFhaubY/m2ym5OYp1l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KPbXiPqT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KPbXiPqT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B493E1F000E9;
	Mon, 31 Aug 2026 14:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788185150;
	bh=lbfaA4nEDSLM0VHK+D0KC198UIqnr7W2p+4uD/hviQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KPbXiPqT12YIRPOcyc2XRBH7fk11pkEur/bZigVlzKAOkFYRasrac7mZYb/GH//c8
	 eVcpfvFY+byDrh0YGTNUVA5XxKG1qeCCjwkQzse9LiOblPtXv6+OaObc9pO4zb+DjU
	 bsauKQ6/7J07gSfOg0//22ZeTgQjoHpn8QK0A8eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Zaidman <michael.zaidman@gmail.com>,
	Germain Hebert <germain.hebert@ca.abb.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 33/69] HID: ft260: fix i2c probing for hwmon devices
Date: Mon, 31 Aug 2026 15:35:06 +0200
Message-ID: <20260831133400.161575428@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133358.601894154@linuxfoundation.org>
References: <20260831133358.601894154@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Zaidman <michael.zaidman@gmail.com>

[ Upstream commit a94f61e63f337d95001e1a976ab701100fa1d666 ]

The below scenario causes the kernel NULL pointer dereference failure:
1. sudo insmod hid-ft260.ko
2. sudo modprobe lm75
3. unplug USB hid-ft260
4. plug USB hid-ft260

[  +0.000006] Call Trace:
[  +0.000004]  __i2c_smbus_xfer.part.0+0xd1/0x310
[  +0.000007]  ? ft260_smbus_write+0x140/0x140 [hid_ft260]
[  +0.000005]  __i2c_smbus_xfer+0x2b/0x80
[  +0.000004]  i2c_smbus_xfer+0x61/0xf0
[  +0.000005]  i2c_default_probe+0xf9/0x130
[  +0.000004]  i2c_detect_address+0x84/0x160
[  +0.000004]  ? kmem_cache_alloc_trace+0xf6/0x200
[  +0.000009]  ? i2c_detect.isra.0+0x69/0x130
[  +0.000005]  i2c_detect.isra.0+0xbf/0x130
[  +0.000004]  ? __process_new_driver+0x30/0x30
[  +0.000004]  __process_new_adapter+0x18/0x20
[  +0.000004]  bus_for_each_drv+0x84/0xd0
[  +0.000003]  i2c_register_adapter+0x1e4/0x400
[  +0.000005]  i2c_add_adapter+0x5c/0x80
[  +0.000004]  ft260_probe.cold+0x222/0x2e2 [hid_ft260]
[  +0.000006]  hid_device_probe+0x10e/0x170 [hid]
[  +0.000009]  really_probe+0xff/0x460
[  +0.000004]  driver_probe_device+0xe9/0x160
[  +0.000003]  __device_attach_driver+0x71/0xd0
[  +0.000004]  ? driver_allows_async_probing+0x50/0x50
[  +0.000004]  bus_for_each_drv+0x84/0xd0
[  +0.000002]  __device_attach+0xde/0x1e0
[  +0.000004]  device_initial_probe+0x13/0x20
[  +0.000004]  bus_probe_device+0x8f/0xa0
[  +0.000003]  device_add+0x333/0x5f0

It happened when i2c core probed for the devices associated with the lm75
driver by invoking 2c_detect()-->..-->ft260_smbus_write() from within the
ft260_probe before setting the adapter data with i2c_set_adapdata().

Moving the i2c_set_adapdata() before i2c_add_adapter() fixed the failure.

Signed-off-by: Michael Zaidman <michael.zaidman@gmail.com>
Signed-off-by: Germain Hebert <germain.hebert@ca.abb.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Stable-dep-of: bf3e39df3a39 ("HID: ft260: fix stack-use-after-return write in I2C read race")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-ft260.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/hid/hid-ft260.c
+++ b/drivers/hid/hid-ft260.c
@@ -969,24 +969,23 @@ static int ft260_probe(struct hid_device
 	mutex_init(&dev->lock);
 	init_completion(&dev->wait);
 
+	ret = ft260_xfer_status(dev);
+	if (ret)
+		ft260_i2c_reset(hdev);
+
+	i2c_set_adapdata(&dev->adap, dev);
 	ret = i2c_add_adapter(&dev->adap);
 	if (ret) {
 		hid_err(hdev, "failed to add i2c adapter\n");
 		goto err_hid_close;
 	}
 
-	i2c_set_adapdata(&dev->adap, dev);
-
 	ret = sysfs_create_group(&hdev->dev.kobj, &ft260_attr_group);
 	if (ret < 0) {
 		hid_err(hdev, "failed to create sysfs attrs\n");
 		goto err_i2c_free;
 	}
 
-	ret = ft260_xfer_status(dev);
-	if (ret)
-		ft260_i2c_reset(hdev);
-
 	return 0;
 
 err_i2c_free:


