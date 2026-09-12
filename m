Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849712E8B64;
	Sat, 12 Sep 2026 16:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228878; cv=none; b=V/uJa1dylLVtC0ZS2Byth/8OJG56stjl6qEY3mULi0/d/OVNdkncOBujj6rnS1fV/tYjgH1p1NvQomthRZwgifGXEKB2EEFPQY2dMUlxTzQ68UAtDoyFiz+lIXah+/piAU/M/TVh8aivwB6811wKLKPcuPlxObMApQWrIn2TjCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228878; c=relaxed/simple;
	bh=Oc6ww/WaiguhSTG2JhaVVheb9dhkBXcuqMgxnyw5vyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aIIUms6pJgPVYrbpgcejINyfwlCn0BnRgasnXysRY41dQewACQ+3B51hDOUgVuoELAFgWeFYJchsHByD3wAg7OvkYPB9rlQMMuN12Hc86HQGTHPE+rf5xaetc/aOYKP6UzAM1DBcK1Ip4UXNTkWQAs3GxEGp/TgvhW24ySPhlNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j9+qeZm8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j9+qeZm8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F0601F000FF;
	Sat, 12 Sep 2026 16:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228876;
	bh=JLXEMzkF2pmjB2g76Wu9HnpGFkkKGQknRmOztDy5GII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j9+qeZm8NJLiJBdl4xqqS1Eracvyw9/M5PRt35XB6B3FaP5JiyFUfL/oo19PUNQTj
	 pgsiOfuu5LAvHOjdAMFcv8Xv0Izw53WV/ZRtU3IOjTFaq/JvbUSL/67ZZVQjGILg9E
	 FdSbjRLVbKah/giQbUE3pVMJPoL9FQ7FzgY60fqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0476/1191] HID: roccat: bound device-supplied profile index
Date: Sat, 12 Sep 2026 08:53:24 +0200
Message-ID: <20260912065558.925294113@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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
index 76da04801ca9b..b3e2a352b0dc3 100644
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



