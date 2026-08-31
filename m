Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06714443A9D;
	Mon, 31 Aug 2026 13:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183548; cv=none; b=EUuryZus5hpbP+iT8fCdHOf5GCiXPbdN3JxhBY1ON7U14nfN9ISQDxazhTMH98mcK6SuBz3KpjZF03q9l4RpbZPtEBqthCoNYFdOVu5fpRNSPYGFc6yyMvYoWtyzVvni7PGGSBCJOu97o7bjVT6ZQbHiSbbP6z1/redPXJWUXrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183548; c=relaxed/simple;
	bh=5bNopTXtiJjeKjY0nv3y83UpqoOye0L99V/qq0x75bA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Isl+Lm4ix3ITFKbnmJyFHqm/t8arzNymMy3apwVRaZM1aoDqh3cqTMA73MJPqAxRrM5r71g7D3Lau4tPs2LjnPxA9qAr8kU/e1b4P1sZUoprxJRDPJCNAsXaIaQLskfEevOQ7E2E99udvhJHB9A5pjPGjvi5DBG6j8T8b6dsdTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O9RDd9gQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O9RDd9gQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBAF51F00ACA;
	Mon, 31 Aug 2026 13:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183545;
	bh=R3KCqClXRWaxwR65BU2A412AAAdvKTWiIEGL1q11zyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O9RDd9gQrFHi+X6mMEUkvfxKfPDdvlzj6tfkOaFjVpK65uCWmeq8QsUDm7/i0XJ0V
	 YUO7GmDMf19JAqWzElWug8Ye2Yb3uWvQdapqDw1FFmg2BjSYLPsUoOcK/5aiHDg0ca
	 lLwLJMF5lQaEvQDjpovB6uaxAlcHHYxdBml2isUPFDeQWRcj7uAFIkxWPXo7FDIVuA
	 R6RV7cSINCAaxylqM9TapQm2hhrJ+3NDXRTuCtntUeHAMIv8622PH4r0kHJIZA9laC
	 Z0eK3wIzHKmCfmoXIx9pWQ67YqGS+xYpU7FuxfJEwKkaaZLyNCJ2/w1/Gq1FZTVITD
	 /OxawuC+KlITw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Craig McQueen <craig@mcqueen.au>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	pavel@kernel.org,
	linux-leds@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] leds: core: Fix race condition for software blink
Date: Mon, 31 Aug 2026 09:23:09 -0400
Message-ID: <20260831133314.4125787-161-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Craig McQueen <craig@mcqueen.au>

[ Upstream commit f92135f100669b508dd62b424ab20bcb33494c79 ]

led_set_brightness() function: Change handling of software blink to
avoid race conditions when stopping blink and setting brightness.

Triggers may call led_set_brightness(LED_OFF),
led_set_brightness(LED_FULL) in quick succession to disable blinking and
turn the LED on. If the delayed work task has not yet disabled blinking
by the time the second call occurs, then the brightness also needs to be
changed in the delayed work task.

Signed-off-by: Craig McQueen <craig@mcqueen.au>
Link: https://patch.msgid.link/20260423113638.2079302-1-craig@mcqueen.au
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background searches finished and line up with the earlier analysis:

- **Commit lookup:** `f92135f100669` (`leds: core: Fix race condition
  for software blink`) is in mainline via the `leds-next-7.2` merge, but
  it is **not** in the current `6.18.44` checkout — so it is a valid
  backport candidate for this tree.
- **Related history:** The prerequisite fixes are already here
  (`fa15d8c69238b`, `2c70953b6f535`, ordered LED workqueue from
  `32360bf6a5d40`).

That supports the **YES** verdict: the bug exists in v6.18.44, the fix
is small and upstream, and the needed infrastructure is already present.

 drivers/leds/led-core.c | 33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/leds/led-core.c b/drivers/leds/led-core.c
index 59473f286b31f..eeb36e50c285c 100644
--- a/drivers/leds/led-core.c
+++ b/drivers/leds/led-core.c
@@ -304,24 +304,31 @@ EXPORT_SYMBOL_GPL(led_stop_software_blink);
 
 void led_set_brightness(struct led_classdev *led_cdev, unsigned int brightness)
 {
-	/*
-	 * If software blink is active, delay brightness setting
-	 * until the next timer tick.
-	 */
-	if (test_bit(LED_BLINK_SW, &led_cdev->work_flags)) {
+	if (brightness) {
 		/*
-		 * If we need to disable soft blinking delegate this to the
-		 * work queue task to avoid problems in case we are called
-		 * from hard irq context.
+		 * If software blink disable is pending, also queue brightness setting.
+		 * If software blink is active, delay brightness setting
+		 * until the next timer tick.
 		 */
-		if (!brightness) {
-			set_bit(LED_BLINK_DISABLE, &led_cdev->work_flags);
+		if (test_bit(LED_SET_BRIGHTNESS, &led_cdev->work_flags) ||
+		    test_bit(LED_BLINK_DISABLE, &led_cdev->work_flags)) {
+			led_cdev->delayed_set_value = brightness;
+			set_bit(LED_SET_BRIGHTNESS, &led_cdev->work_flags);
 			queue_work(led_cdev->wq, &led_cdev->set_brightness_work);
-		} else {
-			set_bit(LED_BLINK_BRIGHTNESS_CHANGE,
-				&led_cdev->work_flags);
+			return;
+		} else if (test_bit(LED_BLINK_SW, &led_cdev->work_flags)) {
 			led_cdev->new_blink_brightness = brightness;
+			set_bit(LED_BLINK_BRIGHTNESS_CHANGE, &led_cdev->work_flags);
+			return;
 		}
+	} else if (test_bit(LED_BLINK_SW, &led_cdev->work_flags)) {
+		/*
+		 * If we need to disable soft blinking delegate this to the
+		 * work queue task to avoid problems in case we are called
+		 * from hard irq context.
+		 */
+		set_bit(LED_BLINK_DISABLE, &led_cdev->work_flags);
+		queue_work(led_cdev->wq, &led_cdev->set_brightness_work);
 		return;
 	}
 
-- 
2.53.0

