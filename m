Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C2E471438;
	Tue, 21 Jul 2026 20:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665206; cv=none; b=u23XiW4qNRWvXWdXmOtWlu6o1PZsrrMPXkby7oZUG5ZgHP3FD9mEd6HiLJsFWPOL/ZYnj7T5SqzW5aIqWV/mPKbTQCRbEbqwowfRAHmUt0Au2elv5V5bwaP+5u84CZ3riCMp6uuth0UnRwFdTnnOUdqkNoPY5S1+oYFQh2MFs+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665206; c=relaxed/simple;
	bh=PSIvo2hvj/7eP2Z3/blYRnKIk4RUOiodQh8iUePBoDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DVbpkmPEo4HHWaAyDJnuY0gAM69KocgfTvUvz4kUcIPM4Wx0QgNGOxhs+BuebwQN7hyUd9axOSd5Hq1rcGKxs8VRmk6iRKWPoDfiyDqTA5bytnegz4cZLpOsYE2quUnNLNIBlmxUZucgVBSBjpHZ9OHCAtMGNDfVs5M7Lp5CNKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cfj8Ebrb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cfj8Ebrb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E59241F000E9;
	Tue, 21 Jul 2026 20:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665204;
	bh=Zj+FFKaTQIT5SoP4SVx/pB+12xZTYy7ZKDphZ8olPeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cfj8EbrbbdmF86sR3B5TMQWrctl4uQNQN6e2637FUszj1NlK+KgjWr08tDa4CksVn
	 c506R7q4a1t7ouiyqAoYzaDhXLhG2DFBxqy1KfUEpgqgImMIG54gf2M5kDnUgV+wV6
	 /mA9kX8CBpLfjtePCErK521R0yMAdeJL7MMTW81w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hansg@kernel.org>,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.6 0215/1266] HID: lg-g15: cancel pending work on remove to fix a use-after-free
Date: Tue, 21 Jul 2026 17:10:52 +0200
Message-ID: <20260721152446.628378038@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -945,11 +945,27 @@ static const struct hid_device_id lg_g15
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
 


