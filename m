Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E103CB557;
	Sat, 17 Oct 2026 18:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260029; cv=none; b=Zq6x1uA9LPZwEMbsGl2sNq84sUChnFLZROeijyYhjiaViHQE+7fabGXFf0kfoarDFhAQzPMm22ItFawHTIf3up7CDHfh4YLUIp5zZN2YU3u8T+9BSIU9/uXxtkBXjnQoj+8dZd2zdwpFsuyU8R/syODUDNABUfFhgPmgnGFlo4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260029; c=relaxed/simple;
	bh=XiUDsYtS6xBbTwO1SZyBw7NCQlcaVLjWFq2wxvoXIjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gGOVIXFhwuckGQ9qR0M6KG3K+YGySa/2qJcDvfboQUMCwEyiTag4jMhphd96uByWpRnMI7gsB3Xh6NVPD8NbVMjtpeSoBJ/W1UJuxu2CertBnSz6xMmxK/0usK9XTFyTf85G5slCuChSh8U3ZQ9VaZxJSU10ZGfh5Zscg0j7rSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f4hFV43q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f4hFV43q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDB991F000C4;
	Sat, 17 Oct 2026 18:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260028;
	bh=XxKHBJsjDum7S3yhODbWmuJOwetDiEmJod9WYXxzkHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f4hFV43q+sJEwIHhWMovJQUF25CxlMSntA6XgvJNT/jBEOYarJh9SDHMNKbMxMJQT
	 M186Gps4iORXnHj2V+TGcgOOOGOQc2qUdIK4CeJ0Eyi4PdyDEmVxtbJmi8KkeeT9ya
	 lc356KLAfyIPRtytXQe55D7E8lv7uCVK86aQEyfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1368/1674] HID: sony: clean up device list on probe failure
Date: Sat, 17 Oct 2026 18:00:40 +0200
Message-ID: <20261017160506.272980188@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Doruk Tan Ozturk <doruk@0sec.ai>

[ Upstream commit 7c65699a3a311198a07659a614fe64d45924839e ]

sony_input_configured() adds some controllers to sony_device_list before
HID core registers their input devices. input_register_device() can fail
after the callback returns successfully. sony_probe() then observes that
HID_CLAIMED_INPUT is clear and unwinds, but only stops the HID hardware.
The devres-managed sony_sc is freed while its list node remains linked, so
the next matching controller traverses freed memory.

Initialize the list node and device ID to inactive states. Make list
removal idempotent and run the driver-private cleanup on every probe
failure path. This also makes a second cleanup safe when
sony_input_configured() already unwound a partial initialization before
sony_probe() handles the missing input claim.

Found by 0sec (https://0sec.ai) using automated source analysis;
verified against the HID input registration and probe unwind paths.

Fixes: 4f967f6d7374 ("HID: sony: Fix memory issue when connecting device using both Bluetooth and USB")
Cc: stable@vger.kernel.org
Reported-by: Doruk Tan Ozturk <doruk@0sec.ai>
Link: https://lore.kernel.org/linux-input/20260724143925.007D61F00A3A@smtp.kernel.org/
Assisted-by: 0sec:multi-model
Signed-off-by: Doruk Tan Ozturk <doruk@0sec.ai>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-sony.c | 33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/hid/hid-sony.c b/drivers/hid/hid-sony.c
index e4b5d202c6637..a83ebda692437 100644
--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -1745,13 +1745,10 @@ static int sony_check_add_dev_list(struct sony_sc *sc)
 
 static void sony_remove_dev_list(struct sony_sc *sc)
 {
-	unsigned long flags;
+	guard(spinlock_irqsave)(&sony_dev_list_lock);
 
-	if (sc->list_node.next) {
-		spin_lock_irqsave(&sony_dev_list_lock, flags);
-		list_del(&(sc->list_node));
-		spin_unlock_irqrestore(&sony_dev_list_lock, flags);
-	}
+	if (!list_empty(&sc->list_node))
+		list_del_init(&sc->list_node);
 }
 
 static int sony_get_bt_devaddr(struct sony_sc *sc)
@@ -1889,6 +1886,13 @@ static inline void sony_cancel_work_sync(struct sony_sc *sc)
 	}
 }
 
+static void sony_cleanup(struct sony_sc *sc)
+{
+	sony_cancel_work_sync(sc);
+	sony_remove_dev_list(sc);
+	sony_release_device_id(sc);
+}
+
 static int sony_input_configured(struct hid_device *hdev,
 					struct hid_input *hidinput)
 {
@@ -2049,9 +2053,7 @@ static int sony_input_configured(struct hid_device *hdev,
 err_close:
 	hid_hw_close(hdev);
 err_stop:
-	sony_cancel_work_sync(sc);
-	sony_remove_dev_list(sc);
-	sony_release_device_id(sc);
+	sony_cleanup(sc);
 	return ret;
 }
 
@@ -2077,6 +2079,8 @@ static int sony_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	}
 
 	spin_lock_init(&sc->lock);
+	INIT_LIST_HEAD(&sc->list_node);
+	sc->device_id = -1;
 
 	sc->quirks = quirks;
 	hid_set_drvdata(hdev, sc);
@@ -2105,6 +2109,7 @@ static int sony_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	ret = hid_hw_start(hdev, connect_mask);
 	if (ret) {
 		hid_err(hdev, "hw start failed\n");
+		sony_cleanup(sc);
 		return ret;
 	}
 
@@ -2156,7 +2161,7 @@ static int sony_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 err:
 	usb_free_urb(sc->ghl_urb);
-
+	sony_cleanup(sc);
 	hid_hw_stop(hdev);
 	return ret;
 }
@@ -2173,13 +2178,7 @@ static void sony_remove(struct hid_device *hdev)
 	}
 
 	hid_hw_close(hdev);
-
-	sony_cancel_work_sync(sc);
-
-	sony_remove_dev_list(sc);
-
-	sony_release_device_id(sc);
-
+	sony_cleanup(sc);
 	hid_hw_stop(hdev);
 }
 
-- 
2.53.0



