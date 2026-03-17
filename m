Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8940B3B3BF0;
	Tue, 17 Mar 2026 11:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773747182; cv=none; b=qWPq/7cExtnTQvzZQifcFFB7nRxtuMDUupeyuC0Kw3QoIdbM8npjcJChlvjtcn53cGVT5XYU7PT7hiBSGSK5OSx1cbo968WS3an3XC2iU4ZLcoMwT96L+qqi7GVcF+LTckZTjUS7/jZG3o0esdKRbHtjOyAErGJjldFD71ZhJcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773747182; c=relaxed/simple;
	bh=1r9IQwqFZijzWT6K13gnGBbK+Qk2kFjyObhsKxHBSx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JJlfeeo6VoQTR/DtFYBIv1cTbHOIsTj/PNFuyxUL5DxjecSP2Y1ZN0iXg5/usQG3y4Fsj4/qnzQEMpMTKmnIhiQ9Robj8ZEibwidSIvEk66Q15PQnQSX87b3qLv4rJN9CeNN2BIgTh9OHCsR2m0rb+ab6Yxju5h+HsmwtUHvzgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B/mjzzIV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B/mjzzIV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45DCDC2BC9E;
	Tue, 17 Mar 2026 11:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773747182;
	bh=1r9IQwqFZijzWT6K13gnGBbK+Qk2kFjyObhsKxHBSx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B/mjzzIVrMdbFycq9RD5F3xPxMzkMxRtKwo9DZwjFhetE8xgad2RSTbHayvzfEh/f
	 2chzNSaAIV0QRy4i4UvFGDzCzbxqBKqgI6TaYi7ZBPT2aG4FzFSO6367dHE2wx4wjV
	 IhDJ8vwB5mc6AbZ6YkrBqXbmb6PJ4Qzi32G44vnuM+D2qY8harTH6zRrrEEXXzsQfS
	 E3nuiEsFegO0ojXUb56iFV/RMn/SSnJ47Jz+dMVMlTJUET8/SUgVUgOilJraW3M77Y
	 HtmSpAmquFQaV4cEMCeB6oB9V1dZ7sefE2NmzRW+m1f9XSiMKNJfSNnpT0WqSTOyMs
	 yKNPhn891Fs2w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jie Deng <dengjie03@kylinos.cn>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	corbet@lwn.net,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.1] usb: core: new quirk to handle devices with zero configurations
Date: Tue, 17 Mar 2026 07:32:40 -0400
Message-ID: <20260317113249.117771-9-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260317113249.117771-1-sashal@kernel.org>
References: <20260317113249.117771-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.8
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jie Deng <dengjie03@kylinos.cn>

[ Upstream commit 9f6a983cfa22ac662c86e60816d3a357d4b551e9 ]

Some USB devices incorrectly report bNumConfigurations as 0 in their
device descriptor, which causes the USB core to reject them during
enumeration.
logs:
usb 1-2: device descriptor read/64, error -71
usb 1-2: no configurations
usb 1-2: can't read configurations, error -22

However, these devices actually work correctly when
treated as having a single configuration.

Add a new quirk USB_QUIRK_FORCE_ONE_CONFIG to handle such devices.
When this quirk is set, assume the device has 1 configuration instead
of failing with -EINVAL.

This quirk is applied to the device with VID:PID 5131:2007 which
exhibits this behavior.

Signed-off-by: Jie Deng <dengjie03@kylinos.cn>
Link: https://patch.msgid.link/20260227084931.1527461-1-dengjie03@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### What the commit does

This commit introduces a new USB quirk `USB_QUIRK_FORCE_ONE_CONFIG`
(BIT(18)) for devices that incorrectly report `bNumConfigurations = 0`
in their device descriptor. Without this quirk, such devices are
rejected during enumeration with `-EINVAL` ("no configurations"). The
quirk forces the configuration count to 1, allowing the device to
enumerate normally.

It's applied to the Noji-MCS SmartCard Reader (VID:PID 5131:2007).

### Changes across files:
1. **`include/linux/usb/quirks.h`**: Adds `USB_QUIRK_FORCE_ONE_CONFIG`
   as BIT(18) — the next available bit
2. **`drivers/usb/core/config.c`**: Modifies `usb_get_configuration()`
   to force `ncfg=1` when the quirk is set, instead of returning
   `-EINVAL`
3. **`drivers/usb/core/quirks.c`**: Adds the device entry and 'q' case
   in the module parameter parser
4. **`Documentation/admin-guide/kernel-parameters.txt`**: Documents the
   'q' character mapping

### Bug classification: Hardware quirk

This is a textbook USB hardware quirk — a specific device reports broken
descriptors, and a per-device quirk makes it work. The stable kernel
rules explicitly allow hardware quirks as exceptions because they:
- Fix real hardware for real users
- Are narrowly scoped to specific VID:PID
- Use established, well-tested infrastructure
- Carry near-zero risk to other devices

### Code quality concerns

**Missing `break` in case 'q'**: The new case 'q' in
`quirks_param_set()` lacks a `break` statement (every other case a-p has
one). However, since 'q' is the **last case** before the switch closing
brace `}`, this is functionally harmless — fall-through hits the end of
the switch. It's a style issue, not a functional bug.

**Operator precedence in config.c**: The condition `ncfg < 1 &&
dev->quirks & USB_QUIRK_FORCE_ONE_CONFIG` is correct due to C
precedence: `<` (6) > `&` (8) > `&&` (11), so it evaluates as `(ncfg <
1) && (dev->quirks & USB_QUIRK_FORCE_ONE_CONFIG)`.

### Risk assessment

- **Scope**: Only affects VID:PID 5131:2007 — zero risk to other devices
- **Mechanism**: The quirk check in `usb_get_configuration()` is gated
  by the device-specific quirk flag
- **Timing**: `usb_detect_quirks()` is called in `hub_port_init()`
  before `usb_get_configuration()` is called in
  `usb_enumerate_device()`, so the quirk is available when needed
- **Size**: Small (~16 insertions), well-contained
- **Maintainer**: Signed off by Greg KH (USB subsystem maintainer)
- **Review**: Went through 3 versions (v1, v2, v3), with review from
  Alan Stern and Greg KH

### Considerations for stable

This is slightly more than a typical "add device ID to existing quirk"
because it introduces a new quirk type with new logic in
`usb_get_configuration()`. However:
- The new logic is 4 lines, guarded by the quirk flag
- It follows established patterns exactly
- Without it, the specific SmartCard reader is completely non-functional
- The USB quirk infrastructure is identical across stable trees

### Verification

- **Verified current code**: Read `drivers/usb/core/config.c:925-944`
  confirming the existing `ncfg < 1` check at line 930 that returns
  `-EINVAL`
- **Verified quirk bit allocation**: Read `include/linux/usb/quirks.h` —
  BIT(17) is `USB_QUIRK_NO_BOS`, BIT(18) is the next available
- **Verified missing break**: Read `drivers/usb/core/quirks.c:130-149` —
  confirmed all other cases (a-p) have `break` statements; the `}` at
  line 145 closes the switch, making the missing break harmless
- **Verified operator precedence**: C precedence rules make `ncfg < 1 &&
  dev->quirks & USB_QUIRK_FORCE_ONE_CONFIG` evaluate correctly
- **Verified timing**: Agent traced the call chain `hub_port_connect()`
  → `hub_port_init()` (calls `usb_detect_quirks()`) → `usb_new_device()`
  → `usb_enumerate_device()` → `usb_get_configuration()` — quirks are
  set before config reading
- **Verified mailing list**: lore.kernel.org shows 3 patch versions with
  review from Alan Stern and Greg KH; could not access full discussion
  content to determine specific reviewer concerns (unverified whether
  break issue was discussed)
- **Verified recent history**: `git log` shows `usb_quirk_list` and
  `quirks.h` are regularly updated with new quirks (e.g.,
  `USB_QUIRK_NO_BOS` was recently added following the same pattern)

### Conclusion

This is a hardware quirk that makes a completely broken USB SmartCard
reader functional. It follows the established USB quirk pattern, is
narrowly scoped to one device, carries near-zero risk, and was reviewed
and accepted by the USB subsystem maintainer. Hardware quirks are
explicitly listed as stable-worthy exceptions. The minor style issue
(missing `break`) does not affect functionality.

**YES**

 Documentation/admin-guide/kernel-parameters.txt | 3 +++
 drivers/usb/core/config.c                       | 6 +++++-
 drivers/usb/core/quirks.c                       | 5 +++++
 include/linux/usb/quirks.h                      | 3 +++
 4 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index aa0031108bc1d..f31e9e4c598fc 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -8090,6 +8090,9 @@ Kernel parameters
 				p = USB_QUIRK_SHORT_SET_ADDRESS_REQ_TIMEOUT
 					(Reduce timeout of the SET_ADDRESS
 					request from 5000 ms to 500 ms);
+				q = USB_QUIRK_FORCE_ONE_CONFIG (Device
+					claims zero configurations,
+					forcing to 1);
 			Example: quirks=0781:5580:bk,0a5c:5834:gij
 
 	usbhid.mousepoll=
diff --git a/drivers/usb/core/config.c b/drivers/usb/core/config.c
index 2bb1ceb9d621a..3067e18ec4d8a 100644
--- a/drivers/usb/core/config.c
+++ b/drivers/usb/core/config.c
@@ -927,7 +927,11 @@ int usb_get_configuration(struct usb_device *dev)
 		dev->descriptor.bNumConfigurations = ncfg = USB_MAXCONFIG;
 	}
 
-	if (ncfg < 1) {
+	if (ncfg < 1 && dev->quirks & USB_QUIRK_FORCE_ONE_CONFIG) {
+		dev_info(ddev, "Device claims zero configurations, forcing to 1\n");
+		dev->descriptor.bNumConfigurations = 1;
+		ncfg = 1;
+	} else if (ncfg < 1) {
 		dev_err(ddev, "no configurations\n");
 		return -EINVAL;
 	}
diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index c4d85089d19b1..53380296c94c6 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -141,6 +141,8 @@ static int quirks_param_set(const char *value, const struct kernel_param *kp)
 			case 'p':
 				flags |= USB_QUIRK_SHORT_SET_ADDRESS_REQ_TIMEOUT;
 				break;
+			case 'q':
+				flags |= USB_QUIRK_FORCE_ONE_CONFIG;
 			/* Ignore unrecognized flag characters */
 			}
 		}
@@ -581,6 +583,9 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* VCOM device */
 	{ USB_DEVICE(0x4296, 0x7570), .driver_info = USB_QUIRK_CONFIG_INTF_STRINGS },
 
+	/* Noji-MCS SmartCard Reader */
+	{ USB_DEVICE(0x5131, 0x2007), .driver_info = USB_QUIRK_FORCE_ONE_CONFIG },
+
 	/* INTEL VALUE SSD */
 	{ USB_DEVICE(0x8086, 0xf1a5), .driver_info = USB_QUIRK_RESET_RESUME },
 
diff --git a/include/linux/usb/quirks.h b/include/linux/usb/quirks.h
index 2f7bd2fdc6164..b3cc7beab4a3c 100644
--- a/include/linux/usb/quirks.h
+++ b/include/linux/usb/quirks.h
@@ -78,4 +78,7 @@
 /* skip BOS descriptor request */
 #define USB_QUIRK_NO_BOS			BIT(17)
 
+/* Device claims zero configurations, forcing to 1 */
+#define USB_QUIRK_FORCE_ONE_CONFIG		BIT(18)
+
 #endif /* __LINUX_USB_QUIRKS_H */
-- 
2.51.0

