Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C6144E043;
	Tue, 10 Mar 2026 09:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773133340; cv=none; b=u1gRKxSY5SXaImLstAT85BcbHyN5UXs9sHHpTotP/QwcQ78tub+6RQ5NJhUsplD5BkqYxwSUF4abl15qlm24WWyKkKjjoIf9ZQla2VbRdHHiiq1XQ7NJHQrP8dbf8WoTWW8zcMr/QHfUZqS/buaSXWR7JzLR66zlM3kWSlrH02k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773133340; c=relaxed/simple;
	bh=SPq3wEgem/fxiZTAe2wnnxRgPBt+p/dW6wj5UfOmv3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=afbPknPwYxpgeFfc/dAH4a0Y+E2+9PMR86lorazMlHPQzZiQGnsyAbuI9bWywoWgWlnnieW3yzMcwFNhIoysOpjb880ZIJB0Bc7/NY03FWVCo83MfDDY5wfcyj/cJoiyHiohBIfGAAQ5zUE1NTj9xLR1nzpvMQXr9y1ilgePkBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=feSgcyxG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="feSgcyxG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 599F5C2BC86;
	Tue, 10 Mar 2026 09:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773133340;
	bh=SPq3wEgem/fxiZTAe2wnnxRgPBt+p/dW6wj5UfOmv3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=feSgcyxGXOo3sH2k0vytR3tFz5aJoRsM/OtkjDgagm32bRCFJtxD0CCTpnq2sFrmY
	 olOvG7hHXPbIDPUQ3dVl8XkmCR1JoHGZ4IFR91pbGZO9tUV8QgP8uFLD01BhqgCpwr
	 oNRP2w7AXRlxytwBwC0jZ6VLL1SdSaIbjOZZKQvdvTBFusoWLGzL0jPJB/RK1Q977W
	 agMHJqslZ3dBoV+SFuZyS+WwvsIx1yIRPvthaR6ECVMpUlCzPmdJlojHDPeKjGBPWl
	 dLzDmW7g9dbDPIi0uXMJ4jRsXtje6Jy3LTFRtu5z/rT3HfctUiNxBYIHD1GIQbCFq3
	 Yh57KDcwedvpg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	jikos@kernel.org,
	linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.1] HID: apple: avoid memory leak in apple_report_fixup()
Date: Tue, 10 Mar 2026 05:01:23 -0400
Message-ID: <20260310090145.2709021-23-sashal@kernel.org>
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

[ Upstream commit 239c15116d80f67d32f00acc34575f1a6b699613 ]

The apple_report_fixup() function was returning a
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

This is very revealing. The caller's flow is:

1. `buf = kmemdup(start, size, ...)` — makes a copy of rdesc
2. `start = device->driver->report_fixup(device, buf, &size)` — calls
   the fixup, passing `buf`
3. `start = kmemdup(start, size, ...)` — copies whatever `report_fixup`
   returned
4. `kfree(buf)` — frees the original buf

**The old buggy code**: `apple_report_fixup` did `rdesc = kmemdup(rdesc
+ 1, ...)` which allocated a NEW buffer and returned it. The caller then
does `kmemdup(start, size)` (copies it again) and `kfree(buf)` (frees
the ORIGINAL `buf`). But the intermediate buffer allocated by
`apple_report_fixup` is never freed — leaked.

**The fix**: Instead of `kmemdup(rdesc + 1, ...)`, just do `rdesc =
rdesc + 1`. This returns a pointer into the caller's `buf`, which the
caller will properly copy and then free.

This is safe because:
- The caller already makes a copy of whatever is returned
  (`kmemdup(start, size)`)
- The caller then frees `buf`
- Since `rdesc + 1` points into `buf`, it's valid until `kfree(buf)`
  which happens AFTER the copy

## Analysis

**What problem the commit solves**: Every time `apple_report_fixup()` is
called for a Magic Keyboard with the `APPLE_RDESC_BATTERY` quirk, a
`kmemdup()` allocation leaks memory. This happens at device probe time,
so each time a Magic Keyboard is connected (or the driver is reloaded),
memory is leaked.

**Meets stable kernel rules**:
1. **Obviously correct and tested** — Yes, the fix simply changes
   `kmemdup(rdesc + 1, ...)` to `rdesc + 1`. The caller already copies
   the returned buffer, so the intermediate allocation was unnecessary.
2. **Fixes a real bug** — Yes, a real memory leak.
3. **Important issue** — Memory leak that occurs on every device probe
   for affected Apple Magic Keyboards. While not a crash, it's a
   persistent resource leak.
4. **Small and contained** — Yes, a 3-line change (removes kmemdup +
   error check, replaces with pointer arithmetic).
5. **No new features** — Correct, pure bug fix.

**Risk vs benefit**: Very low risk. The change simplifies the code by
removing an allocation. The caller's code in `hid-core.c` explicitly
handles this case (comment says "report_fixup() returns a sub-portion of
the input rdesc"). Benefit is fixing a real memory leak affecting Apple
keyboard users.

**Affected versions**: The buggy code was introduced in commit
`6e143293e17a7` which first appeared in v5.17-rc1. All stable trees from
5.17+ are affected (6.1.y, 6.6.y, 6.12.y, etc.).

**Dependencies**: None. The fix is self-contained and applies cleanly.

## Verification

- `git show 6e143293e17a7` confirmed this is the commit that introduced
  the buggy `kmemdup` call in `apple_report_fixup()`, first appearing in
  v5.17-rc1
- Read `hid-core.c:1285-1304` confirmed the caller does NOT take
  ownership of the returned pointer — it copies it with `kmemdup(start,
  size)` and then frees `buf`, meaning any separate allocation by
  `report_fixup` is leaked
- The caller's comment at line 1298-1301 explicitly states
  "report_fixup() returns a static read-only memory... we have no idea
  if that memory needs to be cleaned up" — confirming the caller cannot
  and does not free the report_fixup return value
- Read the fixed code at `hid-apple.c:691-692` confirming `rdesc = rdesc
  + 1` correctly returns a sub-portion of the input buffer, which the
  caller handles properly
- The fix removes 3 lines and adds 1 line — minimal change with clear
  semantics

**YES**

 drivers/hid/hid-apple.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index 2f9a2e07c4263..9dcb252c5d6c7 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -689,9 +689,7 @@ static const __u8 *apple_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		hid_info(hdev,
 			 "fixing up Magic Keyboard battery report descriptor\n");
 		*rsize = *rsize - 1;
-		rdesc = kmemdup(rdesc + 1, *rsize, GFP_KERNEL);
-		if (!rdesc)
-			return NULL;
+		rdesc = rdesc + 1;
 
 		rdesc[0] = 0x05;
 		rdesc[1] = 0x01;
-- 
2.51.0

