Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E673BCD19;
	Sat, 12 Sep 2026 07:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789196939; cv=none; b=SiVImM43sk+ReLCBiTg15myZOSNjh1YCawlyTPe0mjB2GcdGAA4XjpnQmiW6zz4ineIeH5T4xwgGWsfDoSRMmo7QxpDWpsiIamaUBfQjB3BvZ6l02hh2yoOYQ8R9rVT00ArPEC4LMcpKYTdDxefrUoV1GVGc2kvFlndkVfchi2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789196939; c=relaxed/simple;
	bh=HwILeJQUTyL6BuAogNk1ZCWst42ijf+Hq1gX/Vqx2dY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d8km1JsKsG2y3r3FjrIkLrjwm5o+8PosCGvQVeRD/WdHCl7diHaiAhLcqLGvbM2Y6QIiAelV2p54qDgVbadvi0g82ya3LiDO1OqpGXe6kdbpj9ceDo9io4PBmHf//lfacndJeQudz+Co5sZOnY5hnm5Bh3BcqQK8eQ1a3q1Aeuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FATm8Aqx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FATm8Aqx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE9B41F000FF;
	Sat, 12 Sep 2026 07:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789196938;
	bh=lMBuON12S48aQz5E4H1ku4qsQOEWH9zclAPYKtdYWuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FATm8Aqx7voCT2b+Ds95q56LS6TXxUHlWRcUUJMMJ24oNXI2kK0ugJ5y8I6G1o8Sh
	 JooTjqaCGbOIuyMacSvnnGRSAZcmiJUvLQ+U6dnhZb7IfxoVZJBaarOM5ZT1Cv/BN7
	 B05OwKqUeTivsTBrZYAa8h60h5w8vmHrMX2KHe3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0068/1815] HID: roccat: bound device-supplied profile index
Date: Sat, 12 Sep 2026 08:30:18 +0200
Message-ID: <20260912065650.612761162@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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
index 58654cf78f0df..17495fcc8b7da 100644
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
@@ -793,8 +795,10 @@ static void kone_keep_values_up_to_date(struct kone_device *kone,
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



