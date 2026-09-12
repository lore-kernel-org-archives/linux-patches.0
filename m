Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A062FFF9D;
	Sat, 12 Sep 2026 14:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222378; cv=none; b=JLc7CNfXsMyRkvEJ59YFZsQnVgAQJelVIZGS2iUTF37CfIixkDPKsiKy6vbOQ3NkUvaQVHTEjodm0YwH0RsSykPt3Y/b61Eq2cC0hPI9gn9DK4HjUONdmcvmfBtYGKn1IeLL8s9ZFNji3+pN58ZQGBBhmv497ravlh1SKxYcnw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222378; c=relaxed/simple;
	bh=lIR00UJLCCf1D8nkrKV51QhYTOHOIaUjaXfEu1sRim8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SCJN1zI5BbPmq+3WiVjWqX0xLFE+SVh4MqgdTl463XrenovAlmK9CdxQ7hUtwh5OuLA1u/VNqhVfyweC1DZI4AMu9usQ5KuV2OkG4xPnIvdMyhNGP1Ns2V2Px+hM17xzXGKAhEhfY/omfJbSCBFWbJIlNmJ0atBw/NC5E8ffKGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W6e7rcqA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W6e7rcqA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBE6F1F000FF;
	Sat, 12 Sep 2026 14:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222376;
	bh=+6SshwI+jOlgBPQ5EXH+pkPUduXw8bt98js06ifu+q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W6e7rcqAzZNeRvVYl7qkclw+uk/1C0Ybwq5DH1SXO2yqPgVnA2kfIUbnBuPGN+IXh
	 A6wgYqtRbQYK1LcalnUVd5UijiFsoB1iXj5apAPY0w6KpBQIVfOoJYZjcD7JXMRYfN
	 ERy3Y6tVxJyVbJqS1ehmgBSw8inYUcw85dX42FR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0573/1424] HID: roccat: bound device-supplied profile index
Date: Sat, 12 Sep 2026 08:50:05 +0200
Message-ID: <20260912065620.131600570@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index 00a1abc7e8390..ab17179afb3cb 100644
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



