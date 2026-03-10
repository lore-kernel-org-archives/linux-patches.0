Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24FC441036;
	Tue, 10 Mar 2026 09:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773133364; cv=none; b=ZP3UBCgeLIkhWuwSqHsLWJlttM+wTxVlAxf4QHjIZbPCGbFLWHt4MFNmym7437TiqgsuoPs3PVggvdG8+RmPLSf7vZMK2uzBSV7mRrgNG8iTCHwWh78t1+k0uncKfsATO0dV9GF+QSk2jsPDevCljZfSWwkTETs1X/674xd9ZP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773133364; c=relaxed/simple;
	bh=8jrTezgh7FiIbJtZeAaXohKB2BnJG/T2ftDVCgB+k1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=am7eF7OlzyeMONboQi4l0HSOrHMCJODqd33jHpQmv0/KP0FymVRoQPxubw80uL2kuyaykg7LZID4ABdH8jS467MKrxqIl2hv2M82mhac1m9y20yq7f1lr9LPeXFCJlS/Jvo+KClNnRRli4eWZ9c1y7CANkpcDwMtCoqSAO0FmvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uLFXJBZV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uLFXJBZV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA94FC2BC86;
	Tue, 10 Mar 2026 09:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773133364;
	bh=8jrTezgh7FiIbJtZeAaXohKB2BnJG/T2ftDVCgB+k1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uLFXJBZVaJKPMfxrnrdlyKdJaqM79C0oqzNHj28LOpvjyEscZdl8TkMXLqvIfBfEg
	 ncsD0PwuU6Z3swxz2wCszk1S1wT1Sf6eWqVyWpJieb0JZiWmtFJeYg14u3Yv19VKJg
	 h4sHbCGz2B7Lu2ET5R7UYnZlcfuRIVRXdmInE2F7pr6iaDGjZQE5RmdyRbslcAXU1h
	 i2WZ5DsSAqsOSyROlhLgEzFY3pTxhaEIAr3Qxf8SZ1bfVcSBTugOdv3/UA8NLFHr6J
	 X7OVpKgvGa/RMSxZMx8kj81vCjXNwKLe1L2QSw33oO+a1gEMPPkRMxQoNIia64RSfB
	 foGZzQfr6nfFA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	jikos@kernel.org,
	linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.15] HID: magicmouse: avoid memory leak in magicmouse_report_fixup()
Date: Tue, 10 Mar 2026 05:01:40 -0400
Message-ID: <20260310090145.2709021-40-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260310090145.2709021-1-sashal@kernel.org>
References: <20260310090145.2709021-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.6
Content-Transfer-Encoding: 8bit

From: Günther Noack <gnoack@google.com>

[ Upstream commit 91e8c6e601bdc1ccdf886479b6513c01c7e51c2c ]

The magicmouse_report_fixup() function was returning a
newly kmemdup()-allocated buffer, but never freeing it.

The caller of report_fixup() does not take ownership of the returned
pointer, but it *is* permitted to return a sub-portion of the input
rdesc, whose lifetime is managed by the caller.

Assisted-by: Gemini-CLI:Google Gemini 3
Signed-off-by: Günther Noack <gnoack@google.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a thorough analysis.

## Analysis

### What the commit fixes

The `magicmouse_report_fixup()` function was introduced in commit
`0b91b4e4dae63` (v5.16 era, 2021) and uses `kmemdup(rdesc + 1, *rsize,
GFP_KERNEL)` to create a new buffer. The caller in `hid_open_report()`
(hid-core.c) does **not** free the returned pointer — it immediately
`kmemdup()`s the result again and frees its own copy. So the buffer
allocated by magicmouse was leaked every time the device was
initialized.

The fix replaces `kmemdup(rdesc + 1, ...)` with simply `rdesc + 1`,
returning a sub-portion of the input buffer. This is explicitly
permitted by the `report_fixup()` contract as documented in
`include/linux/hid.h` (lines 839-843), and is safe because
`hid_open_report()` immediately copies the returned data.

### Stable kernel criteria assessment

1. **Fixes a real bug**: Yes — memory leak on every device probe for
   Apple Magic Mouse 2 and Magic Trackpad 2 connected via USB.
2. **Obviously correct**: Yes — the HID core immediately `kmemdup()`s
   the return value, so returning a pointer into the caller's buffer is
   safe. The documentation explicitly says "a sub-portion of it" is
   valid.
3. **Small and contained**: Yes — removes 3 lines (kmemdup + NULL
   check), changes one line. Single file, single function.
4. **No new features**: Correct — pure bug fix.
5. **Low risk**: Very low — the change is simpler than the original
   code. Removes an allocation that was never needed.

### User impact

This affects all users of Apple Magic Mouse 2 and Magic Trackpad 2 over
USB. Each time the device is probed (e.g., plugged in, resumed), ~82
bytes are leaked. While not catastrophic per-event, it's a real resource
leak that accumulates.

### Risk assessment

Minimal risk. The fix makes the code simpler and removes a dynamic
allocation. The HID core's defensive `kmemdup()` of the returned pointer
ensures the approach is safe.

### Dependency check

The buggy `kmemdup()` was introduced in commit `0b91b4e4dae63` ("HID:
magicmouse: Report battery level over USB"), which was in v5.16. This
code exists in all current stable trees (6.1.y, 6.6.y, 6.12.y). The fix
is self-contained with no dependencies on other commits.

### Verification

- **git show 0b91b4e4dae63** confirmed the kmemdup was introduced in the
  original "Report battery level over USB" commit (2021, v5.16 era)
- **hid-core.c hid_open_report()** verified: the caller kmemdup's the
  return value immediately and frees its own buffer — it does NOT take
  ownership of the returned pointer (lines 1285-1307)
- **include/linux/hid.h documentation** (lines 839-843) confirmed:
  returning "a sub-portion of it" is explicitly documented as valid
- **git log --oneline -- drivers/hid/hid-magicmouse.c** confirmed the
  commit under review (`c0993f362e2ef`) is the fix, with no other
  dependencies
- **Commit 225c43c0e9164** (the next commit after) only changes the size
  check from `== 83` to `>= 83` and does not affect the fix's
  applicability

This is a clear, small, self-contained memory leak fix in a widely-used
driver. It meets all stable kernel criteria with minimal risk.

**YES**

 drivers/hid/hid-magicmouse.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index f4cf29c2e8330..9eadf3252d0dc 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -994,9 +994,7 @@ static const __u8 *magicmouse_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		hid_info(hdev,
 			 "fixing up magicmouse battery report descriptor\n");
 		*rsize = *rsize - 1;
-		rdesc = kmemdup(rdesc + 1, *rsize, GFP_KERNEL);
-		if (!rdesc)
-			return NULL;
+		rdesc = rdesc + 1;
 
 		rdesc[0] = 0x05;
 		rdesc[1] = 0x01;
-- 
2.51.0

