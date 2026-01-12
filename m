Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E392EBB8C;
	Mon, 12 Jan 2026 14:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768229964; cv=none; b=sKbmp+l9V72ZkVQdpScZf0/CMZ4z1rrdzO1+uIfnW513Y7ws254+ExiPRUiwd7pIfKmJ0M66AjeAY018p418E5T2qZnJekEn/zOpGCcs8QZ8xahUBTMYj1q9D329ZmB11nEUfwOkEeOcSNIT0ad6t9KZGDB0qa8fRuLVKTnDt+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768229964; c=relaxed/simple;
	bh=TKAbiPlTUYkhPD8beZCRCcNSrWoNi1fTxw15ZAroquc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YNS9KZfsv8zRe9kRyHwEualP+aLSP+Wdq+8wFQXMSiiFCy43dBdbyjZva89J3FXR7zyP6a24PLh45ykSST6tAq2/8CrmsIdKbZF7R4QSihK7swvd302RGRt3PxSxPitpulAxZK9pLT4JLzRmp2MFdumfoZkT7yazbUL0k+z+Xno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tZUvuNIb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tZUvuNIb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9402AC2BC86;
	Mon, 12 Jan 2026 14:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768229964;
	bh=TKAbiPlTUYkhPD8beZCRCcNSrWoNi1fTxw15ZAroquc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tZUvuNIbwZ0qOG6PQOuW/NAqSsIiZ2FmmnqLeiaRkt2ujldj6s1U6Cpo1M351I5bn
	 TrcRcTtyhWUjxGzclHZSYytKww/IrNywJt47nQNPKLrq5Um9hffe/kWEBOz7t/wVWu
	 8oY5MgEFjsFjiFY8oZZW3QsW6Aatl3EXtEVLoSLwF29lXhZgP8kWI+PHMWLqVwJFN6
	 036ByX8GqkSCwisMwZF2fJt4rRitTiHl7K2K2qqQp/6hm3rt6R/pMR+vk4mDDyp2K2
	 zXKyMK5HO0v2KyUhum9kcHpjf8/OumKfgexLAX4VGHtWFRvwzXuks5qKN3p1JPDfNo
	 rOAvBMUAXg5+A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	jikos@kernel.org,
	linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] HID: usbhid: paper over wrong bNumDescriptor field
Date: Mon, 12 Jan 2026 09:58:26 -0500
Message-ID: <20260112145840.724774-25-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260112145840.724774-1-sashal@kernel.org>
References: <20260112145840.724774-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.5
Content-Transfer-Encoding: 8bit

From: Benjamin Tissoires <bentiss@kernel.org>

[ Upstream commit f28beb69c51517aec7067dfb2074e7c751542384 ]

Some faulty devices (ZWO EFWmini) have a wrong optional HID class
descriptor count compared to the provided length.

Given that we plainly ignore those optional descriptor, we can attempt
to fix the provided number so we do not lock out those devices.

Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of HID: usbhid: paper over wrong bNumDescriptor field

### 1. COMMIT MESSAGE ANALYSIS

**Subject:** "HID: usbhid: paper over wrong bNumDescriptor field"

The commit message clearly states:
- Some faulty devices (specifically ZWO EFWmini) report an incorrect
  `bNumDescriptors` count that doesn't match the actual provided length
- Since the kernel already ignores optional HID class descriptors, the
  fix recalculates the correct value
- The goal is to not "lock out" these devices that have buggy firmware

The phrase "paper over" indicates this is a **hardware workaround** for
non-compliant devices.

### 2. CODE CHANGE ANALYSIS

**Location:** `drivers/hid/usbhid/hid-core.c` in `usbhid_parse()`

**Before the fix:**
```c
if (!hdesc->bNumDescriptors ||
    hdesc->bLength != sizeof(*hdesc) +
                      (hdesc->bNumDescriptors - 1) * sizeof(*hcdesc)) {
    dbg_hid("hid descriptor invalid...");
    return -EINVAL;  // Device rejected completely
}
```

**After the fix:**
Instead of immediately returning `-EINVAL`, the code now:
1. Validates minimum length: `hdesc->bLength >= sizeof(*hdesc)`
2. Recalculates the correct `bNumDescriptors` from the actual length
3. Logs a warning via `hid_warn()`
4. Only returns `-EINVAL` if the descriptor is truly too short

**Technical mechanism:** The fix derives what `bNumDescriptors` *should*
be from `bLength` using: `fixed_opt_descriptors_size / sizeof(*hcdesc) +
1`. This is mathematically correct since `bLength = sizeof(*hdesc) +
(bNumDescriptors-1) * sizeof(*hcdesc)`.

### 3. CLASSIFICATION

This is a **hardware quirk/workaround** - one of the explicit exceptions
allowed in stable trees.

- ZWO EFWmini is a real device (electronic filter wheel for
  astrophotography)
- The device has buggy firmware that reports incorrect descriptor
  metadata
- The fix enables the hardware to work despite firmware bugs

### 4. SCOPE AND RISK ASSESSMENT

| Metric | Value |
|--------|-------|
| Lines changed | ~20 lines |
| Files touched | 1 |
| Complexity | Low |
| Risk | **LOW** |

**Risk analysis:**
- The fix only triggers in the error path (when descriptor is already
  detected as invalid)
- Normal correctly-behaved devices are completely unaffected
- There's proper validation before applying the fixup
- The kernel already ignores optional descriptors, so fixing the count
  is safe
- Worst case: a truly malformed device passes this check but fails
  elsewhere (no worse than current behavior for users)

### 5. USER IMPACT

**Affected users:** Users with ZWO EFWmini devices and potentially other
USB HID devices with similar firmware bugs.

**Impact without fix:** Device completely non-functional - rejected with
`-EINVAL`.

**Impact with fix:** Device works properly. Warning message logged for
debugging.

This is HIGH impact for affected users - the difference between working
hardware and hardware that's completely locked out.

### 6. STABILITY INDICATORS

- **Author:** Benjamin Tissoires - the HID subsystem maintainer
- **Conservative approach:** Only applies when descriptor is already
  flagged as invalid
- **Warning logged:** `hid_warn()` documents when fixup is applied
- **Proper validation:** Checks `bLength >= sizeof(*hdesc)` before
  attempting fix

### 7. DEPENDENCY CHECK

- No dependencies on other commits
- The `usbhid_parse()` function has been in the kernel for many years
- Self-contained fix that applies cleanly to older kernels

### Summary

**Why this should be backported:**

1. **Hardware quirk exception:** This is explicitly listed as acceptable
   for stable trees - adding workarounds for devices with buggy firmware
2. **Fixes real user-impacting bug:** Real devices (ZWO EFWmini) are
   completely locked out without this fix
3. **Small and surgical:** ~20 lines in one file, low complexity
4. **Low risk:** Only affects already-invalid descriptors; well-
   validated with fallback to original behavior
5. **No new features:** Just a workaround to handle non-compliant
   devices
6. **Maintainer-authored:** Written by the HID subsystem maintainer
7. **No dependencies:** Self-contained and should apply cleanly

**Risk vs Benefit:**
- **Risk:** Minimal - worst case is a truly malformed device passes this
  check but fails later
- **Benefit:** High - enables working hardware for users with affected
  devices

This is a textbook example of a hardware quirk fix that belongs in
stable trees. It enables users with buggy-firmware devices to use their
hardware without affecting anyone else.

**YES**

 drivers/hid/usbhid/hid-core.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index aac0051a2cf65..758eb21430cda 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -985,6 +985,7 @@ static int usbhid_parse(struct hid_device *hid)
 	struct usb_device *dev = interface_to_usbdev (intf);
 	struct hid_descriptor *hdesc;
 	struct hid_class_descriptor *hcdesc;
+	__u8 fixed_opt_descriptors_size;
 	u32 quirks = 0;
 	unsigned int rsize = 0;
 	char *rdesc;
@@ -1015,7 +1016,21 @@ static int usbhid_parse(struct hid_device *hid)
 			      (hdesc->bNumDescriptors - 1) * sizeof(*hcdesc)) {
 		dbg_hid("hid descriptor invalid, bLen=%hhu bNum=%hhu\n",
 			hdesc->bLength, hdesc->bNumDescriptors);
-		return -EINVAL;
+
+		/*
+		 * Some devices may expose a wrong number of descriptors compared
+		 * to the provided length.
+		 * However, we ignore the optional hid class descriptors entirely
+		 * so we can safely recompute the proper field.
+		 */
+		if (hdesc->bLength >= sizeof(*hdesc)) {
+			fixed_opt_descriptors_size = hdesc->bLength - sizeof(*hdesc);
+
+			hid_warn(intf, "fixing wrong optional hid class descriptors count\n");
+			hdesc->bNumDescriptors = fixed_opt_descriptors_size / sizeof(*hcdesc) + 1;
+		} else {
+			return -EINVAL;
+		}
 	}
 
 	hid->version = le16_to_cpu(hdesc->bcdHID);
-- 
2.51.0

