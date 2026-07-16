Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49AB4252B9;
	Thu, 16 Jul 2026 14:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211003; cv=none; b=CRtTDmC1pfguxdes2PEor2tFjRgwLZ9GN3bMxuR/Fx2JrbOUIAdIi96TMi/Aswz/zR2u8M3CnQTt+j2lx4fCUkteu5I2IpIZItt5xtmq4h8p9UGUtgsogUTM2PmGkj/tpYyzYzI2m8RnnnRTkAd0GLSnw2bLu+7coXZmmXpXX7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211003; c=relaxed/simple;
	bh=TqpkfcRHPHR87AzqS1po5yTy+fDBfM7sWc0dd5Y6AlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cpfum4/OHFhfayJbpZOGaCpNAic2zbuaC3zyCUq0R4jhdSg31LjRCZkfit+h++VT0Wjuuw+2GxRMEhQTkYsRukHh4GuW3fHjN7Vm5JzpIjlxedV8NhEhzknNF8dx2biUP9Va5ZxR4rPPgGkD6J3gfYO6c5xZY0Mf156MvbgACHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BfJkJ+dJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BfJkJ+dJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 463E41F00A3F;
	Thu, 16 Jul 2026 14:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211001;
	bh=SE589NUpZJO/QqXLE1a6/0jKfwmQAY245QKJzEyL8V0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BfJkJ+dJqnA2v5RTn7vEe/+ZuQnuuJtgQiHZI6CuHGc7X3VuArr3bahg4Unv0aDgK
	 QzzMEoWd3oMjJ6QQ7fJfy1LxF0141PrPxI4YllQoxximHwRFxBAP/MEE1LaqqeavDR
	 VjwNz37nv43ELsvFOXGpDFeay9b2hixmNERwSgQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.18 261/480] HID: wacom: stop hardware after post-start probe failures
Date: Thu, 16 Jul 2026 15:30:08 +0200
Message-ID: <20260716133050.461995873@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

commit ec2612b8ad9e642596db011dd8b6568ef1edeaa1 upstream.

wacom_parse_and_register() starts HID hardware before registering inputs
and initializing pad LEDs/remotes. Those later steps can fail, but their
error paths currently release Wacom resources without stopping the HID
hardware.

Route post-hid_hw_start() failures through hid_hw_stop() before
releasing driver resources.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: c1d6708bf0d3 ("HID: wacom: Do not register input devices until after hid_hw_start")
Cc: stable@vger.kernel.org
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_sys.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -2462,16 +2462,16 @@ static int wacom_parse_and_register(stru
 
 	error = wacom_register_inputs(wacom);
 	if (error)
-		goto fail;
+		goto fail_hw_stop;
 
 	if (wacom->wacom_wac.features.device_type & WACOM_DEVICETYPE_PAD) {
 		error = wacom_initialize_leds(wacom);
 		if (error)
-			goto fail;
+			goto fail_hw_stop;
 
 		error = wacom_initialize_remotes(wacom);
 		if (error)
-			goto fail;
+			goto fail_hw_stop;
 	}
 
 	if (!wireless) {
@@ -2485,14 +2485,14 @@ static int wacom_parse_and_register(stru
 		cancel_delayed_work_sync(&wacom->init_work);
 		_wacom_query_tablet_data(wacom);
 		error = -ENODEV;
-		goto fail_quirks;
+		goto fail_hw_stop;
 	}
 
 	if (features->device_type & WACOM_DEVICETYPE_WL_MONITOR) {
 		error = hid_hw_open(hdev);
 		if (error) {
 			hid_err(hdev, "hw open failed\n");
-			goto fail_quirks;
+			goto fail_hw_stop;
 		}
 	}
 
@@ -2501,7 +2501,7 @@ static int wacom_parse_and_register(stru
 
 	return 0;
 
-fail_quirks:
+fail_hw_stop:
 	hid_hw_stop(hdev);
 fail:
 	wacom_release_resources(wacom);


