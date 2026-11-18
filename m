Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055299;
	b=jvieip6IXEqhZltyQJfi3GGrGRqC2+uerUyaeVqGStqPi9A6a5nv3nNOdLz+0fseRbd1
	 DC7vetIe31keRom87GwVvZG/K007CMwN3GDIuIHsSXh4+FjgnBElKSvyMOUlsi1I/PN7f
	 6i52oBToGSENZIlIyEla6cI6wS8CaBUiRjzk5ZxgUyyhqW12FcXhuqrGapG0Tf5Wub90x
	 Uh8B3aRWNVVdHEXjY1fD8Vc0MwQyQWNcAe/IEJUI0zrLIAuh1h+rNnLq2WQRRplLAh0t7
	 WLrVgstALsFloJtVMzeo1X7pdYQdhtijObhlAABVyxETpqlGOu8KZPm+6pUwnT0UPPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055299;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WqN1H/wHdVfpA+vdMTkhNfgBmxtJ6mF4f1s1aossiy4=;
	b=SxXq0HB6+DVA42Vl0aSIObFIHHks9kPeUxsLZiUcrQvOXUVEOCqrOJxXzqE51Xmilq2g
	 JX/ySffyN1aw7dfcY5sUOhruAid2lIgtyuF+UDSN+T+b3DkPCWCK9dirxijv7F0JLRZCX
	 TPHJ3+Lf++20GKj9nnNSE6tkl22v0Hd4TuAgMwnZ/QwG8unWv3MEhaTGHxAPL4dOfxkax
	 h6BaXNSvkIZVmOHyFNXHSB4KToTilwLv4Jun97aesrJ0zzyCZx8r0dDRgmcH8CQXUkcCS
	 WOlEF259TOK3AcJaMt2jpKGuEiHjwS6CWqZBnhWMcKDFirFLFO4MKaxjg0NiiGECpdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QI1TpRw0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1924606A330;
	Thu, 19 Nov 2026 02:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QI1TpRw0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D371F000C4;
	Thu, 19 Nov 2026 02:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055298;
	bh=WqN1H/wHdVfpA+vdMTkhNfgBmxtJ6mF4f1s1aossiy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QI1TpRw0JiNCeyl5rCxus7lD/oBGfhVU6schVyENV2oUNJ4WamxJgeiGZW0XYOw3j
	 SXIz96EJWZKn2tM+Z/w4G9Y+kefxCSVw2Sibx7s2D+whcUjzTx8EQyovsUiI5CiMef
	 x+i13UBEw9qjlF/hscd10HDTaMyVNmxFfCQwmFQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1580/2214] swim: Deduplicate polling loops
Date: Wed, 18 Nov 2026 15:54:16 +0100
Message-ID: <20261118150115.225847314@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit b736189c93c9ad1056521a4229ec2f252b714b5a ]

Replace duplicated polling loops with poll_timeout_us(). Change the
interruptible sleep to uninterruptible because signal delivery shouldn't
be allowed to shorten delays required by the drive hardware.

Change the timeout for the !STEP transition to 20 ms in accordance with
the maximum interval required by the UPD72070 spec. The existing 1 second
timeout is impractical considering the number of steps in a typical seek.

Change the return type of swim_readbit() to bool because that way the
bit names make sense i.e. the reader doesn't have to remember to invert
the active-low logic used for drive signals.

Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Reviewed-by: Laurent Vivier <laurent@vivier.eu>
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/0ea2d3313dea26f8b4c2abc4d29055ac95aeb74b.1788513997.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c | 39 ++++++++-------------------------------
 1 file changed, 8 insertions(+), 31 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index adde8dc537259..795058cdf4343 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -19,6 +19,7 @@
 #include <linux/major.h>
 #include <linux/mutex.h>
 #include <linux/hdreg.h>
+#include <linux/iopoll.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>
 #include <linux/platform_device.h>
@@ -296,7 +297,7 @@ static inline void swim_action(struct swim __iomem *base, int action)
 	local_irq_restore(flags);
 }
 
-static inline int swim_readbit(struct swim __iomem *base, int bit)
+static inline bool swim_readbit(struct swim __iomem *base, int bit)
 {
 	int stat;
 
@@ -309,6 +310,9 @@ static inline int swim_readbit(struct swim __iomem *base, int bit)
 	return (stat & SENSE) == 0;
 }
 
+#define swim_readbit_timeout(base, bit, val, timeout_us) \
+	poll_timeout_us(, swim_readbit(base, bit) == val, 1000, timeout_us, false)
+
 static inline void swim_drive(struct swim __iomem *base,
 			      enum drive_location location)
 {
@@ -331,16 +335,8 @@ static inline void swim_motor(struct swim __iomem *base,
 			      enum motor_action action)
 {
 	if (action == ON) {
-		int i;
-
 		swim_action(base, MOTOR_ON);
-
-		for (i = 0; i < 2*HZ; i++) {
-			if (swim_readbit(base, MOTOR_ON))
-				break;
-			set_current_state(TASK_INTERRUPTIBLE);
-			schedule_timeout(1);
-		}
+		swim_readbit_timeout(base, MOTOR_ON, true, 2000 * 1000);
 	} else if (action == OFF) {
 		swim_action(base, MOTOR_OFF);
 		swim_write(base, phase, RELAX | PHASE_PIN_DIR);
@@ -349,16 +345,8 @@ static inline void swim_motor(struct swim __iomem *base,
 
 static inline void swim_eject(struct swim __iomem *base)
 {
-	int i;
-
 	swim_action(base, EJECT);
-
-	for (i = 0; i < 2*HZ; i++) {
-		if (!swim_readbit(base, DISK_IN))
-			break;
-		set_current_state(TASK_INTERRUPTIBLE);
-		schedule_timeout(1);
-	}
+	swim_readbit_timeout(base, DISK_IN, false, 2000 * 1000);
 }
 
 static inline void swim_head(struct swim __iomem *base, enum head head)
@@ -373,19 +361,8 @@ static inline void swim_head(struct swim __iomem *base, enum head head)
 
 static inline int swim_step(struct swim __iomem *base)
 {
-	int wait;
-
 	swim_action(base, STEP);
-
-	for (wait = 0; wait < HZ; wait++) {
-
-		set_current_state(TASK_INTERRUPTIBLE);
-		schedule_timeout(1);
-
-		if (!swim_readbit(base, STEP))
-			return 0;
-	}
-	return -1;
+	return swim_readbit_timeout(base, STEP, false, 20 * 1000);
 }
 
 static inline int swim_track00(struct swim __iomem *base)
-- 
2.53.0



