Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929022EEE7E;
	Wed,  9 Sep 2026 13:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961617; cv=none; b=EamWyHVrK7a2bSDFwllNCeaak/WitCpqpmIL3gQO/addvnTFV2mcRPMNpasGh0eoKGhVxRw4cF53DoripvWkXbmeFG1lbroQUag+nsfy+7ovs8O8LItSng6bSyC98dMC0kL9iZFvGVoGAoDwY+LT9cMOVVp5locXuhSvm4jCvXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961617; c=relaxed/simple;
	bh=bQJQa7/JqL0eBStLUsFDyy6+p4Ls90gODMm1ludB8S4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ESLdSVjaA7wVQ65vax06kJhwdbnv/z7ooOWUrYb7bgqG5tArxy+F+gGOfj7HmplncWMEzDK+rKtL8a8sqzeKjfSuhKX7QBIJgBpDVMNup2Gr6BoIh7jt3puCRnKJzFeR2YwuPxw609zDrCw6Q/iSig0/gNfaAYhaKzMqMfbh09M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=alf21dSl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="alf21dSl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A45031F00A3A;
	Wed,  9 Sep 2026 13:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961616;
	bh=FrghawLbZzTee47mxrQBh8em9XPg58DpPWDsYiCLLiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=alf21dSl5IQ9lqUF/1ip3y3+mD5Seu94+bdPRoPb73dizcaemIX/QigvTkClH1VsB
	 ET2y2GXGzVXdqwOSEET5CsZl7QoTiw2cTZSd7775fqIFyLjxZkgdOtyNOKNvoWeCd4
	 k1L33Bt4aO6Ph7n6hNvnaHjSagDczhFiBf+rWNz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 011/556] HID: sony: clean up device list on probe failure
Date: Wed,  9 Sep 2026 15:34:51 +0200
Message-ID: <20260909134230.869700424@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-sony.c |   33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -1984,11 +1984,10 @@ out:
 
 static void sony_remove_dev_list(struct sony_sc *sc)
 {
-	if (sc->list_node.next) {
-		scoped_guard(spinlock_irqsave, &sony_dev_list_lock) {
-			list_del(&(sc->list_node));
-		}
-	}
+	guard(spinlock_irqsave)(&sony_dev_list_lock);
+
+	if (!list_empty(&sc->list_node))
+		list_del_init(&sc->list_node);
 }
 
 static int sony_get_bt_devaddr(struct sony_sc *sc)
@@ -2123,6 +2122,13 @@ static inline void sony_cancel_work_sync
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
@@ -2296,9 +2302,7 @@ static int sony_input_configured(struct
 err_close:
 	hid_hw_close(hdev);
 err_stop:
-	sony_cancel_work_sync(sc);
-	sony_remove_dev_list(sc);
-	sony_release_device_id(sc);
+	sony_cleanup(sc);
 	return ret;
 }
 
@@ -2322,6 +2326,8 @@ static int sony_probe(struct hid_device
 		return -ENOMEM;
 
 	spin_lock_init(&sc->lock);
+	INIT_LIST_HEAD(&sc->list_node);
+	sc->device_id = -1;
 
 	sc->quirks = quirks;
 	hid_set_drvdata(hdev, sc);
@@ -2350,6 +2356,7 @@ static int sony_probe(struct hid_device
 	ret = hid_hw_start(hdev, connect_mask);
 	if (ret) {
 		hid_err(hdev, "hw start failed\n");
+		sony_cleanup(sc);
 		return ret;
 	}
 
@@ -2404,7 +2411,7 @@ static int sony_probe(struct hid_device
 
 err:
 	usb_free_urb(sc->ghl_urb);
-
+	sony_cleanup(sc);
 	hid_hw_stop(hdev);
 	return ret;
 }
@@ -2421,13 +2428,7 @@ static void sony_remove(struct hid_devic
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
 


