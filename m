Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40FA32765ED;
	Wed, 10 Dec 2025 06:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765348502; cv=none; b=PXlKeItwSWoXMzCTN4DnvCZlvyPmRBK7l4cfpN+SOTl9ywMMlS7v+O8VGi/os9xCmh8Qjiv8wqZ3osQllVbUNQMdHQaFLL5cvIAu9Ws9+TnfaJ9tB/nHlUunrV/H529z3xcVlizsThVkvrit3qhjZSVx1x0MpH/0k9yQg7Pk3M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765348502; c=relaxed/simple;
	bh=q3MraarYR5fzjH9a8NaRW0+Um6sF9oejd2RwlWgRH3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=um3qIiazEvJtthJqTU9HeoTD64/hwINNKIXPr4RRIcG8pRGULWhSspSWwbu6Kvx59W3d/cyy4cIOeJ83pAeYoAu4LMwhPuF4/zuOxx5OsQ4zsY92azfg++eIEtVk7cXJq/i44Im2c1yJzgKkPCFsQPs4s+UjBzVfi0dEIAM0oX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jVjhOZ6n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jVjhOZ6n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17555C116B1;
	Wed, 10 Dec 2025 06:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765348501;
	bh=q3MraarYR5fzjH9a8NaRW0+Um6sF9oejd2RwlWgRH3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jVjhOZ6noBRlLPzxfJl+o3XJKaNr3gJY5zHcD6wzpoI4rDhyEs723ZfaHlXo310nh
	 C8ckheohVRR64EXCLoMQKLGSl9mHaQp2OrUQGQPD2iyznWwk7SyTI3Oah6ZjZctQ/2
	 UArJSEMWsP3tniVv9zjEtAUx77VzzTYk3ZEACOy8tXYQbp4V6AQy5ylV+zhuBmxGfW
	 Tts9Ezaj5zyZ4gGu/+8KlgLmo0LFijAGUL6WSc5JWiMxPUTE2wCxdZoLGJ3cdcieFI
	 dL4r29GwcB1hlrc1Z8H0+E8ainvIYUPO7NcALC/sHWsC9fT0y+XmwUsskG29XmGASG
	 /gD92BrMQM1Sw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mark Pearson <mpearson-lenovo@squebb.ca>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	dmitry.baryshkov@oss.qualcomm.com,
	boddah8794@gmail.com,
	venkat.jayaraman@intel.com,
	akuchynski@chromium.org,
	pooja.katiyar@intel.com,
	jthies@google.com,
	abel.vesa@linaro.org,
	lk@c--e.de
Subject: [PATCH AUTOSEL 6.18-5.10] usb: typec: ucsi: Handle incorrect num_connectors capability
Date: Wed, 10 Dec 2025 01:34:32 -0500
Message-ID: <20251210063446.2513466-3-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251210063446.2513466-1-sashal@kernel.org>
References: <20251210063446.2513466-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mark Pearson <mpearson-lenovo@squebb.ca>

[ Upstream commit 30cd2cb1abf4c4acdb1ddb468c946f68939819fb ]

The UCSI spec states that the num_connectors field is 7 bits, and the
8th bit is reserved and should be set to zero.
Some buggy FW has been known to set this bit, and it can lead to a
system not booting.
Flag that the FW is not behaving correctly, and auto-fix the value
so that the system boots correctly.

Found on Lenovo P1 G8 during Linux enablement program. The FW will
be fixed, but seemed worth addressing in case it hit platforms that
aren't officially Linux supported.

Signed-off-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20250821185319.2585023-1-mpearson-lenovo@squebb.ca
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Commit Analysis: usb: typec: ucsi: Handle incorrect num_connectors
capability

### 1. COMMIT MESSAGE ANALYSIS

**Subject:** Indicates this handles incorrect/buggy firmware behavior
for UCSI (USB Type-C Connector System Software Interface).

**Key points:**
- UCSI spec defines `num_connectors` as 7 bits with reserved 8th bit
  (should be zero)
- Buggy firmware sets the reserved bit, leading to **system not
  booting**
- Found on real hardware: Lenovo P1 G8 during Linux enablement
- Maintainer expects this may hit other platforms not officially Linux-
  supported

**Tags present:**
- `Reviewed-by: Heikki Krogerus` (Intel UCSI maintainer)
- `Signed-off-by: Greg Kroah-Hartman` (USB maintainer)
- Link to LKML discussion

**Tags missing:**
- No `Cc: stable@vger.kernel.org`
- No `Fixes:` tag (this is a workaround for firmware, not fixing a
  kernel bug)

### 2. CODE CHANGE ANALYSIS

The fix adds 6 lines:
```c
/* Check if reserved bit set. This is out of spec but happens in buggy
FW */
if (ucsi->cap.num_connectors & 0x80) {
    dev_warn(ucsi->dev, "UCSI: Invalid num_connectors %d. Likely buggy
FW\n",
             ucsi->cap.num_connectors);
    ucsi->cap.num_connectors &= 0x7f; // clear bit and carry on
}
```

**Technical mechanism of the bug:**
- `num_connectors` is returned from firmware via `UCSI_GET_CAPABILITY`
  command
- With bit 7 set, the value becomes >= 128 instead of the real value
  (likely 1-2)
- This corrupted value is used for:
  - Memory allocation: `kcalloc(ucsi->cap.num_connectors + 1,
    sizeof(*connector), GFP_KERNEL)`
  - Loop iteration: `for (i = 0; i < ucsi->cap.num_connectors; i++)`
- Result: trying to allocate/register 128+ connectors, causing boot
  failure

**The fix:**
- Detects if reserved bit 7 is set
- Logs a warning about buggy firmware
- Clears the bit to get the correct connector count
- System can then boot normally

### 3. CLASSIFICATION

This is a **hardware/firmware quirk workaround** - one of the explicit
exceptions allowed in stable kernels:
- Not a new feature or API
- Not code cleanup or refactoring
- Handles non-compliant firmware (similar to USB quirks, PCI quirks)
- Enables hardware to work correctly with the existing driver

### 4. SCOPE AND RISK ASSESSMENT

| Metric | Assessment |
|--------|------------|
| Lines changed | 6 lines added |
| Files touched | 1 file |
| Complexity | Very low - simple bit check and mask |
| Risk | **Very low** |

**Risk reasoning:**
- If firmware is compliant (bit not set): no change in behavior
- If firmware is buggy (bit set): corrects the value to what it should
  be
- Cannot break working systems
- No side effects possible

### 5. USER IMPACT

**Severity:** **HIGH** - prevents system from booting

**Who is affected:**
- Confirmed: Lenovo P1 G8 users
- Potential: Other systems with buggy UCSI firmware
- Type-C/UCSI is common on modern laptops

**Real-world validation:**
- Found during actual hardware testing/enablement
- Not a theoretical bug - causes real boot failures

### 6. STABILITY INDICATORS

- Reviewed by Heikki Krogerus (Intel, UCSI domain expert)
- Signed off by Greg Kroah-Hartman (USB maintainer)
- Small, obvious fix with clear rationale
- The fix is self-contained and well-understood

### 7. DEPENDENCY CHECK

- Standalone fix with no dependencies on other commits
- UCSI driver exists in all relevant stable trees
- Should apply cleanly to stable kernels

---

## Summary

**What this fixes:** Boot failure on systems with buggy UCSI firmware
that incorrectly sets a reserved bit in the connector count capability
field.

**Why it meets stable criteria:**
1. ✅ **Fixes a real bug affecting users** - confirmed boot failure on
   Lenovo P1 G8
2. ✅ **Obviously correct** - simple bit mask operation, spec-compliant
   behavior
3. ✅ **Small and contained** - 6 lines in one file, no side effects
4. ✅ **Falls under "hardware quirk" exception** - workaround for non-
   compliant firmware
5. ✅ **High impact** - system won't boot without this fix
6. ✅ **Low risk** - cannot break working systems
7. ✅ **Well-reviewed** - by domain experts including USB maintainer

**Why missing stable tags isn't disqualifying:**
- Hardware quirks often lack explicit stable tags
- The nature of the fix (workaround for boot failure) clearly warrants
  backporting
- Greg Kroah-Hartman signed off, who is also a stable tree maintainer

**Risk vs Benefit:**
- Risk: Essentially zero - the code path is only taken for buggy
  firmware
- Benefit: Systems with buggy firmware can boot

This is a textbook example of a hardware quirk/workaround that belongs
in stable trees. It's a small, safe, well-reviewed fix that prevents
boot failures on real hardware.

**YES**

 drivers/usb/typec/ucsi/ucsi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index 3f568f790f39b..3995483a0aa09 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -1807,6 +1807,12 @@ static int ucsi_init(struct ucsi *ucsi)
 		ret = -ENODEV;
 		goto err_reset;
 	}
+	/* Check if reserved bit set. This is out of spec but happens in buggy FW */
+	if (ucsi->cap.num_connectors & 0x80) {
+		dev_warn(ucsi->dev, "UCSI: Invalid num_connectors %d. Likely buggy FW\n",
+			 ucsi->cap.num_connectors);
+		ucsi->cap.num_connectors &= 0x7f; // clear bit and carry on
+	}
 
 	/* Allocate the connectors. Released in ucsi_unregister() */
 	connector = kcalloc(ucsi->cap.num_connectors + 1, sizeof(*connector), GFP_KERNEL);
-- 
2.51.0

