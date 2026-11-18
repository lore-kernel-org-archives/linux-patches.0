Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048529;
	b=TwEfYeOFEFvaAxaVnrcjckwu3LhFU/WG2uoPCt3LoKm6aeZzqnjle6djXsWC/kw0ei4e
	 vb7eDgYPojSxCjugpXcEqSliOWo0YBxicPbqMqK6Lt/t3+48sB2xqe/Mgabn12ZgiUKiY
	 TuAYHFp3VQci2q12JimA6odPgNGXLPyhRbMN3OVhbyBfir3dfUpCRmXqRTqQxeTsrBMQo
	 3qvHfsn3KoDS1tpYKqKX9Nzz+iLOXMI4A0ONpLRicYc1e3NputMnxcpXpqmlwdqHzWVsW
	 xeZAJlR9q7DJTydHGcd5PH0qGObAjQjllWdtsE3cz6ANFvtbcUnd+FayD0hR32UQV4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048529;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w+mn0F09vUm3rpQmFmXpEc1TCBdyq2n8pBPiOURnz+E=;
	b=qPdYTtKA849isHHW7cJ0x4ysNf0+WOOOVaNuL6Yvw2v5G1ZRP8BEm19+zLDetQX+w2wl
	 UVIr6qDGZ37cSCdSDNYvT2BqoSa/1DV4yQ/UCoMEJi4MPRm6z61NcU6gbTpV5EN25mQ/+
	 PchTdoDW4uRB8hQ5WmquwmCsy5RQF9PYsDpNuCz3MknAzx3mKFphYe5QoEV61HsGiLacg
	 L23+lR12njpGBZJH1oQBqsW3Rr5T0hGtpEZ8oICQQZ5rVj6pRE7PWJIECgTpZvdSu1vq2
	 m1lj1syj3RZfLpAQwnh8lEHqbYIO4SOKBbXQou70UWUHjYdikFM1mWNKC+o+g2WDj+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="u+Qx/ifF";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257AB606A31C;
	Thu, 19 Nov 2026 00:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u+Qx/ifF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF6E1F000C4;
	Thu, 19 Nov 2026 00:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048529;
	bh=w+mn0F09vUm3rpQmFmXpEc1TCBdyq2n8pBPiOURnz+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u+Qx/ifFv5iVv2CwY+MlxUfNGpdEThHEEAvLP9/RruH9P5NoOq4yOTKTLwwOSdrhv
	 3ho3YbDV0FCCgMLEQUKUcawZnC8FpNTUIXOkI61+Sf/9zZ0ihBnwTT2y4U9RhLVCnw
	 J88KkPWC32dtL1Sl4VrB/3IhQmwRE+yBVCZ2QgEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2026/2857] swim: Deduplicate polling loops
Date: Wed, 18 Nov 2026 15:51:00 +0100
Message-ID: <20261118150314.353296342@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index db0dca5f07ee1..09829960ebd63 100644
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
@@ -297,7 +298,7 @@ static inline void swim_action(struct swim __iomem *base, int action)
 	local_irq_restore(flags);
 }
 
-static inline int swim_readbit(struct swim __iomem *base, int bit)
+static inline bool swim_readbit(struct swim __iomem *base, int bit)
 {
 	int stat;
 
@@ -310,6 +311,9 @@ static inline int swim_readbit(struct swim __iomem *base, int bit)
 	return (stat & SENSE) == 0;
 }
 
+#define swim_readbit_timeout(base, bit, val, timeout_us) \
+	poll_timeout_us(, swim_readbit(base, bit) == val, 1000, timeout_us, false)
+
 static inline void swim_drive(struct swim __iomem *base,
 			      enum drive_location location)
 {
@@ -332,16 +336,8 @@ static inline void swim_motor(struct swim __iomem *base,
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
@@ -350,16 +346,8 @@ static inline void swim_motor(struct swim __iomem *base,
 
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
@@ -374,19 +362,8 @@ static inline void swim_head(struct swim __iomem *base, enum head head)
 
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



