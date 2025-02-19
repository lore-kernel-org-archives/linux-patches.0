Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602731DE2B5;
	Wed, 19 Feb 2025 09:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956988; cv=none; b=l0TGAKYRSQnYFyGiC1Wuag41F8g4FZBmowrBBNZlzi8KbiZCw66dWYK+nuJy17dZNqDDea3R7yXLA9Y9nVAilJhy7QDx96KlePFk+nBfL0B0tSvZZl6uYUG3c39N9EFlGTdJOkHqLhpZ+mF3j2gSx1cGWo0ebQV9bwvenbzDdLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956988; c=relaxed/simple;
	bh=bQduW6vRlo05Z3c+IqD0DLPKyPnP1sv15fcR/+3OUz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TfY52aQK4i83afF8eXvNKE/pd3Z8gW22l0mmQGr7sXFb+UBDRVwmCMI5D4FfV2aQd9qlPR7OvKYmgNEatTHTDAldinoH/ReO1Xd5RB3YOcN5/hBW4cMtp9hOd+FWy0TMtR43MoWHlxDDZbf9U1fPY3IMxXC6fjpT5wZexS06zw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bm0sxrv4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bm0sxrv4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 768CCC4CED1;
	Wed, 19 Feb 2025 09:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956987;
	bh=bQduW6vRlo05Z3c+IqD0DLPKyPnP1sv15fcR/+3OUz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bm0sxrv4E8ZNfEkkyhG4WZUlRX/U+DVR+bEouipurb4uZQSr0WFr1PDriCl1B42k8
	 PtiNOeN9FN1pcE7o985uwdM3RyydTEjqJnMfmMxYpB6LpmEjoYwLtbOabbmUhzqZs1
	 FcaiIfwVhxi9JS+StPDMTRr8GgMWyHrGdriLGZ7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Stuebner <heiko@sntech.de>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.1 369/578] HID: hid-sensor-hub: dont use stale platform-data on remove
Date: Wed, 19 Feb 2025 09:26:13 +0100
Message-ID: <20250219082707.532682619@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Heiko Stuebner <heiko@sntech.de>

commit 8a5b38c3fd709e8acd2bfdedf66c25e6af759576 upstream.

The hid-sensor-hub creates the individual device structs and transfers them
to the created mfd platform-devices via the platform_data in the mfd_cell.

Before e651a1da442a ("HID: hid-sensor-hub: Allow parallel synchronous reads")
the sensor-hub was managing access centrally, with one "completion" in the
hub's data structure, which needed to be finished on removal at the latest.

The mentioned commit then moved this central management to each hid sensor
device, resulting on a completion in each struct hid_sensor_hub_device.
The remove procedure was adapted to go through all sensor devices and
finish any pending "completion".

What this didn't take into account was, platform_device_add_data() that is
used by mfd_add{_hotplug}_devices() does a kmemdup on the submitted
platform-data. So the data the platform-device gets is a copy of the
original data, meaning that the device worked on a different completion
than what sensor_hub_remove() currently wants to access.

To fix that, use device_for_each_child() to go through each child-device
similar to how mfd_remove_devices() unregisters the devices later and
with that get the live platform_data to finalize the correct completion.

Fixes: e651a1da442a ("HID: hid-sensor-hub: Allow parallel synchronous reads")
Cc: stable@vger.kernel.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Acked-by: Benjamin Tissoires <bentiss@kernel.org>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Acked-by: Jiri Kosina <jkosina@suse.com>
Link: https://lore.kernel.org/r/20241107114712.538976-2-heiko@sntech.de
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-sensor-hub.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

--- a/drivers/hid/hid-sensor-hub.c
+++ b/drivers/hid/hid-sensor-hub.c
@@ -728,23 +728,30 @@ err_stop_hw:
 	return ret;
 }
 
+static int sensor_hub_finalize_pending_fn(struct device *dev, void *data)
+{
+	struct hid_sensor_hub_device *hsdev = dev->platform_data;
+
+	if (hsdev->pending.status)
+		complete(&hsdev->pending.ready);
+
+	return 0;
+}
+
 static void sensor_hub_remove(struct hid_device *hdev)
 {
 	struct sensor_hub_data *data = hid_get_drvdata(hdev);
 	unsigned long flags;
-	int i;
 
 	hid_dbg(hdev, " hardware removed\n");
 	hid_hw_close(hdev);
 	hid_hw_stop(hdev);
+
 	spin_lock_irqsave(&data->lock, flags);
-	for (i = 0; i < data->hid_sensor_client_cnt; ++i) {
-		struct hid_sensor_hub_device *hsdev =
-			data->hid_sensor_hub_client_devs[i].platform_data;
-		if (hsdev->pending.status)
-			complete(&hsdev->pending.ready);
-	}
+	device_for_each_child(&hdev->dev, NULL,
+			      sensor_hub_finalize_pending_fn);
 	spin_unlock_irqrestore(&data->lock, flags);
+
 	mfd_remove_devices(&hdev->dev);
 	mutex_destroy(&data->mutex);
 }


