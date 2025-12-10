Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F414C2459FD;
	Wed, 10 Dec 2025 06:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765348497; cv=none; b=SLWw4AD2BDcGCVsGGDl5axiIqdStAEDmXESaeWrEb28KRE5+jio4S5RTr2R/Ze4+8RWVh6g3CDXj6B6ua/qGcGxUlOodCa9EwYAX8b6c/2QkTeGrQfC2gDIqUPg79ABXbYdAenXauibC/NiE2wEdddQkED/c/HQp1u+L88n93Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765348497; c=relaxed/simple;
	bh=TZPfipY2YRgInQIq7dJfTqGYciLPLHLpk+aHQkkH5ks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F80wv70l5mHzpHzn0nedOhsi9BiIkdjDSGnC9RVSc25sjCGog4QZGnQ2T+pVju3D0TUs6U0w4A6v/xlYTInUM+dEQ74ENqBwHQfP64JwAb3Hz1RWLkOYLVTchqwE4hRrQRPsWD9qU+b5MYN+TwdyuKPtLvOhw+nRr9f+ev7nJdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q47fh9t1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q47fh9t1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 732BAC16AAE;
	Wed, 10 Dec 2025 06:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765348496;
	bh=TZPfipY2YRgInQIq7dJfTqGYciLPLHLpk+aHQkkH5ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q47fh9t1eiIk0sebWNBEE/+AnNP9fBMEqA2i84ci5jlPOwo9qp3dN2txf8ZWCXVf4
	 sl/smh6aDm+8NxPp9gCuNvJW4xA903M2FEVUArKkaB+2ACJ3KAX2HQgPQ0YM4DW/pV
	 PcodReRYipScfJAA4uQR5uWK+9INRPlPtvPtZemRPheagjlITcw/daDItLLY2vlku3
	 AeAiHvS2jvNUpc/kIiHLF928fa3BPCd0v8n5KtAXA/YPB2VlzWkPYc67NQwJVVvmii
	 KwM+RVa2L0eOwxqLJMa9SGgKcndg9UwHIl52Fes+e6k96jD6XLH9vm2WJ14/jhCFJD
	 p94TbPWrdzDZw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Hongyu Xie <xiehongyu1@kylinos.cn>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	mathias.nyman@intel.com,
	linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] usb: xhci: limit run_graceperiod for only usb 3.0 devices
Date: Wed, 10 Dec 2025 01:34:31 -0500
Message-ID: <20251210063446.2513466-2-sashal@kernel.org>
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
Content-Transfer-Encoding: 8bit

From: Hongyu Xie <xiehongyu1@kylinos.cn>

[ Upstream commit 8d34983720155b8f05de765f0183d9b0e1345cc0 ]

run_graceperiod blocks usb 2.0 devices from auto suspending after
xhci_start for 500ms.

Log shows:
[   13.387170] xhci_hub_control:1271: xhci-hcd PNP0D10:03: Get port status 7-1 read: 0x2a0, return 0x100
[   13.387177] hub_event:5779: hub 7-0:1.0: state 7 ports 1 chg 0000 evt 0000
[   13.387182] hub_suspend:3903: hub 7-0:1.0: hub_suspend
[   13.387188] hcd_bus_suspend:2250: usb usb7: bus auto-suspend, wakeup 1
[   13.387191] hcd_bus_suspend:2279: usb usb7: suspend raced with wakeup event
[   13.387193] hcd_bus_resume:2303: usb usb7: usb auto-resume
[   13.387296] hub_event:5779: hub 3-0:1.0: state 7 ports 1 chg 0000 evt 0000
[   13.393343] handle_port_status:2034: xhci-hcd PNP0D10:02: handle_port_status: starting usb5 port polling.
[   13.393353] xhci_hub_control:1271: xhci-hcd PNP0D10:02: Get port status 5-1 read: 0x206e1, return 0x10101
[   13.400047] hub_suspend:3903: hub 3-0:1.0: hub_suspend
[   13.403077] hub_resume:3948: hub 7-0:1.0: hub_resume
[   13.403080] xhci_hub_control:1271: xhci-hcd PNP0D10:03: Get port status 7-1 read: 0x2a0, return 0x100
[   13.403085] hub_event:5779: hub 7-0:1.0: state 7 ports 1 chg 0000 evt 0000
[   13.403087] hub_suspend:3903: hub 7-0:1.0: hub_suspend
[   13.403090] hcd_bus_suspend:2250: usb usb7: bus auto-suspend, wakeup 1
[   13.403093] hcd_bus_suspend:2279: usb usb7: suspend raced with wakeup event
[   13.403095] hcd_bus_resume:2303: usb usb7: usb auto-resume
[   13.405002] handle_port_status:1913: xhci-hcd PNP0D10:04: Port change event, 9-1, id 1, portsc: 0x6e1
[   13.405016] hub_activate:1169: usb usb5-port1: status 0101 change 0001
[   13.405026] xhci_clear_port_change_bit:658: xhci-hcd PNP0D10:02: clear port1 connect change, portsc: 0x6e1
[   13.413275] hcd_bus_suspend:2250: usb usb3: bus auto-suspend, wakeup 1
[   13.419081] hub_resume:3948: hub 7-0:1.0: hub_resume
[   13.419086] xhci_hub_control:1271: xhci-hcd PNP0D10:03: Get port status 7-1 read: 0x2a0, return 0x100
[   13.419095] hub_event:5779: hub 7-0:1.0: state 7 ports 1 chg 0000 evt 0000
[   13.419100] hub_suspend:3903: hub 7-0:1.0: hub_suspend
[   13.419106] hcd_bus_suspend:2250: usb usb7: bus auto-suspend, wakeup 1
[   13.419110] hcd_bus_suspend:2279: usb usb7: suspend raced with wakeup event
[   13.419112] hcd_bus_resume:2303: usb usb7: usb auto-resume
[   13.420455] handle_port_status:2034: xhci-hcd PNP0D10:04: handle_port_status: starting usb9 port polling.
[   13.420493] handle_port_status:1913: xhci-hcd PNP0D10:05: Port change event, 10-1, id 1, portsc: 0x6e1
[   13.425332] hcd_bus_suspend:2279: usb usb3: suspend raced with wakeup event
[   13.431931] handle_port_status:2034: xhci-hcd PNP0D10:05: handle_port_status: starting usb10 port polling.
[   13.435080] hub_resume:3948: hub 7-0:1.0: hub_resume
[   13.435084] xhci_hub_control:1271: xhci-hcd PNP0D10:03: Get port status 7-1 read: 0x2a0, return 0x100
[   13.435092] hub_event:5779: hub 7-0:1.0: state 7 ports 1 chg 0000 evt 0000
[   13.435096] hub_suspend:3903: hub 7-0:1.0: hub_suspend
[   13.435102] hcd_bus_suspend:2250: usb usb7: bus auto-suspend, wakeup 1
[   13.435106] hcd_bus_suspend:2279: usb usb7: suspend raced with wakeup event

usb7 and other usb 2.0 root hub were rapidly toggling between suspend
and resume states. More, "suspend raced with wakeup event" confuses people.

So, limit run_graceperiod for only usb 3.0 devices

Signed-off-by: Hongyu Xie <xiehongyu1@kylinos.cn>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://patch.msgid.link/20251119142417.2820519-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis Summary

### 1. COMMIT MESSAGE ANALYSIS
- **Problem**: The `run_graceperiod` mechanism (500ms delay after xHC
  start) was incorrectly blocking USB 2.0 devices from auto-suspending
- **Symptom**: USB 2.0 root hubs rapidly toggling between suspend and
  resume, causing "suspend raced with wakeup event" log spam
- **No Cc: stable tag** or **Fixes: tag** present, but this is fixing a
  bug in code that WAS marked for stable

### 2. CODE CHANGE ANALYSIS
The change is a minimal one-line addition:
```c
- if (xhci->run_graceperiod) {
+ if (hcd->speed >= HCD_USB3 && xhci->run_graceperiod) {
```

**Root cause**: The original commit 33e321586e37b ("xhci: Add grace
period after xHC start to prevent premature runtime suspend") introduced
`run_graceperiod` in August 2022 (v6.0-rc4). The code comment explicitly
states: "SS devices are only visible to roothub after link training
completes" - SS means SuperSpeed (USB 3.0). However, the implementation
didn't actually check for USB 3.0, applying the grace period to ALL
devices incorrectly.

**Why it matters**: USB 2.0 devices don't require link training delays.
The 500ms grace period prevents them from suspending when they should be
able to, causing the rapid suspend/resume cycling shown in the logs.

### 3. CLASSIFICATION
- **Bug fix**: YES - corrects behavior to match documented intent
- **Feature addition**: NO
- **Security**: NO

### 4. SCOPE AND RISK ASSESSMENT
- **Lines changed**: 1
- **Files touched**: 1 (drivers/usb/host/xhci-hub.c)
- **Pattern used**: `hcd->speed >= HCD_USB3` is used 20+ times in xhci-
  hub.c and xhci.c - this is a well-established pattern
- **Risk**: VERY LOW - trivial change using existing idiom

### 5. USER IMPACT
- **Affected users**: All systems with xHCI USB controllers (most modern
  systems)
- **Severity**: Medium - not a crash, but affects power management and
  creates confusing log messages
- **Visibility**: Users see rapid suspend/resume cycles and log spam

### 6. STABILITY INDICATORS
- Signed-off-by Mathias Nyman (Intel xHCI maintainer)
- Signed-off-by Greg Kroah-Hartman (Linux USB/stable maintainer)
- Follows existing code patterns extensively used in the same file

### 7. DEPENDENCY CHECK
- **Dependencies**: None - the fix uses existing variables and macros
- **Original commit**: 33e321586e37b was marked `Cc:
  stable@vger.kernel.org`, so stable kernels v6.0+ have the buggy code
- The fix should be backported to all stable branches that have the
  original commit

### Key Points

**Why this should be backported:**
1. Fixes a bug in code that was explicitly backported to stable
   (33e321586e37b had Cc: stable)
2. The fix aligns implementation with documented intent (comment says
   "SS devices")
3. Minimal, surgical change with near-zero regression risk
4. Uses well-established pattern (`hcd->speed >= HCD_USB3`) used
   throughout the driver
5. Fixes real user-visible issue: power consumption and log spam
6. Maintained by the same author (Mathias Nyman) who wrote the original

**Risk vs Benefit**:
- **Benefit**: Fixes USB 2.0 power management regression, eliminates
  confusing logs
- **Risk**: Extremely low - single conditional check using existing
  infrastructure

The absence of explicit `Cc: stable` and `Fixes:` tags is likely an
oversight since this clearly fixes a bug in stable-destined code.

**YES**

 drivers/usb/host/xhci-hub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index b3a59ce1b3f41..5e1442e91743d 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -1671,7 +1671,7 @@ int xhci_hub_status_data(struct usb_hcd *hcd, char *buf)
 	 * SS devices are only visible to roothub after link training completes.
 	 * Keep polling roothubs for a grace period after xHC start
 	 */
-	if (xhci->run_graceperiod) {
+	if (hcd->speed >= HCD_USB3 && xhci->run_graceperiod) {
 		if (time_before(jiffies, xhci->run_graceperiod))
 			status = 1;
 		else
-- 
2.51.0

