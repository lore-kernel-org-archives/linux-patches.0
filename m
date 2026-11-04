Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827121;
	b=2we0jC4vOAHGUtexaCappXfA8nuDQsIlz5nBR3SJt1e751pWoBIk1j1ePsRlHiMnrt6x
	 2jkuhoZxjv5jktHdCJ0kK8UOg8pkms7ZmcC+qQpehWbm0P/qbAxB+6iWldz1cTeLkN5NM
	 b3FqpK7G53QRJi7YxTeL5t0PpBo/5mrONNWNJu+d3xLpDadU1zBCrMK4TG8v7SkxJMWZ/
	 EOuGRAKjW1cQuf/MF7Gp05WjXtsGuvUMgzI54UEILf/Ukq+SMgrKBzIAsl0cjLlbBQd3s
	 jj5ldRWio4tN2CQZmoliEUsusBpq6BaWfWAsjDFZqzb3TVHIa/KACTGIc53Ozaex7vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827121;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kaqradZQ51mG41e55cwEQkI9UU6Z1Z4iprYH4mqMaC4=;
	b=u2jm3PyR8DGMLn/MlBMIxUG+oOYTnT9wPNZgJInWsuZdArxKjGJ76B9KqGXysK1Duims
	 gIfteHG/MWSPektDto1mbO47vBRpNZgx5EFkYjZntbWq3zToQ2KBq0ggH1yOhOOxjRV+0
	 MlrJ6MfzbIyiaGcYXxLD5OzIvxr+5/uW60S0eRZyBM7epBLqFuoN6djHx8ahTUqpmLeHi
	 KvZPgykenCLUpw5spf8VMCB7uC/uiCornpl/op5A8NZ+Jn8PWsiQ/gP9hZFZumu+UAdyM
	 +nKBnTMoUnMQpqZ3M7OjFB5d5msdZYTfuBbuIQS0j33OmWBX+Vxp/YBpqLgXjneS7JA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kwRUHR+0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7955606AE33;
	Wed,  4 Nov 2026 21:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kwRUHR+0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7061F1F000C1;
	Wed,  4 Nov 2026 21:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827120;
	bh=kaqradZQ51mG41e55cwEQkI9UU6Z1Z4iprYH4mqMaC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kwRUHR+0hjbXneqDxnutJrIs/rBOJdd58ku60DKbZ1Wn0EtPDJ+QDm8CZf1GeyyjP
	 75WbtuaAP6yJMYQVyVnGP8VCNoESdKAs++l7tGwAlveT1Ez+IOHNFq6qLBt9P+5mG+
	 tt3hau+/KNaSEM4aGEHmythiunblThDSJ574L6Zs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Ping Cheng <ping.cheng@wacom.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.3 186/547] HID: wacom: Fix Use-After-Free in wacom_bamboo_pad
Date: Wed,  4 Nov 2026 16:06:10 -0500
Message-ID: <20261104211043.427272011@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lee Jones <lee@kernel.org>

commit 3a523ecf9ac3fdd33f5eb31c43937ee44135395b upstream.

wacom_bamboo_pad_pen_event() accesses wacom->shared->pen locklessly
relative to wacom_remove_shared_data() which nullifies it.  This
can lead to a Use-After-Free if the sibling device is removed while
events are being processed.

Resolve this by introducing RCU protection for pen and touch
pointers:

 - Annotate 'pen' and 'touch' in wacom_shared struct with __rcu.
 - Wrap lockless readers in wacom_bamboo_pad_pen_event() with
   rcu_read_lock() and rcu_dereference().
 - Update writers in wacom_sys.c using rcu_assign_pointer().
 - Use rcu_dereference_protected for comparisons under
   wacom_udev_list_lock.
 - Also use rcu_access_pointer in wacom_sibling_pending() and
   wacom_mode_change_work() to avoid warnings (while lockless access in
   the latter remains a pre-existing issue).

Cc: stable@vger.kernel.org
Fixes: 8c97a765467c ("HID: wacom: add full support of the Wacom Bamboo PAD")
Signed-off-by: Lee Jones <lee@kernel.org>
Acked-by: Ping Cheng <ping.cheng@wacom.com>
Tested-by: Ping Cheng <ping.cheng@wacom.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_sys.c |   40 ++++++++++++++++++++++++++--------------
 drivers/hid/wacom_wac.c |   13 ++++++-------
 drivers/hid/wacom_wac.h |    4 ++--
 3 files changed, 34 insertions(+), 23 deletions(-)

--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -877,11 +877,18 @@ static void wacom_remove_shared_data(voi
 				    shared);
 
 		scoped_guard(mutex, &wacom_udev_list_lock) {
-			if (wacom_wac->shared->touch == wacom->hdev) {
-				wacom_wac->shared->touch = NULL;
+			struct hid_device *touch =
+				rcu_dereference_protected(wacom_wac->shared->touch,
+							  lockdep_is_held(&wacom_udev_list_lock));
+			struct hid_device *pen =
+				rcu_dereference_protected(wacom_wac->shared->pen,
+							  lockdep_is_held(&wacom_udev_list_lock));
+
+			if (touch == wacom->hdev) {
+				rcu_assign_pointer(wacom_wac->shared->touch, NULL);
 				rcu_assign_pointer(wacom_wac->shared->touch_input, NULL);
-			} else if (wacom_wac->shared->pen == wacom->hdev) {
-				wacom_wac->shared->pen = NULL;
+			} else if (pen == wacom->hdev) {
+				rcu_assign_pointer(wacom_wac->shared->pen, NULL);
 			}
 		}
 
@@ -2362,14 +2369,17 @@ static void wacom_set_shared_values(stru
 	}
 
 	if (wacom_wac->features.device_type & WACOM_DEVICETYPE_TOUCH) {
-		if (wacom_wac->shared->touch == wacom->hdev || !wacom_wac->shared->touch) {
+		struct hid_device *touch =
+			rcu_dereference_protected(wacom_wac->shared->touch,
+						  lockdep_is_held(&wacom_udev_list_lock));
+
+		if (touch == wacom->hdev || !touch) {
 			wacom_wac->shared->type = wacom_wac->features.type;
-			wacom_wac->shared->touch = wacom->hdev;
+			rcu_assign_pointer(wacom_wac->shared->touch, wacom->hdev);
 			rcu_assign_pointer(wacom_wac->shared->touch_input, wacom_wac->touch_input);
 		}
 	} else if (wacom_wac->features.device_type & WACOM_DEVICETYPE_PEN) {
-		/* Pairs with smp_load_acquire() in wacom_sibling_pending() */
-		smp_store_release(&wacom_wac->shared->pen, wacom->hdev);
+		rcu_assign_pointer(wacom_wac->shared->pen, wacom->hdev);
 	}
 }
 
@@ -2385,8 +2395,7 @@ static bool wacom_sibling_pending(struct
 		return false;
 
 	if (wacom->wacom_wac.shared) {
-		/* Pairs with smp_store_release() in wacom_set_shared_values() */
-		if (smp_load_acquire(&wacom->wacom_wac.shared->pen))
+		if (rcu_access_pointer(wacom->wacom_wac.shared->pen))
 			return false;
 	}
 
@@ -2853,16 +2862,19 @@ static void wacom_mode_change_work(struc
 	bool is_direct = wacom->wacom_wac.is_direct_mode;
 	int error = 0;
 
-	if (shared->pen) {
-		wacom1 = hid_get_drvdata(shared->pen);
+	struct hid_device *pen = rcu_access_pointer(shared->pen);
+	struct hid_device *touch = rcu_access_pointer(shared->touch);
+
+	if (pen) {
+		wacom1 = hid_get_drvdata(pen);
 		wacom_release_resources(wacom1);
 		hid_hw_stop(wacom1->hdev);
 		wacom1->wacom_wac.has_mode_change = true;
 		wacom1->wacom_wac.is_direct_mode = is_direct;
 	}
 
-	if (shared->touch) {
-		wacom2 = hid_get_drvdata(shared->touch);
+	if (touch) {
+		wacom2 = hid_get_drvdata(touch);
 		wacom_release_resources(wacom2);
 		hid_hw_stop(wacom2->hdev);
 		wacom2->wacom_wac.has_mode_change = true;
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -3307,6 +3307,7 @@ static int wacom_bpt_irq(struct wacom_wa
 static void wacom_bamboo_pad_pen_event(struct wacom_wac *wacom,
 		unsigned char *data)
 {
+	struct hid_device *pen;
 	unsigned char prefix;
 
 	/*
@@ -3319,13 +3320,11 @@ static void wacom_bamboo_pad_pen_event(s
 	prefix = data[0];
 	data[0] = WACOM_REPORT_BPAD_PEN;
 
-	/*
-	 * actually reroute the event.
-	 * No need to check if wacom->shared->pen is valid, hid_input_report()
-	 * will check for us.
-	 */
-	hid_input_report(wacom->shared->pen, HID_INPUT_REPORT, data,
-			 WACOM_PKGLEN_PENABLED, 1);
+	guard(rcu)();
+	pen = rcu_dereference(wacom->shared->pen);
+	if (pen)
+		hid_input_report(pen, HID_INPUT_REPORT, data,
+				 WACOM_PKGLEN_PENABLED, 1);
 
 	data[0] = prefix;
 }
--- a/drivers/hid/wacom_wac.h
+++ b/drivers/hid/wacom_wac.h
@@ -286,8 +286,8 @@ struct wacom_shared {
 	unsigned touch_max;
 	int type;
 	struct input_dev __rcu *touch_input;
-	struct hid_device *pen;
-	struct hid_device *touch;
+	struct hid_device __rcu *pen;
+	struct hid_device __rcu *touch;
 	bool has_mute_touch_switch;
 	bool is_touch_on;
 };


