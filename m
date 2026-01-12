Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07FB82DB7B0;
	Mon, 12 Jan 2026 14:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768229934; cv=none; b=Lkg0mIYhnrpQqZyv4qlbTTS6Ug0jdMd1WFqf1yh3Cxr4MAOB+24D/obtlWV7nbelEEGeiPUuHunDkq50QLg/D0RuIiGTyMPdCWxPLs2pvQOti31CGEzSJGiQ7jhqQvz5vafcm/SS6GOAX9Iv3Q/MNWNvozpMUkKzVkmV5xgf4eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768229934; c=relaxed/simple;
	bh=iANEYljBmEYObhC9mPTmReYboGBOtiRRyqhSY4jW/fk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eEwrnlMTX9rdxzYARChDPepUYO+qUZJyrf5ZDv5KXYN/acQhuv7ycHJ0TeD30ql5pY9f1r3zhCcK3y/9gCOveABkwuOi2xXRj5NonuXQ4e6zjTsPbKb8u3VlbgipWPXJp+XHT7qaDUBrwQnA/ACyTv5nYNTMJbLUYz7pc6QNK3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X40Sgitg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X40Sgitg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFA29C19423;
	Mon, 12 Jan 2026 14:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768229933;
	bh=iANEYljBmEYObhC9mPTmReYboGBOtiRRyqhSY4jW/fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X40SgitgBrKaCAwYmfse04ryC/cLHtow3tStaGYrQ6jjIjGoNfi8s1TyPQfb7nPez
	 w9i20/GWD9JqFRKxlchj+JyfjLayec33CH9bIgQlANAgyhypZdIFDSJ5+hGvqFrobX
	 DM1XjkdnBanlE0uiRnOuAPzGZ30qAptzAwhQNaAltz4TW/nZor/dMyP4IJJMpPzMW4
	 sEyihrC71z6Hq/SE7JdJ5GOAJ+oSf3V4c0S838lUdLaAz53PqDGZVQ6vyv30YVDxYC
	 b4XJMt+j4t4wdJcFID9ncTMLe7xcY2BW7VFT/FIeDGY6ekPo/NCI4AuhkM8xY06wnI
	 Gkd21go6cnZoQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kwok Kin Ming <kenkinming2002@gmail.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	dianders@chromium.org,
	jikos@kernel.org,
	treapking@chromium.org,
	dan.carpenter@linaro.org,
	superm1@kernel.org,
	guanwentao@uniontech.com
Subject: [PATCH AUTOSEL 6.18-6.1] HID: i2c-hid: fix potential buffer overflow in i2c_hid_get_report()
Date: Mon, 12 Jan 2026 09:58:10 -0500
Message-ID: <20260112145840.724774-9-sashal@kernel.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kwok Kin Ming <kenkinming2002@gmail.com>

[ Upstream commit 2497ff38c530b1af0df5130ca9f5ab22c5e92f29 ]

`i2c_hid_xfer` is used to read `recv_len + sizeof(__le16)` bytes of data
into `ihid->rawbuf`.

The former can come from the userspace in the hidraw driver and is only
bounded by HID_MAX_BUFFER_SIZE(16384) by default (unless we also set
`max_buffer_size` field of `struct hid_ll_driver` which we do not).

The latter has size determined at runtime by the maximum size of
different report types you could receive on any particular device and
can be a much smaller value.

Fix this by truncating `recv_len` to `ihid->bufsize - sizeof(__le16)`.

The impact is low since access to hidraw devices requires root.

Signed-off-by: Kwok Kin Ming <kenkinming2002@gmail.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of HID: i2c-hid: fix potential buffer overflow in
i2c_hid_get_report()

### 1. COMMIT MESSAGE ANALYSIS

The commit message clearly describes a **buffer overflow
vulnerability**:
- `recv_len` comes from userspace via the hidraw driver, bounded only by
  HID_MAX_BUFFER_SIZE (16384)
- `ihid->rawbuf` has size `ihid->bufsize` determined at runtime by
  device report sizes - can be much smaller
- The I2C transfer reads `recv_len + sizeof(__le16)` bytes into the
  potentially smaller buffer
- The fix truncates `recv_len` to prevent overflow

Key phrase: "fix potential buffer overflow" - this is a security fix.
The message acknowledges "impact is low since access to hidraw devices
requires root," but buffer overflows are still serious vulnerabilities.

### 2. CODE CHANGE ANALYSIS

The fix is a single line addition:
```c
recv_len = min(recv_len, ihid->bufsize - sizeof(__le16));
```

**Technical mechanism of the bug:**
- `i2c_hid_xfer()` is called with `recv_len + sizeof(__le16)` as the
  read length
- If userspace requests a large report via hidraw, `recv_len` could be
  up to 16384
- The destination buffer `ihid->rawbuf` has size `ihid->bufsize`, which
  is allocated based on the device's maximum report size
- If `recv_len + 2 > ihid->bufsize`, data is written past the end of
  `rawbuf`

**Why the fix is correct:**
- The `min()` ensures `recv_len ≤ ihid->bufsize - sizeof(__le16)`
- Therefore `recv_len + sizeof(__le16) ≤ ihid->bufsize` - no overflow
  possible
- Placement is perfect: right before the I2C transfer that performs the
  write

### 3. CLASSIFICATION

This is a **security bug fix** - specifically a buffer overflow that:
- Can be triggered from userspace (via hidraw)
- Could lead to kernel memory corruption
- Requires root access (limiting practical exploitability)

Even with limited exploitability, buffer overflows in kernel drivers are
exactly what stable trees want to fix for defense-in-depth.

### 4. SCOPE AND RISK ASSESSMENT

| Metric | Assessment |
|--------|------------|
| Lines changed | 1 |
| Files touched | 1 |
| Complexity | Trivial (min() call) |
| Subsystem maturity | High (i2c-hid is mature, widely used) |
| Risk of regression | Near zero |

The fix is **surgical and contained** - it only adds a bounds check. It
cannot break correct behavior since:
- Valid requests (where recv_len fits in the buffer) are unaffected
- Invalid requests (oversized) now get safely truncated instead of
  causing overflow

### 5. USER IMPACT

**Affected users:** Anyone using I2C-HID devices - common on laptops for
touchpads, touchscreens, and keyboards.

**Severity:** Buffer overflow = potentially high severity for security
(memory corruption, possible privilege escalation), though
exploitability is limited by root requirement.

**Real-world impact:** While requiring root reduces the attack surface,
compromised root processes or certain security models (containers,
sandboxes) make this relevant.

### 6. STABILITY INDICATORS

- Signed-off-by Benjamin Tissoires (HID subsystem maintainer)
- The fix is trivially verifiable as correct
- Standard defensive bounds checking pattern

### 7. DEPENDENCY CHECK

- Standalone fix, no dependencies on other commits
- `i2c_hid_get_report()` and the buffer management have existed for
  years
- Will apply cleanly to stable trees

### STABLE KERNEL RULES ASSESSMENT

| Criterion | Met? |
|-----------|------|
| Obviously correct and tested | ✅ Yes - trivial min() bounds check |
| Fixes a real bug | ✅ Yes - buffer overflow |
| Important issue (security/crash/corruption) | ✅ Yes - security
vulnerability |
| Small and contained | ✅ Yes - 1 line, 1 file |
| No new features | ✅ Yes - pure bug fix |
| Applies cleanly | ✅ Yes - no dependencies |

### RISK VS BENEFIT

**Benefit:** Fixes a buffer overflow vulnerability in widely-used HID
driver code
**Risk:** Effectively zero - the fix is a trivial bounds check that
cannot cause regressions

### CONCLUSION

This commit is an ideal candidate for stable backporting:
- It fixes a genuine security vulnerability (buffer overflow)
- The fix is minimal (1 line), obviously correct, and risk-free
- The i2c-hid driver is widely used on modern laptops
- Even though root is required to exploit, defense-in-depth principles
  favor fixing all buffer overflows
- Has proper maintainer sign-off

**YES**

 drivers/hid/i2c-hid/i2c-hid-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index 63f46a2e57882..5a183af3d5c6a 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -286,6 +286,7 @@ static int i2c_hid_get_report(struct i2c_hid *ihid,
 	 * In addition to report data device will supply data length
 	 * in the first 2 bytes of the response, so adjust .
 	 */
+	recv_len = min(recv_len, ihid->bufsize - sizeof(__le16));
 	error = i2c_hid_xfer(ihid, ihid->cmdbuf, length,
 			     ihid->rawbuf, recv_len + sizeof(__le16));
 	if (error) {
-- 
2.51.0

