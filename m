Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616473FE370;
	Thu, 16 Jul 2026 13:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209455; cv=none; b=gf7KxAcIxGG0JpAXxFDRAkpguF4P7yDLA5rVi22pqk/lrpWIPHh9SYrkR3MzvBp+pid6Uwl83zw/fjYQ98ZLbgH9F7BztM8rCzG9LaCv3T7YFKg+DRlqxls/NFb8M6c0Vgw/vXLCg76+rC4HV6J1CBSbsXd0Sb9KXFQwOYqlI3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209455; c=relaxed/simple;
	bh=eOUBq3HZONWeDTuwmulLU8Mnxqsr08akC1rML5gt4HU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hwFKCIJth4zO0eA1vZqBCx2jqJ6lD4uTdlAuJeb6xzRtVjXv92ne5tJMNsNqWBFUuDMOrxrS5A10CibLm52ntMRqUZz7xHEo+i3eGRfpluGnK7EYh668+yyv2hDKogPBtHnkkmTXzvcGEFKuQZ606FSri51DYcnnej7k0BDaCYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O00xDn4r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O00xDn4r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98DB91F00A3E;
	Thu, 16 Jul 2026 13:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209453;
	bh=j+cAopViIi1+a+IXcj9CJ45by0Oa3BD0Ic2GfS2F6qM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O00xDn4rBrne1y3UEb2ZHUa09QNmHSn/AbFaPcPAXJRA3CBtz/TjYMTKp+pz7Ekgp
	 l8BgrXNooNv4oMmiOPixERqEGxcm9kG0KVZiLbw3D+VNZl4mbadfRSQWEFUPPQMb0w
	 0J8tiMRAwZPgruN1Zf9yJmrN+u3ANxr5AbK/orrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrei Kuchynski <akuchynski@chromium.org>,
	Benson Leung <bleung@chromium.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 7.1 191/518] mfd: cros_ec: Delay dev_set_drvdata() until probe success
Date: Thu, 16 Jul 2026 15:27:39 +0200
Message-ID: <20260716133052.011410986@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrei Kuchynski <akuchynski@chromium.org>

commit 8b2c1d41bc36c100b38ce5ee6def246c527eaf8a upstream.

If ec_device_probe() fails, cros_ec_class_release releases memory for the
cros_ec_dev structure. However, because the drvdata was already set,
sub-drivers like cros_ec_typec can still retrieve the stale pointer via the
platform device. This leads to a use-after-free when cros_ec_typec attempts
to access &typec->ec->ec->dev on a device that has already been released.
Move dev_set_drvdata() to ensure that the pointer is only made available
once all initialization steps have succeeded.

 sysfs: cannot create duplicate filename '/class/chromeos/cros_ec'
 Call trace:
  sysfs_do_create_link_sd+0x94/0xdc
  sysfs_create_link+0x30/0x44
  device_add_class_symlinks+0x90/0x13c
  device_add+0xf0/0x50c
  ec_device_probe+0x150/0x4f0
  platform_probe+0xa0/0xe0
 ...
 BUG: KASAN: invalid-access in __memcpy+0x44/0x230
 Write at addr f5ffff809e2d33ac by task kworker/u32:5/125
 Pointer tag: [f5], memory tag: [fe]
 Tainted : [W]=WARN, [O]=OOT_MODULE
 Hardware name: Google Navi unprovisioned 0x7FFFFFFF/sku0 board/sku3
 Workqueue: events_unbound deferred_probe_work_func
 Call trace:
  __memcpy+0x44/0x230
  cros_ec_check_features+0x60/0xcc [cros_ec_proto]
  cros_typec_probe+0xe8/0x6e0 [cros_ec_typec]
  platform_probe+0xa0/0xe0

Cc: stable@vger.kernel.org
Fixes: 1c1d152cc5ac ("platform/chrome: cros_ec_dev - utilize new cdev_device_add helper function")
Co-developed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrei Kuchynski <akuchynski@chromium.org>
Reviewed-by: Benson Leung <bleung@chromium.org>
Link: https://patch.msgid.link/20260427131721.1165078-1-akuchynski@chromium.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/cros_ec_dev.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/mfd/cros_ec_dev.c
+++ b/drivers/mfd/cros_ec_dev.c
@@ -195,7 +195,6 @@ static int ec_device_probe(struct platfo
 	if (!ec)
 		return retval;
 
-	dev_set_drvdata(dev, ec);
 	ec->ec_dev = dev_get_drvdata(dev->parent);
 	ec->dev = dev;
 	ec->cmd_offset = ec_platform->cmd_offset;
@@ -237,6 +236,8 @@ static int ec_device_probe(struct platfo
 	if (retval)
 		goto failed;
 
+	dev_set_drvdata(dev, ec);
+
 	/* check whether this EC is a sensor hub. */
 	if (cros_ec_get_sensor_count(ec) > 0) {
 		retval = mfd_add_hotplug_devices(ec->dev,


