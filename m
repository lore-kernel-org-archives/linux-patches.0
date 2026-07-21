Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E9E3AA4F9;
	Tue, 21 Jul 2026 22:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673361; cv=none; b=dC4G1AmCaG2Xt1UYdMqFFWedLGYiluw745m4ZzVt/VgMg1RUQ2E09VgLtjUgYW9JF1JktFixfoV8zxmrDYzBMUpRQYt8xSUV5P04D0HR1aRSPjUDjuhDPKJjpI9FOfynM+bCTJHpyOKS/yUxX6lZxm1zHw6O7cLmRGzENboGlEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673361; c=relaxed/simple;
	bh=Wc5hKid3xcN4kH9HRvEW273HrzNp6ojwRiVvIIX0tqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ATIfhcKHO2JCczDhpq5o5LNi7moiGv2x7On4IDJt+Ruxr5PnofTKHa/66fehW1QREBX+7F2uF2xXQ+KO2T2TV6Ggm/1tksuWRS1xeJs5q70sgiYUJEAA3rsjMCv/YOLrFcnl9a7ptVB8YZKn1q4B6TBOLgk274MkHr5K7elCKPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MxqiT4Wv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MxqiT4Wv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41BC61F000E9;
	Tue, 21 Jul 2026 22:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673359;
	bh=qBgEOs/Lul/scU5G4dKkmnD2TEBj/X1juh88T/fZmjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MxqiT4WvXE0+NSFKVKIWvRpwJVTINlsmJvDvloIHc1xVBXWA16/7SR88WUxiv0lCN
	 6Gu7yLrpjki5H92x7yyAFDa+JU7lxOcvU2IqMGdeaVLTkgGO8eLgUkr3M4UsHc00rR
	 Rsgmgc5KfTYNHLAasG3YuD5iQ7s++8XWOfxuCLQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrei Kuchynski <akuchynski@chromium.org>,
	Benson Leung <bleung@chromium.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 5.10 080/699] mfd: cros_ec: Delay dev_set_drvdata() until probe success
Date: Tue, 21 Jul 2026 17:17:19 +0200
Message-ID: <20260721152357.509699123@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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
@@ -137,7 +137,6 @@ static int ec_device_probe(struct platfo
 	if (!ec)
 		return retval;
 
-	dev_set_drvdata(dev, ec);
 	ec->ec_dev = dev_get_drvdata(dev->parent);
 	ec->dev = dev;
 	ec->cmd_offset = ec_platform->cmd_offset;
@@ -179,6 +178,8 @@ static int ec_device_probe(struct platfo
 	if (retval)
 		goto failed;
 
+	dev_set_drvdata(dev, ec);
+
 	/* check whether this EC is a sensor hub. */
 	if (cros_ec_get_sensor_count(ec) > 0) {
 		retval = mfd_add_hotplug_devices(ec->dev,


