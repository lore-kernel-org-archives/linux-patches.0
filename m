Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4863C757EA;
	Sat, 12 Sep 2026 19:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242258; cv=none; b=GgNwbLcKhz1uYP8BgkosX0fVaKVTvOuyNHEzvKnv6M+QcmdI+3Gph9LjBT8EaOjEF5xji3L/ksH0hOTtnZB9k02BDi51tczzyNIDtsDU4mDqQotVuhgrvWgqi+jN8YLAT4QSi9oAa1fN8mMhGK4EH+nbquiZcIFV3p2YUQyBawc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242258; c=relaxed/simple;
	bh=xlM+NwkI5olUDayobhPn2c9dWdS9k93T3Hfq6qlahwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t8tspu2E4vFER+LP6pohUI6eYwkfMOETsdbUmPoTqtFdLwyBtyB3po1v/+EnGjJx1hq6rxfdpE+Xn6QinzIAsyEoy3Er974dyOObQ7UPA6qf1s7hXkwTR/9p1YTH6lUhHr+Dj+I6XhIRRmGe7vWqCSHGPV9oUMKv6h9CC6tmoK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eksSuTHN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eksSuTHN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EF081F000FF;
	Sat, 12 Sep 2026 19:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242257;
	bh=4XH93hEls8COqiPGzkpmyl1vLS/dLCIX2U+wTrmeUJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eksSuTHNZo6ex0fvntBTaENMrPxul7sDsmxf82HB8EVUJ7LV87wKLPah79xfHUh7L
	 4NO9oTqbOeLTFzFCHF+q4rwQFNJgrsjPGuEM4uAlv3fM7C/41sCFaDhmsJkL6g+pug
	 B6KIFATxfvI/P/8pgT2m1w8pthSShgP0l12Y7ExY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 342/798] HID: roccat: bound device-supplied profile index
Date: Sat, 12 Sep 2026 08:59:30 +0200
Message-ID: <20260912065524.999548216@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

[ Upstream commit 43fae42628a8c10fa8981773d7ec9f1a367821a7 ]

kone_keep_values_up_to_date() and kone_profile_activated() use an
8-bit, device-supplied profile value as an index into the 5-element
kone->profiles[] array without a range check. A malicious USB device
claiming the Roccat Kone id can send a switch-profile event (or a
startup_profile read at probe) with an out-of-range value and make the
driver read out of bounds; the result is exposed via the actual_dpi
sysfs attribute.

Reject out-of-range indices in both paths.

This was found with static analysis and confirmed with the KUnit test
added in the following patch (KASAN: slab-out-of-bounds).

Fixes: 14bf62cde7942 ("HID: add driver for Roccat Kone gaming mouse")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-roccat-kone.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-roccat-kone.c b/drivers/hid/hid-roccat-kone.c
index e8522eacf7973..cd2ce6e6449aa 100644
--- a/drivers/hid/hid-roccat-kone.c
+++ b/drivers/hid/hid-roccat-kone.c
@@ -36,6 +36,8 @@ static uint profile_numbers[5] = {0, 1, 2, 3, 4};
 
 static void kone_profile_activated(struct kone_device *kone, uint new_profile)
 {
+	if (new_profile < 1 || new_profile > ARRAY_SIZE(kone->profiles))
+		new_profile = 1;
 	kone->actual_profile = new_profile;
 	kone->actual_dpi = kone->profiles[new_profile - 1].startup_dpi;
 }
@@ -790,8 +792,10 @@ static void kone_keep_values_up_to_date(struct kone_device *kone,
 {
 	switch (event->event) {
 	case kone_mouse_event_switch_profile:
-		kone->actual_dpi = kone->profiles[event->value - 1].
-				startup_dpi;
+		if (event->value >= 1 &&
+		    event->value <= ARRAY_SIZE(kone->profiles))
+			kone->actual_dpi =
+				kone->profiles[event->value - 1].startup_dpi;
 		fallthrough;
 	case kone_mouse_event_osd_profile:
 		kone->actual_profile = event->value;
-- 
2.53.0



