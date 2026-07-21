Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496C2442129;
	Tue, 21 Jul 2026 21:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668388; cv=none; b=QPZ5pHuX3Y1GBtpm7LBbI858u6AlBRa04cXZB2dpc4TaYEYipD78cVUesv+AirbyyQeg/bcEwRO99H/wT0YZKDi+hp+h8xiDXAlUMoIQ6iA4XacD6bDI8zRlaBDLtr/69GhY5aLwNNiyK/JgcC5J+SPwC/eUrrtcvjCPW2Kofts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668388; c=relaxed/simple;
	bh=SwT1JkuVpHaWOH6gfYTLA0djizI2WXzwcYWavYZSrew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eASaWMaYmUd3Shz47TOVLyy02ZKkzs7BOGlnI35B8ROpwi/ZY2qqMtIT0KSiY7JRJJ7/YshtUQTEzfZ1OL+VISr1+HMHr/NRuKahbE+TFc8x9/EnmcZfn3v72QrMQ31Grhfu69wwhtpP7+ORIN5lqN8LVHC5cXwaMcUZrNv/4YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b8PI2Bam; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b8PI2Bam"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F3441F00A3D;
	Tue, 21 Jul 2026 21:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668386;
	bh=pYtqEkwbbldKRFtK7DvjEtPTep5w62OrXwArB2ewR+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b8PI2BamBjOZOx5JPFb6aBPwPrfYtSl6IcpEnh9RFCFwIi75ZV/e/cSDaeHqHE2aw
	 neGRZAmodhM3qHrW5J1BvO05U7UWdCNEJti/dj25rvtdagIr/zIczY6YQq4PVrQ3rx
	 nP/fkiXOeFazLrU+XAOd14F7Tr1JqfOzBEQq6N68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hansg@kernel.org>,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.1 0157/1067] HID: lg-g15: cancel pending work on remove to fix a use-after-free
Date: Tue, 21 Jul 2026 17:12:38 +0200
Message-ID: <20260721152428.102886714@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Maoyi Xie <maoyixie.tju@gmail.com>

commit 7705b4140d188ce22656f6e541ae7ef834c7e11a upstream.

lg_g15_data is allocated with devm and holds a work item. The report
handlers schedule that work straight from device input.
lg_g15_event() and lg_g15_v2_event() do it on the backlight cycle key,
and lg_g510_leds_event() does it too. The worker dereferences the
lg_g15_data back through container_of.

The driver had no remove callback and never cancelled the work. So if a
report scheduled the work and the keyboard was then unplugged, devres
freed lg_g15_data while the work was still pending or running, and the
worker touched freed memory. This is a use-after-free. It is reachable
as a race on device unplug.

Add a remove callback that cancels the work before devres frees the
state. g15->work is only initialized for the models that schedule it
(G15, G15 v2, G510). The G13 and Z-10 leave it zeroed, so guard the
cancel on g15->work.func to avoid cancelling a work that was never set
up. The g15 NULL test mirrors the one already in lg_g15_raw_event().

Fixes: 97b741aba918 ("HID: lg-g15: Add keyboard and LCD backlight control")
Cc: stable@vger.kernel.org
Suggested-by: Hans de Goede <hansg@kernel.org>
Signed-off-by: Maoyi Xie <maoyixie.tju@gmail.com>
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-lg-g15.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/drivers/hid/hid-lg-g15.c
+++ b/drivers/hid/hid-lg-g15.c
@@ -944,11 +944,27 @@ static const struct hid_device_id lg_g15
 };
 MODULE_DEVICE_TABLE(hid, lg_g15_devices);
 
+static void lg_g15_remove(struct hid_device *hdev)
+{
+	struct lg_g15_data *g15 = hid_get_drvdata(hdev);
+
+	/*
+	 * g15->work is only initialized for the models that schedule it
+	 * (G15, G15 v2, G510). The G13 and Z-10 leave it zeroed, so only
+	 * cancel it when it was set up.
+	 */
+	if (g15 && g15->work.func)
+		cancel_work_sync(&g15->work);
+
+	hid_hw_stop(hdev);
+}
+
 static struct hid_driver lg_g15_driver = {
 	.name			= "lg-g15",
 	.id_table		= lg_g15_devices,
 	.raw_event		= lg_g15_raw_event,
 	.probe			= lg_g15_probe,
+	.remove			= lg_g15_remove,
 };
 module_hid_driver(lg_g15_driver);
 


