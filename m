Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868C044CAF3;
	Tue, 10 Mar 2026 09:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773133333; cv=none; b=S1qLaxo9Lp0+NYbVxoCPUqI8b64fNIRk/kN8V4SRn6fiOavLMvzXrpp8nrzCmAzZl5AiLbruP1/6MNbYSjG+77xz1TyLTwukeneUgQqMmHwrqjmiPnf9nPVCcl8oWA058oHIltUNGV+rYzwcMpKLR87u06H1Mc90tEZUP/cW0yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773133333; c=relaxed/simple;
	bh=evhKPyU7Sb5O7u9HZt6apms9Tl1WZKdf1tbga43qqzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u8ro1k4TArOQ2s53CbNon0WO0OrxQ5SKhT9equvBmJUIqSComY0kbg+A1EDXi1xTsa1bigcm002pYDgwhgsPJMq2HoaGFTDoJ9ht+9yp532dTHdqtGQ1iaW477n30ybXclaSKP/RqokyWg24zFgEdEcdVf9ndsH/2QQrUzXVuNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rV6MmcyS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rV6MmcyS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C5E9C2BC87;
	Tue, 10 Mar 2026 09:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773133333;
	bh=evhKPyU7Sb5O7u9HZt6apms9Tl1WZKdf1tbga43qqzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rV6MmcySTlugw6/Jt8UMLLY6nB0Xq7s0ZvUVsnrX4oyEsPOwenJasQnpvzrbA/Hjl
	 3QCQeG/7IBxnEqQUIEq/pmO2TDOVXnGRNutzQrGG4WYunyqXMeJhZqUCy+97YtFx4i
	 BtEeSEzTQgcWsCcVVhftvNGdD437aellmaZlBVriiEQ5yrjgnpWY1AB59HQtyAriJL
	 F9Tk/3K2cevcKEG7q11bnlnJ9FoGK9Uh9VwIxns4xU2j/ANd/OMUARDGTBsuH04//6
	 Kylc4112nrTK7tpalNlmcAi9VBUMaa7mFF0Ei1KyBb5Nb7qSXsiT2jnBEbuN9kXngb
	 pcpGbjzo/aAlQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	jikos@kernel.org,
	linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] HID: asus: avoid memory leak in asus_report_fixup()
Date: Tue, 10 Mar 2026 05:01:18 -0400
Message-ID: <20260310090145.2709021-18-sashal@kernel.org>
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

[ Upstream commit 2bad24c17742fc88973d6aea526ce1353f5334a3 ]

The asus_report_fixup() function was returning a newly allocated
kmemdup()-allocated buffer, but never freeing it.  Switch to
devm_kzalloc() to ensure the memory is managed and freed automatically
when the device is removed.

The caller of report_fixup() does not take ownership of the returned
pointer, but it is permitted to return a pointer whose lifetime is at
least that of the input buffer.

Also fix a harmless out-of-bounds read by copying only the original
descriptor size.

Assisted-by: Gemini-CLI:Google Gemini 3
Signed-off-by: Günther Noack <gnoack@google.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### Problem Description

The `asus_report_fixup()` function in `drivers/hid/hid-asus.c` had a
memory leak in the `QUIRK_T100CHI | QUIRK_T90CHI` path. The buggy code
used `kmemdup()` to allocate a new report descriptor buffer, but this
buffer was never freed by anyone:

**The leak mechanism (verified by reading hid-core.c:1285-1307):**
1. Caller allocates `buf` via `kmemdup()` (line 1291)
2. Caller passes `buf` to `report_fixup()` (line 1296)
3. The old `report_fixup()` returned a *new* `kmemdup()`'d pointer,
   discarding `buf`
4. Caller does `start = kmemdup(start, size, ...)` — making *yet another
   copy* (line 1303)
5. Caller does `kfree(buf)` — frees the original, but NOT the
   intermediate kmemdup from report_fixup()
6. The intermediate buffer is **leaked**

### Fix Analysis

The fix is small (11 insertions, 4 deletions) and does three things:

1. **Switches from `kmemdup()` to `devm_kzalloc()`**: Ties the
   allocation to the HID device lifetime, so it's automatically freed on
   device removal. This eliminates the leak.

2. **Fixes error handling**: Old code returned `NULL` on allocation
   failure, which the caller doesn't handle well. New code returns the
   original `rdesc`, matching the pattern already used by
   `QUIRK_G752_KEYBOARD` in the same function.

3. **Fixes out-of-bounds read**: Old code did `kmemdup(rdesc, *rsize,
   ...)` where `*rsize` was already set to `rsize_orig + 1` (one byte
   larger than the actual descriptor). New code does `memcpy(new_rdesc,
   rdesc, rsize_orig)`, copying only the valid data.

### Stable Criteria Assessment

- **Fixes a real bug**: Yes — memory leak on every T100CHI/T90CHI
  keyboard report descriptor parse
- **Obviously correct**: Yes — follows the identical pattern used by
  QUIRK_G752_KEYBOARD in the same function (verified in the diff
  context)
- **Small and contained**: Yes — 15 lines changed in a single file
- **No new features**: Correct — pure bug fix
- **Bug has existed since 2017**: Commit 73c75d3958579 introduced
  T100CHI support with the buggy `kmemdup()` pattern, present in all
  stable trees

### Risk Assessment

**Very low risk.** The fix:
- Follows an existing pattern already proven in the same function
  (QUIRK_G752_KEYBOARD)
- Only affects ASUS T100CHI and T90CHI hardware
- The devm_kzalloc lifetime (device lifetime) is correct since the
  caller copies the returned data immediately
- No dependencies on other commits

### Verification

- **Verified caller behavior**: Read `hid-core.c:1285-1307` — confirmed
  the caller does `kmemdup()` of the returned pointer then `kfree(buf)`,
  meaning any new allocation from `report_fixup()` is leaked
- **Verified the existing devm_kzalloc pattern**: The
  QUIRK_G752_KEYBOARD block in the same function already uses
  `devm_kzalloc` with the same allocation + `return rdesc` on failure
  pattern
- **Verified bug age**: `git log --oneline` showed commit
  `73c75d3958579` (2017-08-04) introduced the T100CHI support with
  `kmemdup()`, confirmed present in stable trees via `git tag
  --contains`
- **Verified commit SHA**: `git show 5dc6c17c16935` confirmed the commit
  matches the diff under review, with upstream commit `2bad24c17742f`
- **Verified the OOB read**: Old code set `*rsize = rsize_orig + 1`
  BEFORE `kmemdup(rdesc, *rsize, ...)`, reading one byte past the
  original descriptor — confirmed by the diff context showing the order
  of operations

This is a clear, small, low-risk fix for a real memory leak (and minor
OOB read) in a HID driver, following an established pattern already in
the same function. It meets all stable kernel criteria.

**YES**

 drivers/hid/hid-asus.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-asus.c b/drivers/hid/hid-asus.c
index 472bca54642b9..8487332bf43b0 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -1306,14 +1306,21 @@ static const __u8 *asus_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		 */
 		if (*rsize == rsize_orig &&
 			rdesc[offs] == 0x09 && rdesc[offs + 1] == 0x76) {
-			*rsize = rsize_orig + 1;
-			rdesc = kmemdup(rdesc, *rsize, GFP_KERNEL);
-			if (!rdesc)
-				return NULL;
+			__u8 *new_rdesc;
+
+			new_rdesc = devm_kzalloc(&hdev->dev, rsize_orig + 1,
+						 GFP_KERNEL);
+			if (!new_rdesc)
+				return rdesc;
 
 			hid_info(hdev, "Fixing up %s keyb report descriptor\n",
 				drvdata->quirks & QUIRK_T100CHI ?
 				"T100CHI" : "T90CHI");
+
+			memcpy(new_rdesc, rdesc, rsize_orig);
+			*rsize = rsize_orig + 1;
+			rdesc = new_rdesc;
+
 			memmove(rdesc + offs + 4, rdesc + offs + 2, 12);
 			rdesc[offs] = 0x19;
 			rdesc[offs + 1] = 0x00;
-- 
2.51.0

