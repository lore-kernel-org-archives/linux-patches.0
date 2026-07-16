Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B220429810;
	Thu, 16 Jul 2026 14:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212111; cv=none; b=XuszeOYxtnf16D0Uw1XCn1WPDn6uMP4wT8UFHyEG/Hyp2AvlLE0NTaVPgLVtLPKQD8ZOiTp5dcOe352xc/FAk5KYzQYlPDELx6d4scPyuBrIrh7XQxXrIpzx8rkeEA7dXPVBsT72NhB95R859oi0i74MBLbOrfenUGnwlo4RRtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212111; c=relaxed/simple;
	bh=KzQeXOoUCstc7YzDXfhsGFgXqVoX13SM9zji2n2dF6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NtyfMPMcRe5dCnYe5okSPo/4Yftp05yhNtmCXWTWtjX+kuuIxJTciGGuFZysltJZT4O/Ak83JY0WxCo/nbAyA2ULEmVR0KQUgIKNwP85Lgyj+FZMv8zJbIAfuZ66V1jObFaRuXSJhn2L4sUXwHDHTNBqC2d0kV7WYK97aV+SyDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k++TQ54K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k++TQ54K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B169C1F00A3A;
	Thu, 16 Jul 2026 14:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212110;
	bh=oDBs8Kyriiw6EpjIEwawAGOMDnPDeVUuhViOzKxJoN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k++TQ54Kts5LrI++8Ksx/3BpKAZbm4ffCFJuomdtwdWZNwkGQwqyyxDgq4IDBJQte
	 YiCTD55mdgZ+UkCByZqaGkCQl6i5h4dUXhIKAP2c+H52hDCjwFX9fYWk9uGGfVn9VD
	 gmnU4XixRlfoIs9QXTqs5RN18h7m+9L7wK+m1Koo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manish Khadka <maskmemanish@gmail.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.12 204/349] HID: letsketch: fix UAF on inrange_timer at driver unbind
Date: Thu, 16 Jul 2026 15:32:18 +0200
Message-ID: <20260716133037.933314350@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

From: Manish Khadka <maskmemanish@gmail.com>

commit 46c8beeccd8ab2c863827254a85ea877654a3534 upstream.

letsketch_driver does not provide a .remove callback, but
letsketch_probe() arms a per-device timer:

    timer_setup(&data->inrange_timer, letsketch_inrange_timeout, 0);

The timer is re-armed from letsketch_raw_event() with a 100 ms
timeout on every pen-in-range report, and its callback dereferences
data->input_tablet to deliver a synthetic BTN_TOOL_PEN release.

letsketch_data is allocated with devm_kzalloc(), and its input_dev
fields are devm-allocated via letsketch_setup_input_tablet().  On
device unbind (USB unplug or rmmod), the HID core runs its default
teardown and devm cleanup frees both letsketch_data and the input
devices.  Because no .remove callback exists, nothing drains the
timer first: if raw_event armed it within ~100 ms of the unbind,
the pending timer fires on freed memory.  This is a UAF read of
data and of data->input_tablet, followed by input_report_key() /
input_sync() into the freed input_dev.

The same problem can occur on the probe error path: if
hid_hw_start() enabled I/O on an always-poll-quirk device and then
failed, raw_event may have armed the timer before devm releases
data.

Fix by adding a .remove callback that calls hid_hw_stop() first.
hid_hw_stop() synchronously kills the URBs that deliver raw_event(),
so once it returns no path can re-arm the timer.  timer_shutdown_sync()
then drains any in-flight callback and permanently disables further
mod_timer() calls.  Apply the same timer_shutdown_sync() in the probe
error path so the timer is guaranteed not to outlive data.

Fixes: 33a5c2793451 ("HID: Add new Letsketch tablet driver")
Cc: stable@vger.kernel.org
Signed-off-by: Manish Khadka <maskmemanish@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-letsketch.c |   36 +++++++++++++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 3 deletions(-)

--- a/drivers/hid/hid-letsketch.c
+++ b/drivers/hid/hid-letsketch.c
@@ -295,13 +295,42 @@ static int letsketch_probe(struct hid_de
 
 	ret = letsketch_setup_input_tablet(data);
 	if (ret)
-		return ret;
+		goto err_shutdown_timer;
 
 	ret = letsketch_setup_input_tablet_pad(data);
 	if (ret)
-		return ret;
+		goto err_shutdown_timer;
 
-	return hid_hw_start(hdev, HID_CONNECT_HIDRAW);
+	ret = hid_hw_start(hdev, HID_CONNECT_HIDRAW);
+	if (ret)
+		goto err_shutdown_timer;
+
+	return 0;
+
+err_shutdown_timer:
+	/*
+	 * Drain any pending callback and permanently disable the timer
+	 * before devm releases data: if hid_hw_start() enabled I/O on an
+	 * always-poll-quirk device and then failed, raw_event may have
+	 * armed the timer already.
+	 */
+	timer_shutdown_sync(&data->inrange_timer);
+	return ret;
+}
+
+static void letsketch_remove(struct hid_device *hdev)
+{
+	struct letsketch_data *data = hid_get_drvdata(hdev);
+
+	/*
+	 * hid_hw_stop() synchronously kills the URBs that deliver
+	 * raw_event(), so once it returns no path can re-arm
+	 * inrange_timer.  timer_shutdown_sync() then drains any
+	 * in-flight callback and permanently disables further
+	 * mod_timer() calls before devm releases data.
+	 */
+	hid_hw_stop(hdev);
+	timer_shutdown_sync(&data->inrange_timer);
 }
 
 static const struct hid_device_id letsketch_devices[] = {
@@ -314,6 +343,7 @@ static struct hid_driver letsketch_drive
 	.name = "letsketch",
 	.id_table = letsketch_devices,
 	.probe = letsketch_probe,
+	.remove = letsketch_remove,
 	.raw_event = letsketch_raw_event,
 };
 module_hid_driver(letsketch_driver);


