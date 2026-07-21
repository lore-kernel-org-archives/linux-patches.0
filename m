Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ABB943CECF;
	Tue, 21 Jul 2026 22:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672914; cv=none; b=Ma8yHg3YfoGSGAPBYjkt5A8xpJO1hdflqkEPGKex6PlFkFZ6ygAK4KzZ0oGFUn+SQgKP/0POiKAXWijEiph/NDgvUwmjFfKKmq38cgLg8s7Q+bTNSIHnZQ05R3VrGw0Ah4bSqUkOwBhkByqD6Vbfhk+0qAR2ypZLRb1jr5yN3Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672914; c=relaxed/simple;
	bh=q4AIgaXLOqmvVfYq+QT+iFXk0TqrB/Y5T/iXozSxje4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uHhuSY9E2VgbuJ0BCiNXOyExQw2Iaac0YeLcdtVghQFegQA8hDBzpOOeHaPqAb1Bc2r52H4CDCCg7XL8XhJgeoIGq+Oj3qnRinMXPtli0/FbbRAvclnnOg3CUq+SwbOkloh+o/kxXaNDZRP0uA6OwtdEuVeEicJzO5/H8F/tOnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zBFQ5Owk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zBFQ5Owk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D74921F00A3D;
	Tue, 21 Jul 2026 22:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672904;
	bh=YwxhL2HgkoqlcPRMBHzDXaoxruUccNOamL2Fqp5kslM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zBFQ5OwkxvUHl2K7+P+VYmvPY3oi2Wu5XkkJBxVLd1X+gLMziYTPhfdRLYrgByrwi
	 rr37Ra7IyQQvEasQn8OX8dSNhrgHXRnjxuaOTLqtcKInFOPcZFQZDClMfpYr8cd98v
	 qT95RQdJSgEUy80yQ7dr2eADmuyZkekBN1YY2Gw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manish Khadka <maskmemanish@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 800/843] HID: appleir: fix UAF on pending key_up_timer in remove()
Date: Tue, 21 Jul 2026 17:27:15 +0200
Message-ID: <20260721152424.063145585@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manish Khadka <maskmemanish@gmail.com>

[ Upstream commit 75fe87e19d8aff81eb2c64d15d244ab8da4de945 ]

appleir_remove() runs hid_hw_stop() before timer_delete_sync().
hid_hw_stop() synchronously unregisters the HID input device via
hid_disconnect() -> hidinput_disconnect() -> input_unregister_device(),
which drops the last reference and frees the underlying input_dev when
no userspace handle holds it open.

key_up_tick() reads appleir->input_dev and calls input_report_key() /
input_sync() on it.  The timer is armed from appleir_raw_event() with
a HZ/8 (~125 ms) timeout on every keydown and key-repeat report.  If a
key was pressed shortly before the device is disconnected, the timer
can fire after hid_hw_stop() has freed input_dev but before the
teardown drains it.

A simple reorder is not sufficient.  Putting the timer drain first
still leaves a window where a USB URB completion (raw_event) running
during hid_hw_stop() can call mod_timer() and re-arm the timer, which
then fires after hidinput_disconnect() has freed input_dev.  The same
URB-completion window also lets raw_event() reach key_up(), key_down()
and battery_flat() directly, all of which dereference
appleir->input_dev.

Introduce a 'removing' flag on struct appleir, gated by the existing
spinlock.  appleir_remove() sets the flag under the lock and then
shuts down the timer with timer_shutdown_sync(), which both drains any
in-flight callback and permanently disables further mod_timer() calls.
appleir_raw_event() and key_up_tick() bail out early if the flag is
set, so no path can arm or run the timer, or dereference
appleir->input_dev, after remove() has started tearing down.

The keyrepeat and flatbattery branches of appleir_raw_event()
previously called into the input layer without holding the spinlock;
take it now so the flag check is well-defined.  This incidentally
closes a pre-existing read-side race on appleir->current_key in the
keyrepeat branch.

This bug is structurally a sibling of commit 4db2af929279 ("HID:
appletb-kbd: fix UAF in inactivity-timer cleanup path") and has been
present since the driver was introduced.

Fixes: 9a4a5574ce42 ("HID: appleir: add support for Apple ir devices")
Cc: stable@vger.kernel.org
Signed-off-by: Manish Khadka <maskmemanish@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-appleir.c |   45 +++++++++++++++++++++++++++++++++++----------
 1 file changed, 35 insertions(+), 10 deletions(-)

--- a/drivers/hid/hid-appleir.c
+++ b/drivers/hid/hid-appleir.c
@@ -109,9 +109,10 @@ struct appleir {
 	struct hid_device *hid;
 	unsigned short keymap[ARRAY_SIZE(appleir_key_table)];
 	struct timer_list key_up_timer;	/* timer for key up */
-	spinlock_t lock;		/* protects .current_key */
+	spinlock_t lock;		/* protects .current_key, .removing */
 	int current_key;		/* the currently pressed key */
 	int prev_key_idx;		/* key index in a 2 packets message */
+	bool removing;			/* set during teardown; gates input_dev access */
 };
 
 static int get_key(int data)
@@ -172,7 +173,7 @@ static void key_up_tick(struct timer_lis
 	unsigned long flags;
 
 	spin_lock_irqsave(&appleir->lock, flags);
-	if (appleir->current_key) {
+	if (!appleir->removing && appleir->current_key) {
 		key_up(hid, appleir, appleir->current_key);
 		appleir->current_key = 0;
 	}
@@ -195,6 +196,10 @@ static int appleir_raw_event(struct hid_
 		int index;
 
 		spin_lock_irqsave(&appleir->lock, flags);
+		if (appleir->removing) {
+			spin_unlock_irqrestore(&appleir->lock, flags);
+			goto out;
+		}
 		/*
 		 * If we already have a key down, take it up before marking
 		 * this one down
@@ -229,17 +234,25 @@ static int appleir_raw_event(struct hid_
 	appleir->prev_key_idx = 0;
 
 	if (!memcmp(data, keyrepeat, sizeof(keyrepeat))) {
-		key_down(hid, appleir, appleir->current_key);
-		/*
-		 * Remote doesn't do key up, either pull them up, in the test
-		 * above, or here set a timer which pulls them up after 1/8 s
-		 */
-		mod_timer(&appleir->key_up_timer, jiffies + HZ / 8);
+		spin_lock_irqsave(&appleir->lock, flags);
+		if (!appleir->removing) {
+			key_down(hid, appleir, appleir->current_key);
+			/*
+			 * Remote doesn't do key up, either pull them up, in
+			 * the test above, or here set a timer which pulls them
+			 * up after 1/8 s
+			 */
+			mod_timer(&appleir->key_up_timer, jiffies + HZ / 8);
+		}
+		spin_unlock_irqrestore(&appleir->lock, flags);
 		goto out;
 	}
 
 	if (!memcmp(data, flatbattery, sizeof(flatbattery))) {
-		battery_flat(appleir);
+		spin_lock_irqsave(&appleir->lock, flags);
+		if (!appleir->removing)
+			battery_flat(appleir);
+		spin_unlock_irqrestore(&appleir->lock, flags);
 		/* Fall through */
 	}
 
@@ -318,8 +331,20 @@ fail:
 static void appleir_remove(struct hid_device *hid)
 {
 	struct appleir *appleir = hid_get_drvdata(hid);
+	unsigned long flags;
+
+	/*
+	 * Mark the driver as tearing down so that any concurrent raw_event
+	 * (e.g. from a USB URB completion that hid_hw_stop() has not yet
+	 * killed) and the key_up_timer softirq stop touching input_dev
+	 * before hid_hw_stop() frees it via hidinput_disconnect().
+	 */
+	spin_lock_irqsave(&appleir->lock, flags);
+	appleir->removing = true;
+	spin_unlock_irqrestore(&appleir->lock, flags);
+
+	timer_shutdown_sync(&appleir->key_up_timer);
 	hid_hw_stop(hid);
-	timer_delete_sync(&appleir->key_up_timer);
 }
 
 static const struct hid_device_id appleir_devices[] = {


