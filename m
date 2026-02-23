Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F54366073;
	Mon, 23 Feb 2026 12:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771850276; cv=none; b=NRPv1Jw8WWg/Lv9n6QTaY46BUAt7PNoJDgOvFLYkxpci3KD/bsejlTDaxnjdLYQzfaXs1K1zFaOyY7QwoJWBK9qyyhN8tnXVffafJzFWlSh4MJqjGAiO4Zcl5BdGjONjL1LXrHJTd2aCuYdwOoFK+vnhVGXmf1CSCo4CCK3JJP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771850276; c=relaxed/simple;
	bh=RQh1j+LUKytS3w1QRWWV+FCwNZExkTptVRygNB3i8xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aG4Q6GbhhQLYz9IYUs+G29zNRKlGkLVtLiCKgxZ1nmPDYAReiF8FbzBkk7wFwdNbjeIq2RE2n3EOcztGG06c+9yJ7kD0Gj4L38sIn6dmCKDq75Hb4+ep9SGkqOv7E2OEHUkJwiGoFO/B75jLCpdq2aGLVobQoJlcDAzQ7/HZTbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TcVyXuQU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TcVyXuQU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 690A6C2BCAF;
	Mon, 23 Feb 2026 12:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771850276;
	bh=RQh1j+LUKytS3w1QRWWV+FCwNZExkTptVRygNB3i8xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TcVyXuQUW/36l1glygxuqv3OF7I9TC7EShd0d+3rOwhBGRvtbnn+lJR2rJuxTyGt5
	 cmZ3Ygk+aXMEh4wB4KAVpFvGkLPk/IOhL58Z6GCqS6oX1EveY8TbDRKkwUaENtJe/I
	 xj8FFuHWSGNMx5rUDUnt0j8DE8Z49RQkRROch3fMQ0lyfDi9kuEr8eH5Q8Dnerk0HY
	 WKa51Q7JDO0bm7V/dzom10M+Cp4FW0EiuT1WFGA3mKFxPDoR0vG+wbGLJf4ebiVt4a
	 ulKk337N8fX/y0yzk7oxLQABs1QCj/6z3lXXu1SzPZboDA3QZf/yTCrBYYPwpAhnjN
	 pzBW/9Pmzm5Xw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	lgirdwood@gmail.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] regulator: core: Remove regulator supply_name length limit
Date: Mon, 23 Feb 2026 07:37:16 -0500
Message-ID: <20260223123738.1532940-11-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260223123738.1532940-1-sashal@kernel.org>
References: <20260223123738.1532940-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>

[ Upstream commit e243cdd87b911ce9968b62e4ab2b680dfadc4341 ]

When creating the regulator object, associated with a consumer device,
the supply_name is string formatted into a statically sized buffer on
the stack, then strdup()'ed onto the heap.

Not only is the dance on the stack unnecessary, but when the device's
name is long we might not fit the constructed supply_name in the fixed
64 byte buffer on the stack.

One such case can be seen on the Qualcomm Rb3Gen2 board, where we find a
PCIe controller, with a PCIe switch, with a USB controller, with a USB
hub, consuming a regulator. In this example the dev->kobj.name itself is
62 characters long.

Drop the temporary buffer on the stack and kasprintf() the string
directly on the heap, both to simplify the code, and to remove the
length limitation.

Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Link: https://patch.msgid.link/20260211-regulator-supply-name-length-v1-1-3875541c1576@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have sufficient information for a thorough analysis.

## Analysis

### 1. COMMIT MESSAGE ANALYSIS

The commit message clearly describes a real bug: the
`create_regulator()` function uses a fixed 64-byte stack buffer
(`REG_STR_SIZE`) to format the supply name. When the device's kobject
name plus the supply name exceeds 63 characters, the `snprintf` output
is truncated, and the `size >= REG_STR_SIZE` check causes the function
to return NULL — meaning the regulator **fails to be created entirely**.

The commit describes a concrete real-world case on the Qualcomm Rb3Gen2
board where a deeply nested device topology (PCIe controller -> PCIe
switch -> USB controller -> USB hub) produces a device name 62
characters long, which combined with the supply name easily exceeds 64
bytes.

### 2. CODE CHANGE ANALYSIS

The change is small and surgical:

**Before:** A 64-byte stack buffer `buf[REG_STR_SIZE]` is used with
`snprintf()`, then `kstrdup()`. If the formatted string is >= 64 bytes,
the function returns NULL (regulator creation fails).

**After:** `kasprintf(GFP_KERNEL, "%s-%s", dev->kobj.name, supply_name)`
allocates exactly the needed size on the heap directly. No truncation
possible (unless memory allocation itself fails).

The change:
- Removes the `#define REG_STR_SIZE 64` (which was only used here)
- Removes the stack buffer and `snprintf` + truncation check + `kstrdup`
  dance
- Replaces with a single `kasprintf()` call
- Keeps the `kfree_const()` cleanup compatible (kasprintf returns heap
  memory, which kfree_const handles correctly)

### 3. USER IMPACT

When `create_regulator()` returns NULL, both callers (`set_supply()` at
line 1798, and `_regulator_get_common()` at line 2411) treat it as
-ENOMEM and fail the regulator acquisition. This means:

- **In `set_supply()`**: The regulator's supply chain fails to resolve.
  The regulator won't work properly.
- **In `_regulator_get_common()`**: `regulator_get()` returns an error
  to the consumer driver. The driver's probe will fail, meaning the
  device won't function.

On the Qualcomm Rb3Gen2, this means a USB hub behind a PCIe-connected
USB controller can't get its regulator, potentially causing the entire
downstream USB tree to be non-functional.

### 4. SCOPE AND RISK

- **Lines changed**: ~15 lines removed, ~3 lines added (net reduction)
- **Files affected**: 1 file (drivers/regulator/core.c)
- **Risk**: Very low. `kasprintf` is a well-established kernel API. The
  change is semantically equivalent but removes an arbitrary limitation.
  The only functional difference is: names that were previously rejected
  (>63 chars) now succeed.
- **Regression potential**: Minimal. The new code handles the same error
  cases (memory allocation failure). The `kfree_const` in
  `destroy_regulator()` works correctly with both `kasprintf` and
  `kstrdup_const` allocated memory.

### 5. STABLE KERNEL CRITERIA

- **Obviously correct**: Yes — `kasprintf` is the standard kernel
  pattern for "format a string and allocate it"
- **Fixes a real bug**: Yes — regulator creation silently fails for
  devices with long names
- **Important issue**: Yes — complete device failure on affected
  hardware
- **Small and contained**: Yes — 1 file, ~15 lines net change, purely
  within one function
- **No new features**: Correct — no new API, no behavior change for
  names that fit in 64 bytes
- **No dependencies**: The code uses standard kernel APIs (`kasprintf`,
  `kfree_const`) that exist in all stable trees

### 6. DEPENDENCY CHECK

The commit operates on `create_regulator()` which has existed in the
kernel for a very long time. The `kasprintf` API is available in all
supported stable kernels. The `kfree_const` pattern was introduced in
commit 0630b614391f (2017), so it's in all current stable trees. No
dependencies on other recent commits.

### Verification

- **Verified** that `create_regulator()` is called from `set_supply()`
  (line 1798) and `_regulator_get_common()` (line 2411), both of which
  propagate NULL as -ENOMEM errors that fail driver probe
- **Verified** that `REG_STR_SIZE` was only used in `create_regulator()`
  (via grep)
- **Verified** that `kfree_const()` is used in `destroy_regulator()` to
  free `supply_name`, and works correctly with `kasprintf`-allocated
  memory (heap memory is always freeable by kfree_const)
- **Verified** via git log that `kstrdup_const` pattern was introduced
  in commit 0630b614391f (2017), present in all stable trees
- **Verified** the code before the patch at lines 1996-2004 showing the
  64-byte buffer and truncation-then-return-NULL behavior
- **Verified** the commit applies to a single file
  (drivers/regulator/core.c) with minimal change scope
- **Unverified**: Could not independently verify the 62-character device
  name claim on Rb3Gen2 (taken from commit message, which is from the
  Qualcomm kernel engineer)

### Conclusion

This commit fixes a real bug where regulator creation fails for devices
with long kobject names (>~58 characters when combined with supply
name). The failure causes complete device malfunction. The fix is small,
surgical, uses standard kernel APIs, has no dependencies, and carries
essentially zero regression risk. It meets all stable kernel criteria.

**YES**

 drivers/regulator/core.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 4b6182cde859a..6fb00d21004ed 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1944,8 +1944,6 @@ static const struct file_operations constraint_flags_fops = {
 #endif
 };
 
-#define REG_STR_SIZE	64
-
 static void link_and_create_debugfs(struct regulator *regulator, struct regulator_dev *rdev,
 				    struct device *dev)
 {
@@ -1993,15 +1991,7 @@ static struct regulator *create_regulator(struct regulator_dev *rdev,
 	lockdep_assert_held_once(&rdev->mutex.base);
 
 	if (dev) {
-		char buf[REG_STR_SIZE];
-		int size;
-
-		size = snprintf(buf, REG_STR_SIZE, "%s-%s",
-				dev->kobj.name, supply_name);
-		if (size >= REG_STR_SIZE)
-			return NULL;
-
-		supply_name = kstrdup(buf, GFP_KERNEL);
+		supply_name = kasprintf(GFP_KERNEL, "%s-%s", dev->kobj.name, supply_name);
 		if (supply_name == NULL)
 			return NULL;
 	} else {
-- 
2.51.0

