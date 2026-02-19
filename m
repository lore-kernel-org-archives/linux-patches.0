Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2822DB794;
	Thu, 19 Feb 2026 02:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771466680; cv=none; b=TFoRit6CbEdJ6I0g7IvRF7tZAUNhgRVMlhCbvsXstsoaIUFsHUwT8rEbVD+SBBSHCrIUeCoZ/WedXen4D5CxTnE4de3YyBGNl9JL3tBf6Wl98N+Ye2BRF3YaKaFFLPPXaJ9I2dsi2aj7m1UYIyv5njXicT3jYAv0MgrrVnkydF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771466680; c=relaxed/simple;
	bh=uAi1eoNzNJxWFObLzShw59JJxbfLapH+WZEJwIlddE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AM/3H0On8r+jmrJUzYQwbk/Nu4pILLT2eF3bTZNvsPKkXGtFJfHTsIFH+5+wQp20mUpRcUbyZGKvKZE3hd7cbwnIXXLp0uDavk04oDxWnVSucYaWGAKg4xYON704KGcXTzn1Caxg1a65zsdyRpnZ22ax6WXLRwLkx190nBT4K0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K7dP5nDf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K7dP5nDf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55140C19422;
	Thu, 19 Feb 2026 02:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771466680;
	bh=uAi1eoNzNJxWFObLzShw59JJxbfLapH+WZEJwIlddE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K7dP5nDfMyXrcud97AgBPGJEptotnr9/WYkO6iJEVfPR9C8/YpKjsudMYFfbWL/OC
	 hn9JUv2wTJMTtgaKTMWyKj7SKQSxsDQYio7Zn7n0lzS0s72XolEb4rNPoNiihmdH9J
	 7LTSrMQlCDHTbbQO668grOGfpujAxa5zSJZkqMQ8NEaB/i8AvsMFJVY5ta7ML2SwxK
	 wj+H4u9ADf5axQ89xdXTlWOMdqNkHjuO8SF681Sjcw36L0VJgZcdmIgi2IU6gVOVvC
	 CF8VZlxkzaLh/TO04xCQb0cz8sDkVWEJ6HWvkpO/s5OvbUODCbQe2+LIB5xSx9keSF
	 SwK68x1jZjnJA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Navaneeth K <knavaneeth786@gmail.com>,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	parthiban.veerasooran@microchip.com,
	christian.gromm@microchip.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.12] most: core: fix resource leak in most_register_interface error paths
Date: Wed, 18 Feb 2026 21:03:49 -0500
Message-ID: <20260219020422.1539798-13-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260219020422.1539798-1-sashal@kernel.org>
References: <20260219020422.1539798-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Navaneeth K <knavaneeth786@gmail.com>

[ Upstream commit 1f4c9d8a1021281750c6cda126d6f8a40cc24e71 ]

The function most_register_interface() did not correctly release resources
if it failed early (before registering the device). In these cases, it
returned an error code immediately, leaking the memory allocated for the
interface.

Fix this by initializing the device early via device_initialize() and
calling put_device() on all error paths.

The most_register_interface() is expected to call put_device() on
error which frees the resources allocated in the caller. The
put_device() either calls release_mdev() or dim2_release(),
depending on the caller.

Switch to using device_add() instead of device_register() to handle
the split initialization.

Acked-by: Abdun Nihaal <abdun.nihaal@gmail.com>
Signed-off-by: Navaneeth K <knavaneeth786@gmail.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/20251127165337.19172-1-knavaneeth786@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The MOST driver has been in the kernel since well before 5.15 (moved out
of staging in March 2020, v5.7 timeframe), so this bug affects all
active stable trees.

## Summary of the Bug Fix

**What was the bug:** `most_register_interface()` had resource leaks on
its early error paths. When `ida_alloc()` or `kzalloc()` failed, the
function returned an error without calling `put_device(iface->dev)`. The
callers (most_usb.c and dim2.c) relied on `most_register_interface()` to
properly clean up the device on failure by calling `put_device()`, which
triggers the release callback (`release_mdev` or `dim2_release`) to free
the parent structure. Without the `put_device()` call, these structures
were leaked.

**What the fix does:**
1. Calls `device_initialize(iface->dev)` early, before any possible
   failure point
2. Adds `put_device(iface->dev)` on both early error paths (ida_alloc
   failure, kzalloc failure)
3. Switches from `device_register()` to `device_add()` because
   `device_register()` = `device_initialize()` + `device_add()`, and
   initialization now happens earlier

**The change is:**
- +4 lines, -1 line (net +3 lines)
- Touches a single file
- Uses a well-established kernel pattern (device_initialize +
  device_add)
- Reviewed by Dan Carpenter, a highly respected kernel reviewer
- Acked and merged by Greg Kroah-Hartman

## Stable Kernel Criteria Assessment

1. **Obviously correct and tested**: Yes — the pattern of
   `device_initialize()` + `put_device()` on error paths +
   `device_add()` is a standard kernel device lifecycle pattern.
   Reviewed by Dan Carpenter.
2. **Fixes a real bug**: Yes — resource leak on error paths.
3. **Important issue**: Moderate — resource leaks on probe failure. This
   occurs when hardware registration fails (e.g., out of memory), which
   is uncommon but real.
4. **Small and contained**: Yes — only 3 net new lines in a single file.
5. **No new features or APIs**: Correct.
6. **Applies cleanly**: The code in stable should be very close to
   mainline since this file hasn't changed much.

## Risk Assessment

**Risk: Very Low**
- The change is tiny and follows a well-understood pattern
- It only affects error paths, so success paths are unmodified
- The `device_initialize()` + `device_add()` split is idiomatic and
  widely used in the kernel
- The only way this could regress would be if `device_initialize()` is
  called at the wrong time, but it's called right after validation
  checks and before any other operations on the device

## Verification

- Read `drivers/most/core.c` lines 1279-1371 to understand the full
  function and confirm the resource leak
- Verified callers in `drivers/most/most_usb.c:1059-1061` — confirms
  caller relies on `most_register_interface` to clean up via
  `put_device()` (just returns error, no local cleanup)
- Verified callers in `drivers/staging/most/dim2/dim2.c:892` — confirms
  caller directly returns without cleanup, relying on
  `most_register_interface`
- Verified `release_mdev` (most_usb.c:928-937) frees mdev and associated
  resources — confirms memory leak if `put_device()` not called
- Verified `dim2_release` (dim2.c:722-732) frees dim2 resources —
  confirms memory leak if `put_device()` not called
- Verified the MOST driver has been in the kernel since before v5.15 via
  commit history (`b276527539188` moved it out of staging in 2020)
- Confirmed stable trees v5.15.y, v6.1.y, v6.6.y all exist and would
  contain this code
- Confirmed the diff shows only the current tree's version (without the
  fix) — the fix is a candidate, not yet applied
- Verified the fix follows standard kernel device lifecycle pattern
  (device_initialize + device_add instead of device_register)

**YES**

 drivers/most/core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/most/core.c b/drivers/most/core.c
index da319d108ea1d..6277e6702ca8c 100644
--- a/drivers/most/core.c
+++ b/drivers/most/core.c
@@ -1286,15 +1286,19 @@ int most_register_interface(struct most_interface *iface)
 	    !iface->poison_channel || (iface->num_channels > MAX_CHANNELS))
 		return -EINVAL;
 
+	device_initialize(iface->dev);
+
 	id = ida_alloc(&mdev_id, GFP_KERNEL);
 	if (id < 0) {
 		dev_err(iface->dev, "Failed to allocate device ID\n");
+		put_device(iface->dev);
 		return id;
 	}
 
 	iface->p = kzalloc(sizeof(*iface->p), GFP_KERNEL);
 	if (!iface->p) {
 		ida_free(&mdev_id, id);
+		put_device(iface->dev);
 		return -ENOMEM;
 	}
 
@@ -1304,7 +1308,7 @@ int most_register_interface(struct most_interface *iface)
 	iface->dev->bus = &mostbus;
 	iface->dev->groups = interface_attr_groups;
 	dev_set_drvdata(iface->dev, iface);
-	if (device_register(iface->dev)) {
+	if (device_add(iface->dev)) {
 		dev_err(iface->dev, "Failed to register interface device\n");
 		kfree(iface->p);
 		put_device(iface->dev);
-- 
2.51.0

