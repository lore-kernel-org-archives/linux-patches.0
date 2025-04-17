Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345E42571A2;
	Thu, 17 Apr 2025 18:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915250; cv=none; b=QOt2DDDGAUempCpmL0hwdL4Mr9OR1fOgfBxcQ0MpAXMT2Gdep/brUUv2nB1APrmKIFFyKSR0EDZrYuXGfa6KPDFasPyQl/bfqiUes05E6QhbDgQHTEspvn6A44r6VPAA4CjbG6LGXu6sIfZ9FwW4xgGxRzpWujsv0mdWQ/90UfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915250; c=relaxed/simple;
	bh=vtF4UBvfPa7PPCQfKHzRwSUMKjJtmVHDCZ88TZmA7iM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AX9t2EGV1M/vjfQNXxgpRPVr0YqcUinhXQQ+rZuaRLtoSd2VuhUpv8xvyhpOmiJjKV+qjqNU5WX1bRlRP3bzSPVCaO2WDqrKSGQ1jDgPqq/HtYVfKzDdq7i5+nBL1UfHr0hksrGjX33FrOiXfcOCVlGRxwsjets277AyI+9Rxro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tfafUsfS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tfafUsfS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A57CC4CEE4;
	Thu, 17 Apr 2025 18:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915249;
	bh=vtF4UBvfPa7PPCQfKHzRwSUMKjJtmVHDCZ88TZmA7iM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tfafUsfS1CQTXuf1IvzQ4D7IxoedKfeBiH4slTc3ZRy1tDRmNu3oapmDwE333JuYd
	 07p3uj6IByKtXLyt1Ml5Ou33Mt+NtpG6xHMuBPKcVH2SCGoThqPelhpwFLzUCm9jOz
	 LjXO8AsN8G93c6b5C69Qz2dk8HiZncBXG9VXGf34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Tomasz=20Paku=C5=82a?= <tomasz.pakula.oficjalny@gmail.com>,
	=?UTF-8?q?Micha=C5=82=20Kope=C4=87?= <michal@nozomi.space>,
	Paul Dino Jones <paul@spacefreak18.xyz>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 067/393] HID: pidff: Add FIX_WHEEL_DIRECTION quirk
Date: Thu, 17 Apr 2025 19:47:56 +0200
Message-ID: <20250417175110.290893310@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>

[ Upstream commit 3051bf5ec773b803c474ea556b57d678a8885be3 ]

Most steering wheels simply ignore DIRECTION field, but some try to be
compliant with the PID standard and use it in force calculations. Games
often ignore setting this field properly and/or there can be issues with
dinput8 -> wine -> SDL -> Linux API translation, and this value can be
incorrect. This can lead to partial/complete loss of Force Feedback or
even unexpected force reversal.

Sadly, this quirk can't be detected automatically without sending out
effects that would move an axis.

This fixes FFB on Moza Racing devices and others where effect direction
is not simply ignored.

Signed-off-by: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
Reviewed-by: Michał Kopeć <michal@nozomi.space>
Reviewed-by: Paul Dino Jones <paul@spacefreak18.xyz>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/usbhid/hid-pidff.c | 12 +++++++++---
 include/linux/hid.h            |  1 +
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/usbhid/hid-pidff.c b/drivers/hid/usbhid/hid-pidff.c
index b8c2ba0a930c2..a37cf852a2836 100644
--- a/drivers/hid/usbhid/hid-pidff.c
+++ b/drivers/hid/usbhid/hid-pidff.c
@@ -137,6 +137,9 @@ static const u8 pidff_block_load_status[] = { 0x8c, 0x8d };
 #define PID_EFFECT_STOP		1
 static const u8 pidff_effect_operation_status[] = { 0x79, 0x7b };
 
+/* Polar direction 90 degrees (North) */
+#define PIDFF_FIXED_WHEEL_DIRECTION	0x4000
+
 struct pidff_usage {
 	struct hid_field *field;
 	s32 *value;
@@ -328,9 +331,12 @@ static void pidff_set_effect_report(struct pidff_device *pidff,
 	pidff->set_effect[PID_GAIN].value[0] =
 		pidff->set_effect[PID_GAIN].field->logical_maximum;
 	pidff->set_effect[PID_DIRECTION_ENABLE].value[0] = 1;
-	pidff->effect_direction->value[0] =
-		pidff_rescale(effect->direction, 0xffff,
-				pidff->effect_direction);
+
+	/* Use fixed direction if needed */
+	pidff->effect_direction->value[0] = pidff_rescale(
+		pidff->quirks & HID_PIDFF_QUIRK_FIX_WHEEL_DIRECTION ?
+		PIDFF_FIXED_WHEEL_DIRECTION : effect->direction,
+		0xffff, pidff->effect_direction);
 
 	/* Omit setting delay field if it's missing */
 	if (!(pidff->quirks & HID_PIDFF_QUIRK_MISSING_DELAY))
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 818e07744c408..c2927e3854a6e 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -1233,6 +1233,7 @@ int hid_pidff_init_with_quirks(struct hid_device *hid, __u32 initial_quirks);
 #define HID_PIDFF_QUIRK_MISSING_DELAY		BIT(0)
 #define HID_PIDFF_QUIRK_MISSING_PBO		BIT(1)
 #define HID_PIDFF_QUIRK_PERMISSIVE_CONTROL	BIT(2)
+#define HID_PIDFF_QUIRK_FIX_WHEEL_DIRECTION	BIT(3)
 
 #define dbg_hid(fmt, ...) pr_debug("%s: " fmt, __FILE__, ##__VA_ARGS__)
 
-- 
2.39.5



