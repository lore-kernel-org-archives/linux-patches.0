Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA442550C2;
	Mon,  9 Jun 2025 13:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749476738; cv=none; b=mWYAtWWa9gfWP5nQLaGXB//BWBXe3UHZXmHLEG2DMGrOE4JKXqPp+a2D1+FgFLkZlrTXpa6EaOdQCJ/KlZ5SBwHdNEv+TN0u/lShydX8Sxxpuxtf5KNL4nk97kIIdhG5W/SCbhqMeHKH6UGg7jBehbZJ59diD2ANrOmTqEV6gUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749476738; c=relaxed/simple;
	bh=NOlAPlc7wj5iRuJBEpnv7Oj6ElGTUNSRJc9G++43nH4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tId4V1pot03U51Uph4Czbg3OwhnkN75ZIsZGd1s0JQhLjGnRKW3k//4xWke0hg0DnandV8XvDthzc0gby/pO5c0HAKaLnFCfPkjZpdB73F/S3n3rddy0nyz16EG2adw1HMX6RHrI4GdLwlOhVexLlK1h2MSvdhqsRqhO0Yi/t18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d4vIMllv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d4vIMllv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF1BC4CEED;
	Mon,  9 Jun 2025 13:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749476738;
	bh=NOlAPlc7wj5iRuJBEpnv7Oj6ElGTUNSRJc9G++43nH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d4vIMllvZbEIrvnnPZ6l2ZmgwmbyNPHEa0+Hh4Uhe5bwlZCVCIzHF8x69eChC3H8k
	 2duwBPsUeWgz3MQ3kH+t+2WrYu0TfDM5PnrgejcFdYOLUnc6QwETkXPVU0BlMXYPs0
	 M/j9OkYWUfOVkaRXOkoefQG8TV/I+bRXxXq61MkDu7gbieQQfoufJ/uckFlq95c3hw
	 0KuelDl/Y9mFATKOXP9qm/igKG3HbGC4zqnbRNtVpNbk0wweIjj6h3YSi9sb76g6Ae
	 6ZkqGC5Z2fCvV7n5jU4tRQU7IJJ2A+DmtVuMIabqP8XMBHur6+oXWAClq12ZRu5T1v
	 C5R+qlvyDLROw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Rengarajan S <rengarajan.s@microchip.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	kumaravel.thiagarajan@microchip.com,
	tharunkumar.pasumarthi@microchip.com,
	linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 12/29] 8250: microchip: pci1xxxx: Add PCIe Hot reset disable support for Rev C0 and later devices
Date: Mon,  9 Jun 2025 09:44:53 -0400
Message-Id: <20250609134511.1342999-12-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250609134511.1342999-1-sashal@kernel.org>
References: <20250609134511.1342999-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.10
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rengarajan S <rengarajan.s@microchip.com>

[ Upstream commit c40b91e38eb8d4489def095d62ab476d45871323 ]

Systems that issue PCIe hot reset requests during a suspend/resume
cycle cause PCI1XXXX device revisions prior to C0 to get its UART
configuration registers reset to hardware default values. This results
in device inaccessibility and data transfer failures. Starting with
Revision C0, support was added in the device hardware (via the Hot
Reset Disable Bit) to allow resetting only the PCIe interface and its
associated logic, but preserving the UART configuration during a hot
reset. This patch enables the hot reset disable feature during suspend/
resume for C0 and later revisions of the device.

Signed-off-by: Rengarajan S <rengarajan.s@microchip.com>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/20250425145500.29036-1-rengarajan.s@microchip.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES**

This commit should be backported to stable kernel trees based on the
following analysis:

## Bug Fix Analysis

**This commit fixes a significant user-facing bug**: Systems that issue
PCIe hot reset requests during suspend/resume cycles cause PCI1XXXX
device revisions prior to C0 to lose their UART configuration registers,
resulting in:
- Device inaccessibility
- Data transfer failures
- Complete loss of UART functionality after suspend/resume

This is exactly the type of critical hardware functionality bug that
stable backports are designed to address.

## Code Changes Assessment

**The changes are minimal and well-contained**:

1. **Single bit definition added** (line 118):
  ```c
  #define UART_RESET_HOT_RESET_DISABLE    BIT(17)
  ```

2. **Revision-gated logic in suspend** (lines 625-626):
  ```c
  if (priv->dev_rev >= 0xC0)
  data |= UART_RESET_HOT_RESET_DISABLE;
  ```

3. **Corresponding logic in resume** (lines 656-657):
  ```c
  if (priv->dev_rev >= 0xC0)
  data &= ~UART_RESET_HOT_RESET_DISABLE;
  ```

**Risk Assessment**:
- **Very low risk** - Only affects C0 and later hardware revisions (>=
  0xC0)
- **Hardware-specific** - Only impacts Microchip PCI1XXXX UART devices
- **Well-tested functionality** - Uses existing hardware feature
  designed for this purpose
- **No architectural changes** - Simple register bit manipulation in
  existing suspend/resume paths

## Comparison with Similar Commits

Looking at the reference examples, this commit aligns with **Similar
Commit #3** which was marked for backporting ("Backport Status: YES").
That commit also:
- Fixed a hardware-specific bug (RTS pin toggle issue)
- Made minimal, contained changes
- Addressed device functionality problems
- Was revision-specific (B0 hardware only)

Unlike the "NO" examples which added new features (suspend/resume
support, RS485 support, burst mode), this commit purely fixes existing
broken functionality.

## Stable Tree Criteria Met

✅ **Fixes important bug** - Complete UART failure after suspend/resume
✅ **Minimal risk** - Small, contained changes to single driver
✅ **No new features** - Just enables existing hardware capability
✅ **No architectural changes** - Uses existing suspend/resume framework
✅ **Critical subsystem impact** - Serial communication is essential
functionality

The commit message explicitly states this addresses "device
inaccessibility and data transfer failures" which are exactly the types
of regressions stable trees exist to prevent.

 drivers/tty/serial/8250/8250_pci1xxxx.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_pci1xxxx.c b/drivers/tty/serial/8250/8250_pci1xxxx.c
index e9c51d4e447dd..4c149db846925 100644
--- a/drivers/tty/serial/8250/8250_pci1xxxx.c
+++ b/drivers/tty/serial/8250/8250_pci1xxxx.c
@@ -115,6 +115,7 @@
 
 #define UART_RESET_REG				0x94
 #define UART_RESET_D3_RESET_DISABLE		BIT(16)
+#define UART_RESET_HOT_RESET_DISABLE		BIT(17)
 
 #define UART_BURST_STATUS_REG			0x9C
 #define UART_TX_BURST_FIFO			0xA0
@@ -620,6 +621,10 @@ static int pci1xxxx_suspend(struct device *dev)
 	}
 
 	data = readl(p + UART_RESET_REG);
+
+	if (priv->dev_rev >= 0xC0)
+		data |= UART_RESET_HOT_RESET_DISABLE;
+
 	writel(data | UART_RESET_D3_RESET_DISABLE, p + UART_RESET_REG);
 
 	if (wakeup)
@@ -647,7 +652,12 @@ static int pci1xxxx_resume(struct device *dev)
 	}
 
 	data = readl(p + UART_RESET_REG);
+
+	if (priv->dev_rev >= 0xC0)
+		data &= ~UART_RESET_HOT_RESET_DISABLE;
+
 	writel(data & ~UART_RESET_D3_RESET_DISABLE, p + UART_RESET_REG);
+
 	iounmap(p);
 
 	for (i = 0; i < priv->nr; i++) {
-- 
2.39.5

