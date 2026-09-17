Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B8E49D5AB;
	Thu, 17 Sep 2026 19:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671687; cv=none; b=aKOD5HU4v1levxpwMMaqOo30UOxRsbSHt88qz0IBAf6jUIW5v5T0wpFtQF+Iqiv6XUDKF3CtPqrA2y7RkrwI5kPBMwX0eC/k6oKR8TaS/SYVHqwn8Xdl43ZU8SpMs55uF75/fRdWjlr/U4u+1nx9f9u3fOtACFs5eefwY67yg4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671687; c=relaxed/simple;
	bh=X1tfRYZjfNN20/erJ6x1NCD3QNSg19xi9llehAUmm88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L4ZohxS7NcjYUVzFUCCJIpvj8Zn5BNRBFU2gv/dRsH/kKfONe864rFHPB183l6zu543y/hmLjNMh/nM7HU8QIAhspq8jFAdKdZ5yu2KVZ0oJkW5ag3zoDeAzyRMUwL6vuFdE1/K6EqnSK8sayQ80hKtO6OYlwRxs6WV2E1Tuit0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HvDzuvEp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HvDzuvEp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE171F00898;
	Thu, 17 Sep 2026 19:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671678;
	bh=Ia+HsXdas5rsUUvNs851OH5jGtsLkfwWf09ytljxNdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HvDzuvEphToQgsQ4Qn/lMBlhR8m1Lfu9yorjmSNOBOfESz7L76lRR72hX24sNEkEG
	 wjZ1i4bdBUqH3pyuzQgckfvXALhwDQKDYkxJPZnYs85aYoBZHKCC5M9h4zMJ3nPbSu
	 xe3mRqq/3eUaSVeLkpfha5FxBzaBHqeTqxZfu4yo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1056/1102] HID: sony: clean up device list on probe failure
Date: Thu, 17 Sep 2026 16:16:39 +0100
Message-ID: <20260917151607.323184465@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
@@ -1740,11 +1740,10 @@ out:
 
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
@@ -1879,6 +1878,13 @@ static inline void sony_cancel_work_sync
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
@@ -2037,9 +2043,7 @@ static int sony_input_configured(struct
 err_close:
 	hid_hw_close(hdev);
 err_stop:
-	sony_cancel_work_sync(sc);
-	sony_remove_dev_list(sc);
-	sony_release_device_id(sc);
+	sony_cleanup(sc);
 	return ret;
 }
 
@@ -2065,6 +2069,8 @@ static int sony_probe(struct hid_device
 	}
 
 	spin_lock_init(&sc->lock);
+	INIT_LIST_HEAD(&sc->list_node);
+	sc->device_id = -1;
 
 	sc->quirks = quirks;
 	hid_set_drvdata(hdev, sc);
@@ -2093,6 +2099,7 @@ static int sony_probe(struct hid_device
 	ret = hid_hw_start(hdev, connect_mask);
 	if (ret) {
 		hid_err(hdev, "hw start failed\n");
+		sony_cleanup(sc);
 		return ret;
 	}
 
@@ -2144,7 +2151,7 @@ static int sony_probe(struct hid_device
 
 err:
 	usb_free_urb(sc->ghl_urb);
-
+	sony_cleanup(sc);
 	hid_hw_stop(hdev);
 	return ret;
 }
@@ -2161,13 +2168,7 @@ static void sony_remove(struct hid_devic
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
 


