Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024268;
	b=aVL+J42zV8f8NcDCseUmstZuIaYyad6uW/TXW53bwieyKRvWWVgViwvk9oq2cvIOn1p+
	 eE3+SS3NqAbjYwZEBBBNvwxAsJvu4xovJAH7Oy96KrddSj+CstRbLDFw8UE7aa29FA91h
	 08n5qtfYuOwQijLeWEr/UiO3nDOTyc2beZKM40DSCM0gE3dOMkRZG0Z1m7+ZEPgJ+pMBc
	 EquRVwpLmWbtib9BU6GyKMThTLWX+EnQrGabOBsHYwwxVDqhiXvMH7iDG0JpJDtElAmQb
	 7LfgYpnJ+YN4G94ZwEqASaeOZqtO/bs6y8XvdtNPpXNGskaukx0n8exR78TJVatFJCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024268;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DHgPewmLU37yiQhDCOxgW0zYckAIVS+CyEvlg4qC5PQ=;
	b=ja+tn3Yplku24dViAlZdCNivs5Je68GxVx0gSp3Udzhj0XtYcEuVACn+yvajY7IUX4+p
	 ZfmR5vLIZXcKpDNH/r7Qv1XhL9aSSG8v80w7VeX7CaYMp4mv9E/jPrr/iRyDHN4IDDwGy
	 SNPZwt+N3JabqgJ25lU5OnhZ8Lfp9BXLqxKBGtLN2yxXMRP7LxWerId9ZAUQO5StCWbNC
	 Ugol/hw6jOeCZdcdoein6+PxHrTvp+bxkRzc9tcF+qfKTWRCI0Dus5jq/dBWVmDKow2pP
	 dF/hDtf3jEOCho9ragQBCN7OMnaQUhYHv+ZIdn0oSvJjlwiJG5gSedxpCqPGpsbXYog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qTouVq2K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA640606A31C;
	Wed, 18 Nov 2026 17:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qTouVq2K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 360061F000C4;
	Wed, 18 Nov 2026 17:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024268;
	bh=DHgPewmLU37yiQhDCOxgW0zYckAIVS+CyEvlg4qC5PQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qTouVq2K3ZmIP5Ti2aq/Y2/orfUwS12V7mpRUPOUrwH+WDswZy+mgo3KySP28eQy8
	 iXwIlGyEEXij8qDsImiqkfuPaX5Zc7P6miNG1Kk6x4JVV0mmBzrxcfd7mVkAUyHWjf
	 aretldp7m39agYI4TUtZqM3nimuIwIyH7iQSUDQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0648/2151] swim: Deduplicate polling loops
Date: Wed, 18 Nov 2026 15:39:43 +0100
Message-ID: <20261118150145.454680586@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 237ed93fb0af4..474b343452ea5 100644
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



