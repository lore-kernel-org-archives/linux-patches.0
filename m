Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF210315D5D;
	Mon, 17 Aug 2026 13:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974220; cv=none; b=E35Dflhms9g/kGidTN6UVmNidRTjul8lxIJUEvPil48yRanquqVhb0picEewrkgmZlAUO1EtDDHPcIgTGsWGQmgQTLC1HftvjgP+qWyIht27itCEg4K1bptoJTNzxAYPDh+UjeuW33Acf7fnLEUFNmkSxJAE5ln9YXqaB0oFvGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974220; c=relaxed/simple;
	bh=Fhhl5w8NF1NjrDQw8COdTTxWx2qn0DRnkmhbGFtnSpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kiU10N3shMJ/hiLhM/DkTg55S/XhjaohnHoaxGA1fAmCPu17gcmmw0F1V7vPGAazdMSk8JU+cMlXfzTfanNtXE4HhNRNIy8GXaNoo/C5gJ6xDb9oM88J0jRCPkTeSo8+x0qhPBKEBdIqsXlI0SnanRVaVnINP3OnlkuPAYO9Q9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=snJoL87T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="snJoL87T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 109B31F000E9;
	Mon, 17 Aug 2026 13:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974218;
	bh=ajsBKR6VON5C9Pg8hU+WtNcbCDpCsYXvTEq10Ha+z7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=snJoL87Ta9RvfsFdAAqHTazZg7SzG4JVRFzCsQyhiMu3pc5mF8eZVCw3aGIaYNnRQ
	 zakq1aWO8AC3vqC6nQk/2PVx4ljt/JTOI5nUSbClmNJRC83HxR9P+b9YZeFHz9IsOX
	 5jTNzfeqN/9sQAKVtrlUv26s5y9oy70N22YCiQsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Michal Pecio <michal.pecio@gmail.com>,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 7.1 131/271] usb: xhci: use BIT_ULL for CRCR bits to fix incorrect 64bit mask
Date: Mon, 17 Aug 2026 15:30:56 +0200
Message-ID: <20260817132542.239987573@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lachlan Hodges <lachlan.hodges@morsemicro.com>

commit 3d26cd1f3ff25cebd10d4b0e8188cf40dade28e9 upstream.

xhci is unusable on some systems after driver switched to BIT() macro.
Upper 32bits of 64bit CRCR command register are unintentionally cleared.

Seen on a raspberry pi 4B compiled for arm32.
The main symptoms were the following log message:

[    0.549897] raspberrypi-firmware soc:firmware: Attached to firmware from 2021-02-25T12:11:39
[    0.626859] xhci_hcd 0000:01:00.0: xHCI Host Controller
[    0.626889] xhci_hcd 0000:01:00.0: new USB bus registered, assigned bus number 1
[    0.812619] xhci_hcd 0000:01:00.0: hcc params 0x002841eb hci version 0x100 quirks 0x0000200000000890
[    0.813188] xhci_hcd 0000:01:00.0: xHCI Host Controller
[    0.813203] xhci_hcd 0000:01:00.0: new USB bus registered, assigned bus number 2
[    0.813219] xhci_hcd 0000:01:00.0: Host supports USB 3.0 SuperSpeed
[    0.813602] hub 1-0:1.0: USB hub found
[    0.814052] hub 2-0:1.0: USB hub found
[    0.952714] xhci_hcd 0000:01:00.0: ERROR mismatched command completion event

Additionally running lsusb just hangs. Running the same kernel compiled
for aarch64 worked fine. Bisected to the commit in the Fixes line.
Additionally a USB device plugged in to the USB3.0 (or 2.0) did not
enumerate. Once this patch is applied the USB device enumerates properly.

The CRCR register is 64 bits wide - commit abe93f27cdd7
("xhci: use BIT macro") changed the flag definitions from (1 << n),
a signed int, to BIT(n), an unsigned long. Within
xhci_set_cmd_ring_deq(), the following operation is performed on the
CRCR register:

...
	crcr &= ~CMD_RING_PTR_MASK;
	crcr |= deq_dma;
	crcr &= ~CMD_RING_CYCLE;
	crcr |= xhci->cmd_ring->cycle_state;
...

Previously, ~CMD_RING_CYCLE was ~(int)1, a negative signed value
(0xFFFFFFFE with the sign bit set). Widening a negative signed int to
u64 sign-extends it to 0xFFFFFFFFFFFFFFFE, correctly clearing only bit
0 and preserving the 64-bit pointer written two lines above.

After the change when running on 32 bit kernels, ~CMD_RING_CYCLE is
~(unsigned long)1UL. On a 32-bit host this is an unsigned 32-bit
value (0xFFFFFFFE, no sign bit). Widening an unsigned value to u64
zero-extends it instead (0x00000000FFFFFFFE), so the subsequent AND
silently clears bits 63:32 of crcr, truncating the command ring
pointer that was just written before the value reaches hardware.

To fix, similar to how CMD_RING_PTR_MASK is defined, make sure we
use the BIT_ULL variant when defining the CRCR bits.

[Mathias: use BIT_ULL() for ERST_EHB and EP_CTX_CYCLE_MASK as suggested
by Michal Pecio, also include raspberry case in commit message]

Fixes: abe93f27cdd7 ("xhci: use BIT macro")
Cc: stable <stable@kernel.org>
Assisted-by: Claude:claude-sonnet-5
cc: Michal Pecio <michal.pecio@gmail.com>
Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://patch.msgid.link/20260804083639.2148950-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -187,13 +187,13 @@ struct xhci_op_regs {
 
 /* CRCR - Command Ring Control Register - cmd_ring bitmasks */
 /* bit 0 - Cycle bit indicates the ownership of the command ring */
-#define CMD_RING_CYCLE		BIT(0)
+#define CMD_RING_CYCLE		BIT_ULL(0)
 /* stop ring operation after completion of the currently executing command */
-#define CMD_RING_PAUSE		BIT(1)
+#define CMD_RING_PAUSE		BIT_ULL(1)
 /* stop ring immediately - abort the currently executing command */
-#define CMD_RING_ABORT		BIT(2)
+#define CMD_RING_ABORT		BIT_ULL(2)
 /* true: command ring is running */
-#define CMD_RING_RUNNING	BIT(3)
+#define CMD_RING_RUNNING	BIT_ULL(3)
 /* bits 63:6 - Command Ring pointer */
 #define CMD_RING_PTR_MASK	GENMASK_ULL(63, 6)
 
@@ -268,7 +268,7 @@ struct xhci_intr_reg {
  * bit 3 - Event Handler Busy (EHB), whether the event ring is scheduled to be serviced by
  * a work queue (or delayed service routine)?
  */
-#define ERST_EHB		BIT(3)
+#define ERST_EHB		BIT_ULL(3)
 /* bits 63:4 - Event Ring Dequeue Pointer */
 #define ERST_PTR_MASK		GENMASK_ULL(63, 4)
 
@@ -499,7 +499,7 @@ struct xhci_ep_ctx {
 #define CTX_TO_MAX_ESIT_PAYLOAD(p)	(((p) >> 16) & 0xffff)
 
 /* deq bitmasks */
-#define EP_CTX_CYCLE_MASK		BIT(0)
+#define EP_CTX_CYCLE_MASK		BIT_ULL(0)
 /* bits 63:4 - TR Dequeue Pointer */
 #define TR_DEQ_PTR_MASK			GENMASK_ULL(63, 4)
 


