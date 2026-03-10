Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C8547279B;
	Tue, 10 Mar 2026 09:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773133359; cv=none; b=Wzq5uo2tAADO9OWC+MymFYf83CYc4hQLZThZgsRkInkSUcK4Cd+cjEWtotZHoYgbqIvZbiTw+62/1lRIJR1QwfVamg9hSypl0MZuwHxOCxXKhx5L43qxO7KeMXJoGPDxhG6g6gjQeJBrWXxYsbug67vhnrWgUb5Ey6LyRtJT3pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773133359; c=relaxed/simple;
	bh=K997Wr3ov2A3p7MGNXnHurRpkz+YGz/zVkoBQxQymvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KjDP+XXIfZcbdw/YsiF6mvbBwzTP5I0848OuQWcDiUQURBTdMDpBgZ4hNbUbNcExBdQlNpJ4/tXpsgCo/mKv1WppsPOGrDrA3GC74jOjSPvhqJpSEVtQJ3jxF+GhscPBisj/3G9XhKWPjupWQsYtlLr5YeEEGB4IEYDfts2rN5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ROUZAKjE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ROUZAKjE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D02A2C19423;
	Tue, 10 Mar 2026 09:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773133358;
	bh=K997Wr3ov2A3p7MGNXnHurRpkz+YGz/zVkoBQxQymvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ROUZAKjEY2XRlpwcxj7BoUkUrj9vQk95tfX8mcyIY3s/j6xJAcWSY0eCenODgYJD8
	 jXD2US7fHC9QXub8iTKzd03JeXhEDgR+c4bmqwqf2rqR9+2UXT0KiK3yDbebXRrMM6
	 5Jsunjp6VJ31H02snV39FtgX9HfzHY82X3isRxLt0w+WTG9tYUpz6YAwo1j3NWMSSm
	 U3qUhc/jmc2+NHf49IVyYDzMoNDhGUBz4xCoBWtBplUe6a5iiR/sBmKXowwfqVQWT7
	 qqlRhFKZtG++2joh7Z8l9ZdtsknGvcWoSbsPu7EncGtbllCNqbi/1TrirbnM3HDBAQ
	 nWfKNdiCrJRIw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Julius Lehmann <lehmanju@devpi.de>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	jikos@kernel.org,
	bentiss@kernel.org,
	linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.15] HID: magicmouse: fix battery reporting for Apple Magic Trackpad 2
Date: Tue, 10 Mar 2026 05:01:36 -0400
Message-ID: <20260310090145.2709021-36-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260310090145.2709021-1-sashal@kernel.org>
References: <20260310090145.2709021-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Julius Lehmann <lehmanju@devpi.de>

[ Upstream commit 5f3518d77419255f8b12bb23c8ec22acbeb6bc5b ]

Battery reporting does not work for the Apple Magic Trackpad 2 if it is
connected via USB. The current hid descriptor fixup code checks for a
hid descriptor length of exactly 83 bytes. If the hid descriptor is
larger, which is the case for newer apple mice, the fixup is not
applied.

This fix checks for hid descriptor sizes greater/equal 83 bytes which
applies the fixup for newer devices as well.

Signed-off-by: Julius Lehmann <lehmanju@devpi.de>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### Problem
Battery reporting doesn't work for Apple Magic Trackpad 2 when connected
via USB if the HID descriptor is larger than exactly 83 bytes. Newer
Apple devices have expanded HID descriptors, so the original strict
equality check (`*rsize == 83`) causes the battery report fixup to be
silently skipped.

### The Fix
A single-character change: `*rsize == 83` becomes `*rsize >= 83`. This
allows the descriptor fixup to apply for newer devices with larger
descriptors.

### Safety Analysis
The fix is safe because:
1. The `>= 83` check still guarantees the descriptor is at least 83
   bytes, so accessing `rdesc[46]` and `rdesc[58]` is within bounds.
2. The additional content checks (`rdesc[46] == 0x84 && rdesc[58] ==
   0x85`) still validate the descriptor format before applying any
   modification.
3. The device type is still checked (`is_usb_magicmouse2` or
   `is_usb_magictrackpad2`), so unrelated devices are unaffected.

### Stable Criteria Assessment
- **Fixes a real bug**: Yes — battery reporting completely broken for
  newer Apple trackpad/mouse devices over USB.
- **Obviously correct**: Yes — the original check was overly
  restrictive; the `>=` check is the natural fix while maintaining
  safety through the other validation checks.
- **Small and contained**: Yes — single character change in one file,
  one driver.
- **No new features**: Correct — just enables existing battery reporting
  functionality for devices it should already work with.
- **Low regression risk**: Very low — only affects Apple Magic Mouse 2 /
  Magic Trackpad 2 USB devices, and the content validation guards
  against incorrect application.

### User Impact
Apple Magic Mouse 2 and Magic Trackpad 2 are widely used peripherals.
Users connecting via USB (e.g., for charging) lose battery level
reporting without this fix. This affects real hardware that many people
use daily.

### Verification
- `git blame` confirmed the original `*rsize == 83` check was introduced
  in commit `0b91b4e4dae63` ("HID: magicmouse: Report battery level over
  USB", Nov 2021), so the bug has existed since then.
- Read the surrounding code (lines 973-1006) to confirm the `rdesc[46]`
  and `rdesc[58]` access is safe with `>= 83` guard.
- `git log --grep` confirmed multiple battery-related fixes to this
  driver, indicating ongoing maintenance and real user interest.
- The device checks (`is_usb_magicmouse2`, `is_usb_magictrackpad2`)
  limit scope to specific Apple products only.
- The fix is self-contained with no dependencies on other commits.

**YES**

 drivers/hid/hid-magicmouse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index 91f621ceb924b..f4cf29c2e8330 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -990,7 +990,7 @@ static const __u8 *magicmouse_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 	 */
 	if ((is_usb_magicmouse2(hdev->vendor, hdev->product) ||
 	     is_usb_magictrackpad2(hdev->vendor, hdev->product)) &&
-	    *rsize == 83 && rdesc[46] == 0x84 && rdesc[58] == 0x85) {
+	    *rsize >= 83 && rdesc[46] == 0x84 && rdesc[58] == 0x85) {
 		hid_info(hdev,
 			 "fixing up magicmouse battery report descriptor\n");
 		*rsize = *rsize - 1;
-- 
2.51.0

